# Challenge 3
Gianmarco Poggi - 
Leonardo Stagliano - 917310

- Public channel link to thingspeak: <a href="https://thingspeak.com/channels/1064837">https://thingspeak.com/channels/1064837</a>

NOTES: As we were parsing the csv, we noticed that  (probably due to some packets being malformed) the JSON.parse() and the Buffer.from() libraries were throwing errors and returning a total of 20 messages, while if we parsed the string on our own we obtained 37 messages.
Therefore we decided, since it wasn't specified to consider all the messages as valid and so we parsed all the messages as a string with our custom function, resulting in a total of 37 messages getting published to thingspeak.
