class Message
  constructor: (chat, text, user, user_id) ->
    @chat_id = chat
    @text = text
    @user = user
    @user_id = user_id

module.exports = Message
