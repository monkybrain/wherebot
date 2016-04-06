exports.log = (a) -> console.log a
exports.logResponse = (err, response) -> if err? then console.error err else console.log response