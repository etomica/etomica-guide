# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SPHINXPROJ    = Etomica
SOURCEDIR     = .
BUILDDIR      = _build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

venv: venv/bin/activate
venv/bin/activate: requirements.txt
	test -d venv || python -m venv venv && source ./venv/bin/activate && pip install -Ur requirements.txt
	touch venv/bin/activate

serve: venv
	source venv/bin/activate && sphinx-autobuild --open-browser -b html $(SOURCEDIR) $(BUILDDIR)/html -i ".git*" -i ".vscode*" -i "venv*"

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
# %: Makefile
# 	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)