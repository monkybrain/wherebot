// Generated by CoffeeScript 1.10.0
(function() {
  var Firebase, Promise, R, Rx, addId, base, defaultTo, dot, getChild, getSnapshot, getStatus, getTeamId, getTeamRef, getUserBackDateTimeRef, getUserBackRef, getUserId, getUserRef, getUserStateRef, getUserStatusRef, getValue, getValueWithDefault, log, makeUserObject, method, ref1, setValue, snapshotToValue, teams;

  Firebase = require('firebase');

  Promise = require('promise');

  R = require('ramda');

  Rx = require('rx');

  ref1 = require('../misc/helpers'), dot = ref1.dot, method = ref1.method;

  log = require('../misc/util').log;

  base = new Firebase('https://werebot.firebaseio.com/');

  teams = base.child('teams');


  /* PRIVATE */

  getTeamId = dot('team');

  getUserId = dot('user');

  getStatus = dot('status');

  getChild = R.curry(function(name, ref) {
    return ref.child(name);
  });

  getUserRef = function(message) {
    return teams.child(getTeamId(message)).child('users/' + getUserId(message));
  };

  getTeamRef = R.pipe(getTeamId, getChild(teams));

  getUserStateRef = R.pipe(getUserRef, getChild('state'));

  getUserStatusRef = R.pipe(getUserRef, getChild('status'));

  getUserBackRef = R.pipe(getUserRef, getChild('back'));

  getUserBackDateTimeRef = R.pipe(getUserRef, getChild('backDateTime'));

  getSnapshot = function(ref) {
    return ref.once('value');
  };

  snapshotToValue = function(snapshot) {
    return snapshot.val();
  };

  getValue = R.pipeP(getSnapshot, snapshotToValue);

  addId = function(value, message) {
    return R.merge(value, {
      id: getUserId(message)
    });
  };

  defaultTo = R.curry(function(defaultValue, val) {
    if (val == null) {
      return defaultValue;
    } else {
      return val;
    }
  });

  getValueWithDefault = function(defaultValue) {
    return R.pipeP(getValue, defaultTo(defaultValue));
  };

  setValue = R.curry(function(value, ref) {
    return ref.set(value);
  });

  makeUserObject = function(userId, snapshot) {
    var user;
    user = {};
    user[userId] = snapshot.val();
    return user;
  };


  /* PUBLIC */

  exports.getUser = R.pipe(getUserRef, getValue);

  exports.getUserState = R.pipe(getUserStateRef, getValueWithDefault('idle'));

  exports.getUserStatus = R.pipe(getUserStatusRef, getValue);

  exports.getUserBack = R.pipe(getUserBackRef, getValue);

  exports.setUserState = function(message, value) {
    return setValue(value, getUserStateRef(message));
  };

  exports.setUserBack = function(message, value) {
    return setValue(value, getUserBackRef(message));
  };

  exports.setUserStatus = R.curry(R.pipe(getUserStatusRef, setValue));


  /* TEST */


  /*message =
    user: 'U036HR7S2'
    team: 'T02FHSL18'
  
   * log addId status: 'fisk', message
   * exports.setUserState message, 'idle'
  exports.getUserState(message)
  .then log
   */

}).call(this);
