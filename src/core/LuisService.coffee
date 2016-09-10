log       = require 'winston'
denodeify = require 'denodeify'
request   = denodeify(require 'request')
_         = require 'underscore'
config    = require './../config'

LUIS_API_URL="https://api.projectoxford.ai/luis/v1/application?id=2cd7d9de-beae-48b4-8f8b-e27f83dd20f5&subscription-key=:key:&q=:text:"
TIMEOUT_MS=3000
SCORE_MIN_THRESHOLD=0.5
class LuisService

  constructor: (apiKey) ->
    @apiKey = apiKey

  getIntentFromText: (text) ->
    options =
      url: LUIS_API_URL.replace(":text:", encodeURIComponent(text)).replace(':key:', @apiKey)
      timeout: TIMEOUT_MS
      headers: "Accept": "application/json"

    log.debug options
    return request(options).then(@transformResponse)

  transformResponse: (response) =>
    data = JSON.parse(response.body)

    if !data?.intents || !_.isArray(data.intents) || data.intents.length is 0
      throw new Error("Luis.Ai detection failed (no intent or incorrect response data)")

    bestIntent = data.intents[0]
    if bestIntent.score < SCORE_MIN_THRESHOLD
      throw new Error("Luis.Ai detection failed (score of #{intent.score} is below #{SCORE_MIN_THRESHOLD} threshold)")

    parameters = {}
    log.debug data.entities
    for entity in data.entities
      parameters[entity.type] = entity.entity

    return {
      intent: bestIntent.intent
      parameters: parameters
    }

module.exports = LuisService
