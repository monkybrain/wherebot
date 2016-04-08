Firebase = require 'firebase'
Promise = require 'promise'
R = require 'ramda'
Rx = require 'rx'


# My modules
{dot} = require '../misc/helpers'
{log} = require '../misc/util'

base = new Firebase 'https://werebot.firebaseio.com/'
teams = base.child 'teams'

### PRIVATE ###

# Parse message
getTeamId = dot('team')
getUserId = dot('user')
getStatus = dot('status')

# Handle refs and children
getUserRef = (message) -> teams.child(getTeamId(message)).child('users/' + getUserId(message))
getUserStateRef = (message) -> getUserRef(message).child('state')
getUserStatusRef = (message) -> getUserRef(message).child('status')
getUserBackRef = (message) -> getUserRef(message).child('back')
getUserBackDateTimeRef = (message) -> getUserRef(message).child('backDateTime')

# GET helpers
getSnapshot = (ref) -> ref.once 'value'
snapshotToValue = (snapshot) -> snapshot.val()
getValue = R.pipeP getSnapshot, snapshotToValue
addId = (value, message) -> R.merge value, id: getUserId(message) # To be implemented
defaultTo = R.curry (defaultValue, val) -> if not val? then defaultValue else val
getValueWithDefault = (defaultValue) -> R.pipeP getValue, defaultTo(defaultValue)

# SET helpers
setValue = (value, ref) -> ref.set value

# MISC helpers
makeUserObject = (userId, snapshot) ->
  user = {}
  user[userId] = snapshot.val()
  user

### PUBLIC ###

# GET
exports.getUser = R.pipe getUserRef, getValue
exports.getUserState = R.pipe getUserStateRef, getValueWithDefault('idle')
exports.getUserStatus = R.pipe getUserStatusRef, getValue
exports.getUserBack = R.pipe getUserBackRef, getValue

# SET
# I smell curry here, but can't quite figure it out...
exports.setUserState = (message, state) -> setValue(state, getUserStateRef(message))
exports.setUserBack = (message, state) -> setValue(state, getUserBackRef(message))
exports.setUserStatus = (message, state) -> setValue(state, getUserStatusRef(message))

### TEST ###
###
message =
  user: 'U036HR7S2'
  team: 'T02FHSL18'

# log addId status: 'fisk', message

exports.getUserStatus(message)
.then log
###
