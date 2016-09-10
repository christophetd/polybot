string        = require './../utils/strings'
log           = require 'winston'

config =
  intent: 'insult'

module.exports = (bot) -> bot.hear config, (res, data) ->
  responses = string "insults_responses"
  response = responses[Math.floor(Math.random() * responses.length)]

  res.reply response.replace(':name:', data.user)
