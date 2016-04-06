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
makeUserObject = (userId, snapshot) ->
  user = {}
  user[userId] = snapshot.val()
  user

### PUBLIC ###

# STREAM
response$ = new Rx.Subject()

# GET
getUserState = (message) ->

  new Promise (resolve, reject) =>

    # Get user state
    getUserStateRef(getTeamId(message), getUserId(message)).once 'value', (snapshot) =>

      # If no record, default to 'idle'
      state = if not snapshot.val()? then 'idle' else state

      # Resolve promise
      resolve state

      # Push to response stream
      response$.onNext state

# SET
setUserStatus = (message, entities) -> getUserStatusRef(getTeamId(message), getUserId(message)).set entities['status']
setUserState = (message, state) -> getUserStateRef(getTeamId(message), getUserId(message)).set state

module.exports =
  response$: response$.share()
  getUserState: getUserState
  setUserStatus: setUserStatus
  setUserState: setUserState

### TEST ###
message =
  team: 'T0123'
  user: 'U0ABC'
entities =
  status: 'at work'
