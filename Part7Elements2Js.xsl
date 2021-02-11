<xsl:stylesheet version="2.0" xmlns:db="http://docbook.org/ns/docbook" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
    <xsl:output omit-xml-declaration="yes" method="text" media-type="text/javascript"/>
    <xsl:output method="text" encoding="utf-8"/>
    <xsl:template match="/">
        <xsl:text>{
</xsl:text>
        <xsl:apply-templates select="db:book/db:chapter[@xml:id='chapter_E']/db:section[@xml:id='sect_E.1']/db:table[@xml:id='table_E.1-1']/db:tbody"/>
        <xsl:apply-templates select="db:book/db:chapter[@xml:id='chapter_E']/db:section[@xml:id='sect_E.2']/db:table[@xml:id='table_E.2-1']/db:tbody"/>
        <xsl:text>}
</xsl:text>
     </xsl:template>
     <xsl:template match="db:tbody">
        <xsl:for-each select="db:tr">
            <xsl:variable name="tag">
                <xsl:value-of select="normalize-space(./db:td[1])"/>
            </xsl:variable>
            <xsl:variable name="group">
                <xsl:value-of select="substring($tag,2,4)"/>
            </xsl:variable>
            <xsl:variable name="element">
                <xsl:value-of select="substring($tag,7,4)"/>
            </xsl:variable>
            <xsl:text>&#009;'</xsl:text>
            <xsl:value-of select="concat($group,$element)"/>
            <xsl:text>': {'tag': '</xsl:text>
            <xsl:value-of select="concat($group,$element)"/>
            <xsl:text>', 'vr': '</xsl:text>
            <xsl:value-of select="normalize-space(./db:td[4])"/>
            <xsl:text>', 'vm': '</xsl:text>
            <xsl:value-of select="normalize-space(./db:td[5])"/>
            <xsl:text>', 'name': '</xsl:text>
            <xsl:value-of select="normalize-space(./db:td[3])"/>
            <xsl:text>'}</xsl:text>
            <xsl:if test="following-sibling::*">
                <xsl:text>,
</xsl:text>
            </xsl:if>  
        </xsl:for-each>
        <xsl:text>
        
</xsl:text>            
   </xsl:template>
</xsl:stylesheet>
