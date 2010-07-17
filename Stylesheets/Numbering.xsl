<?xml version="1.0"?>
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
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
    <xsl:apply-templates/>
</xsl:template>

<xsl:variable name="headingOffset">1</xsl:variable>

<xsl:template match="d:section[@numbering='appendix']">
    <xsl:param name="N"/>
    <xsl:variable name="M"><xsl:value-of select="$N"/><xsl:number
        level="single"
        count="d:section[@numbering='appendix']"
        format="A"/></xsl:variable>
    <xsl:variable name="level" select="count(ancestor-or-self::d:section)+$headingOffset"/>
    <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:attribute name="number"><xsl:value-of select="$M"/></xsl:attribute>
        <xsl:attribute name="ref-prefix">
            <xsl:choose>
                <xsl:when test="$level=1">Appendix&#160;</xsl:when>
                <xsl:otherwise>Section&#160;</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:apply-templates>
            <xsl:with-param name="N"><xsl:value-of select="$M"/>.</xsl:with-param>
        </xsl:apply-templates>
    </xsl:copy>
</xsl:template>

<xsl:template match="d:section[not(@numbering!='')]">
    <xsl:param name="N"/>
    <xsl:variable name="M"><xsl:value-of select="$N"/><xsl:number
        level="single"
        count="d:section[not(@numbering!='')]"
        format="1"/></xsl:variable>
    <xsl:variable name="level" select="count(ancestor-or-self::d:section)+$headingOffset"/>
    <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:attribute name="number"><xsl:value-of select="$M"/></xsl:attribute>
        <xsl:attribute name="ref-prefix">
            <xsl:choose>
                <xsl:when test="$level=1">Chapter&#160;</xsl:when>
                <xsl:otherwise>Section&#160;</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:apply-templates>
            <xsl:with-param name="N"><xsl:value-of select="$M"/>.</xsl:with-param>
        </xsl:apply-templates>
    </xsl:copy>
</xsl:template>

<xsl:template match="d:section[@numbering='none']">
    <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="d:eq">
    <xsl:param name="N"/>
    <xsl:variable name="M"><xsl:value-of select="substring-before($N, '.')"/>.<xsl:number
        level="any"
        count="d:eq" from="//d:body/d:section"
        format="1"/></xsl:variable>
    <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:attribute name="number"><xsl:value-of select="$M"/></xsl:attribute>
        <xsl:attribute name="ref-prefix">Eq.&#160;(</xsl:attribute>
        <xsl:attribute name="ref-suffix">)</xsl:attribute>
        <xsl:apply-templates>
            <xsl:with-param name="N"><xsl:value-of select="$M"/></xsl:with-param>
        </xsl:apply-templates>
    </xsl:copy>
</xsl:template>

<xsl:template match="d:section[@numbering='none']|d:*|*">
    <xsl:param name="N"/>
    <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates>
            <xsl:with-param name="N"><xsl:value-of select="$N"/></xsl:with-param>
        </xsl:apply-templates>
    </xsl:copy>
</xsl:template>

</xsl:stylesheet>
