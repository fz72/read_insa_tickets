#!/bin/bash

input="auth.txt"
while IFS= read -r line
do
	param="${line:0:6}"
	case $param in
	"aboid=")
		aboid_file="${line:6}"
		;;
	"email=")
		email_file="${line:6}"
		;;
	"kvpid=")
		kvpid_file="${line:6}"
		;;
	esac
done < "$input"

read -p "Abo Id($aboid_file):" aboId
read -p "Email($email_file):" email
read -p "kvpid($kvpid_file):" kvpid

if [ "$kvpid" == "" ]
then
	kvpid="$kvpid_file"
fi

if [ "$aboid" == "" ]
then
        aboid="$aboid_file"
fi

if [ "$email" == "" ]
then
        email="$email_file"
fi


url=$(echo "https://deutschlandticket.insa.de/srv/dtick_srv/abo/verify")

echo "Request:" $url "/" $aboid "/" $email "/" $kvpid

content=$(curl --compressed -sS -H "accept: application/json" --data-urlencode "email=$email" -d "aboid=$aboid" -d "kvpid=$kvpid" -G "$url")
if [ $? -ne 0 ]; then
	echo "Request error"
	exit 1
fi

#echo $content

error_code=$(echo $content | jq -r '.error.errcode')
error=$(echo $content | jq -r '.error.errdesc')

if [ $error_code != "" ] && [ $error_code != "0" ]
then
	echo "Error:" $error_code" "$error
	exit 1
fi

token=$(echo $content | jq -r '.data."x-auth-token"')
echo "Token:" $token


content=$(curl --compressed -sS -H "accept: application/json" -H "x-auth-token: $token"  https://deutschlandticket.insa.de/srv/dtick_srv/abo/load)
if [ $? -ne 0 ]; then
	echo "Request error"
	exit 1
fi

#echo $content

echo $content | jq -c '.data.ticket_list[]' | while read i; do
	
    	#echo "$i"
	
	qrcode=$(echo $i | jq -r '.qrcode')
	validfrom=$(echo $i | jq -r '.validity_begin')
	productname=$(echo $i | jq -r '.product_name')
	uuid=$(echo $i | jq -r '.uuid')

	#echo "base64:" $qrcode

	filename=$(echo "ticket_"$validfrom"_"$productname"_"$uuid".png")

	base64 -d <<< "$qrcode" >> "$filename"

	echo "Ticket gesichert:" $filename

done
