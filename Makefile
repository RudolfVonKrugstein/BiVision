all: frameWithProcessEvent.o Main.hs TechnicalUtils.hs FrameWithProcessEvent.hs Messages.hs
	ghc Main.hs frameWithProcessEvent.o -lstdc++

frameWithProcessEvent.o: frameWithProcessEvent.cpp frameWithProcessEvent.h
	gcc -c frameWithProcessEvent.cpp `wx-config --cflags` -o frameWithProcessEvent.o

