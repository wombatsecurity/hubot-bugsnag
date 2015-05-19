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
require "sugar"
module.exports = (robot, scripts) ->
  robot.router.post '/hubot/bugsnag/:room', (req, res) ->
    try
      robot.logger.info "Hubot received BugSnag POST with params:"
      robot.logger.info req.params
      robot.logger.info "Hubot received BugSnag POST with body:"
      robot.logger.info req.body

      room   = req.params.room
      robot.logger.info "Hubot will post to room #{room}"

      event = req.body
      robot.logger.info "Hubot received the following event:"
      robot.logger.info event

      projectName = event.project.name.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
      robot.logger.info "projectName = #{projectName}"

      if event.trigger.type == 'comment'
        robot.logger.info "Event Trigger Type is Comment"
        item = event.error.exceptionClass
        if event.error.message
          item += ": #{event.error.message}"

        robot.logger.info "item = #{item}"
        robot.logger.info item.truncate(85)
        title = ["Comment on #{item.truncate(85)}"]
        robot.logger.info "DONE"
        title.push("<#{event.error.url}|(details)>")
      else if event.trigger.type == 'projectSpiking'
        title = ["Spike of #{event.trigger.rate} exceptions/minute from <#{event.project.url}|#{projectName}>"]
      else
        title = ["#{event.trigger.message} in #{event.error.releaseStage} from <#{event.project.url}|#{projectName}>"]
        title.push("in #{event.error.context}")
        title.push("<#{event.error.url}|(details)>")

      robot.logger.info "Title = #{title}"

      # Build the common payload
      payload = {
        username: "Bugsnag",
        text: title.join(" "),
        attachments: []
      }


      # Attach error information
      if event.comment
        payload.attachments.push(commentAttachment(event))
      else if event.error
        payload.attachments.push(errorAttachment(event))

      robot.logger.info payload
      robot.messageRoom room, payload

    catch error
      robot.messageRoom room, "Whoa, I got an error: #{error}"
      robot.logger.error error
      # ...


    res.send 'OK'




commentAttachment = (event) ->
  {
    color: "good"
    fallback: "Somebody commented"
    author_name: event.user.name
    text: event.comment.message
  }

errorAttachment = (event) ->
  attachment =
    fallback: "Something happened",
    fields: [
      {
        title: "Error"
        value: (event.error.exceptionClass + (if event.error.message then ": #{event.error.message}")).truncate(85)
      },
      {
        title: "Location",
        value: event.error.stacktrace && @firstStacktraceLine(event.error.stacktrace)
      }
    ]
  switch event.error.severity
    when "error"
      attachment.color = "#E45F58"
    when "warning"
      attachment.color = "#FD9149"
    when "info"
      attachment.color = "#20A6DF"

  attachment
