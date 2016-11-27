# EPFL PolyBot

This repository holds the source code of the Telegram Bot EPFL PolyBot (@epfl_PolyBot).

[**Talk to PolyBot!**](https://telegram.me/epfl_polybot)

## Features

You can talk to the bot using natural language, and ask him about:
- the menu of the campus restaurants
- the room occupancies
- (more to come!)

Sample conversation:

![bot](https://cloud.githubusercontent.com/assets/136675/18413587/8a40d208-77b4-11e6-87f5-7660b81c9afb.PNG)

Update: you can also ask him the metro schedules! (only leaving from EPFL)

![metros](https://cloud.githubusercontent.com/assets/136675/20647472/c84bf8fe-b49d-11e6-98bf-b9ef84fe9f52.PNG)

It uses the [OpenData Transport API](https://transport.opendata.ch/).

If you don't want to type human-readable sentences, the following also works:

```
/metro lausanne
/menu cafeteria MX
/room INF2
```


The bot is only available in french as of now.

## Running

Requirements: Node, Npm

- Clone this repository, and `cd` in it

```
git clone https://github.com/christophetd/polybot
cd polybot
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
