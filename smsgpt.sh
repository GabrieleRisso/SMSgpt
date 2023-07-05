# Author: Gabriele Risso  License: MIT
# SMSgpt: https://github.com/GabrieleRisso/SMSgpt/tree/main
# POC of a phone used as SMS gateway to serve queries to chatGPT over GSM network using the regular Android message app.
# Tested on Arch-linux and Google Pixel 6 with Andorid 13


#YOU MUST export open-ai api key
#export OPENAI_API_KEY="sk-BQfU5xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

#for wireless adb
#adb connect 192.168.1.55

#for adb wired just connect your phone. must be in device mode
#adb devices


echo "{OK} STARTED.  Waiting for new incoming messages"
echo "{L?} is ID of the last message. it's normal"

counter=$(adb shell 'content query --uri content://sms/inbox --projection address,body --sort "date ASC"'  | sed '/^$/d' | tail -n 1 | awk '{print $2}' | cut -d'=' -f2- | sed 's/,$//')

while true; do
  new_counter=$(adb shell 'content query --uri content://sms/inbox --projection address,body --sort "date ASC"' | sed '/^$/d' | tail -n 1 | awk '{print $2}' | cut -d'=' -f2- | sed 's/,$//')  
  echo "L: $new_counter"
  

  #command to get the actual counter value

  if ((new_counter > counter)); then

	#find the last recived message, and grep only the adress of it.
	addr="$(adb shell 'content query --uri content://sms/inbox --projection date,address,body --sort "date ASC"' | sed '/^$/d' | tail -n 1 | awk '{print $4}' | cut -d'=' -f2- | sed 's/,$//')"
	
 	echo "{+++} Message recived form $addr:"
	
	#find the last recived message, and grep only the body of it.
	body="$(adb shell 'content query --uri content://sms/inbox --projection date,address,body --sort "date ASC"' | sed '/^$/d' | tail -n 1 | grep -oP '(?<=body=).*' )"
	
	echo "{body}: $body"
	
	#ask chatgpt 
	rep="$(sgpt "$body ? Reply without markdown, special chars, punctuation or emoji in a maximum of 115 chars" | sed 's/ /\\ /g' | sed "s/'/\\\'/g" )"
	
	echo "{rep}: $rep"
	
	#replay with SMS
	adb shell service call isms 5 i32 0 s16 "com.android.mms.service" s16 "null" s16 "${addr}" s16 "null" s16 ${rep} s16 "null" s16 "null" i32 0 i64 0

    echo "{!!!} Sending message to $addr"
	#echo "C: $counter"

	#update counters
    counter=$new_counter

	#remove this line if you wnant to use it with other GSM clients other then yourself 
	counter=$((counter+1))

	echo "{...} Waiting for new incoming messages"

  fi

  sleep 1

done


#---------------
#HACKY way of sending sms;
#adb shell am start -a android.intent.action.SENDTO -d sms:+39xxxxxxxxx --es sms_body "$txt" --ez exit_on_sent false;
#sleep 1;
#adb shell input keyevent 22 && adb shell input keyevent 22 && adb shell input keyevent 23;
