# Challenge 2

Gianmarco Poggi - 928420
Leonardo Staglianò - 917310

Github Repository : https://github.com/gianmarco27/IoT-Challenges

## Requirements Interpretation
	
The packet is composed by 3 fields codified as integers:

- A counter
- A type identifier
- An optional field, filled only by the mote #2, in which the sensor data is stored

If the message sent by the mote #1 is not acked the timer keeps iterating, raising the counter and creating a new message.

If the message sent by the mote #2 is not acked it immediately tries again to send another packed with the same payload, this was done to reply to the request with the value at the time it was issued avoiding the reading of a new value from the sensor.
	
## Implementation
	
We defined the message structure in the RadioC1.h file using a typedef construct with two uint16_t fields and one uint8_t called:

- counter (uint_16)
- value (uint_16)
- type (uint_8)

Upon boot SplitControl manages which mote should start the timer to send request messages.
The messages are sent in a UNICAST way, where the ID of the recipient is properly set at send-time.

To manage the ACK requests we wired our interface to the AMSender component.

Upon timer expiration we increment the counter that fills the request by the mote #1, this value is then returned by mote #2 when it is ready to answer with a response message.

	

