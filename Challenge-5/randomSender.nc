#include "randomSender.h"
#include "Timer.h"
#include "printf.h"
module randomSender {

  uses {
  /****** INTERFACES *****/
	interface Boot;
	interface SplitControl;
	interface Packet;
    interface AMSend;
    interface Receive; 
    
    interface Timer<TMilli> as MilliTimer;
	
  }

} implementation {

	uint value;

	message_t packet;

	void sendReq() {

	 my_msg_t *msg = (my_msg_t*)(call Packet.getPayload(&packet, sizeof(my_msg_t)));
	 if (msg == NULL) {
		return;
	  }
	 value = rand();
	 value = (value % 101 + 101) % 101;
	 msg->value = value;
	 if(TOS_NODE_ID == 2){
	 	msg->topic = MOTE2;
	 }else if(TOS_NODE_ID == 3){
	 	msg->topic = MOTE3;
	 }
	
	 
	 if(call AMSend.send(1, &packet,sizeof(my_msg_t)) == SUCCESS){
	    
		 
  	}
	 
 }

   event void Boot.booted() {
	dbg("boot","Application booted.\n");
	call SplitControl.start();
  }

    event void SplitControl.startDone(error_t err){
  	if(err == SUCCESS) {
  		if(TOS_NODE_ID == 2 || TOS_NODE_ID == 3){
  			call MilliTimer.startPeriodic( 5000 );
  			srand(TOS_NODE_ID);
  		}
  	}else{
  		call SplitControl.start();
  	}
  }

  event void AMSend.sendDone(message_t* buf,error_t err) {
  }


  event void SplitControl.stopDone(error_t err){
  }

  //***************** MilliTimer interface ********************//
  event void MilliTimer.fired() {
	sendReq();
  }


  event message_t* Receive.receive(message_t* buf,void* payload, uint8_t len) {
	 if (len != sizeof(my_msg_t)){
	 	return buf;
	 }else{
	 	my_msg_t *msg = (my_msg_t*)payload;
	 	value = msg->value;

	 	printf("value:%d ", value);
 		printf("/mote%d.bufferflush\n", msg->topic);
	 	printfflush();
	 	return buf;
	 }

  }

}