class Message
  constructor: (chat, text, user) ->
    @chat_id = chat
    @text = text
    @user = user

module.exports = Message
