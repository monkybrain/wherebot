// Generated by CoffeeScript 1.10.0
(function() {
  var Promise, getUser, nlp_date, queries, ref, ref1, replies, setUserBack, setUserBackDateTime, setUserState, setUserStatus;

  Promise = require('promise');

  ref = require('../services/database'), setUserStatus = ref.setUserStatus, setUserState = ref.setUserState, setUserBack = ref.setUserBack, setUserBackDateTime = ref.setUserBackDateTime, getUser = ref.getUser;

  ref1 = require('./phrases'), replies = ref1.replies, queries = ref1.queries;

  nlp_date = require('date.js');

  exports.intents = {

    /* ERROR */
    unknown: function() {
      return replies.intents.unknown;
    },

    /* SET */
    set_self_status: (function(_this) {
      return function(message, entities) {
        return new Promise(function(resolve, reject) {
          var reply;
          setUserStatus(message, entities.status);
          reply = [replies.intents.set_self_status];
          if (entities.back != null) {
            setUserBack(message, entities.back);
            setUserBackDateTime(message, nlp_date(entities.back).toISOString());
            setUserState(message, 'idle');
          }
          if (entities.back == null) {
            setUserBack(message, null);
            setUserBackDateTime(message, null);
            setUserState(message, 'bot_query_back');
            reply.push(queries.back);
          }
          return resolve(reply.join("\n"));
        });
      };
    })(this),
    set_self_back: (function(_this) {
      return function(message, entities) {
        return new Promise(function(resolve, reject) {
          var reply;
          if (entities.back != null) {
            setUserBack(message, entities.back);
            setUserBackDateTime(message, nlp_date(entities.back).toISOString());
            setUserState(message, 'idle');
            reply = [replies.intents.set_self_back];
          }
          if (entities.back == null) {
            setUserState(message, 'bot_query_back');
            reply = [replies.intents.unknown];
          }
          return resolve(reply.join("\n"));
        });
      };
    })(this),
    query_user_status: function(message, entities) {
      return new Promise((function(_this) {
        return function(resolve, reject) {
          return getUsers(message).then(function(user) {
            return resolve(replies.intents.query_user_status(user));
          });
        };
      })(this));
    }
  };

}).call(this);
