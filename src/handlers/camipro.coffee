strings = require './../utils/strings'
log     = require 'winston'
camiproProvider = require './../providers/camipro_provider'
config =
  regex: /^\/camipro.*?/


module.exports = (bot) -> bot.hear config, (res, data) ->
  camiproProvider.getBalance res, data.user_id
  .then (balance) -> res.replyMessage 'balance_response', balance
