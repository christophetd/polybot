messages = JSON.parse(require('fs').readFileSync(__dirname + '/../../resources/messages.json'))
vsprintf = require('format').vsprintf

format = (msg_id) ->
    msg = messages[msg_id]
    if not msg?
        throw new Error("Unknown message #{msg_id}")

    if typeof msg is 'string'
        args = [].splice.call(arguments, 1)
        vsprintf(msg, args)
    else
        msg

module.exports = format
