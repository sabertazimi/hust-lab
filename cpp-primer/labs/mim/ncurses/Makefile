# sudo apt-get install libncurses5-dev
#
DEMO=init_func

all:
	mkdir -p ./bin
	$(CXX) -Wall -Wextra -Werror -pedantic -std=c++14 $(DEMO).cpp -lncurses -o ./bin/$(DEMO)

run:
	./bin/$(DEMO)

clean:
	rm -fr ./bin/$(DEMO)

