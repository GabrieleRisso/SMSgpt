sudo systemctl start docker.service 
alias sgpt="docker run --rm --env OPENAI_API_KEY --volume gpt-cache:/tmp/shell_gpt ghcr.io/ther1d/shell_gpt"

#for wireless adb
#adb connect 192.168.1.77


#test="$( echo "dove si torva la vergine dei cristiani ?" | sed 's/ /\\ /g' | sed "s/'/\\\'/g" ) "

#echo $test

#invia SMS
#adb shell service call isms 5 i32 0 s16 "com.android.mms.service" s16 "null" s16 "+393455049699" s16 "null" s16 ${test} s16 "null" s16 "null" i32 0 i64 0
# ciao
# come faccio a diventare maggiorenne?

#ricevi SMS
#adb shell 'content query --uri content://sms/inbox --projection date,address,body --sort "date ASC"' | tail -n 10
#estraggo sms --> sgpt

#mittente: address: +393455049699
#addr="$(adb shell 'content query --uri content://sms/inbox --projection date,address,body --sort "date ASC"' | tail -n 1 | awk '{print $4}' | cut -d'=' -f2- | sed 's/,$//')"

#messaggio del mittente: body: come faccio a divetare bello?
#body="$(adb shell 'content query --uri content://sms/inbox --projection date,address,body --sort "date ASC"' | tail -n 1 | grep -oP '(?<=body=).*' )"

counter=$(adb shell 'content query --uri content://sms/inbox --projection address,body --sort "date ASC"'  | sed '/^$/d' | tail -n 1 | awk '{print $2}' | cut -d'=' -f2- | sed 's/,$//')
#counter=$((counter+1))

while true; do
  new_counter=$(adb shell 'content query --uri content://sms/inbox --projection address,body --sort "date ASC"' | sed '/^$/d' | tail -n 1 | awk '{print $2}' | cut -d'=' -f2- | sed 's/,$//')  
  echo "L: $new_counter"

  #command to get the actual counter value

  if ((new_counter > counter)); then
    	#mittente: address: +393455049699
	addr="$(adb shell 'content query --uri content://sms/inbox --projection date,address,body --sort "date ASC"' | sed '/^$/d' | tail -n 1 | awk '{print $4}' | cut -d'=' -f2- | sed 's/,$//')"
	echo "C: $counter"
	#messaggio del mittente: body: come faccio a divetare bello?
	body="$(adb shell 'content query --uri content://sms/inbox --projection date,address,body --sort "date ASC"' | sed '/^$/d' | tail -n 1 | grep -oP '(?<=body=).*' )"
	echo "body: $body"
	#chiedo a gpt una risposta
	rep="$(sgpt " ${body} Rispondi in maniera solare e incalzante con un massimo di 115 caratteri" | sed 's/ /\\ /g' | sed "s/'/\\\'/g" )"
	
	#file="tempfile.txt" 

	#cat <<EOF > "$file"
	#$rep
	#EOF
	
	#repf=$(python strip.py $file)
	echo "rep: $rep"
	
	#rispondo con un SMS
	adb shell service call isms 5 i32 0 s16 "com.android.mms.service" s16 "null" s16 "${addr}" s16 "null" s16 ${rep} s16 "null" s16 "null" i32 0 i64 0

    	counter=$new_counter
	counter=$((counter+1))
        echo "C sending: $counter"


  fi

  sleep 1
done

#chiedo a gpt una risposta
#rep="$(sgpt " ${body} Rispondi con un massimo di 115 caratteri" | sed 's/ /\\ /g' | sed "s/'/\\\'/g" )"

#echo $rep
#rispondo con un SMS
#adb shell service call isms 5 i32 0 s16 "com.android.mms.service" s16 "null" s16 "${addr}" s16 "null" s16 ${rep} s16 "null" s16 "null" i32 0 i64 0


#---------------
#metodo dimmerda
#adb shell am start -a android.intent.action.SENDTO -d sms:+393455049699 --es sms_body "$txt" --ez exit_on_sent false;
#sleep 1;
#adb shell input keyevent 22 && adb shell input keyevent 22 && adb shell input keyevent 23;
