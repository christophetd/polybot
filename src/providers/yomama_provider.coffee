request = require 'request'
JOKE_URL = "http://api.yomomma.info/"

module.exports = -> new Promise (resolve, reject) ->
    request JOKE_URL, (err, res, body) ->
        reject err if err?
        reject res.statusCode if res? and res.statusCode isnt 200
        resolve JSON.parse(body).joke
