R = require 'ramda'
Firebase = require 'firebase'

{log} = require '../../misc/util'

# Refs
getBase = (url) -> new Firebase url
getChild = R.curry (name, ref) -> ref.child(name)

# Get
getSnapshot = (ref) -> ref.once 'value'
snapshotToValue = (snapshot) -> snapshot.val()
getValue =  R.pipe getSnapshot, snapshotToValue

# Defaults
defaultTo = R.curry (defaultValue, val) -> if not val? then defaultValue else val
getValueWithDefault = (defaultValue) -> R.pipeP getValue, defaultTo(defaultValue)

# Set
setValue = R.curry (value, ref) -> ref.set value

# test...
message =
  user: 'U036HR7S2'
  team: 'T02FHSL18'

exports =
  # Getters
  getBase: getBase
  getValue: getValue
  getValueWithDefault: getValueWithDefault
  # Setters
  setValue: setValue
