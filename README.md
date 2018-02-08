# Etomica Guide

This is the source code for the Etomica user guide. To build and serve the documentation locally,
you must have python 3 installed. Then run `make serve` from this directory, which will install the
dependencies, build the docs, and open a web browser. 

To add a new page, create a new markdown file in this directory, then add it to the toctree in `index.rst`.
Just type the name of the file minus the .md extension, making sure to follow the existing indentation.

For Sphinx markdown specifics see the [recommonmark docs](http://recommonmark.readthedocs.io/en/latest/auto_structify.html).