# Node modules
Rx = require 'rx'

# My modules
Slack = require './services/slack'
Wit = require './services/wit'
Database = require './services/database'
{log} = require './misc/util'
{getUserState} = require './services/database'
{processBundle} = require './internal/process'



### STREAMS ###

# SLACK

# On incoming slack message
Slack.incoming.message$.subscribe (message) =>

  # Fetch user state from database
  getUserState(message)

  # Send message and state to wit.ai
  .then (state) => Wit.processMessage message, state

# WIT.AI

# On incoming bundle (message + outcome from wit.ai)
Wit.bundle$.subscribe (bundle) ->

  # Process bundle
  processBundle bundle

  # Send reply
  .then (bundle) => Slack.send bundle



# Tap here to debug! (uncomment lines below)
# Slack.incoming.message$.do(log).subscribe()
# Wit.outcome$.do(log)
# Database.response$.do(log).subscribe()