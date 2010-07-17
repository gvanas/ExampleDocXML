<?xml version='1.0' encoding="UTF-8"?>
<!--
"Multi-target document example for blahtexml"
blahtexml: an extension of blahtex with XML processing in mind
http://gva.noekeon.org/blahtexml

Copyright (c) 2010, Gilles Van Assche
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the names of the authors nor the names of their affiliation may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-->
<xsl:stylesheet
    version="1.0"
    xmlns:d="http://gva.noekeon.org/blahtexml/exampledoc"
    xmlns:m="http://www.w3.org/1998/Math/MathML"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="d">

<xsl:output method="text" indent="no" encoding="UTF-8"/>

<xsl:variable name="texHeading"/>

<xsl:template match="d:document">
    <xsl:choose>
        <xsl:when test="$texHeading!=''">
            <xsl:value-of select="$texHeading"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="putTexHeading"/>
        </xsl:otherwise>
    </xsl:choose>
<xsl:text>
\begin{document}
</xsl:text>
    <xsl:call-template name="make-title"/>
    <xsl:apply-templates select="d:body"/>
<xsl:text>
\end{document}
</xsl:text>
</xsl:template>

<xsl:template match="d:authors">
    <xsl:apply-templates select="d:author"/>
</xsl:template>

<xsl:template match="d:author">
    <xsl:call-template name="replaceSpecialChars"><xsl:with-param name="content" select="."/></xsl:call-template>
    <xsl:choose>
        <xsl:when test="position()&lt;last()-1">, </xsl:when>
        <xsl:when test="position()=(last()-1)"> and </xsl:when>
    </xsl:choose>
</xsl:template>

<xsl:template match="d:abstract">
\begin{abstract}
    <xsl:apply-templates/>
\end{abstract}
</xsl:template>

<xsl:template name="make-title">
\author{<xsl:apply-templates select="d:head/d:authors"/>}
\title{<xsl:apply-templates select="d:head/d:title"/>}
\maketitle
    <xsl:apply-templates select="d:head/d:abstract"/>
</xsl:template>

<xsl:template match="d:body">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:section[@numbering='appendix'][position()=1]">
    <xsl:text>\appendix</xsl:text>
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:section">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:div">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:h">
    <xsl:variable name="level" select="count(ancestor-or-self::d:section)+$headingOffset"/>
    <xsl:variable name="star"><xsl:if test="count(ancestor-or-self::d:section[@numbering='none'])&gt;0">*</xsl:if></xsl:variable>
    <xsl:choose>
        <xsl:when test="$level=1">\chapter<xsl:value-of select="$star"/>{<xsl:apply-templates/>}</xsl:when>
        <xsl:when test="$level=2">\section<xsl:value-of select="$star"/>{<xsl:apply-templates/>}</xsl:when>
        <xsl:when test="$level=3">\subsection<xsl:value-of select="$star"/>{<xsl:apply-templates/>}</xsl:when>
        <xsl:otherwise>\subsubsection<xsl:value-of select="$star"/>{<xsl:apply-templates/>}</xsl:otherwise>
    </xsl:choose>
    <xsl:text>
</xsl:text>
    <xsl:if test="../@id!=''">\label{<xsl:value-of select="../@id"/>}
    </xsl:if>
</xsl:template>

<xsl:template match="d:p">
    <xsl:text>

\begin{sloppypar}
</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\end{sloppypar}

</xsl:text>
</xsl:template>

<xsl:template match="d:eq">
    <xsl:choose>
        <xsl:when test="@id!=''">
\begin{equation}
\label{<xsl:value-of select="@id"/>}
<xsl:value-of select="m:math/m:semantics/m:annotation[@encoding='TeX']"/>
\end{equation}
        </xsl:when>
        <xsl:otherwise>
\begin{equation*}
<xsl:value-of select="m:math/m:semantics/m:annotation[@encoding='TeX']"/>
\end{equation*}
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="d:pre">
    <xsl:text>

\begin{verbatim}
</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\end{verbatim}

</xsl:text>
</xsl:template>

<xsl:template match="d:ul">
\begin{itemize}
<xsl:apply-templates/>
\end{itemize}
</xsl:template>

<xsl:template match="d:ol">
\begin{enumerate}
<xsl:apply-templates/>
\end{enumerate}
</xsl:template>

