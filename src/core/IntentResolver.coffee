config      = require './../config'
LuisService  = require './LuisService'

class IntentResolver
  constructor: () ->
    @luisService = new LuisService(config.secrets.luis)

  getIntentFromText: (text) -> @luisService.getIntentFromText(text)

module.exports = IntentResolver
