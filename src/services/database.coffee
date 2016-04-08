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
getTeamId = dot('team')
getUserId = dot('user')
getStatus = dot('status')

getUserRef = (teamId, userId) -> teams.child(teamId).child('users/' + userId)
getUserStateRef = (teamId, userId) -> getUserRef(teamId, userId).child('state')
getUserStatusRef = (teamId, userId) -> getUserRef(teamId, userId).child('status')
getUserBackRef = (teamId, userId) -> getUserRef(teamId, userId).child('back')
getUserBackDateTimeRef = (teamId, userId) -> getUserRef(teamId, userId).child('backDateTime')

makeUserObject = (userId, snapshot) ->
  user = {}
  user[userId] = snapshot.val()
  user

### PUBLIC ###

# STREAM
response$ = new Rx.Subject()

# GET: User
getUser = (message) =>

  new Promise (resolve, reject) =>

    # Get user state
    getUserRef(getTeamId(message), getUserId(message)).once 'value', (snapshot) =>

      user = R.merge snapshot.val(), id: getUserId(message)

      # Resolve user
      resolve user

      # Push to response stream
      # response$.onNext makeUserObject(getUserId(message), snapshot)

# GET: User state
getUserState = (message) =>

  new Promise (resolve, reject) =>

    # Get user state
    getUserStateRef(getTeamId(message), getUserId(message)).once 'value', (snapshot) =>

      # If no record, default to 'idle'
      state = if not snapshot.val()? then 'idle' else snapshot.val()

      # Resolve state
      resolve state

      # Push to response stream
      response$.onNext state

# GET: User status
getUserStatus = (message) =>

  new Promise (resolve, reject) =>

    # Get user status
    getUserStatusRef(getTeamId(message), getUserId(message)).once 'value', (snapshot) =>

      # Get status from snapshot
      status = snapshot.val()

      log status

      # Resolve status
      resolve status

      # Push to response stream
      response$.onNext status

# SET
setUserStatus = (message, status) -> getUserStatusRef(getTeamId(message), getUserId(message)).set status
setUserState = (message, state) -> getUserStateRef(getTeamId(message), getUserId(message)).set state
setUserBack = (message, back) -> getUserBackRef(getTeamId(message), getUserId(message)).set back
setUserBackDateTime = (message, backDateTime) -> getUserBackDateTimeRef(getTeamId(message), getUserId(message)).set backDateTime

module.exports =
  response$: response$.share()
  getUserState: getUserState
  getUser: getUser
  setUserStatus: setUserStatus
  setUserState: setUserState
  setUserBack: setUserBack
  setUserBackDateTime: setUserBackDateTime

### TEST ###
message =
  team: 'T0123'
  user: 'U0ABC'
entities =
  status: 'at work'
