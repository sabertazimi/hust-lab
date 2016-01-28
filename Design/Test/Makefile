Test.exe : Test.o
	gcc -o Test.exe Test.o
Test.o : Test.c
	gcc -o Test.o -c Test.c

clean :
	rm -fr *.o
	
test :
	./Test.exe
