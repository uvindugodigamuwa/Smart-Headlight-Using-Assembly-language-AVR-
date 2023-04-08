# Smart-Headlight-Using-Assembly-language-AVR-
Controlling intensity level of headlight with light level in environment, and dimming headlight when a vehicle come from front. Also consider whether vehicle is moving or not, engine is started or not. Also turn off headlight after some time delay after engine is turned off. 
Used Atmega328p for the project
Used 12V power supply to power two head lights and 7805 voltage regulator was used for suppling power to the circuit.
outside light levels was measured by two LDRs and those analog values were converted to digital values using Analog to digital converter module in the chip
converted digital value was used to control the PWM of the output signal to the two head lights.
Headlights turns on only when environment light level is low than pre defined value and after turned on, it increases the brightness of bulbs with the darkness.
also when a vehicle is coming from front, thet vehicle's headlight level is measured by a LDR and reduces the brightness level of bulbs.
Also light is turned on only when vehicle start to move.
when engine is turned off, headlight is turned off after pre defined time period.
