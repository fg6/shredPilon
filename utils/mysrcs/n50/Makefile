#
#	 Makefile
#
CC=g++
SOURCES= n50.cpp 

INCLUDES = 
LIBS =  

CFLAGS= -c  $(INCLUDES) 
COMPILE = $(CC)  -std=c++11 $(CFLAGS)

OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=$(SOURCES:.cpp=)

all: cleanall iprint $(SOURCES) $(EXECUTABLE) clean oprint 

iprint:
	@echo '+++ compiling all ... '
oprint:
	@echo 'Done '

# compile source	
$(EXECUTABLE): $(OBJECTS) 
	$(CC) -std=c++11 $(OBJECTS) -lgzstream -lz -o $@


# create *.o
.cpp.o:
	$(COMPILE) $< -o $@

clean:
	@rm -f $(OBJECTS)

cleanall:
	@echo -n '+++ Cleaning all object files ... '
	@rm -f $(EXECUTABLE) $(OBJECTS)
	@echo 'Done.'


