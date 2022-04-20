
local discordia = require('discordia')
local discordia_interactions = require('discordia-interactions')

-- Initialize discordia-components patches
require('discordia-components')
-- Patch client
require('client/Client')

-- TODO: doc comments
local enums = discordia.enums
local new_enums = require('enums')
local interactionType = enums.interactionType
local isInstance = discordia.class.isInstance

-- Patch enums into discordia
for k, v in pairs(new_enums) do
  enums[k] = enums.enum(v)
end

-- Patch modal class in
local Modal = require('containers/Modal')
discordia.Modal = Modal
-- Patch TextInput component
local TextInput = require('components/TextInput')
discordia.TextInput = TextInput

-- Wrap modal_resolvers to allow using interaction:modal(Modal)
local resolver = discordia_interactions.resolver
resolver.modal_resolvers.modals = function(content)
  if isInstance(content, Modal) then
    return content:raw()
  elseif type(content) == 'table' and content.id and content.title then
    return Modal(content):raw()
  end
end

-- Assign a pre-listener of interactionCreate event to emit modalSubmits
local prelisteners = discordia_interactions.EventHandler.interaction_create_prelisteners
prelisteners.modalSubmit = function(interaction, client)
  if interaction.type == interactionType.modalSubmit then
    client:emit('modalSubmit', interaction)
  end
end

return {
  Modal = Modal,
  TextInput = TextInput,
}

