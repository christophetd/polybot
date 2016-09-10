string        = require './../utils/strings'
log           = require 'winston'
abbrev        = require './../utils/name_abbrev'

config =
  intent: 'greet'
  regex: /^\/start(.*)?/


module.exports = (bot) -> bot.hear config, (res, data) ->
  greetings = string "greetings"
  greeting = greetings[Math.floor(Math.random() * greetings.length)]

  res.reply greeting.replace(":name:", abbrev(data.user))
