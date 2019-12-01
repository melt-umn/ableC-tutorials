EXAMPLES=getting_started error_checking declarations embedded_dsl construction lifting overloading extended_env type_qualifiers

all: $(EXAMPLES)
	echo $(EXAMLES)

$(EXAMPLES):
	$(MAKE) -C $@

.PHONY: all $(EXAMPLES)
.NOTPARALLEL: # Avoid running multiple Silver builds in parallel
