#!/bin/python
import urllib2 , time , socket , sys , getpass , os
os.system('cls' if os.name == 'nt' else 'clear')
user = getpass.getuser()
REMOTE_SERVER = "www.google.com"
print "Hello" , user+","  , "Here are the current reports."
print (time.strftime("%c")) , "\n"

def internet_connection():
  try:
    host = socket.gethostbyname(REMOTE_SERVER)
    s = socket.create_connection((host, 80), 2)
    return True
  except:
     pass
  return False
if internet_connection() == False :
	print "\033[1;31mUnable to communicate with the outside world. Aborting\033[1;m"
	sys.exit()
print "Internet Connection Status"
if internet_connection() == True :
	print "\033[1;32mOnline\033[1;m"
print "Internet Threat Level"                                      
isc = urllib2.urlopen("http://isc.sans.edu/infocon.txt") 
threatlvl = isc.read()                            
isc.close()
                                      
if threatlvl == "green":
	print "\033[1;32mGreen, Everything is normal. No significant new threat known according to ISC.\033[1;m"
elif threatlvl == "test":
	print "\033[1;34mTest, This status is used for testing only. Everything is normal. No significant new threat known according to ISC.\033[1;m"
elif threatlvl == "yellow":
	print "\033[1;33mYellow, We are currently tracking a significant new threat. The impact is either unknown or expected to be minor according to ISC.\033[1;m"
elif threatlvl == "orange":
	print "Orange, A major disruption in connectivity is imminent or in progress according to ISC."
elif threatlvl == "red":
	print "\033[1;31mRed, Loss of connectivity across a large part of the internet according to ISC.\033[1;m"


msisac = urllib2.urlopen("https://msisac.cisecurity.org/text/index.cfm?keys=level")
threatlvl2 = msisac.read()
threatlvl2 = threatlvl2.strip('\n')
msisac.close()
if threatlvl2 == "low":
	print "\033[1;32mLow, No unusual activity exists beyond the normal concern for known hacking activities, known viruses or other malicious activity according to MSISAC.\033[1;m"
elif threatlvl2 == "guarded":
	print "\033[1;34mGuarded, Risk of increased hacking, virus or other malicious activity according to MSISAC.\033[1;m"
elif threatlvl2 == "elevated":
	print "\033[1;33mElevated, Risk due to increased hacking, virus or other malicious activity which compromises systems or diminishes service according to MSISAC.\033[1;m"
elif threatlvl2 == "high":
	print "\033[1;35mHigh, High risk of increased hacking, virus or other malicious cyber activity according to MSISAC.\033[1;m"
elif threatlvl2 == "severe":
	print "\033[1;31mSevere, Loss of connectivity across a large part of thesevere risk of hacking, virus or other malicious activity resulting in wide-spread outages and/or significantly destructive compromises to systems with no known remedy or debilitates one or more critical infrastructure sectors according to MSISAC.\033[1;m"

print "Power Grid Status" 
gridstatus = urllib2.urlopen("http://www.gridstatusnow.com/status")
pwrgrid = gridstatus.read()
gridstatus.close()
if pwrgrid == '{"status":"Safe"}' :
	print "\033[1;32mSafe\033[1;m"
elif pwrgrid == '{"status":"Warning"}' :
	print "\033[1;33Warning! Try to preserve Power and save Your work.\033[1;m"
elif pwrgrid == '{"status":"Danger"}' :
	print "\033[1;31mDanger\033[1;m"
sys.exit()
