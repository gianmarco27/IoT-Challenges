# Challenge 1

Gianmarco Poggi - 928420
Leonardo Staglianò - 917310

Github Repository : https://github.com/gianmarco27/IoT-Challenges

## Requirements Interpretation
	
The packet is composed by 2 fields codified as integers:

- A counter
- The sender id (obtained by the TOS_NODE_ID Macro)

We assumed that the counter in the message is incremented by the receiver upon message reception and stored in the local counter variable.
	
Notice that we couldn't set a proper 3Hz frequency due to the fact that 1/3 is a periodical number as we used the call seen in the previous lessons the closest we could achieve was setting a 333ms timer period.
	

## Implementation
	
We defined the message structure in the RadioC1.h file using a typedef construct with two uint16_t fields called:

- counter
- senderId

Upon creation of the packets the TOS_NODE_ID is assigned to the sender id of the packet.

TOS_NODE_ID is also used to set the 3 different motes frequency upon mote boot by setting a timer which values were defined as enum in the header file.

Upon message reception the node first increments the counter then checks if its value is mod10, if so proceeds to turn off all the leds of the mote, otherwise analizes the sender of the message to determine which led has to be toggled.

To avoid race conditions a boolean is used to prevent any call to send a message while a previous one is still in progress.
	

