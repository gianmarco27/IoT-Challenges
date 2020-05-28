#include "randomSender.h"
#include "printf.h"

configuration randomSenderAppC {}

implementation {


/****** COMPONENTS *****/
  components MainC, randomSender as App;
  //add the other components here
  components new TimerMilliC() as timer_t;
  components ActiveMessageC;
  components new AMSenderC(AM_MY_MSG);
  components new AMReceiverC(AM_MY_MSG);
  components PrintfC;
  components SerialStartC;
  

/****** INTERFACES *****/
  //Boot interface
  App.Boot -> MainC.Boot;

  /****** Wire the other interfaces down here *****/
  App.SplitControl -> ActiveMessageC;
  App.AMSend -> AMSenderC;
  App.Packet -> AMSenderC;
  App.Receive -> AMReceiverC;
  App.MilliTimer -> timer_t;
}