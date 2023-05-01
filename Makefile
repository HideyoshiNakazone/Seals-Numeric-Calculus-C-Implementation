CC=gcc
CFLAGS=-g3
LDLIBS=-lm


debug_tests: CFLAGS += -DDEBUG -g
debug_tests: tests


#############################################################################
#                       BUILDING SHARED LIBRARIES                           #
#############################################################################

shared: modules/shared/array.so modules/root/root.so modules/linear/linear.so modules/integral/integral.so
	mkdir -p seals/lib
	mv modules/**/*.so seals/lib

	mkdir -p seals/include
	cp modules/**/*.h seals/include


#############################################################################
#                           BUILDING TESTS                                  #
#############################################################################


run_tests: tests
	./tests/test_linear
	./tests/test_root
	./tests/test_integral
	./tests/test_array

tests: tests/test_linear tests/test_array tests/test_root tests/test_integral

tests/test_linear: tests/linear/test_linear.o modules/linear/linear.o  modules/shared/array.o
	$(CC) $(CFLAGS) modules/linear/linear.o  modules/shared/array.o $(LDLIBS) -o tests/test_linear tests/linear/test_linear.o

tests/test_root: tests/root/test_root.o modules/root/root.o
	$(CC) $(CFLAGS) modules/root/root.o $(LDLIBS) -o tests/test_root tests/root/test_root.o

tests/test_integral: tests/integral/test_integral.o modules/integral/integral.o
	$(CC) $(CFLAGS) modules/integral/integral.o $(LDLIBS) -o tests/test_integral tests/integral/test_integral.o

tests/test_array: tests/shared/test_array.o modules/shared/array.o
	$(CC) $(CFLAGS) modules/shared/array.o $(LDLIBS) -o tests/test_array tests/shared/test_array.o


#############################################################################
#                           GENERIC BUILDS                                  #
#############################################################################

%.so: %.o
	$(CC) $(CFLAGS) $(INCLUDES) -shared $^ $(LDLIBS) -o $@

%: %.c
	$(CC) $(CFLAGS) $^ $(LDLIBS) -o $@

clean:
	rm -f tests/*.o
	rm -f modules/linear/*.o
	rm -f modules/integral/*.o
	rm -f modules/root/*.o
	rm -f modules/shared/*.o
	rm -f test_linear
	rm -f test_root
	rm -f test_integral
	rm -f test_array