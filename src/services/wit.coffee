# Node modules
Rx = require 'rx';
wit = require 'node-wit'

{log} = require '../misc/util'
{dot} = require '../misc/helpers'

### PRIVATE ###
token = process.env.WIT_TOKEN
getText = dot('text')
arrayNotEmpty = (array) -> array.length > 0
makeStateObject = (state) -> {context: {state: state}}

### PUBLIC ###

# Stream of wit.ai outcomes
bundle$ = new Rx.Subject()

# Process incoming slack message
processMessage = (message, state) ->

  # Send message to wit.ai for processing...
  wit.captureTextIntent token, getText(message), makeStateObject(state), (err, res) =>

    # ...then push bundle of incoming message and outcome to stream (unless no outcome)
    if arrayNotEmpty(res.outcomes)
      bundle = message: message, outcome: res.outcomes[0]
      bundle$.onNext bundle

module.exports =
  bundle$: bundle$.share()
  processMessage: processMessage
