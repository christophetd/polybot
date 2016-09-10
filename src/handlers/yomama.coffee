yoMamaJoke = require './../providers/yomama_provider'

###
module.exports = (bot) -> bot.hear /^\/yomama/, (res) ->
  yoMamaJoke()
  .then res.reply
  .catch res.reply
###
