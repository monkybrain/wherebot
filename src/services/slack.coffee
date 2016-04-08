# Node modules
slack = require 'slack'
Rx = require 'rx';

# My modules
{messageTextToLowerCaseExceptTags, typeIs, userIsnt} = require('../misc/helpers').slack
{log} = require '../misc/util'

nullBack = (err, data) ->

# Constants
token = process.env.SLACK_TOKEN
self = 'U0WRAJMB5'

# Initialize and run slackbot

bot = slack.rtm.client()
bot.listen {token}

# Greeting
bot.hello (message) ->
  slack.chat.postMessage {token: token, channel: 'D0WSS7VGQ', text: "Hi there. Looking for someone? Or perhaps you'd like to share your whereabouts?", as_user: true}, nullBack

### PUBLIC ###

# Collection of incoming streams
incoming = {}

# STREAM: Incoming events
incoming.event$ =
  # New stream
  Rx.Observable.create (observer) ->
    # On bot message -> push to stream
    bot.message (data) -> observer.onNext data

# STREAM: Incoming messages
incoming.message$ =
  # Take all slack events...
  incoming.event$
  # ...filter out messages...
  .where typeIs 'message'
  # ...that aren't from the bot itself
  .where userIsnt self
  # ...and convert message text to lower case (except tags, e.g. <@U0ABCDEF>)
  .map messageTextToLowerCaseExceptTags
  # and make steam 'hot'
  .share()

# Collection of outgoing streams
outgoing = {}

# Outgoing messages
outgoing.message$ = new Rx.Subject()

# EXPORT: Send message to Slack
send = (bundle) ->
  {message, reply} = bundle
  slack.chat.postMessage {token: token, channel: message.channel, text: reply, as_user: true}, nullBack

module.exports =
  incoming: incoming
  outgoing: outgoing
  send: send