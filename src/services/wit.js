// Generated by CoffeeScript 1.10.0
(function() {
  var Rx, arrayNotEmpty, bundle$, dot, getText, log, makeStateObject, processMessage, token, wit;

  Rx = require('rx');

  wit = require('node-wit');

  log = require('../misc/util').log;

  dot = require('../misc/helpers').dot;


  /* PRIVATE */

  token = process.env.WIT_TOKEN;

  getText = dot('text');

  arrayNotEmpty = function(array) {
    return array.length > 0;
  };

  makeStateObject = function(state) {
    return {
      context: {
        state: state
      }
    };
  };


  /* PUBLIC */

  bundle$ = new Rx.Subject();

  processMessage = function(message, state) {
    return wit.captureTextIntent(token, getText(message), makeStateObject(state), (function(_this) {
      return function(err, res) {
        var bundle;
        if (arrayNotEmpty(res.outcomes)) {
          bundle = {
            message: message,
            outcome: res.outcomes[0]
          };
          return bundle$.onNext(bundle);
        }
      };
    })(this));
  };

  module.exports = {
    bundle$: bundle$.share(),
    processMessage: processMessage
  };

}).call(this);
