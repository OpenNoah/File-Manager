PRG	= ./bin/z/Fmanager.sh

.PHONY: run
run: usleep
	PATH="$$PATH:$$PWD" $(PRG)

usleep: usleep.c
	gcc -o $@ -O3 $<

.PHONY: clean
clean:
	rm -f usleep
