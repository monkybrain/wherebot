// Generated by CoffeeScript 1.10.0
(function() {
  var Rx, bot, incoming, log, messageTextToLowerCaseExceptTags, outgoing, ref, self, send, slack, token, typeIs, userIsnt;

  slack = require('slack');

  Rx = require('rx');

  ref = require('../misc/helpers').slack, messageTextToLowerCaseExceptTags = ref.messageTextToLowerCaseExceptTags, typeIs = ref.typeIs, userIsnt = ref.userIsnt;

  log = require('../misc/util').log;

  token = process.env.SLACK_TOKEN;

  self = 'U0WRAJMB5';

  bot = slack.rtm.client();

  bot.listen({
    token: token
  });


  /* PUBLIC */

  incoming = {};

  incoming.event$ = Rx.Observable.create(function(observer) {
    return bot.message(function(data) {
      return observer.onNext(data);
    });
  });

  incoming.message$ = incoming.event$.where(typeIs('message')).where(userIsnt(self)).map(messageTextToLowerCaseExceptTags).share();

  outgoing = {};

  outgoing.message$ = new Rx.Subject();

  send = function(bundle) {
    return log(bundle);

    /*{message, reply} = bundle
    bot.chat.postMessage {token: token, channel: message.channel, text: reply}, log
     */
  };

  module.exports = {
    incoming: incoming,
    outgoing: outgoing,
    send: send
  };

}).call(this);
