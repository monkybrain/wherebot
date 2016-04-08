# Replies
exports.replies =
  intents:
    unknown: "Sorry, didn't quite get that. Could you please rephrase that?"
    set_self_status: "Ok, got it!"
    set_self_back: "Ok, thanks!"
    query_user_status: (user) ->
      reply = "<@#{user.id}> is #{user.status}."
      if user.back?
        reply += " He/she will be back #{user.back}"
      reply

# Queries
exports.queries =
  back: "When do you expect to be back?"

