<xsl:stylesheet version="3.0" 
                xmlns:db="http://docbook.org/ns/docbook" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/TR/xmlschema-2">          
    <xsl:output omit-xml-declaration="yes" method="xml" media-type="application/xml" indent="yes" encoding="utf-8"/>
    <xsl:param name="format" select="'json'"/>

    <xsl:template match="/">        
        <xsl:variable name="part06" as="document-node()" select="."/>

        <xsl:variable name="header-info" as="node()">
            <metadata xsl:exclude-result-prefixes="#all">
                <xsl:apply-templates select="$part06/db:book[@xml:id='PS3.6']/db:subtitle"/>
                <generated><xsl:value-of select="adjust-dateTime-to-timezone(current-dateTime())"/></generated>
            </metadata>
        </xsl:variable>
        
        <xsl:variable name="uid-list" as="node()">
            <uids xsl:exclude-result-prefixes="#all">
                <xsl:apply-templates select="$part06/db:book[@xml:id='PS3.6']/db:chapter[@xml:id='chapter_A']/db:table[@xml:id='table_A-1']/db:tbody" mode="extract-uids"/>
            </uids>
        </xsl:variable>
        
        <xsl:variable name="sorted-uids" as="node()">
            <uidRegistry>
                <xsl:copy-of select="$header-info"/>
                <xsl:apply-templates select="$uid-list" mode="sort"/>
            </uidRegistry>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$format='json'">
                <xsl:text>{</xsl:text>
                <xsl:apply-templates select="$sorted-uids" mode="as-json"/>
                <xsl:text>}</xsl:text>                               
            </xsl:when>
            <xsl:when test="$format='xml'">
                <xsl:copy-of select="$sorted-uids"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">Unrecognized output format: <xsl:value-of select="$format"/>. Supported formats are json, xml.</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Extract UID data from tables -->
    <xsl:template match="db:tbody" mode="extract-uids">
        <xsl:for-each select="db:tr" >
            <uid xsl:exclude-result-prefixes="#all">
                <xsl:attribute name="value"><xsl:value-of select="normalize-space(./db:td[1])"/></xsl:attribute>
                <xsl:attribute name="name"><xsl:value-of select="normalize-space(./db:td[2])"/></xsl:attribute>
                <xsl:attribute name="keyword"><xsl:value-of select="normalize-space(./db:td[3])"/></xsl:attribute>
                <xsl:attribute name="type">
                    <xsl:variable name="uidtype"><xsl:value-of select="normalize-space(./db:td[4])"/></xsl:variable>
                    <xsl:choose>
                        <xsl:when test="contains($uidtype, 'Transfer Syntax')">transferSyntax</xsl:when>
                        <xsl:when test="contains($uidtype, 'Well-known SOP Instance')">sopInstance</xsl:when>
                        <xsl:when test="contains($uidtype, 'Well-known frame of reference')">frameOfReference</xsl:when>
                        <xsl:when test="contains($uidtype, 'SOP Class')">sopClass</xsl:when>
                        <xsl:when test="contains($uidtype, 'Meta SOP Class')">metaSopClass</xsl:when>
                        <xsl:when test="contains($uidtype, 'DICOM UIDs as a Coding Scheme')">dicomScheme</xsl:when>
                        <xsl:when test="contains($uidtype, 'Coding Scheme')">codingScheme</xsl:when>
                        <xsl:when test="contains($uidtype, 'Application Context Name')">appContext</xsl:when>
                        <xsl:when test="contains($uidtype, 'Service Class')">serviceClass</xsl:when>
                        <xsl:when test="contains($uidtype, 'Well-known Printer SOP Instance')">printerSopInstance</xsl:when>
                        <xsl:when test="contains($uidtype, 'Well-known Print Queue SOP Instance')">printerQueueSopInstance</xsl:when>
                        <xsl:when test="contains($uidtype, 'Application Hosting Model')">application Hosting Model</xsl:when>
                        <xsl:when test="contains($uidtype, 'Mapping Resource')">mappingResource</xsl:when>
                        <xsl:when test="contains($uidtype, 'LDAP OID')">ldap</xsl:when>
                        <xsl:when test="contains($uidtype, 'Synchronization Frame of Reference')">syncFrameOfReference</xsl:when>
                        <xsl:otherwise>
                            <xsl:message terminate="yes">Unknown UID type: '<xsl:value-of select="$uidtype"/>'.</xsl:message>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="retired"><xsl:value-of select="exists(./db:td[1]/descendant::db:emphasis)"/></xsl:attribute>
            </uid>
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

    <xsl:template match="uids" mode="sort">
        <xsl:copy>
            <xsl:for-each select="uid">
                <xsl:sort select="@value"/>   
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="uidRegistry" mode="as-json">
        <xsl:for-each select="./*">
            <xsl:apply-templates select="." mode="as-json"/>
        </xsl:for-each>
    </xsl:template>
 
    <xsl:template match="uids" mode="as-json">
        <xsl:text>"uids" : [
</xsl:text>
        <xsl:for-each select="./uid">
            <xsl:text>{ "value" : "</xsl:text>
            <xsl:value-of select="./@value"/>
            <xsl:text>", "name" : "</xsl:text>
            <xsl:value-of select="./@name"/>
            <xsl:text>", "keyword" : "</xsl:text>
            <xsl:value-of select="./@keyword"/>
            <xsl:text>", "type" : "</xsl:text>
            <xsl:value-of select="./@type"/>
            <xsl:text>", "retired" : </xsl:text>
            <xsl:value-of select="./@retired"/>
            <xsl:text> }</xsl:text>
            <xsl:if test="following-sibling::*">
                <xsl:text>,</xsl:text>
            </xsl:if>  
            <xsl:text>
</xsl:text>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
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
</xsl:stylesheet>