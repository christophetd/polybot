log   = require 'winston'
path  = require 'path'
config = {}
config.handlers_dir = path.resolve(__dirname, "..", "handlers")

# Check if we are in a testing environment
if process.env.ENV is 'test'
  # The secrets should now come from the environment variables
  config.secrets = {
    yandex: process.env.YANDEX_KEY,
    telegram: process.env.TELEGRAM_KEY,
    owm: process.env.OWM_KEY
  }

  for key of config.secrets
    if not config.secrets[key]?
      log.error "Unable to find environment variable corresponding to the secret key of "+key
      process.exit 1

else
  # Load the file containing the secret keys
  try
    config.secrets = require './secrets'
  catch err
    log.error "Unable to find "+path.join(__dirname, "secrets.coffee") + ". Please refer to the documentation"
    process.exit 1

module.exports = config
