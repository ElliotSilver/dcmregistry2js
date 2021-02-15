<xsl:stylesheet version="3.0" 
                xmlns:db="http://docbook.org/ns/docbook" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/TR/xmlschema-2">          
    <xsl:output omit-xml-declaration="yes" method="xml" media-type="application/xml" indent="yes" encoding="utf-8"/>
    <xsl:param name="format" select="'json'"/>
    <xsl:param name="part07" as="document-node()"/>
    
    <xsl:template match="/">        
        <xsl:variable name="part06" as="document-node()" select="."/>

        <xsl:variable name="header-info" as="node()">
            <metadata xsl:exclude-result-prefixes="#all">
                <xsl:apply-templates select="$part06/db:book[@xml:id='PS3.6']/db:subtitle"/>
                <generated><xsl:value-of select="adjust-dateTime-to-timezone(current-dateTime())"/></generated>
            </metadata>
        </xsl:variable>
        
        <xsl:variable name="tag-list" as="node()">
            <tags xsl:exclude-result-prefixes="#all">
                <xsl:apply-templates select="$part06/db:book[@xml:id='PS3.6']/db:chapter[@xml:id='chapter_6']/db:table[@xml:id='table_6-1']/db:tbody" mode="extract-tags"/>
                <xsl:apply-templates select="$part06/db:book[@xml:id='PS3.6']/db:chapter[@xml:id='chapter_7']/db:table[@xml:id='table_7-1']/db:tbody" mode="extract-tags">
                    <xsl:with-param name="metainfo" select="'true'"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="$part06/db:book[@xml:id='PS3.6']/db:chapter[@xml:id='chapter_8']/db:table[@xml:id='table_8-1']/db:tbody" mode="extract-tags">
                    <xsl:with-param name="dicomdir" select="'true'"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="$part06/db:book[@xml:id='PS3.6']/db:chapter[@xml:id='chapter_9']/db:table[@xml:id='table_9-1']/db:tbody" mode="extract-tags">
                    <xsl:with-param name="realtime" select="'true'"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="$part07/db:book[@xml:id='PS3.7']/db:chapter[@xml:id='chapter_E']/db:section[@xml:id='sect_E.1']/db:table[@xml:id='table_E.1-1']/db:tbody" mode="extract-tags">
                    <xsl:with-param name="command" select="'true'"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="$part07/db:book[@xml:id='PS3.7']/db:chapter[@xml:id='chapter_E']/db:section[@xml:id='sect_E.2']/db:table[@xml:id='table_E.2-1']/db:tbody" mode="extract-tags">
                    <xsl:with-param name="retired" select="'true'"/>
                    <xsl:with-param name="command" select="'true'"/>
                </xsl:apply-templates>
            </tags>
        </xsl:variable>
        
        <xsl:variable name="sorted-tags" as="node()">
            <elementRegistry>
                <xsl:copy-of select="$header-info"/>
                <xsl:apply-templates select="$tag-list" mode="sort"/>
            </elementRegistry>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$format='json'">
                <xsl:text>{</xsl:text>
                <xsl:apply-templates select="$sorted-tags" mode="as-json"/>
                <xsl:text>}</xsl:text>
            </xsl:when>
            <xsl:when test="$format='xml'">
                <xsl:copy-of select="$sorted-tags"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">Unrecognized output format: <xsl:value-of select="$format"/>. Supported formats are json, xml.</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Extract Tag data from table -->
    <xsl:template match="db:tbody" mode="extract-tags">
        <xsl:param name="retired"/>
        <xsl:param name="command" select="'false'"/>
        <xsl:param name="metainfo" select="'false'"/>
        <xsl:param name="dicomdir" select="'false'"/>
        <xsl:param name="realtime" select="'false'"/>
        <xsl:for-each select="db:tr" >
            <xsl:variable name="tag">
                <xsl:value-of select="normalize-space(./db:td[1])"/>
            </xsl:variable>
            <xsl:variable name="group">
                <xsl:value-of select="substring($tag,2,4)"/>
            </xsl:variable>
            <xsl:variable name="element">
                <xsl:value-of select="substring($tag,7,4)"/>
            </xsl:variable>
            <element xsl:exclude-result-prefixes="#all">
                <xsl:attribute name="tag"><xsl:value-of select="concat($group,$element)"/></xsl:attribute>
                <xsl:attribute name="name"><xsl:value-of select="normalize-space(./db:td[2])"/></xsl:attribute>
                <xsl:attribute name="keyword"><xsl:value-of select="normalize-space(./db:td[3])"/></xsl:attribute>
                <xsl:attribute name="vr"><xsl:value-of select="normalize-space(./db:td[4])"/></xsl:attribute>
                <xsl:attribute name="vm"><xsl:value-of select="normalize-space(./db:td[5])"/></xsl:attribute>
                <xsl:attribute name="retired">
                    <xsl:choose>
                        <xsl:when test="$retired != ''"><xsl:value-of select="$retired='true'"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="contains(./db:td[6],'RET')"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="command"><xsl:value-of select="$command='true'"/></xsl:attribute>
                <xsl:attribute name="metainfo"><xsl:value-of select="$metainfo='true'"/></xsl:attribute>
                <xsl:attribute name="dicomdir"><xsl:value-of select="$dicomdir='true'"/></xsl:attribute>
                <xsl:attribute name="realtime"><xsl:value-of select="$realtime='true'"/></xsl:attribute>
                <xsl:attribute name="dicos"><xsl:value-of select="contains(./db:td[6],'DICOS')"/></xsl:attribute>
                <xsl:attribute name="diconde"><xsl:value-of select="contains(./db:td[6],'DICONDE')"/></xsl:attribute>
            </element>
        </xsl:for-each>
    </xsl:template>

    <!-- Extract DICOM release number -->
    <xsl:template match="db:subtitle">
        <release>
            <xsl:analyze-string select="text()" regex="([0-9]{{4}}[^ ]+)">
                <xsl:matching-substring><xsl:value-of select="regex-group(1)"/> </xsl:matching-substring>
            </xsl:analyze-string>
        </release>
    </xsl:template>

    <!-- Sort processed tag entries -->
    <xsl:template match="/" mode="sort">
        <xsl:apply-templates select="tags" mode="sort"/>
    </xsl:template>
    
    <xsl:template match="tags" mode="sort">
        <xsl:copy>
            <xsl:for-each select="element">
                <xsl:sort select="@tag"/>   
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>


    <!-- -->
    <!-- JSON conversion follows -->
    <!-- -->
    <xsl:template match="/" mode="as-json">{
        <xsl:apply-templates select="*" mode="as-json"/>}
    </xsl:template>
    
    <!-- Object or Element Property-->
    <xsl:template match="*" mode="as-json">
        "<xsl:value-of select="name()"/>" : <xsl:call-template name="Properties"/>
    </xsl:template>

    <!-- Array Element -->
    <xsl:template match="*" mode="ArrayElement">
        <xsl:call-template name="Properties"/>
    </xsl:template>

    <!-- Object Properties -->
    <xsl:template name="Properties">
        <xsl:variable name="childName" select="name(*[1])"/>
        <xsl:choose>
            <xsl:when test="not(*|@*)">"<xsl:value-of select="."/>"</xsl:when>
            <xsl:when test="count(*[name()=$childName]) > 1">{ "<xsl:value-of select="$childName"/>" : [<xsl:apply-templates select="*" mode="ArrayElement"/>] }</xsl:when>
            <xsl:otherwise>{
                <xsl:apply-templates select="@*" mode="as-json"/>
                <xsl:apply-templates select="*" mode="as-json"/>
    }</xsl:otherwise>
        </xsl:choose>
        <xsl:if test="following-sibling::*">,</xsl:if>
    </xsl:template>

    <!-- Attribute Property -->
    <xsl:template match="@*" mode="as-json">"<xsl:value-of select="name()"/>" : "<xsl:value-of select="."/>",
    </xsl:template>  
   
    <!-- <xsl:template match="/" mode="as-json">
        <json:object>
            <xsl:apply-templates select="tags" mode="as-json"/>
        </json:object>
    </xsl:template> -->
   

    <xsl:template match="elementRegistry" mode="as-json">
        <xsl:for-each select="./*">
            <xsl:apply-templates select="." mode="as-json"/>
        </xsl:for-each>
    </xsl:template>


    <xsl:template match="tags" mode="as-json">
        <xsl:text>"tags" : [
</xsl:text>
        <xsl:for-each select="./element">
            <xsl:text>{ "tag" : "</xsl:text>
            <xsl:value-of select="./@tag"/>
            <xsl:text>", "name" : "</xsl:text>
            <xsl:value-of select="./@name"/>
            <xsl:text>", "keyword" : "</xsl:text>
            <xsl:value-of select="./@keyword"/>
            <xsl:text>", "vr" : "</xsl:text>
            <xsl:value-of select="./@vr"/>
            <xsl:text>", "vm" : "</xsl:text>
            <xsl:value-of select="./@vm"/>
            <xsl:text>", "retired" : </xsl:text>
            <xsl:value-of select="./@retired"/>
            <xsl:text>, "command" : </xsl:text>
            <xsl:value-of select="./@command"/>
            <xsl:text>, "metainfo" : </xsl:text>
            <xsl:value-of select="./@metainfo"/>
            <xsl:text>, "realtime" : </xsl:text>
            <xsl:value-of select="./@realtime"/>
            <xsl:text>, "dicomdir" : </xsl:text>
            <xsl:value-of select="./@dicomdir"/>
            <xsl:text>, "dicos" : </xsl:text>
            <xsl:value-of select="./@dicos"/>
            <xsl:text>, "diconde" : </xsl:text>
            <xsl:value-of select="./@diconde"/>
            <xsl:text> }</xsl:text>
            <xsl:if test="following-sibling::*">
                <xsl:text>,</xsl:text>
            </xsl:if>  
            <xsl:text>
</xsl:text>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>
</xsl:stylesheet>