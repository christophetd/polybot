[![Build Status](https://travis-ci.com/christophetd/awesome-bot.svg?token=XndQsXByyZvxbqRRWyCC&branch=master)](https://travis-ci.com/christophetd/awesome-bot)

# Awesome bot

This repository holds the source code of the Telegram Bot AwesomeBot (@ThousandBot for legacy reasons).

## Running

Requirements: Node, Npm

- Clone this repository, and `cd` in it

```
git clone https://github.com/christophetd/awesome-bot
cd awesome-bot
```
- Install dependencies

```
npm install
```
- Create a new Bot as explained [here](https://core.telegram.org/bots#3-how-do-i-create-a-bot)

- Copy the sample configuration file:

```
cp src/config/secrets.coffee.sample src/config/secrets.coffee
```
- Set the secret keys in this file

- Run the bot by running

```
npm start
```

- All set! You can now talk to the bot on Telegram. Please note that its username will *not* be @ThousandBot, but the username you have chosen when you created it.

## Testing

The tests are regrouped in the `spec` folder. To run the tests, use

```
npm test
```