<xsl:template match="d:li">\item <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:a">
    <xsl:text>\href{</xsl:text>
    <xsl:value-of select="./@href"/>
    <xsl:text>}{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="d:ref">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:ref-number">\ref{<xsl:value-of select="../@t"/>}</xsl:template>

<xsl:template match="d:ieq">
    <xsl:text>$</xsl:text>
    <xsl:value-of select="m:math/m:semantics/m:annotation[@encoding='TeX']"/>
    <xsl:text>$</xsl:text>
</xsl:template>

<xsl:template match="d:span">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:code">\texttt{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="d:em">\emph{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="d:sc">\textsc{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="d:strong">\textbf{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="d:sub">$_{\text{<xsl:apply-templates/>}}$</xsl:template>
<xsl:template match="d:sup">$^{\text{<xsl:apply-templates/>}}$</xsl:template>

<xsl:template match="d:author/text()|d:affiliation/text()|d:title/text()|d:abstract/text()|d:h/text()|d:p/text()|d:li/text()|d:a/text()|d:span/text()|d:code/text()|d:em/text()|d:sc/text()|d:strong/text()|d:sub/text()|d:sup/text()">
    <xsl:call-template name="replaceSpecialChars">
        <xsl:with-param name="content" select="."/>
    </xsl:call-template>
</xsl:template>

<xsl:template match="d:body/text()|d:section/text()"/>

<xsl:template name="replaceSpecialChars">
    <xsl:param name="content"/>
    <xsl:if test="string-length($content)>0">
    <xsl:choose>
        <xsl:when test="starts-with($content,'&#x0D;')"><xsl:text> </xsl:text><xsl:call-template name="replaceSpecialChars"><xsl:with-param name="content" select="substring-after($content, '&#x0D;')"/></xsl:call-template></xsl:when>
        <xsl:when test="starts-with($content,'&#x0A;')"><xsl:text> </xsl:text><xsl:call-template name="replaceSpecialChars"><xsl:with-param name="content" select="substring-after($content, '&#x0A;')"/></xsl:call-template></xsl:when>
        <xsl:when test="starts-with($content,'#')">\#<xsl:call-template name="replaceSpecialChars"><xsl:with-param name="content" select="substring-after($content, '#')"/></xsl:call-template></xsl:when>
        <xsl:when test="starts-with($content,'$')">\$<xsl:call-template name="replaceSpecialChars"><xsl:with-param name="content" select="substring-after($content, '$')"/></xsl:call-template></xsl:when>
        <xsl:when test="starts-with($content,'%')">\%<xsl:call-template name="replaceSpecialChars"><xsl:with-param name="content" select="substring-after($content, '%')"/></xsl:call-template></xsl:when>
        <xsl:when test="starts-with($content,'^')">\^{}<xsl:call-template name="replaceSpecialChars"><xsl:with-param name="content" select="substring-after($content, '^')"/></xsl:call-template></xsl:when>
        <xsl:when test="starts-with($content,'&amp;')">\&amp;<xsl:call-template name="replaceSpecialChars"><xsl:with-param name="content" select="substring-after($content, '&amp;')"/></xsl:call-template></xsl:when>
        <xsl:when test="starts-with($content,'_')">\_<xsl:call-template name="replaceSpecialChars"><xsl:with-param name="content" select="substring-after($content, '_')"/></xsl:call-template></xsl:when>
        <xsl:when test="starts-with($content,'{')">\{<xsl:call-template name="replaceSpecialChars"><xsl:with-param name="content" select="substring-after($content, '{')"/></xsl:call-template></xsl:when>
        <xsl:when test="starts-with($content,'}')">\}<xsl:call-template name="replaceSpecialChars"><xsl:with-param name="content" select="substring-after($content, '}')"/></xsl:call-template></xsl:when>
        <xsl:when test="starts-with($content,'~')">\~{}<xsl:call-template name="replaceSpecialChars"><xsl:with-param name="content" select="substring-after($content, '~')"/></xsl:call-template></xsl:when>
        <xsl:when test="starts-with($content,'\')">$\backslash$<xsl:call-template name="replaceSpecialChars"><xsl:with-param name="content" select="substring-after($content, '\')"/></xsl:call-template></xsl:when>
        <xsl:when test="starts-with($content,'&#160;')">~<xsl:call-template name="replaceSpecialChars"><xsl:with-param name="content" select="substring-after($content, '&#160;')"/></xsl:call-template></xsl:when>
        <xsl:when test="starts-with($content,'&#xAD;')">\-<xsl:call-template name="replaceSpecialChars"><xsl:with-param name="content" select="substring-after($content, '&#xAD;')"/></xsl:call-template></xsl:when>
        <xsl:when test="starts-with($content,'&#x2190;')">$\leftarrow$<xsl:call-template name="replaceSpecialChars"><xsl:with-param name="content" select="substring-after($content, '&#x2190;')"/></xsl:call-template></xsl:when>
        <xsl:when test="starts-with($content,'&#x2192;')">$\rightarrow$<xsl:call-template name="replaceSpecialChars"><xsl:with-param name="content" select="substring-after($content, '&#x2192;')"/></xsl:call-template></xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="substring($content,1,1)"/>
            <xsl:call-template name="replaceSpecialChars">
                <xsl:with-param name="content" select="substring($content, 2)"/>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>
