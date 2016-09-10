# Todo : this was done to use unicode characters

emojiList =
  embarrassed: ":/"

replaceEmoji = (text) ->
  regxp = new RegExp("\\[emoji:([a-zA-Z0-9]+)\\]", "g")
  text.replace regxp, (match) ->
    emojiName = /\[emoji\:([a-zA-Z]+)\]/gm.exec(match)[1] # todo: support multiple emoji in the same message
    return emojiList[emojiName.toLowerCase()] || ''

module.exports = {replaceEmoji}
