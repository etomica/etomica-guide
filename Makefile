# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXPROJ    = Etomica
SOURCEDIR     = .
BUILDDIR      = _build

# Put it first so that "make" without argument is like "make help".
help: venv
	source venv/bin/activate && sphinx-build -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS)

.PHONY: help

venv: venv/bin/activate
venv/bin/activate: requirements.txt
	test -d venv || python3 -m venv venv && source ./venv/bin/activate && pip3 install -Ur requirements.txt
	touch venv/bin/activate

html: venv
	source venv/bin/activate && sphinx-build -b html $(SOURCEDIR) $(BUILDDIR)/html

serve: venv
	source venv/bin/activate && sphinx-autobuild --open-browser -b html $(SOURCEDIR) $(BUILDDIR)/html -i ".git*" -i ".vscode*" -i "venv*"

