<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" xmlns:math="http://exslt.org/math"
    extension-element-prefixes="math" exclude-result-prefixes="xs t e" version="2.0">
    <xsl:param name="DEBUG"/>
    <xsl:variable name="textID" select="//t:TEI/@xml:id"/>
    <xsl:variable name="pCount" select="count(//t:text//t:p)"/>
    <!--<xsl:variable name="random">
<xsl:value-of select="xs:integer(floor(math:random() * $pCount))"/>
    </xsl:variable>
    -->
    <xsl:variable name="url">
        <xsl:text>https://www.random.org/integers/?num=5&amp;min=1&amp;max=</xsl:text>
        <xsl:value-of select="$pCount"/>
        <xsl:text>&amp;col=1&amp;base=10&amp;format=plain&amp;rnd=new</xsl:text>
    </xsl:variable>
    <xsl:variable name="randomParas" select="tokenize(unparsed-text($url), '\s')"/>
    <xsl:template match="/">
        <xsl:if test="$DEBUG">
            <xsl:message>Text is <xsl:value-of select="$textID"/> and there are <xsl:value-of
                    select="$pCount"/> paragraphs here.</xsl:message>
        </xsl:if>
        <xsl:variable name="context" select="//t:body"/>
        <samples>
            <xsl:for-each select="$randomParas">
                <xsl:variable name="random">
                    <xsl:value-of select="."/>
                </xsl:variable>
                <xsl:if test="string-length($random) gt 0">
                    <sample>
                        <xsl:apply-templates
                            select="
                                $context//t:p[count(preceding::t:p[ancestor::t:body]) =
                                xs:integer($random)]">
                            <xsl:with-param name="wordCount" select="0"/>
                            <xsl:with-param name="maxWords" select="400"/>
                        </xsl:apply-templates>
                    </sample>
                </xsl:if>
            </xsl:for-each>
        </samples>
    </xsl:template>
    <xsl:template match="t:p">
        <xsl:param name="wordCount"/>
        <xsl:param name="maxWords"/>
        <xsl:variable name="paraNo">
            <xsl:value-of select="count(preceding::t:p[ancestor::t:body])"/>
        </xsl:variable>
        <xsl:if test="$DEBUG">
            <xsl:message>Now on para <xsl:value-of select="$paraNo"/> (<xsl:value-of
                    select="e:wCount(.)"/> words starting <xsl:value-of select="substring(., 1, 20)"
                />) and wordCountSoFar is <xsl:value-of select="$wordCount"/>
            </xsl:message>
        </xsl:if>
        <xsl:variable name="prefix">
            <xsl:value-of select="concat($textID, $paraNo)"/>
        </xsl:variable>
        <xsl:if test="$wordCount &lt; $maxWords">
            <p n="{$prefix}">
                <xsl:value-of select="normalize-space(.)"/>
            </p>
            <xsl:text>
</xsl:text>
            <xsl:apply-templates select="following::t:p[1]">
                <xsl:with-param name="wordCount" select="$wordCount + e:wCount(.)"/>
                <xsl:with-param name="maxWords" select="$maxWords"/>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>
    <xsl:function name="e:wCount" as="xs:integer" xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:value-of
            select="
                string-length(normalize-space($arg)) - string-length(translate(normalize-space
                ($arg), ' ', '')) + 1"
        />
    </xsl:function>
</xsl:stylesheet>
