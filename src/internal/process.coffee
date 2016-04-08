R = require 'ramda'
Promise = require 'promise'

{log} = require '../misc/util'
{setUserStatus, setUserState} = require '../services/database'
{replies, queries} = require './phrases'
{intents} = require './intents'

### PRIVATE ###
parseEntities = R.compose R.map(R.prop('value')), R.map(R.nth(0))

processIntent = (intent, message, entities) ->

  # If existing intent
  if intents[intent]?

    # -> perform operation
    return intents[intent](message, entities)

  # Else -> log (TODO: Proper error handling needed)
  # else console.error "intent not found"

### PUBLIC ###

# Process bundle, return reply
processBundle = (bundle) ->

  new Promise (resolve, reject) =>

    # Deconstruct bundle
    {message, outcome} = bundle
    {intent, confidence} = outcome
    entities = parseEntities(outcome.entities)

    # If confidence low -> set intent to unknown
    if confidence < 0.5 or intent is 'UNKNOWN'
      console.log "Low confidence: " + confidence
      intent = 'unknown'

    # Else process intent
    processIntent(intent, message, entities)

    .then (reply) =>
      log reply
      resolve R.merge bundle, reply: reply



module.exports =
  processBundle: processBundle
