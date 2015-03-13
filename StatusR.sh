#!/bin/bash

#	https://github.com/mohamedation/StatusR
#	originally written by: Mohamed Adel
#	e-mail: mohamedation[at]gmail[dot]com
#	twitter: [at]Mohamedation

#	this is version 2.5 of the script. for more information, Please find the read me file.





clear

# checks if lynx is installed and if not, it stops the script and exit.
command -v lynx >/dev/null 2>&1 || { echo >&2 "I require lynx to work, but it's not installed. Please, install lynx first.  Aborting."; exit 1; }
echo -e "\033[1mHello, $USER. Here are the Current Reports.\033[0m"
echo -e "$(date) \n"

# checks if You are connected to the internet or not and if not, it stops the script and exit.
echo -e '\033[1mInternet Connection status\033[0m'
wget -q --tries=10 --timeout=20 -O - http://google.com > /dev/null
if [[ $? -eq 0 ]]
then
	echo -e "\e[32mOnline\e[0m"
else
	echo -e "\e[31mOffline\e[0m" && echo -e "\e[31mCan't communicate with the outside world. Aborting\e[0m" && exit
fi

# checks Google DNS Primary server. You can change it to whatever DNS service you are using or just comment it out.
echo -e '\033[1mGoogle DNS status\033[0m'
ping  -c 1 -W 10  8.8.8.8 > /dev/null
if [[ $? -eq 0 ]]
then
        echo -e "\e[32mUp\e[0m"
else
        echo -e "\e[31mDown\e[0m"
fi

# checks the internet threat levels on ISC and MSISAC.
echo -e '\033[1mInternet threat level\033[0m'
# Threat Level According to Internet Storm Center. visit https://isc.sans.edu/infocon.html to know more. 
threatlvl=$(lynx -dump "http://isc.sans.edu/infocon.txt")
if [ "$threatlvl" == "green" ]
then
	echo -e "\e[32mGreen, Everything is normal. No significant new threat known according to ISC.\e[0m"
	
elif [ "$threatlvl" == "test" ]
then
	echo -e "\e[34mTest, This status is used for testing only. Everything is normal. No significant new threat known according to ISC.\e[0m" 		
elif [ "$threatlvl" == "yellow" ]
then
	echo -e "\e[33mYellow, We are currently tracking a significant new threat. The impact is either unknown or expected to be minor according 		to ISC\e[0m"
	
elif [ "$threatlvl" == "orange" ]
then
	echo -e "\e[33mOrange, A major disruption in connectivity is imminent or in progress according to ISC.\e[0m"

elif [ "$threatlvl" == "red" ]
then
	echo -e "\e[31mRed, Loss of connectivity across a large part of the internet according to ISC.\e[0m"

else
	echo "$threatlvl"
fi

# Threat level according to Multi-State information Sharing & Analysis Center. visit https://msisac.cisecurity.org/alert-level/index.cfm to know more.
threatlvl2=$(lynx -dump "https://msisac.cisecurity.org/text/index.cfm?keys=level")


if [ "$threatlvl2" == "low" ]
then
	echo -e "\e[32mLow, No unusual activity exists beyond the normal concern for known hacking activities, known viruses or other malicious activity according to MSISAC.\e[0m"
	
elif [ "$threatlvl2" == "guarded" ]
then
	echo -e "\e[34mGuarded, Risk of increased hacking, virus or other malicious activity according to MSISAC.\e[0m" 		

elif [ "$threatlvl2" == "elevated" ]
then
	echo -e "\e[33mElevated, Risk due to increased hacking, virus or other malicious activity which compromises systems or diminishes service according to MSISAC. \e[0m"
	
elif [ "$threatlvl2" == "high" ]
then
	echo -e "\e[31mHigh, High risk of increased hacking, virus or other malicious cyber activity according to MSISAC.\e[0m"

elif [ "$threatlvl2" == "severe" ]
then
	echo -e "\e[31mSevere, Loss of connectivity across a large part of thesevere risk of hacking, virus or other malicious activity resulting in wide-spread outages and/or significantly destructive compromises to systems with no known remedy or debilitates one or more critical infrastructure sectors according to MSISAC.\e[0m"
	
else
	echo "$threatlvl2"
fi







echo -e "\033[1mPower Grid Status\033[0m"
pwrgrid=$(lynx -dump "http://www.gridstatusnow.com/status")
if [ "$pwrgrid" == '{"status":"Safe"}' ]
then
	echo -e "\e[32mSafe ⚡ ⚡ ⚡ ⚡ ⚡ ⚡ \e[0m"
	
elif [ "$pwrgrid" == '{"status":"Warning"}' ]
then
	echo -e "\e[33mWarning! Try to preserve Power and save Your work. ⚠ ⚠ ⚠ \e[0m"

elif [ "$pwrgrid" == '{"status":"Danger"}' ]
then
	echo -e "\e[31mDanger ↯ ☠ ☠ ☠ ☠ \e[0m"

else
	echo "No Data"
fi

#checking weather. You must change "/HECA.html" to the desired location.
echo -e "\033[1mWeather\033[0m"
lynx -dump "http://weather.noaa.gov/weather/current/HECA.html" | grep --after-context=5 "Wind " | sed -e 's/^[ \t]*//'

#checking space weather.
echo -e "\033[1mSpace Weather\033[0m"
xray=$(lynx -dump "http://www.hamqsl.com/solarxml.php" | grep -o -P '(?<=xray>).*(?=</xray>)' | sed -e 's/^[ \t]*//' )
kindex=$(lynx -dump "http://www.hamqsl.com/solarxml.php" | grep -o -P '(?<=kindex>).*(?=</kindex>)' | sed -e 's/^[ \t]*//' )
# to learn more about flare classes >> http://spaceweather.com/glossary/flareclasses.html
echo "X-ray class is $xray"
# to learn more about K-index >> https://en.wikipedia.org/wiki/K-index
if [ "$kindex" -eq 4 ]
then
	echo -e "\e[33mK-index is $kindex (slight disturbance)\e[0m"
elif [ "$kindex" -gt 4 ]
then
	echo -e "\e[31mK-index is $kindex (Magnetic storm in progress)\e[0m"
else
	echo -e "\e[32mK-index is $kindex (No disturbance)\e[0m"
fi






exit
