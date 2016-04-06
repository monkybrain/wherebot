R = require 'ramda'
Promise = require 'promise'

{log} = require '../misc/util'
{setUserStatus, setUserState} = require '../services/database'

### PRIVATE ###
parseEntities = R.compose R.map(R.prop('value')), R.map(R.nth(0))

# Replies
replies =
  intents:
    unknown: "Sorry, didn't quite get that. Could you please rephrase that?"
    set_self_status: "Ok, got it!"

# Queries
queries =
  back: "When do you expect to be back?"

# Intents
intents =
  'set_self_status': (message, entities) ->

    # Write new status to database
    setUserStatus message, entities

    # Reply = array of sentences
    reply = [replies.intents.set_self_status]

    # If 'back' not specified
    if not entities.back?
      # -> Set user state to 'bot_query_back'
      setUserState message, 'bot_query_back'
      # -> Add query to reply
      reply.push [queries.back]

    # Else -> set user state to 'idle'
    else setUserState message, 'idle'

    # Join array to single string
    reply.join "\n"

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