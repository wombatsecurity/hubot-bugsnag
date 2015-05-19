# Description:
#   Accepts POST from BugSnag.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   POST /hubot/bugsnag
#
# Author:
#   veverkap

fs = require 'fs'
path = require 'path'

module.exports = (robot, scripts) ->
  robot.router.post '/hubot/bugsnag/:room', (req, res) ->
    try
      robot.logger.info "Hubot received BugSnag POST with params:"
      robot.logger.info req.params
      robot.logger.info "Hubot received BugSnag POST with body:"
      robot.logger.info req.body
      room   = req.params.room
      robot.logger.info "Hubot will post to room #{room}"
      error = req.body.error

      robot.messageRoom room, "I have a secret: #{req.body.error}"

    catch error
      robot.messageRoom room, "Whoa, I got an error: #{error}"
      robot.logger.error error
      # ...


    res.send 'OK'

