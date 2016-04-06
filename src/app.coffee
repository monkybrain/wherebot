# Node modules
Rx = require 'rx'

# My modules
Slack = require './services/slack'
Wit = require './services/wit'
Database = require './services/database'
{log} = require './misc/util'
{getUserState} = require './services/database'
{processBundle} = require './processes/bundle'

# On incoming slack message
Slack.incoming.message$.subscribe (message) =>

  # Fetch user state from database
  getUserState(message)

  # Send message and state to wit.ai
  .then (state) => Wit.processMessage message, state

# On receiving bundle of original message and outcome from wit.ai -> process outcome
Wit.outcome$.subscribe (bundle) ->

  processBundle bundle

  # Send reply
  .then (bundle) => Slack.send bundle



# Tap here to debug! (nothing -> log)
# Slack.incoming.message$.do(log).subscribe()
# Wit.outcome$.do(log)
# Database.response$.do(log).subscribe()