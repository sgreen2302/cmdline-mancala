.PHONY: test check

build:
	dune build

code:
	-dune build
	code .
	! dune build --watch

utop:
	OCAMLRUNPARAM=b dune utop src

test:
	OCAMLRUNPARAM=b dune exec tests/test.exe	

bisect:
	rm -rf _coverage bisect*.coverage
	-dune exec --instrument-with bisect_ppx --force tests/test.exe
	bisect-ppx-report html

play:
	OCAMLRUNPARAM=b dune exec bin/main.exe

doc:
	dune build @doc

opendoc: doc
	@bash opendoc.sh	

check:
	@bash check.sh

zip:
	rm -f game.zip
	zip -r game.zip . -x@exclude.lst

clean:
	rm -rf _coverage bisect*.coverage
	dune clean
	

