ifeq ($(ASYMPTOTE_USER),)
  export ASYMPTOTE_USER=asymptote
endif

export ASYMPTOTE_UID=$(shell getent passwd $(ASYMPTOTE_USER) | sed -e 's/[^:]*:[^:]*:\([0-9]*\):.*/\1/')
export ASYMPTOTE_GID=$(shell getent passwd $(ASYMPTOTE_USER) | sed -e 's/[^:]*:[^:]*:[^:]*:\([0-9]*\):.*/\1/')
export ASYMPTOTE_HOME=$(shell getent passwd $(ASYMPTOTE_USER) | sed -e 's/[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:\([^:]*\):.*/\1/')

ifeq ($(ASYMPTOTE_UID),)
  export ASYMPTOTE_UID=0
endif

ifeq ($(ASYMPTOTE_GID),)
  export ASYMPTOTE_GID=0
endif

ifeq ($(ASYMPTOTE_HOME),)
  export ASYMPTOTE_HOME=$HOME
endif

all:
	$(MAKE) -C ui
	cd server && npm install

run:
	rm -rf clients/*
	node server/server.js

clean:
	$(MAKE) -C ui clean
	-rm -rf clients/* logs/*
