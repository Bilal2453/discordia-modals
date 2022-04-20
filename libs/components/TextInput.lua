local discordia = require('discordia')
local class = discordia.class

local enums = discordia.enums
local componentType = enums.componentType
local textInputStyle = enums.textInputStyle

local Component = class.classes.Component

local TextInput = class('TextInput', Component)

function TextInput:__init(data, ...)
  -- Validate arguments into appropriate structure
  data = self._validate(data, ...)
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

function TextInput._isEligible()
  -- seems to always be accepted, since there is only a single cell in each row
  return true
end

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

function TextInput:label(label)
  label = tostring(label)
  assert(#label >= 1 and #label <= 45, 'label must be a string in the range 1-45 inclusive')
  return self:_set('label', label)
end

function TextInput:minLength(min)
  min = tonumber(min)
  assert(min >= 0 and min <= 4000, 'minLength must be in the range 0-4000 inclusive')
  return self:_set('minLength', min)
end

function TextInput:maxLength(max)
  max = tonumber(max)
  assert(max >= 1 and max <= 4000, 'maxLength must be in the range 1-4000 inclusive')
  return self:_set('maxLength', max)
end

function TextInput:required()
  return self:_set('required', true)
end

function TextInput:optional()
  return self:_set('required', false)
end

function TextInput:value(value)
  value = tostring(value)
  assert(#value >= 1 and #value <= 4000, 'value must be in the range 1-4000 inclusive')
  return self:_set('value', value)
end

function TextInput:placeholder(placeholder)
  placeholder = tostring(placeholder)
  assert(#placeholder >= 0 and #placeholder <= 100, 'placeholder must be in the range 0-100 inclusive')
  return self:_set('placeholder', placeholder)
end

return TextInput
