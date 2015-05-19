# Description:
#   Say Hi to Hubot.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot hello - "hello!"
#   hubot orly - "yarly"
#
# Author:
#   veverkap

fs = require 'fs'
path = require 'path'

module.exports = (robot, scripts) ->
  robot.router.post '/hubot/bugsnag/:room', (req, res) ->
    room   = req.params.room
    data   = JSON.parse req.body.payload
    secret = data.secret

    robot.messageRoom room, "I have a secret: #{secret}"

    res.send 'OK'

