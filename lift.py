#!/usr/bin/python

import Adafruit_BBIO.GPIO as GPIO
import time

## pin defs ##
sevenSegDisplay = {"A": "P8_11", "B": "P8_12", "C": "P8_13", "D": "P8_14", 
"E": "P8_15", "F": "P8_16", "G": "P8_17", "H": "P8_18"}
floorButtons = ["P8_10", "P8_8", "P8_9", "P8_7"]

## functions defs ##
def setAllLeds(val):
	logicLevel = [GPIO.HIGH, GPIO.LOW]
    for key in sevenSegDisplay:
        GPIO.output(sevenSegDisplay[key], logicLevel[val])

def displayNum(n):
    if n == 0:
        setAllLeds(1)
        GPIO.output(sevenSegDisplay["G"], GPIO.HIGH)
        GPIO.output(sevenSegDisplay["H"], GPIO.HIGH)

    elif n == 1:
        setAllLeds(0)
        GPIO.output(sevenSegDisplay["B"], GPIO.LOW)
        GPIO.output(sevenSegDisplay["C"], GPIO.LOW)

    elif n == 2:
        setAllLeds(1)
        GPIO.output(sevenSegDisplay["C"], GPIO.HIGH)
        GPIO.output(sevenSegDisplay["F"], GPIO.HIGH)
        GPIO.output(sevenSegDisplay["H"], GPIO.HIGH)
                        
    elif n == 3:
        setAllLeds(1)
        GPIO.output(sevenSegDisplay["E"], GPIO.HIGH)
        GPIO.output(sevenSegDisplay["F"], GPIO.HIGH)
        GPIO.output(sevenSegDisplay["H"], GPIO.HIGH)

def main():
    ## pin setup and initialization ##
    for key in sevenSegDisplay:
        GPIO.setup(sevenSegDisplay[key], GPIO.OUT)

    for pin in floorButtons:
        GPIO.setup(pin, GPIO.IN)
        GPIO.add_event_detect(pin, GPIO.FALLING)

    currentFloor = 0
    destFloor = 0
    displayNum(0) ## lift is at floor 0 ##

    while True:
        for pin in floorButtons:
            if GPIO.event_detected(pin):
                destFloor = floorButtons.index(pin)
                break

        time.sleep(0.02)

        if currentFloor != destFloor:
            time.sleep(0.25)

            step = 0
            if currentFloor < destFloor:
                step = 1
            else:
                step = -1

            while (currentFloor + step) != destFloor:
                time.sleep(2)
                currentFloor += step
                displayNum(currentFloor)

            time.sleep(2.25)
            currentFloor += step
            for i in range (3):
                setAllLeds(0)
                time.sleep(0.5)
                displayNum(currentFloor)
                time.sleep(0.5)
## start ##
main()