weatherProvider = require './../providers/weather_provider'

###
module.exports = (bot) -> bot.hear /\/weather (.*)/, (res, matches) ->
  time = matches[1]
  weatherProvider (time)
  .then res.reply
  .catch res.reply
  ###
