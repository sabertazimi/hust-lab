EXPLOITS=$(wildcard *.txt)
CHECKS=$(patsubst %,testprint-%,$(EXPLOITS))

RESULTS=__results.log
INPUT=__gdb.in
TEST_BYTES=__test.bytes
USERID=USERID

$(INPUT): $(USERID)
	echo "run -g -u \"`cat $(USERID)`\" < $(TEST_BYTES) > $(RESULTS)" > $@
	echo "quit" >> $@

test: $(CHECKS)

test-%: % $(INPUT)
	./sendstring < $< > $(TEST_BYTES)
	echo "" | gdb -x $(INPUT) bufbomb >/dev/null || true
	rm $(TEST_BYTES)

testprint-%: test-%
	echo $<
	cat $(RESULTS)
	rm $(RESULTS)

check-smoke.txt: test-smoke.txt $(RESULTS)
	grep -q "Level 0 VALID" $(RESULTS)
	rm $(RESULTS)

check-fizz.txt: test-fizz.txt $(RESULTS)
	grep -q "Level 1 VALID" $(RESULTS)
	rm $(RESULTS)

check-bang.txt: test-bang.txt $(RESULTS)
	grep -q "Level 2 VALID" $(RESULTS)
	rm $(RESULTS)

check-dynamite.txt: test-dynamite.txt $(RESULTS)
	grep -q "Boom!" $(RESULTS)
	grep -q "Level 3 VALID" $(RESULTS)
	rm $(RESULTS)

.INTERMEDIATE: $(INPUT)
.SILENT:

.PHONY: test test-%
