local discordia = require('discordia')
local class = discordia.class
local isInstance = class.isInstance

local enums = discordia.enums
local componentType = enums.componentType

local TextInput = require('components/TextInput')
local Component = class.classes.Component
local ComponentsContainer = class.classes.ComponentsContainer

local MAX_ROWS = 5
local MAX_ROW_CELLS = 1
local COMPONENTS = {TextInput}

---@alias Modal-Resolvable string|{id: string, title: string, [number]: TextInput-Resolvable}

---Represents a Discord modal used to display a GUI prompt for end-users.
---This is main builder for modals, the entry point of this library and where to create modals.
---@class Modal
---@field textInputs ArrayIterable A cache of all constructed [[TextInput]] classes in this instance.
---@overload fun(data?: string|Modal-Resolvable): Modal
---<!tag:interface> <!method-tags:mem>
local Modal = class('Modal', ComponentsContainer)

---<!ignore>
---Creates a new [[Modal]] instance.
---@param data string|table
---@return Modal
function Modal:__init(data)
  -- validate and resolve argument
  data = self:_validate(data)
  -- make sure an id is supplied
  assert(data.id, 'an id must be supplied')

  -- init the components container parent
  ComponentsContainer.__init(self, {
    maxRows = MAX_ROWS,
    maxRowCells = MAX_ROW_CELLS,
    components = COMPONENTS,
  })

  -- load the rest of the supplied data
  self:_load(data)
end

---<!ignore>
--- A simple helper function to get the names of supported components in a modal for error messages.
---@return string # a string of components names separated by , (comma)
local function getSupportedComponents()
  local supported_components = {}
  for _, v in pairs(COMPONENTS) do
    supported_components[#supported_components+1] = v.__name
  end
  return table.concat(supported_components, ', ')
end

---<!ignore>
---Resolves the data parameter for a Modal instance.
---@param data Modal-Resolvable
---@return Modal-Resolvable
function Modal:_validate(data)
  local data_type = type(data)
  if data_type ~= 'table' then
    data = {id = data}
  end
  return data
end

---<!ignore>
---Loads the provided data into the Modal instance.
---@param data Modal-Resolvable
function Modal:_load(data)
  -- make sure we got a table
  local data_type = type(data)
  if data_type ~= 'table' then
    error('bad argument #1 to Modal (expected Component|table, got ' .. data_type .. ')', 4)
  end

  if isInstance(data, Component) then -- is the provided argument a component?
    self:_buildComponent(data.__class, data)
  elseif next(data) then -- is the provided argument a table representing the modal?
    -- load id and title
    self._id = data.id
    if data.title then self:title(data.title) end

    -- load any provided component in the array portion
    for i = 1, #data do
      local comp, comp_type = data[i], nil

      -- make sure the comp is some sort of a table
      if type(comp) ~= 'table' then
        error('invalid modal structure: array portion can only contain table|Component', 4)
      end

      -- figure the component type out
      if not comp.type then
        comp_type = componentType.textInput
      else
        comp_type = type(comp.type) == 'number' and comp.type or componentType[comp.type]
      end

      -- make sure the component is supported in a modal
      local comp_class = COMPONENTS[comp_type - 3]
      if not comp_class then
        error('Component type not supported in a modal, supported components are ' .. getSupportedComponents() .. '')
      end

      -- build the component
      self:_buildComponent(comp_class, comp)
    end
  else -- we don't recognize it
    error('invalid modal structure', 4)
  end
end

---Sets the title of the modal. A modal title is displayed as a big text in the top-center of a modal.
---@param title string
---@return Modal
function Modal:title(title)
  title = tostring(title)
  self._title = assert(title, 'title must be in the range 1-45 inclusive')
  return self
end

---Creates and assign a new [[TextInput]] component.
---@param data TextInput-Resolvable
---@param label string
---@param style Style-Resolvable
---@return Modal
function Modal:textInput(data, label, style)
  self:_buildComponent(TextInput, data, label, style)
  return self
end

---Removes a previously assigned [[TextInput]] component from the current instance.
---@param id string
---@return Modal
function Modal:removeTextInput(id)
  return self:_remove(TextInput, id)
end

local component_raw = Modal.raw
---Returns the raw table structure of this modal that is accepted by Discord.
---@return table
function Modal:raw()
  -- get raw representation of the components
  local components = component_raw(self)
  -- construct the modal raw structure
  return {
    title = self._title,
    custom_id = self._id,
    components = components,
  }
end

return Modal
