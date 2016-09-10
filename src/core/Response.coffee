log       = require 'winston'
getString = require './../utils/strings'
emoji     = require './../utils/emoji'
class Response
  constructor: (chat, adapter) ->
    @chat = chat
    @adapter = adapter

  reply: (text) =>
    text = emoji.replaceEmoji(text)

    # Wrap the call in a process.nextTick to let the listeners register callbacks
    process.nextTick => @adapter.sendMessage(@chat, text)

  replyMessage: (messageName) =>
    extraArgs = Array.prototype.slice.call(arguments)
    extraArgs.splice(0, 1)

    @reply getString.apply(null, [messageName].concat(extraArgs))

  replyOneOf: (str) =>
    values = if str instanceof Array then str else getString str
    text = values[Math.floor(Math.random() * values.length)]
    @reply(text)

  replyOneOfMessages: (messageName) => @replyOneOf getString messageName

  sendPhoto: (stream) =>
    @adapter.sendPhoto(@chat, stream)

module.exports = Response
