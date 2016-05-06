Promise = require 'promise'

{setUserStatus, setUserState, setUserBack, setUserBackDateTime, getUser} = require '../services/database'
{replies, queries} = require './phrases'

nlp_date = require 'date.js'

# Intent handlers
exports.intents =

  ### ERROR ###
  unknown: -> replies.intents.unknown

  ### SET ###

  # Set self status
  set_self_status: (message, entities) =>

    # New promise
    new Promise (resolve, reject) =>

      # Write new status to database
      setUserStatus message, entities.status

      # Initialize reply array
      reply = [replies.intents.set_self_status]

      # [?] If 'back' specified
      if entities.back?

        # -> Update 'back'
        setUserBack message, entities.back

        # -> setUserBackDateTime
        setUserBackDateTime message, nlp_date(entities.back).toISOString()

        # -> Set user state to 'idle'
        setUserState message, 'idle'

      # Else
      if not entities.back?

        # -> Clear current 'back'
        setUserBack message, null

        # -> Clearn current 'back date time'
        setUserBackDateTime message, null

        # -> Set user state to 'bot_query_back'
        setUserState message, 'bot_query_back'

        # -> Add query to reply
        reply.push queries.back

      # Join array to single string
      resolve reply.join "\n"

  # Set self back
  set_self_back: (message, entities) =>

    # New promise
    new Promise (resolve, reject) =>

      # If 'back' specified
      if entities.back?

        # -> Update 'back'
        setUserBack message, entities.back

        # -> Update back datetime
        setUserBackDateTime message, nlp_date(entities.back).toISOString()

        # -> Set user state to 'bot_query_back'
        setUserState message, 'idle'

        reply = [replies.intents.set_self_back]

      # Else
      if not entities.back?

        # -> Set user state to 'bot_query_back'
        setUserState message, 'bot_query_back'

        # -> Add query to reply
        reply = [replies.intents.unknown]

      # Join array to single string
      resolve reply.join "\n"

  query_user_status: (message, entities) ->

    # New promise
    new Promise (resolve, reject) =>

      getUsers(message)
      .then (user) ->
        resolve replies.intents.query_user_status(user)