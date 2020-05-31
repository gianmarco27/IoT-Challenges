# Challenge 5

Gianmarco Poggi - 928420
Leonardo Stagliano - 917310

- Public channel link to thingspeak: <a href="https://thingspeak.com/channels/1070320">https://thingspeak.com/channels/1070320</a>

## Notes

- To obtain the random number for the motes 2 and 3 we use the rand() function and then we use the modulus twice to obtain valuse between 0 and 100
- Every mote communicates its topic via an integer since requested types for communication are integer number, upon receiving the messages, mote 1 actually writes the topic corresponding to each mote.
- A message regulator has been introduced on the node-red flow to cope with the maximum publication frequency allowed by the free version of thingspeak.
- Messages with a value > 70 produce an empty message in our function which is subsequently discarded via a switch.
