TelegramBot   = require 'node-telegram-bot-api';
BaseAdapter   = require './BaseAdapter'
Message       = require './Message'
log           = require 'winston'
class TelegramAdapter extends BaseAdapter

  constructor: (apiToken) ->
    @telegram = new TelegramBot(apiToken, polling: true)
    @telegram.on 'message', (msg) =>
      log.debug "[Message] on chat #{msg.chat.id} : #{msg.text}"
      user_name = msg.from?.first_name?.split(/\s+/)[0]
      @emit('message', new Message(msg.chat.id, msg.text, user_name, msg.from?.id))

    @telegram.getMe()
    .then (me) -> log.info "Bot started: @#{me.username}"
    .catch (err) -> log.error "Bot failed to start : #{err}"

  sendMessage: (chat, msg) =>
    @telegram.sendMessage chat, msg, parse_mode: 'Markdown'

  sendPhoto: (chat, stream) =>
    @telegram.sendPhoto chat, stream

module.exports = TelegramAdapter
