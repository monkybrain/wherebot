R = require 'ramda'
Promise = require 'promise'

{log} = require '../misc/util'
{setUserStatus, setUserState} = require '../services/database'
{replies, queries} = require './phrases'
{intents} = require './intents'

### PRIVATE ###
parseEntities = R.compose R.map(R.prop('value')), R.map(R.nth(0))

processIntent = (intent, message, entities) ->

  # If existing intent -> perform operation
  if intents[intent]? then intents[intent] message, entities
  # Else -> log
  else console.error "intent not found"

### PUBLIC ###

# Process bundle, return reply
processBundle = (bundle) ->

  new Promise (resolve, reject) =>

    # Deconstruct bundle
    {message, outcome} = bundle
    {intent, confidence} = outcome
    entities = parseEntities(outcome.entities)

    # If confidence low -> ask user to rephrase
    if confidence < 0.5 or intent is 'UNKNOWN'
      reply = replies.intents.unknown

    # Else process intent
    else reply = processIntent intent, message, entities

    resolve R.merge bundle, reply: reply

module.exports =
  processBundle: processBundle