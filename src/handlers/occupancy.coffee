occupancy = require './../providers/occupancy_provider'

config =
  intent: "check_occupancy"
  regex: /\/(?:occupancy|room) ([A-Za-z0-9]+)/i

module.exports = (bot) -> bot.hear config, (response, data) ->
  room = if data.intent then data.parameters.room_code else data.matches[1]

  if !room?
    response.replyOneOf "wat"

  occupancy room
  .then response.reply
  .catch response.reply
