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

<xsl:import href="ToXHTML-common.xsl"/>

<xsl:output encoding="UTF-8"
  doctype-public = "-//W3C//DTD XHTML 1.1//EN"
  doctype-system = "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"/>

<xsl:template match="d:ieq">
    <span class="eq"><xsl:apply-templates select="m:math"/></span>
</xsl:template>

<xsl:template match="d:eq">
    <table class="equation" id="{generate-id()}">
    <tr><td class="eq"><xsl:apply-templates select="m:math"/></td><xsl:if test="@number!=''"><td class="number">(<xsl:value-of select="@number"/>)</td></xsl:if></tr>
    </table>
</xsl:template>

<xsl:template match="m:mi">
    <xsl:choose>
        <xsl:when test="@mathvariant='bold'">
            <b><xsl:value-of select="."/></b>
        </xsl:when>
        <xsl:when test="@mathvariant='sans-serif'">
            <span class="sans-serif"><xsl:value-of select="."/></span>
        </xsl:when>
        <xsl:when test="@mathvariant='script'">
            <span class="script"><xsl:value-of select="."/></span>
        </xsl:when>
        <xsl:when test="string-length(.)=1">
            <i><xsl:value-of select="."/></i>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="."/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="m:mn">
    <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="m:mo">
    <xsl:choose>
        <xsl:when test="contains('&#x2061;&#x2062;',.)"/>
        <xsl:when test=".='&#x2146;'"><span class="serif">d</span></xsl:when>
        <xsl:otherwise><span class="mo"><xsl:value-of select="."/></span></xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="m:mtext">
    <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="m:mrow">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="m:msup|m:mover">
    <xsl:apply-templates select="./*[1]"/>
    <sup><xsl:apply-templates select="./*[2]"/></sup>
</xsl:template>

<xsl:template match="m:msub|m:munder">
    <xsl:apply-templates select="./*[1]"/>
    <sub><xsl:apply-templates select="./*[2]"/></sub>
</xsl:template>

<xsl:template match="m:msubsup|m:munderover">
    <xsl:apply-templates select="./*[1]"/>
    <sub><xsl:apply-templates select="./*[2]"/></sub>
    <sup><xsl:apply-templates select="./*[3]"/></sup>
</xsl:template>

<xsl:template match="m:msqrt">
    <span class="mo">&#x221A;(</span><xsl:apply-templates/><span class="mo">)</span>
</xsl:template>

<xsl:template match="m:mfrac">
    <xsl:choose>
        <xsl:when test="name(./*[1])='mrow'"><span class="mo">(</span><xsl:apply-templates select="./*[1]"/><span class="mo">)</span></xsl:when>
        <xsl:otherwise><xsl:apply-templates select="./*[1]"/></xsl:otherwise>
    </xsl:choose>
    <span class="mo">/</span>
    <xsl:choose>
        <xsl:when test="name(./*[2])='mrow'"><span class="mo">(</span><xsl:apply-templates select="./*[2]"/><span class="mo">)</span></xsl:when>
        <xsl:otherwise><xsl:apply-templates select="./*[2]"/></xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="m:mtable">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="m:mtr">
    <span class="mo">[</span><xsl:apply-templates/><span class="mo">]</span>
</xsl:template>

<xsl:template match="m:mtr/m:mtd">
    <xsl:apply-templates/>
    <xsl:if test="position()&lt;last()">, </xsl:if>
</xsl:template>

<xsl:template match="m:*/text()"/>

</xsl:stylesheet>
