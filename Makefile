# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SPHINXPROJ    = Etomica
SOURCEDIR     = .
BUILDDIR      = _build

# Put it first so that "make" without argument is like "make help".
help: venv
	@source venv/bin/activate && $(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS)

.PHONY: help Makefile

requirements.txt:
	@test 0

venv: venv/bin/activate
	@test 0

venv/bin/activate: requirements.txt
	test -d venv || python3 -m venv venv && source ./venv/bin/activate && pip3 install -Ur requirements.txt
	touch venv/bin/activate

serve: venv
	@source venv/bin/activate && sphinx-autobuild --open-browser -b html $(SOURCEDIR) $(BUILDDIR)/html -i ".git*" -i ".vscode*" -i "venv*"

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is supposed as a shortcut for $(SPHINXOPTS), but... isn't
%: Makefile
	@source venv/bin/activate && $(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS)
