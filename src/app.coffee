token =
  wit: process.env.WIT_TOKEN
  slack: process.env.SLACK_TOKEN

Slack = require './services/slack'
Wit = require './services/wit'