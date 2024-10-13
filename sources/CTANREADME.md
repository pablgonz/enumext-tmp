## enumext — Enumerate exercise sheets

Release v1.0 \[2024-10-13\]

## Description

This package provides enumerated list environments compatible with
_tagging_ PDF for creating “simple exercise sheets” along with
“multiple choice questions”, storing the “answers” to these in memory
using `multicol` and `scontents` packages.

## Requirements

The minimum requirement is `LaTeX` release 2024-11-01. Loads and depends
on updated versions of:

- [expl3](https://ctan.org/pkg/expl3)
- [latex-base](https://www.ctan.org/pkg/latex-base)

## Installation

The package `enumext` is present in `TeX Live` and `MiKTeX`, use the
package manager to install.

For manual installation, download [enumext.zip](http://mirrors.ctan.org/macros/latex/contrib/enumext.zip) and unzip it,
then run:

```
$ luatex enumext.ins
```

and move all files to appropriate locations:

```
  enumext.sty      -> TDS:tex/latex/enumext/enumext.sty
  enumext.pdf      -> TDS:doc/latex/enumext/enumext.pdf
  enumext.dtx      -> TDS:source/latex/enumext/enumext.dtx
  enumext.ins      -> TDS:source/latex/enumext/enumext.ins
```

then run `mktexlsr`. To produce the documentation with source code run `luatex enumext.ins` and
`lualatex enumext.dtx` three times.

## Examples

The file <code>&lt;enumext.pdf&gt;</code> contains attached examples, which can be extracted
from the PDF viewer or from the command line by running:

```
$ pdfdetach -saveall enumext.pdf
```

and then you can use the excellent `arara` tool to compile them.

## License

The scontents package may be modified and distributed under the terms and
conditions of the [LaTeX Project Public License](https://www.latex-project.org/lppl/), version 1.3c or greater.

## Contents

- README.md (this file)
- enumext.pdf  (documentation)
- enumext.dtx  (master file that produced all files)
- enumext.ins  (installer to extract all files)

## Author and copyright

Copyright (C) 2024 by Pablo González L <pablgonz@educarchile.cl>
