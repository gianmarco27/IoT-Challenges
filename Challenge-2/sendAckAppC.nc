#include "sendAck.h"

configuration sendAckAppC {}

implementation {


/****** COMPONENTS *****/
  components MainC, sendAckC as App;
  //add the other components here
  components new TimerMilliC() as timer_t;
  components new FakeSensorC();
  components ActiveMessageC;
  components new AMSenderC(AM_MY_MSG);
  components new AMReceiverC(AM_MY_MSG);
  

/****** INTERFACES *****/
  //Boot interface
  App.Boot -> MainC.Boot;

  /****** Wire the other interfaces down here *****/
  App.SplitControl -> ActiveMessageC;
  App.AMSend -> AMSenderC;
  App.Packet -> AMSenderC;
  App.Receive -> AMReceiverC;
  App.MilliTimer -> timer_t;
  App.sensorRead -> FakeSensorC;
  App.pack_ack -> AMSenderC;
  


}



