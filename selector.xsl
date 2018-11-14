<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" 
    xmlns:math="http://exslt.org/math" extension-element-prefixes="math"
    exclude-result-prefixes="xs t e" version="2.0">
    <!-- Take 5 random passages of 400 “tokens” from each text: 100 samples per language. 
        Whitespace tokenizer: 2,000 whitespace-delimited tokens per text. 
Tokens that don’t fit a entire sentence get trimmed manually.
 Exclude headings, include poetry -->

    <xsl:variable name="textID" select="//t:TEI/@xml:id"/>

    <!-- get a random number between 1 and number of paragraphs in the body of the text -->
    <xsl:variable name="pCount" select="count(//t:p)"/>
    <xsl:variable name="random" select="306">
  <!--      <xsl:value-of select="xs:integer(floor(math:random() * $pCount))"/>-->
    </xsl:variable>
    
    
    <xsl:template match="/">
        <xsl:message>Text is <xsl:value-of select="$textID"/> and there are <xsl:value-of
            select="$pCount"/> paragraphs here: we start with number <xsl:value-of
                select="$random"/> .</xsl:message>
        
    <sample>
        <xsl:apply-templates select="//t:body//t:p[count(preceding::t:p[ancestor::t:body]) = $random]">
        <xsl:with-param name="wordCount" select="0"/>
        <xsl:with-param name="maxWords" select="400"/>
     </xsl:apply-templates>
    </sample></xsl:template>
    
   <xsl:template match="t:p">
        <xsl:param name="wordCount"/>
        <xsl:param name="maxWords"/>
       <xsl:variable name="paraNo">
           <xsl:value-of 
           select="count(preceding::t:p[ancestor::t:body])"/>
       </xsl:variable>
       <xsl:message>Now on para  <xsl:value-of 
           select="$paraNo"/> (<xsl:value-of 
               select="e:wCount(.)"/> words) and  wordCount is <xsl:value-of 
               select="$wordCount"/>
       </xsl:message>
       <xsl:variable name="prefix">
           <xsl:value-of select="concat($textID, $paraNo)"/>
       </xsl:variable>
       <xsl:if test="$wordCount &lt; $maxWords">   
           <p n="{$prefix}"><xsl:value-of select="."/></p>
           <xsl:apply-templates select="following::t:p[1]">
               <xsl:with-param name="wordCount" select="$wordCount + e:wCount(.)"/>
               <xsl:with-param name="maxWords" select="$maxWords"/>
           </xsl:apply-templates>
       </xsl:if>
  <!--   <xsl:choose>
         <xsl:when test="$paraNo &gt; $random">
             <xsl:if test="$wordCount &lt; $maxWords">   
           <p n="{$prefix}"><xsl:value-of select="."/></p>
             <xsl:apply-templates select="following-sibling::t:p[1]">
                 <xsl:with-param name="wordCount" select="$wordCount + e:wCount(.)"/>
                 <xsl:with-param name="maxWords" select="$maxWords"/>
              </xsl:apply-templates>
             </xsl:if>
             </xsl:when>
         <xsl:otherwise>
               <xsl:apply-templates select="following-sibling::t:p[1]">
                 <xsl:with-param name="wordCount" select="$wordCount"/>
                 <xsl:with-param name="maxWords" select="$maxWords"/>
             </xsl:apply-templates>
         </xsl:otherwise>
        
     </xsl:choose>  
      -->
          
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
    
</xsl:stylesheet>
