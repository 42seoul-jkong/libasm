CC = cc

CFLAGS += -I../include
LDFLAGS += -L.. -lasm

CFLAGS += -Wall -Wextra -Werror

CFLAGS += -O0 -g
CFLAGS += -fsanitize=address,undefined

compile: main.c
	$(CC) $^ $(CFLAGS) $(LDFLAGS) -o test.out
