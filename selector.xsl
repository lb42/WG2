<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" 
    xmlns:math="http://exslt.org/math" extension-element-prefixes="math"
    exclude-result-prefixes="xs t" version="2.0">
    <!-- Take 5 random passages of 400 “tokens” from each text: 100 samples per language. 
        Whitespace tokenizer: 2,000 whitespace-delimited tokens per text. 
Tokens that don’t fit a entire sentence get trimmed manually.
 Exclude headings, include poetry -->

    <xsl:variable name="textID" select="//t:TEI/@xml:id"/>

    <!-- get a random number between 1 and number of chapters in the body of the text -->
    <xsl:variable name="pCount" select="count(//t:p)"/>
    <xsl:variable name="random">
        <xsl:value-of select="xs:integer(floor(math:random() * $pCount))"/>
    </xsl:variable>
    <!-- how many words in that random para? -->   
    <xsl:variable name="chosenP">
        <xsl:value-of select="//t:p[count(preceding::t:p[ancestor::t:body]) = $random]"/>
    </xsl:variable>
    <xsl:variable name="prefix">
        <xsl:value-of select="concat($textID, format-number($random, '0000'))"/>
    </xsl:variable>
    <xsl:variable name="maxWords" select="400"/>
    
    <xsl:template match="/">
        <xsl:message>Text is <xsl:value-of select="$textID"/> and there are <xsl:value-of
                select="$pCount"/> paragraphs here.</xsl:message>
        
        <xsl:for-each select="//t:p[count(preceding::t:p[ancestor::t:body]) &gt; $random]">
      <!--      and e:wCount() &lt; $maxWords]">
     -->    
      <xsl:variable name="wordsSoFar">
	<xsl:value-of select="sum(e:wCount(preceding::t:p[ancestor::t:body])"/>
      </xsl:variable>

      <xsl:message>Words so far <xsl:value-of select="$wordsSofar"/>
      </xsl:message>
      
      <xsl:apply-templates select="."/>

    </xsl:for-each> 
 <!--       <xsl:apply-templates select="//t:p[count(preceding::t:p[ancestor::t:body]) &gt; $random]"/>
-->    </xsl:template>
    
    <xsl:template match="t:p">
    
        <xsl:variable name="pLength">
            <xsl:value-of
                select="string-length(normalize-space(.))"
            /></xsl:variable>
        
        
        <xsl:variable name="wCount">
            <xsl:value-of select="$pLength - string-length(translate(normalize-space
                (.), ' ', '')) + 1"/>
        </xsl:variable>   
           
        <xsl:message>Paragraph  <xsl:value-of 
            select="count(preceding::t:p[ancestor::t:body])"/>(starting <xsl:value-of 
            select="substring(.,1,30)"/>) has <xsl:value-of 
            select="$pLength"/> chars and <xsl:value-of 
            select="$wCount"/> words </xsl:message>
    </xsl:template>
    
    
    <xsl:function name="e:wCount" as="xs:integer" xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>        
        <xsl:value-of select="string-length(normalize-space($arg)) - string-length(translate(normalize-space
            ($arg), ' ', '')) + 1"/>
    </xsl:function>   
    
    <xsl:function name="e:word-count" as="xs:integer" xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>        
        <xsl:sequence
            select="
            count(tokenize($arg, '\W+')[. != ''])
            "/>        
    </xsl:function>
        <!-- if para has at least 400 words proceed to process it; otherwise do nothing -->
   <!--  <xsl:choose><xsl:when test="$wCount &gt; 399">
            <sample>
                <xsl:apply-templates
                    select="$chosenP"/>
            </sample>
        </xsl:when>
        <xsl:otherwise>
           <sample> 
               <xsl:for-each select="t:p[position() ></xsl:for-each>
               <xsl:apply-templates
                select="//t:p[count(preceding::t:p[ancestor::t:body]) = $random]"/>
            <xsl:apply-templates
                select="//t:p[count(preceding::t:p[ancestor::t:body]) = $random+1]"/>
            
    </sample>    </xsl:otherwise></xsl:choose>
-->

   <!-- <xsl:template match="t:p">
        <xsl:variable name="pString">
            <xsl:value-of select="."/>
        </xsl:variable>
        <xsl:message>Which has <xsl:value-of select="string-length($pString)"/> chars</xsl:message>

        <xsl:message>Which has <xsl:value-of 
            select="count(tokenize($pString, '\.\s'))"/> sUnits</xsl:message>
        <xsl:for-each select="tokenize($pString, '\.\s')">
            <xsl:variable name="seq">
                <xsl:value-of select="concat($prefix, string(position()))"/>
            </xsl:variable>
            <xsl:variable name="wc">
                <xsl:value-of select="string-length(translate(normalize-space
                (.), ' ', '')) + 1"/>
            </xsl:variable>
            <xsl:message>S'unit <xsl:value-of 
                select="$seq"/> has <xsl:value-of select="$wc"/> words</xsl:message>
             
            <s n="{$seq}" wc="{$wc}">
                <xsl:value-of select="."/><xsl:text>. </xsl:text>
            </s>
        </xsl:for-each>
    </xsl:template>
  -->      
</xsl:stylesheet>
