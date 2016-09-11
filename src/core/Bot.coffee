Response      = require './Response'
log           = require 'winston'
IntentResolver= require './IntentResolver'
strings       = require './../utils/strings'

class Bot
  constructor: (adapter) ->
    @adapter = adapter
    @adapter.on('message', @dispatchMessage)
    @handlers = []
    @intentResolver = new IntentResolver()

  hear: (config, fn) ->
    @handlers.push(intent: config.intent, regex: config.regex, fn: fn)

  dispatchMessage: (message) =>
    log.debug "Resolving intent"

    res = new Response(message.chat_id, @adapter)

    @intentResolver.getIntentFromText(message.text)
    .then @dispatchFromIntent.bind(this, message, res)
    .catch (err) =>
      log.debug "Nothing from Luis : "+err
      log.debug "Trying regex dispatch instead"
      @dispatchFromRegex(message, res)

  dispatchFromIntent: (message, response, data) =>
    log.debug "Luis returned parsing for this message"
    log.debug data

    data.user = message.user
    data.user_id = message.user_id

    for handler in @handlers
      if data.intent is handler.intent
        try
          return handler.fn(response, data)
        catch e
          log.error e
          return response.replyOneOfMessages "internal_error"

    throw new Error("No handler found for intent '#{data.intent}'")

  dispatchFromRegex: (message, response) =>
    data = user: message.user, user_id: message.user_id, matches: []

    for handler in @handlers
      if handler.regex?.test message.text
        data.matches = message.text.match handler.regex
        try
          return handler.fn(response, data)
        catch e
          log.error e
          return response.replyOneOfMessages "internal_error"

    log.debug "NOTHING FOUND REPLY WATWAT"
    response.replyOneOfMessages "wat"

module.exports = Bot
