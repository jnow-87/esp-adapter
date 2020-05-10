/**
 * Copyright (C) 2020 Jan Nowotsch
 * Author Jan Nowotsch	<jan.nowotsch@gmail.com>
 *
 * Released under the terms of the GNU GPL v2.0
 */



#include <stdio.h>
#include <unistd.h>
#include <sys/string.h>
#include <sys/errno.h>


/* global functions */
int main(void){
	char c;


	printf("hello world\n");
	fflush(stdout);

	while(1){
		if(read(0, &c, 1) != 1)
			break;

		write(1, &c, 1);
	}

	printf("error \"%s\"\n", strerror(errno));
	printf("exit\n");
	fflush(stdout);

	return 0;
}
