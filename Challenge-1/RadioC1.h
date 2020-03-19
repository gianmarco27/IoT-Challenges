#ifndef RADIO_C1_H
#define RADIO_C1_H

typedef nx_struct radio_c1_msg {
  nx_uint16_t counter;
  nx_uint16_t senderId;
} radio_c1_msg_t;


enum {
	AM_RADIO_COUNT_MSG = 6, TIMER_1HZ = 1000, TIMER_3HZ = 333, TIMER_5HZ = 200,
};


#endif
