#"Multi-target document example for blahtexml"
#blahtexml: an extension of blahtex with XML processing in mind
#http://gva.noekeon.org/blahtexml
#
#Copyright (c) 2010, Gilles Van Assche
#All rights reserved.
#
#Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#    * Neither the names of the authors nor the names of their affiliation may be used to endorse or promote products derived from this software without specific prior written permission.
#
#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

.PHONY: help

help:
	@echo "From a source file called Name.ed:"
	@echo "- type 'make Name.xhtmlmathml.xml' to produce XHTML with MathML"
	@echo "- type 'make Name.xhtmlpng.xml' to produce XHTML with bitmap equations"
	@echo "- type 'make Name.xhtmlapprox.xml' to produce XHTML with approximate equation layout"
	@echo "- type 'make Name.article.latex.tex' to produce a LaTeX article"
	@echo "- type 'make Name.revtex.latex.tex' to produce a LaTeX article with the revtex4-1 class"
	@echo "- type 'make Name.ieee.latex.tex' to produce a LaTeX article with the IEEEtran class"
	@echo "- type 'make Name.article.xelatex.tex' to produce a LaTeX article"
	@echo "  (the .tex extension can be replaced by .pdf to get a PDF file)"
	@echo "- type 'make Name.odt' to produce an OpenDocument text document"

%.ed+blahtexml: %.ed Stylesheets/PrepareForBlahtexml.xsl
	@echo "Generating $@"
	@xsltproc -o $@ Stylesheets/PrepareForBlahtexml.xsl $<

%.ed+mathml: %.ed+blahtexml
	@echo "Generating $@"
	@mkdir -p images
	@blahtexml --xmlin --mathml-nsprefix-none --annotate-TeX --annotate-PNG --png-directory images < $< > $@

%.ed+numbering: %.ed+mathml Stylesheets/Numbering.xsl
	@echo "Generating $@"
	@xsltproc -o $@ Stylesheets/Numbering.xsl $<

%.ed+references: %.ed+numbering Stylesheets/Referencing.xsl
	@echo "Generating $@"
	@xsltproc -o $@ Stylesheets/Referencing.xsl $<

%.xhtmlmathml.xml: %.ed+references Stylesheets/ToXHTML-common.xsl Stylesheets/ToXHTMLMathML.xsl
	@echo "Generating $@"
	@xsltproc -o $@ Stylesheets/ToXHTMLMathML.xsl $<

%.xhtmlpng.xml: %.ed+references Stylesheets/ToXHTML-common.xsl Stylesheets/ToXHTMLPNG.xsl
	@echo "Generating $@"
	@xsltproc -o $@ Stylesheets/ToXHTMLPNG.xsl $<

%.xhtmlapprox.xml: %.ed+references Stylesheets/ToXHTML-common.xsl Stylesheets/ToXHTML-approximate.xsl
	@echo "Generating $@"
	@xsltproc -o $@ Stylesheets/ToXHTML-approximate.xsl $<

%.article.latex.tex: %.ed+references Stylesheets/ToLaTeX-common.xsl Stylesheets/ToLaTeX-article.xsl
	@echo "Generating $@"
	@xsltproc -o $@ Stylesheets/ToLaTeX-article.xsl $<

%.revtex.latex.tex: %.ed+references Stylesheets/ToLaTeX-common.xsl Stylesheets/ToLaTeX-revtex.xsl
	@echo "Generating $@"
	@xsltproc -o $@ Stylesheets/ToLaTeX-revtex.xsl $<

%.ieee.latex.tex: %.ed+references Stylesheets/ToLaTeX-common.xsl Stylesheets/ToLaTeX-ieee.xsl
	@echo "Generating $@"
	@xsltproc -o $@ Stylesheets/ToLaTeX-ieee.xsl $<

%.latex.pdf: %.latex.tex
	@echo "Generating $@"
	@pdflatex $<
	@pdflatex $<
	@rm $(addsuffix .aux, $(basename $<)) $(addsuffix .log, $(basename $<)) $(addsuffix .out, $(basename $<))

%.article.xelatex.tex: %.ed+references Stylesheets/ToLaTeX-common.xsl Stylesheets/ToXeLaTeX-common.xsl Stylesheets/ToXeLaTeX-article.xsl
	@echo "Generating $@"
	@xsltproc -o $@ Stylesheets/ToXeLaTeX-article.xsl $<

%.xelatex.pdf: %.xelatex.tex
	@echo "Generating $@"
	@xelatex $<
	@xelatex $<
	@rm $(addsuffix .aux, $(basename $<)) $(addsuffix .log, $(basename $<)) $(addsuffix .out, $(basename $<))

%.odt-content: %.ed+references Stylesheets/ToODT.xsl
	@echo "Generating $@"
	@xsltproc -o $@ Stylesheets/ToODT.xsl $<

%.odt: %.odt-content
	@echo "Generating $@"
	mkdir -p $(addsuffix .dir, $(basename $<))
	cp -Rp ODT-Template/* $(addsuffix .dir, $(basename $<))/
	cp -p $< $(addsuffix .dir, $(basename $<))/content.xml
	cd $(addsuffix .dir, $(basename $<)) ; zip -0 $@ mimetype ; zip -r $@ * -x mimetype
	mv $(addsuffix .dir, $(basename $<))/$@ .
	rm -rf $(addsuffix .dir, $(basename $<))
