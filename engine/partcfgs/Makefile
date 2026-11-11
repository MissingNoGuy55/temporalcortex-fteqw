AATEST_OBJS= \
	generatebuiltin.o

default: all

all: generatebuiltin

clean:
	-$(RM) $(AATEST_OBJS) $(UPGRADE_OBJS)

CXXFLAGS+=-DTEMPORALCORTEX

generatebuiltin: $(AATEST_OBJS)
	$(CXX) $(CXXFLAGS) -o generatebuiltin $(AATEST_OBJS)

%.o : %.c
	$(CXX) -o $@ -c $<
