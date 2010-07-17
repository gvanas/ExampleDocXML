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
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
    xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    exclude-result-prefixes="d">

<xsl:template match="d:document">
<office:document-content office:version="1.0">
  <office:scripts/>
  <office:automatic-styles>
    <style:style style:name="Formula" style:family="graphic">
      <style:graphic-properties draw:auto-grow-width="true" draw:auto-grow-height="true"/>
    </style:style>
    <style:style style:name="EquationTable.Col1" style:family="table-column">
        <style:table-column-properties style:rel-column-width="8155*"/>
    </style:style>
    <style:style style:name="EquationTable.Col2" style:family="table-column">
        <style:table-column-properties style:rel-column-width="1483*"/>
    </style:style>
  </office:automatic-styles>
  <office:body>
    <office:text>
    <xsl:apply-templates select="d:head"/>
    <xsl:apply-templates select="d:body"/>
    </office:text>
  </office:body>
</office:document-content>
</xsl:template>

<xsl:template match="d:head">
    <xsl:apply-templates select="d:title"/>
    <xsl:apply-templates select="d:authors"/>
    <xsl:apply-templates select="d:affiliations"/>
    <xsl:apply-templates select="d:abstract"/>
</xsl:template>

<xsl:template match="d:authors">
    <text:p text:style-name="Authors">
        <xsl:apply-templates select="d:author"/>
    </text:p>
</xsl:template>

<xsl:template match="d:author">
    <text:span text:style-name="Author"><xsl:value-of select="."/></text:span>
    <xsl:if test="@affiliation!=''"><text:span text:style-name="Superscript"><xsl:apply-templates select="../../d:affiliations/d:affiliation[contains(current()/@affiliation,@name)]" mode="author-superscript"/></text:span></xsl:if>
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
    <xsl:apply-templates select="d:affiliation"/>
</xsl:template>

<xsl:template match="d:affiliation">
    <text:p text:style-name="Affiliation"><text:span text:style-name="Superscript"><xsl:value-of select="count(preceding-sibling::d:affiliation)+1"/></text:span>&#160;<xsl:apply-templates/></text:p>
</xsl:template>

<xsl:template match="d:title">
    <text:p text:style-name="Title"><xsl:apply-templates/></text:p>
</xsl:template>

<xsl:template match="d:abstract">
    <text:p text:style-name="Abstract"><xsl:apply-templates/></text:p>
</xsl:template>

<xsl:template match="d:body">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:section">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:div">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:h">
    <xsl:variable name="level" select="count(ancestor-or-self::d:section)"/>
    <xsl:variable name="number" select="../@number"/>
    <text:h text:style-name="{concat('Heading_20_', $level)}" text:outline-level="{$level}">
        <text:bookmark-start text:name="{generate-id(..)}"/>
        <xsl:apply-templates/>
        <text:bookmark-end text:name="{generate-id(..)}"/>
    </text:h>
</xsl:template>

<xsl:template match="d:p">
    <text:p text:style-name="Text_20_body">
    <xsl:apply-templates/>
    </text:p>
</xsl:template>

<xsl:template match="d:eq">
    <table:table table:name="{generate-id(.)}" table:style-name="EquationTable">
        <table:table-column table:style-name="EquationTable.Col1"/>
        <table:table-column table:style-name="EquationTable.Col2"/>
        <table:table-row>
            <table:table-cell><text:p text:style-name="EquationTable.Col1.P">
            <draw:frame draw:name="{generate-id(.)}" text:anchor-type="as-char" draw:z-index="0" draw:style-name="Formula">
            <draw:object>
            <xsl:copy-of select="m:math"/>
            </draw:object>
            </draw:frame>
            </text:p></table:table-cell>
            <table:table-cell><text:p text:style-name="EquationTable.Col2.P">(<xsl:value-of select="@number"/>)</text:p></table:table-cell>
        </table:table-row>
    </table:table>
</xsl:template>

