# Intent handlers
exports.intents =

  # -> Set self status
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