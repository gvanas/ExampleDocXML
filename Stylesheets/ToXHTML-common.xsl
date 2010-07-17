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
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:d="http://gva.noekeon.org/blahtexml/exampledoc"
    xmlns:m="http://www.w3.org/1998/Math/MathML"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="d">

<xsl:template match="d:document">
    <html xml:lang="en">
    <xsl:apply-templates/>
    </html>
</xsl:template>

<xsl:template match="d:head">
    <head>
    <meta http-equiv="Content-Type" content="text/xml; charset=UTF-8" />
    <title><xsl:value-of select="title"/></title>
    <link rel="stylesheet" type="text/css" href="document.css" />
    </head>
</xsl:template>

<xsl:template match="d:authors">
    <p class="authors">
        <xsl:apply-templates select="d:author"/>
    </p>
</xsl:template>

<xsl:template match="d:author">
    <span class="author"><xsl:value-of select="."/></span>
    <xsl:if test="@affiliation!=''"><sup><xsl:apply-templates select="../../d:affiliations/d:affiliation[contains(current()/@affiliation,@name)]" mode="author-superscript"/></sup></xsl:if>
    <xsl:choose>
        <xsl:when test="position()&lt;last()-1">, </xsl:when>
        <xsl:when test="position()=(last()-1)"> and </xsl:when>
    </xsl:choose>
</xsl:template>

<xsl:template match="d:affiliation" mode="author-superscript">
    <xsl:value-of select="count(preceding-sibling::d:affiliation)+1"/>
    <xsl:if test="position()&lt;last()">,</xsl:if>
</xsl:template>

<xsl:template match="d:affiliations">
    <div class="affiliations">
        <xsl:apply-templates select="d:affiliation"/>
    </div>
</xsl:template>

<xsl:template match="d:affiliation">
    <p class="affiliation"><sup><xsl:value-of select="count(preceding-sibling::d:affiliation)+1"/></sup>&#160;<xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="d:title">
    <h1><xsl:apply-templates/></h1>
</xsl:template>

<xsl:template match="d:abstract">
    <h2>Abstract</h2>
    <div class="abstract"><xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="d:body">
    <body>
        <xsl:apply-templates select="../d:head/d:title"/>
        <xsl:apply-templates select="../d:head/d:authors"/>
        <xsl:apply-templates select="../d:head/d:affiliations"/>
        <xsl:apply-templates select="../d:head/d:abstract"/>
        <xsl:apply-templates/>
    </body>
</xsl:template>

<xsl:template match="d:section">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:div">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:h">
    <xsl:variable name="level" select="count(ancestor-or-self::d:section)+1"/>
    <xsl:variable name="number" select="../@number"/>
    <xsl:variable name="hname">
        <xsl:choose>
            <xsl:when test="$level=1">h1</xsl:when>
            <xsl:when test="$level=2">h2</xsl:when>
            <xsl:when test="$level=3">h3</xsl:when>
            <xsl:when test="$level=4">h4</xsl:when>
            <xsl:when test="$level=5">h5</xsl:when>
            <xsl:otherwise>h6</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$hname}">
        <xsl:attribute name="id"><xsl:value-of select="generate-id(..)"/></xsl:attribute>
        <xsl:if test="$number!=''"><xsl:value-of select="$number"/>&#160;</xsl:if><xsl:apply-templates/>
    </xsl:element>
</xsl:template>

<xsl:template match="d:p">
    <p>
    <xsl:apply-templates/>
    </p>
</xsl:template>

<xsl:template match="d:pre">
    <pre>
    <xsl:apply-templates/>
    </pre>
</xsl:template>

<xsl:template match="d:ul">
    <ul>
        <xsl:apply-templates/>
    </ul>
</xsl:template>

<xsl:template match="d:ol">
    <ol>
        <xsl:apply-templates/>
    </ol>
</xsl:template>

<xsl:template match="d:li">
    <li>
        <xsl:apply-templates/>
    </li>
</xsl:template>

<xsl:template match="d:a">
    <a><xsl:copy-of select="./@href"/><xsl:apply-templates/></a>
</xsl:template>

<xsl:template match="d:ref">
    <xsl:variable name="pointer"><xsl:value-of select="concat('#',generate-id(//d:*[@id=current()/@t]))"/></xsl:variable>
    <span class="ref"><a href="{$pointer}"><xsl:apply-templates/></a></span>
</xsl:template>

<xsl:template match="d:ref-number">
    <span class="ref-number"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="d:span">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:code"><code><xsl:apply-templates/></code></xsl:template>
<xsl:template match="d:em"><em><xsl:apply-templates/></em></xsl:template>
<xsl:template match="d:sc"><span class="sc"><xsl:apply-templates/></span></xsl:template>
<xsl:template match="d:strong"><strong><xsl:apply-templates/></strong></xsl:template>
<xsl:template match="d:sup"><sup><xsl:apply-templates/></sup></xsl:template>
<xsl:template match="d:sub"><sub><xsl:apply-templates/></sub></xsl:template>

<xsl:template match="d:body/text()|d:section/text()"/>

</xsl:stylesheet>
