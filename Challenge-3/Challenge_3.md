# Challenge 3
Gianmarco Poggi - 
Leonardo Stagliano - 917310

- 1) Since just one difference is required we notice that the message with Id 3987 is of type CONFIRMABLE then receives an ACK afterwards, meanwhile the message with Id: 22636 is of type NON-CONFIRMABLE

- 2) The client receives an ACK to the request specifying that the GET method is not allowed for the queried resource. Therefore we can say the client recieves a response from the COAP protocol point of view, but it isn't actually a response to its query.

- 3) The localhost server receives a total of 36 packets split between the alias 127.0.0.1 and 10.0.2.15

- 4) Since the wildcard + specifies "one level" and we couldn't find any topic with just one level after department we can assert that the answer is 0. No client published or subscribed to a topic with just one level after /department(number)/
results can be observed with the following RegEx:
mqtt.topic matches "factory\/department[0-9]{1,}\/" && mqtt.msgtype == 3

- 5) By inspecting the DNS request we can assert that the IP addresses of which HiveMQ is alias of are two:
18.185.199.22 and 3.120.68.56
therefore we can say that there are only 10 clients who specified a will message to these ip address -> HiveMQ broker

- 6) The total publish messages with QOS = 1 are 124, only messages with QOS = 1 require a Publish ACK message while other values require different behaviour, therefore since the Publish ACK messages are 74 we can assert that:
50 publish messages with QOS = 1 do not receive a proper ACK

- 7) Since we verified the content of the last will messages we can assert that in total only 1 message containing the last will message content and with QOS set to 0 (fire and forget) have been delivered to the clients correctly

- 8) The client “4m3DWYzWr40pce6OaBQAfk” publishes only 2 messages to the broker of which one is QOS = 0 (fire and forget), therefore we check it the client that subscribed to that topic on that broker (ip check) has received the following message with QOS = 1
{"id": "Actuator 2", "value": 812, "lat": 100, "lng": 140, "unit": "C", "type": "temperature"}
as we can see by filtering Ip, Port and MQTT.topic the subscriber only received the message marked on publishing with QOS = 0, but never received the message with QOS = 1 that we are looking for with the content mentioned above.

- 9) The Average length on non malformed packets for a connection message on mqttv5 protocol is of 13, with some variations depending on the message containing other flags like username and password from the "default one".
So we can affirm that the length of the different messages is affected by optional values that might be present or not depending on requested connection

- 10) Either some kind of interaction kept happening for each connection before the keep-alive expired or the keep-alive value was so high that no PING/REQ happened during the pcap capture time.