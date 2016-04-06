// Generated by CoffeeScript 1.10.0
(function() {
  var Database, Rx, Slack, Wit, getUserState, log, processBundle;

  Rx = require('rx');

  Slack = require('./services/slack');

  Wit = require('./services/wit');

  Database = require('./services/database');

  log = require('./misc/util').log;

  getUserState = require('./services/database').getUserState;

  processBundle = require('./processes/bundle').processBundle;

  Slack.incoming.message$.subscribe(function(message) {
    return getUserState(message).then(function(state) {
      return Wit.processMessage(message, state);
    }).then(function(bundle) {
      return processBundle(bundle);
    });
  });


  /*
   * On receiving bundle of original message and outcome from wit.ai -> process outcome
  Wit.outcome$.subscribe (bundle) ->
  
    processBundle bundle
   */

}).call(this);
