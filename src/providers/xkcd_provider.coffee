request = require 'request'
cheerio = require 'cheerio'
fs = require 'fs'
Promise = require 'promise'

XKCD_URL = 'http://c.xkcd.com/random/comic/'

module.exports = -> new Promise (resolve, reject) ->
    request XKCD_URL, (err, res, body) ->
        reject err if err?
        reject res.statusCode if res? and res.statusCode isnt 200
        $ = cheerio.load body
        img_url = "http:" + $('#comic > img').attr('src')
        try
            resolve request.get(img_url)
        catch err
            reject err
