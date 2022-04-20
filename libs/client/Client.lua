local discordia = require('discordia')
local Client = discordia.Client

-- patch an alias to waitFor
function Client:waitModal(id, timeout)
  return self:waitFor('modalSubmit', timeout, function(interaction)
    return not id and true or id == interaction.data.custom_id
  end)
end
