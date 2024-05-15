#if defined _mail_included
#endinput
#endif


#define _mail_included


#pragma tabsize 8


native mail_init(host[], user[], password[], from[], sendername[]);
native mail_send(index, to[], subject[], messsage[], type = 0);


forward OnMailSendSuccess(index, to[], subject[], message[], type);
forward OnMailSendError(index, to[], subject[], message[], type, error[], error_code);


#pragma tabsize 4