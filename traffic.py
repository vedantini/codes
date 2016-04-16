import Adafruit_BBIO.GPIO as GPIO
import time

# to make all LEDs HIGH
def colorAllHIGH(colorLEDs):
	for led in colorLEDs:
		GPIO.output(led, GPIO.HIGH)
 
 # GPIO pins naming initials
p8="P8_"
p9="P9_"

# setting up all the pins as output and making them low initially
i=1
for i in range(1,47):
	print i	
	
	GPIO.setup(p8+str(i),GPIO.OUT)
	GPIO.output(p8+str(i),GPIO.LOW)
	
	GPIO.setup(p9+str(i),GPIO.OUT)
	GPIO.output(p9+str(i),GPIO.LOW)

	time.sleep(0.1)
	
print "all_low_done"
time.sleep(4)

# to check mapping of LEDs to the GPIO pins of the Beaglebone Black
'''
print "P8"

for i in range(1,47):
	print i	
	
	GPIO.output(p8+str(i),GPIO.HIGH)
	time.sleep(3)
	GPIO.output(p8+str(i),GPIO.LOW)


time.sleep(4)

print "P9"


for i in range(1,47):
	print i	
	
	GPIO.output(p9+str(i),GPIO.HIGH)
	time.sleep(3)
	GPIO.output(p9+str(i),GPIO.LOW)


print "checking of pin no done."
'''

# LEDs are divided into 4 quadrants (for simplicity 0, 1, 2, 3)

# index of the arrays below specifies the quadrant
redLEDs = ["P9_23", "P9_11", "P8_11", "P8_18"]
yellowLEDs = ["P9_16", "P9_13", "P8_13", "P8_16"]
greenLEDs = ["P9_14", "P9_15", "P8_15", "P8_14"]
leftTurnLEDs = ["P8_17", "P8_12", "P9_24", "P9_12"]

# make all free left signals active
colorAllHIGH(leftTurnLEDs)

#continuous loop
while True:
	
	j=0
	for j in range(0, 4):

		# red signals of all quadrants active
		colorAllHIGH(redLEDs)
		
		# GREEN signal
		print "Quadrant "+str(j)+" GO signal"		
		GPIO.output(redLEDs[j],GPIO.LOW)
		GPIO.output(greenLEDs[j],GPIO.HIGH)	
		time.sleep(5)
		GPIO.output(greenLEDs[j],GPIO.LOW)
		
		# YELLOW signal
		print "Quadrant "+str(j)+" WAIT signal"
		GPIO.output(yellowLEDs[j],GPIO.HIGH)
		time.sleep(1)
		GPIO.output(yellowLEDs[j],GPIO.LOW)
	
		print "\n"	
