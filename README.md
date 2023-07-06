# SMSgpt
POC of a phone used as SMS gateway to serve queries to chatGPT over GSM network using the regular Android message app. 

#### Tested on Arch-linux and Google Pixel 6 with Andorid 13

## How it work

Android Debug Bridge aka  ```adb``` connection is created, either wired or wireless, from computer to phone.
```smsgpt``` listen for new incoming messages on the phone, checks the body of the last message and queries ChatGPT.
The new message is then sent as a response to the client phone number.

## How to setup
#### Server

-    Download sgpt (used to communicate to chatGPT): ```pip install shell-gpt```

-    Set your open-ai api key: ```export OPENAI_API_KEY="sk-BQfU50xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"```

- Download adb and test it with: ```adb --version``` 

#### Phone1 (No root is required)

In developer settings activate:

- ABD wired connection:        ```debug usb ON```

- ABD wireless connection:     ```wireless debug ON```

#### Server-Phone connect
- Check if adb is working after pairing: ```adb devices``` must be in device mode.

- Connect to wireless abd: ```abd connect IP-addr-of-the-phone``` (Recommended) 


# Use: ./smsgpt.sh

#### There are two modes: ```gateway``` and ```chat with yourself```

## chat with yourself mode:

    --> PC(Server) --- USB adb --> Phone1 ---\                                
               \---- WIFI adb --> Phone1 ------> GSM Network --> PC(Server) -->
                    {3-500 m}                   {loopback}

Start script in bash terminal: ```./smsgpt.sh```

On the phone, to test it, go to the message SMS app and text yourself with a question.

### Expected terminal output:
```
{OK} STARTED.  Waiting for new incoming messages
{L?} is Id of the last message.
1668
1668
1670

{<--} Incoming message N^1668 form +33XXXXXXXXXX
{type}:		inbound
{body}:		Math or chocolate?

{-->} Sending message to +33XXXXXXXXXX
{type}:		outbound
{body}:		Math or chocolate? Well, that's a tough choice. I guess it depends on whether you prefer numbers or sweetness.

{...} Waiting for new incoming messages
Result: Parcel(00000000    '....')
1670
1670
1670

```
### On the phone:
```
Receive a SMS message with the chatGPT reply as its body
```

# gateway mode:
Activate with: remove/comment the line: ```counter=$((counter+1))```

This allows remote clients to text your phone number and receive chatGPT reply messages on their phone over the GSM network.
All possible phone clients are natively supported: Android (Google), iOS (Apple), Windows Phone (Microsoft), BlackBerry OS (BlackBerry), Symbian (Nokia).



    PC(Server) --- USB adb --> Phone1
            \---- WIFI adb --> Phone1 --> GSM Network --> Phone2(Client)
                  {3-500 m}              {long range}
                   


## Limitation and bugs:
```
. Only one message at the time is supported.
. SMSs are limited to 160 chars. For now I'm limiting individual SMS to that lenght and not splitting them. SMS concatenation is possible.
. A message is not sent when the body contains special chars, like emoji or strange char.
. Real word use mode issue: the reply SMS sent from the server to the client is not displayed on server SMS messaging app, only in the console and client message app.
```

## Leave a star if intrested in further development

#### Acknowledgements should be given to shell-gpt, which can be found at this GitHub repository: https://github.com/TheR1D/shell_gpt.

 