<xsl:template name="pre-lines">
    <xsl:param name="textstring"/>
    <xsl:choose>
        <xsl:when test="starts-with($textstring, '&#10;')">
            <text:line-break/>
            <xsl:call-template name="pre-lines">
                <xsl:with-param name="textstring" select="substring($textstring, 2)"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($textstring, '&#10;')">
            <xsl:call-template name="pre-spaces">
                <xsl:with-param name="textstring" select="substring-before($textstring, '&#10;')"/>
            </xsl:call-template>
            <text:line-break/>
            <xsl:call-template name="pre-lines">
                <xsl:with-param name="textstring" select="substring(substring-after($textstring, substring-before($textstring, '&#10;')), 2)"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="pre-spaces">
                <xsl:with-param name="textstring" select="$textstring"/>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="pre-spaces">
    <xsl:param name="numspaces" select="0"/>
    <xsl:param name="textstring"/>
    <xsl:choose>
        <xsl:when test="starts-with($textstring, '&#32;')">
            <xsl:call-template name="pre-spaces">
                <xsl:with-param name="textstring" select="substring($textstring, 2)"/>
                <xsl:with-param name="numspaces" select="$numspaces+1"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($textstring, '&#32;')">
            <xsl:if test="$numspaces=1"><xsl:text> </xsl:text></xsl:if>
            <xsl:if test="$numspaces&gt;1"><text:s text:c="{$numspaces}"/></xsl:if>
            <xsl:value-of select="substring-before($textstring, '&#32;')"/>
            <xsl:call-template name="pre-spaces">
                <xsl:with-param name="textstring" select="substring-after($textstring, substring-before($textstring, ' '))"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:if test="$numspaces=1"><xsl:text> </xsl:text></xsl:if>
            <xsl:if test="$numspaces&gt;1"><text:s text:c="{$numspaces}"/></xsl:if>
            <xsl:value-of select="$textstring"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="d:pre/text()" priority="1">
    <xsl:call-template name="pre-lines">
        <xsl:with-param name="textstring" select="."/>
    </xsl:call-template>
</xsl:template>

<xsl:template match="d:pre">
    <text:p text:style-name="Preformatted_20_Text">
        <xsl:apply-templates/>
    </text:p><xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="d:ul">
    <text:list text:style-name="List">
        <xsl:apply-templates select="d:li|d:ol|d:ul"/>
    </text:list><xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="d:ul/d:ul|d:ol/d:ul">
    <text:list-item>
    <text:list text:style-name="List">
        <xsl:apply-templates select="d:li|d:ol|d:ul"/>
    </text:list>
    </text:list-item><xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="d:ol">
    <text:list text:style-name="Numbering">
        <xsl:apply-templates select="d:li|d:ol|d:ul"/>
    </text:list><xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="d:ul/d:ol|d:ol/d:ol">
    <text:list-item>
    <text:list text:style-name="Numbering">
        <xsl:apply-templates select="d:li|d:ol|d:ul"/>
    </text:list>
    </text:list-item><xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="d:li">
    <xsl:if test="normalize-space(.)!=''">
        <text:list-item>
            <text:p>
                <text:bookmark-start text:name="{generate-id(.)}"/>
                <xsl:apply-templates/>
                <text:bookmark-end text:name="{generate-id(.)}"/>
            </text:p>
        </text:list-item><xsl:text>
</xsl:text>
    </xsl:if>
</xsl:template>

<xsl:template match="d:a">
    <text:a xlink:type="simple" xlink:href="{@href}"><xsl:apply-templates/></text:a>
</xsl:template>

<xsl:template match="d:ref">
    <xsl:variable name="pointer">
        <xsl:value-of select="concat('#',generate-id(//*[@id=current()/@t]))"/>
    </xsl:variable>
    <text:a xlink:type="simple" xlink:href="{$pointer}"><xsl:apply-templates/></text:a>
</xsl:template>

<xsl:template match="d:ieq">
    <draw:frame draw:name="{generate-id(.)}" text:anchor-type="as-char" draw:z-index="0" draw:style-name="Formula">
    <draw:object>
    <xsl:copy-of select="m:math"/>
    </draw:object>
    </draw:frame>
</xsl:template>

<xsl:template match="d:span">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:code"><text:span text:style-name="Code"><xsl:apply-templates/></text:span></xsl:template>
<xsl:template match="d:em"><text:span text:style-name="I"><xsl:apply-templates/></text:span></xsl:template>
<xsl:template match="d:sc"><text:span text:style-name="SC"><xsl:apply-templates/></text:span></xsl:template>
<xsl:template match="d:strong"><text:span text:style-name="B"><xsl:apply-templates/></text:span></xsl:template>
<xsl:template match="d:sub"><text:span text:style-name="Subscript"><xsl:apply-templates/></text:span></xsl:template>
<xsl:template match="d:sup"><text:span text:style-name="Superscript"><xsl:apply-templates/></text:span></xsl:template>

<xsl:template match="d:body/text()|d:section/text()"/>

</xsl:stylesheet>
