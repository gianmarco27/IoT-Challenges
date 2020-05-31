#ifndef RANDOMSENDER_H
#define RANDOMSENDER_H

//payload of the msg
typedef nx_struct my_msg {
	nx_uint8_t topic; 
	nx_uint16_t value;
} my_msg_t;

#define MOTE2 2
#define MOTE3 3

enum{
AM_MY_MSG = 6
};

#endif