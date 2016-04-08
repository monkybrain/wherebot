Firebase = require 'firebase'
Promise = require 'promise'
R = require 'ramda'
Rx = require 'rx'


# My modules
{dot, method} = require '../misc/helpers'
{log} = require '../misc/util'

base = new Firebase 'https://werebot.firebaseio.com/'
teams = base.child 'teams'

### PRIVATE ###

# Parse message
getTeamId = dot('team')
getUserId = dot('user')
getStatus = dot('status')

# Handle refs and children
getChild = R.curry (name, ref) -> ref.child(name)
getUserRef = (message) -> teams.child(getTeamId(message)).child('users/' + getUserId(message))
getTeamRef = R.pipe getTeamId, getChild(teams)
getUserStateRef = R.pipe getUserRef, getChild('state')
getUserStatusRef = R.pipe getUserRef, getChild('status')
getUserBackRef = R.pipe getUserRef, getChild('back')
getUserBackDateTimeRef = R.pipe getUserRef, getChild('backDateTime')

# GET
# Firebase Ref -> Snapshot
getSnapshot = (ref) -> ref.once 'value'

# Snapshot to value (Firebase Snapshot -> Object)
snapshotToValue = (snapshot) -> snapshot.val()

# Get Value (Firebase Ref -> Object)
getValue = R.pipeP getSnapshot, snapshotToValue

addId = (value, message) -> R.merge value, id: getUserId(message) # To be implemented

defaultTo = R.curry (defaultValue, val) -> if not val? then defaultValue else val

# Get Value With Default (Firebase Ref -> String -> String)
getValueWithDefault = (defaultValue) -> R.pipeP getValue, defaultTo(defaultValue)

# SET helpers
# setValue = (value, ref) -> ref.set value
setValue = R.curry (value, ref) -> ref.set value

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
# TODO: Curry the rest (and work out how to to do it nicely...)
exports.setUserState = (message, value) -> setValue(value, getUserStateRef(message))
exports.setUserBack = (message, value) -> setValue(value, getUserBackRef(message))
# exports.setUserStatus = (message, value) -> setValue(value, getUserStatusRef(message))
exports.setUserStatus = R.curry R.pipe(getUserStatusRef, setValue)

### TEST ###

###message =
  user: 'U036HR7S2'
  team: 'T02FHSL18'

# log addId status: 'fisk', message
# exports.setUserState message, 'idle'
exports.getUserState(message)
.then log###



