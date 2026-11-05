AATEST_OBJS= \
	generatebuiltin.o

default: all

all: generatebuiltin

clean:
	-$(RM) $(AATEST_OBJS) $(UPGRADE_OBJS)

generatebuiltin: $(AATEST_OBJS)
	$(CXX) $(CXXFLAGS) -o generatebuiltin $(AATEST_OBJS)

%.o : %.c
	$(CXX) -o $@ -c $<
