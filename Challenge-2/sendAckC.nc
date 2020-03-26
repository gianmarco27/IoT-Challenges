#include "sendAck.h"
#include "Timer.h"

module sendAckC {

  uses {
  /****** INTERFACES *****/
	interface Boot;
	interface SplitControl;
	interface Packet;
    interface AMSend;
    interface Receive; 
    
    interface Timer<TMilli> as MilliTimer;
    interface PacketAcknowledgements as pack_ack;
	
    //interfaces for communication
	//interface for timer
    //other interfaces, if needed
	
	//interface used to perform sensor reading (to get the value from a sensor)
	
	interface Read<uint16_t> as sensorRead;
  }

} implementation {

  uint8_t counter=0;
  message_t packet;

  
  //***************** Send request function ********************//
  void sendReq() {
	/* This function is called when we want to send a request
	 *
	 * STEPS:
	 * 1. Prepare the msg
	 * 2. Set the ACK flag for the message using the PacketAcknowledgements interface
	 *     (read the docs)
	 * 3. Send an UNICAST message to the correct node
	 * X. Use debug statements showing what's happening (i.e. message fields)
	 */
	 my_msg_t *msg = (my_msg_t*)(call Packet.getPayload(&packet, sizeof(my_msg_t)));
	 if (msg == NULL) {
		return;
	  }
	 msg->type = REQ;
	 msg->counter = counter;
	 msg->value = 0;
	 
	 call pack_ack.requestAck(&packet);
	 
	 dbg("radio_pack","Preparing the message... \n");
	 if(call AMSend.send(2, &packet,sizeof(my_msg_t)) == SUCCESS){
	     dbg("radio_send", "Packet passed to lower layer successfully!\n");
	     dbg("radio_pack",">>>Pack\n \t Payload length %hhu \n", call Packet.payloadLength( &packet ) );
	     dbg_clear("radio_pack","\t Payload Sent\n" );
		 dbg_clear("radio_pack", "\t\t type: %hhu \n", msg->type);
		 dbg_clear("radio_pack", "\t\t counter: %hhu \n", msg->counter);
		 
  	}
	 
 }        

  //****************** Task send response *****************//
  void sendResp() {
  	/* This function is called when we receive the REQ message.
  	 * Nothing to do here. 
  	 * `call Read.read()` reads from the fake sensor.
  	 * When the reading is done it raise the event read one.
  	 */
	call sensorRead.read();
  }

  //***************** Boot interface ********************//
  event void Boot.booted() {
	dbg("boot","Application booted.\n");
	call SplitControl.start();
  }

  //***************** SplitControl interface ********************//
  event void SplitControl.startDone(error_t err){
  	if(err == SUCCESS) {
  		if(TOS_NODE_ID == 1){
  			call MilliTimer.startPeriodic( 1000 );
  		}
  	}else{
  		call SplitControl.start();
  	}
  }
  
  event void SplitControl.stopDone(error_t err){
  }

  //***************** MilliTimer interface ********************//
  event void MilliTimer.fired() {
  	counter++;
	sendReq();
  }
  

  //********************* AMSend interface ****************//
  event void AMSend.sendDone(message_t* buf,error_t err) {
	/* This event is triggered when a message is sent 
	 *
	 * STEPS:
	 * 1. Check if the packet is sent
	 * 2. Check if the ACK is received (read the docs)
	 * 2a. If yes, stop the timer. The program is done
	 * 2b. Otherwise, send again the request
	 * X. Use debug statements showing what's happening (i.e. message fields)
	 */
	 my_msg_t *msg = (my_msg_t*)(call Packet.getPayload(&packet, sizeof(my_msg_t)));
	 if(buf == &packet && err == SUCCESS){
	 	dbg("radio_send", "Packet sent...\n");
	 	dbg("radio_send", "\t\t type: %hhu \n", msg->type);
	  	dbg("radio_send", "\t\t counter: %hhu \n", msg->counter);
	  	dbg("radio_send", "\t\t value: %hhu \n", msg->value);
	 	if(call pack_ack.wasAcked(&packet)){
	 		dbg("radio_send", "Message acked.\n");
	 		if(TOS_NODE_ID == 1){
	 			call MilliTimer.stop();
	 		}
	 	}else{
	 		if(TOS_NODE_ID == 2){
	 			dbg("radio_send", "Message not acked, repeating send..\n");
	 			call AMSend.send(1, &packet,sizeof(my_msg_t));
	 			
	 		}
	 	}
	  	
	 }else{
	 	dbgerror("radio_send", "Send done error!");
	 }
  }

  //***************************** Receive interface *****************//
  event message_t* Receive.receive(message_t* buf,void* payload, uint8_t len) {
	/* This event is triggered when a message is received 
	 *
	 * STEPS:
	 * 1. Read the content of the message
	 * 2. Check if the type is request (REQ)
	 * 3. If a request is received, send the response
	 * X. Use debug statements showing what's happening (i.e. message fields)
	 */
	 if (len != sizeof(my_msg_t)){
	 	return buf;
	 }else{
	 	my_msg_t *msg = (my_msg_t*)payload;
	 	counter = msg->counter;
	 	dbg("radio_rcv", "Packet received...");
	 	dbg("radio_rcv", "\t\t type: %hhu \n", msg->type);
	  	dbg("radio_rcv", "\t\t counter: %hhu \n", msg->counter);
	 	if(msg->type == REQ){
	 		sendResp();
	 	}
	 }

  }
  
  //************************* Read interface **********************//
  event void sensorRead.readDone(error_t result, uint16_t data) {
	/* This event is triggered when the fake sensor finish to read (after a Read.read()) 
	 *
	 * STEPS:
	 * 1. Prepare the response (RESP)
	 * 2. Send back (with a unicast message) the response
	 * X. Use debug statement showing what's happening (i.e. message fields)
	 */
	 my_msg_t *msg = (my_msg_t*)(call Packet.getPayload(&packet, sizeof(my_msg_t)));
	 if (msg == NULL) {
		return;
	  }
	 msg->type = RESP;
	 msg->counter = counter;
	 msg->value = data;
	 
	 call pack_ack.requestAck(&packet);
	 
	 dbg("radio_pack","Preparing the message... \n");
	 if(call AMSend.send(1, &packet,sizeof(my_msg_t)) == SUCCESS){
	     dbg("radio_send", "Packet passed to lower layer successfully!\n");
	     dbg("radio_pack",">>>Pack\n \t Payload length %hhu \n", call Packet.payloadLength( &packet ) );
	     dbg_clear("radio_pack","\t Payload Sent\n" );
		 dbg_clear("radio_pack", "\t\t type: %hhu \n", msg->type);
		 dbg_clear("radio_pack", "\t\t counter: %hhu \n", msg->counter);
		 dbg_clear("radio_pack", "\t\t value: %hhu \n", msg->value);
		 
  	}

}

}

