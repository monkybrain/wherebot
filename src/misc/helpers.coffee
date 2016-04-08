R = require 'ramda'

### SLACK ###

# [TEST] String -> Boolean
isTag = R.test /<@.[^<]*>/

# [TRANSFORM] String -> String
toLowerCase = (string) -> string.toLowerCase()

# [TRANSFORM] String -> String
wordToLowerCaseUnlessTag = (word) -> if isTag(word) then word else toLowerCase(word)

# [TRANSFORM] String -> String
sentenceToLowerCaseUnlessTag = R.pipe R.split(" "), R.map(wordToLowerCaseUnlessTag), R.join " "

# [TRANSFORM] Object -> Object
messageTextToLowerCaseExceptTags = R.evolve text: sentenceToLowerCaseUnlessTag

# [TEST] String -> Boolean
typeIs = (value) -> R.pipe dot('type'), R.equals value

# [TEST] String -> Boolean
userIsnt = (userId) -> R.pipe dot('user'), R.equals(userId), R.not

# [GET] Object -> String -> Value/Object
dot = (key) -> (obj) -> if obj[key]? then obj[key] else undefined
method = dot

### PUBLIC ###
module.exports =
  dot: dot
  method: method
  slack:
    userIsnt: userIsnt
    typeIs: typeIs
    messageTextToLowerCaseExceptTags: messageTextToLowerCaseExceptTags


