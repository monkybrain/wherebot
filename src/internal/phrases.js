// Generated by CoffeeScript 1.10.0
(function() {
  exports.replies = {
    intents: {
      unknown: "Sorry, didn't quite get that. Could you please rephrase that?",
      set_self_status: "Ok, got it!",
      set_self_back: "Ok, thanks!",
      query_user_status: function(user) {
        var reply;
        reply = "<@" + user.id + "> is " + user.status + ".";
        if (user.back != null) {
          reply += " He/she will be back " + user.back;
        }
        return reply;
      }
    }
  };

  exports.queries = {
    back: "When do you expect to be back?"
  };

}).call(this);
