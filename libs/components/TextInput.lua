local discordia = require('discordia')
local class = discordia.class

local enums = discordia.enums
local componentType = enums.componentType
local textInputStyle = enums.textInputStyle

local Component = class.classes.Component

---@alias Style-Resolvable 'short'|'paragraph' | 1|2
---@alias TextInput-Resolvable string|{id: string, label: string, style: Style-Resolvable, minLength: number, maxLength: number, required: boolean, value: string, placeholder: string}

---A component that represents [TextInput](https://discord.com/developers/docs/interactions/message-components#text-inputs).
---A TextInput is a GUI component where the user can input a piece of text.
---TextInput component can only be used in a [[Modal]] context.
---@class TextInput: Component
---@overload fun(data: TextInput-Resolvable, label?: string, style?: Style-Resolvable)
---<!tag:interface> <!method-tags:mem>
local TextInput = class('TextInput', Component)

---<!ignore>
---Creates a new instance of the component TextInput.
---@param data TextInput-Resolvable
---@param label string
---@param style Style-Resolvable
function TextInput:__init(data, label, style)
  -- Validate arguments into appropriate structure
  data = self._validate(data, label, style)
  assert(data.id, 'an id must be supplied')

  -- Default style to short if not provided
  if data.style == nil then
    data.style = 1
  end

  -- Loading the rest of provided data
  self._load = {
    label = self.label,
    style = self.style,
    value = self.value,
    optional = function(i, d) return d and i:optional() or i:required() end, -- undocumented, niche case
    required = function(i, d) return d and i:required() or i:optional() end,
    maxLength = self.maxLength,
    minLength = self.minLength,
    placeholder = self.placeholder,
  }

  -- Base constructor initializing
  Component.__init(self, data, componentType.textInput)
end

---<!ignore>
---Decides whether a row can be used or not.
---@return boolean
function TextInput._isEligible()
  -- seems to always be accepted, since there is only a single cell in each row
  return true
end

---<!ignore>
---Resolves the parameters into an appropriate structure.
---@param data TextInput-Resolvable
---@param label string|nil
---@param style Style-Resolvable|nil
---@return table
function TextInput._validate(data, label, style)
  if type(data) ~= 'table' then
    data = {id = data}
  end
  if label ~= nil then
    data.label = label
  end
  if style ~= nil then
    data.style = style
  end
  return data
end

---Sets the style of the TextInput.
---@param style Style-Resolvable
---@return TextInput
function TextInput:style(style)
  -- resolve the style
  local resolved_style
  if type(style) == 'string' then
    resolved_style = textInputStyle[style]
  elseif tonumber(style) then
    resolved_style = tonumber(style)
  end
  -- make sure it is valid
  if not resolved_style and style ~= nil then
    error('TextInput style is not valid (expected valid number|string value, got ' .. tostring(style) .. ')')
  end
  -- set it
  return self:_set('style', resolved_style or textInputStyle.short)
end

---Sets the label of the TextInput.
---@param label string
---@return TextInput
function TextInput:label(label)
  label = tostring(label)
  assert(#label >= 1 and #label <= 45, 'label must be a string in the range 1-45 inclusive')
  return self:_set('label', label)
end

---Sets the minmum required amount of characters in the user input. Must be a value between 0 and 4000 inclusive.
---@param min number
---@return TextInput
function TextInput:minLength(min)
  min = tonumber(min)
  assert(min >= 0 and min <= 4000, 'minLength must be in the range 0-4000 inclusive')
  return self:_set('minLength', min)
end

---Sets the maximum possible amount of characters in the user input. Must be a value between 0 and 4000 inclusive.
---@param max number
---@return TextInput
function TextInput:maxLength(max)
  max = tonumber(max)
  assert(max >= 1 and max <= 4000, 'maxLength must be in the range 1-4000 inclusive')
  return self:_set('maxLength', max)
end

---Sets this TextInput as required.
---A required TextInput must be provided for the user to be able to submit the modal.
---@return TextInput
function TextInput:required()
  return self:_set('required', true)
end

---Sets this TextInput as optiona.
---An optional TextInput may or may not be provided on user modal submit.
---@return TextInput
function TextInput:optional()
  return self:_set('required', false)
end

---Sets a pre-provided value for the TextInput.
---The pre-provided value can be then optionally changed by the user.
---Must be a value between 1 and 4000 inclusive.
---@param value string
---@return TextInput
function TextInput:value(value)
  value = tostring(value)
  assert(#value >= 1 and #value <= 4000, 'value must be in the range 1-4000 inclusive')
  return self:_set('value', value)
end

---Sets a placeholder for the TextInput. A placeholder is a shaded text displayed when the TextInput value is empty.
---Must be a value between 0 and 100 inclusive.
---@param placeholder string
---@return TextInput
function TextInput:placeholder(placeholder)
  placeholder = tostring(placeholder)
  assert(#placeholder >= 0 and #placeholder <= 100, 'placeholder must be in the range 0-100 inclusive')
  return self:_set('placeholder', placeholder)
end

return TextInput
