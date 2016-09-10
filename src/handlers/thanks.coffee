string        = require './../utils/strings'
log           = require 'winston'

config =
  intent: 'thanks'


module.exports = (bot) -> bot.hear config, (res, data) ->
  responses = string "you_re_welcome"
  response = responses[Math.floor(Math.random() * responses.length)]

  res.reply response.replace(":name:", data.user)
