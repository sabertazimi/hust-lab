bomb.out: bomb defuser.txt
	@./bomb < defuser.txt > bomb.out || true

check-defuser.txt: bomb.out
	@grep -q "Phase 1 defused. How about the next one?" bomb.out || (echo "Phase 1 was not defused!" ; false)
	@grep -q "That's number 2.  Keep going!" bomb.out || (echo "Phase 2 was not defused!" ; false)
	@grep -q "Halfway there!" bomb.out || (echo "Phase 3 was not defused!" ; false)
	@grep -q "So you got that one.  Try this one." bomb.out || (echo "Phase 4 was not defused!" ; false)
	@grep -q "Congratulations! You've (mostly) defused the bomb!" bomb.out || (echo "Phase 5 was not defused!" ; false)

.PHONY: check-defuser.txt
.SUFFIXES:
