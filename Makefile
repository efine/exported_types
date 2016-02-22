#.PHONY: all escriptize compile info doc deps update-deps clean \
#		clean-doc-data distclean

ERLFLAGS= -pa $(CURDIR)/ebin \
		  -pa $(CURDIR)/deps/*/ebin

#
# Check for required packages
#
REQUIRED_PKGS := \
	erl

_ := $(foreach pkg,$(REQUIRED_PACKAGES),\
		$(if $(shell which $(pkg)),\
			$(error Missing required package $(pkg)),))

ERLANG_VER=$(shell erl -noinput -eval 'io:put_chars(erlang:system_info(system_version)),halt().')

# Prefer local rebar, if present

ifneq (,$(wildcard ./rebar))
    REBAR_PGM = `pwd`/rebar
else
    REBAR_PGM = rebar
endif

REBAR = $(REBAR_PGM)
REBAR_VSN := $(shell $(REBAR) --version)

all: compile

compile: deps
	$(REBAR) compile escriptize

info:
	@echo 'Erlang/OTP system version: $(ERLANG_VER)'
	@echo '$(REBAR_VSN)'

doc:
	$(REBAR) skip_deps=true doc

deps: info
	$(REBAR) get-deps

update-deps: info
	$(REBAR) update-deps

shell: compile
	@erl $(ERLFLAGS)

clean-doc-data:
	- rm -f $(CURDIR)/doc/*.html
	- rm -f $(CURDIR)/doc/edoc-info
	- rm -f $(CURDIR)/doc/*.md

clean:
	- rm -rf $(CURDIR)/ebin
	$(REBAR) skip_deps=true clean

distclean: clean clean-doc-data
	- rm -rf $(CURDIR)/deps

# ex: ts=4 sts=4 sw=4 noet
