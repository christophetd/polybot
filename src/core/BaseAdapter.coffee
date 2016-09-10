EventEmitter = require 'events'

class BaseAdapter extends EventEmitter

  sendMessage: (chat, message) -> throw new Error("not implemented")

  sendPhoto: (chat, message) -> throw new Error("not implemented")

module.exports = BaseAdapter
