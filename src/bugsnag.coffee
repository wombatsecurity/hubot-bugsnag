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
    try
      # ...
      room   = req.params.room
      robot.logger.info req.body.payload
      data   = JSON.parse req.body.payload
      secret = data.secret

      robot.messageRoom room, "I have a secret: #{secret}"

    catch error
      robot.messageRoom room, "Whoa, I got an error: #{error}"
      robot.logger.error error
      # ...


    res.send 'OK'

