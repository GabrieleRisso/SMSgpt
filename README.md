# SMSgpt
POC of a phone used as SMS gateway to serve queries to chatGPT over GSM network using the regular Android message app. 

#### Tested on Arch-linux and Google Pixel 6 with Andorid 13

## How it work

Android Debug Bridge aka "adb" connection is created, either wired or wireless, from computer to phone.
smsgpt listen for new incoming messages on the phone, checks the body of the last message and queries ChatGPT.
The new message is then sent as a reply to the client phone number.

## How to setup
#### PC:
Open a BASH terminal

Download sgpt (used to talk to chatGPT): ```pip install shell-gpt```

Set your open-ai api key: ```export OPENAI_API_KEY="sk-BQfU50xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"```

Download adb and test it with: ```adb --version``` 

#### PHONE:
No root is required.
In developer settings activate:

ABD wired connection: ```debug usb ON```

(Recommended) ABD wireless connection: ```wireless debug ON```

#### (optional) PC:
Check if adb is working after pairing: ```adb devices``` must be in DEVICE mode.

(Recommended) Connect to wireless abd: ```abd connect IP-addr-of-the-phone```

# How to use

#### There are two modes: real world use and chat with yourself

## chat with yourself :

Start script in bash terminal: ./smsgpt.sh

On the phone, to test it, go to the message SMS app and text yourself with a question.

### Expected terminal output:
```
{...} Waiting for new incoming messages
L: 544
L: 544
L: 545
{+++} Message recived:
body: Where is the money ?
rep:
The\ money\ is\ in\ banks,\ investments,\ and\ people\'s\ wallets,\ both\ physically\ and\ digitally.
Result: Parcel(00000000 '....')
C: 546
{...} Waiting for new incoming messages
L: 546
L: 546
L: 546
```
### On the phone:
```
Recive a message with the chatGPT reply
```

# REAL WORLD USE:
Remove/comment the line: ```counter=$((counter+1))```

This allows remote clients to text your phone number and receive chatGPT reply messages on their phone over the GSM network.
All possible phone clients are natively supported: Android (Google), iOS (Apple), Windows Phone (Microsoft), BlackBerry OS (BlackBerry), Symbian (Nokia).

## Limitation and bugs:
```
. Only one message at the time is supported, it trips if there are more the one message. it starts talking to itself...
. SMSs are limited to 160 chars. For now I'm limiting individual SMS to that lenght and not splitting them.
. A message is not sent when the body contains special chars, like emoji or strange char.
. Real word use mode issue: the reply SMS sent from the server to the client is not displayed on server SMS messaging app, only in the console and client message app.
```

## Leave a star if you enjoy this

#### credits due to shell-gpt: https://github.com/TheR1D/shell_gpt

 
