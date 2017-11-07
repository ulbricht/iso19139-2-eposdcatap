<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:date="http://exslt.org/dates-and-times" xmlns:xs="http://www.w3.org/2001/XMLSchema"

	xmlns:eposap="http://www.epos-ip.org/terms.html" xmlns:adms="http://www.w3.org/ns/adms#"
	xmlns:dct="http://purl.org/dc/terms/" xmlns:dcat="http://www.w3.org/ns/dcat#"
	xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:skos="http://www.w3.org/2004/02/skos/core#"
	xmlns:spdx="http://spdx.org/rdf/terms#" xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
	xmlns:locn="http://www.w3.org/ns/locn#" xmlns:schema="http://schema.org/"
    xmlns:cnt="http://www.w3.org/2008/content#" xmlns:http="http://www.w3.org/2006/http#"
    xmlns:srv="http://www.isotc211.org/2005/srv"
        >

	<xsl:output method="xml" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>

<xsl:template match="/">

    <eposap:Epos>

        <xsl:for-each select="//gmd:MD_Metadata">
      		<xsl:call-template name="datasetrecords" select="."/>
        </xsl:for-each>

	<xsl:for-each  select="//gmd:CI_ResponsibleParty[descendant::gmd:individualName]">
		<xsl:call-template name="individuals" select="."/>
	</xsl:for-each> 

	<xsl:for-each  select="//gmd:CI_ResponsibleParty[descendant::gmd:organisationName]">
		<xsl:call-template name="organizations" select="."/>
	</xsl:for-each> 

	<xsl:for-each  select="//gmd:MD_Metadata">
		<xsl:call-template name="webservices" select="."/>
	</xsl:for-each> 

    </eposap:Epos>



</xsl:template>

<xsl:template name="individuals" match="//gmd:CI_ResponsibleParty[descendant::gmd:individualName]">
<xsl:variable name="persid">
	<xsl:choose>
		<xsl:when test="normalize-space(.//gmd:individualName/gmx:Anchor/@xlink:href)!=''">
			<xsl:value-of select=".//gmd:individualName/gmx:Anchor/@xlink:href"/>
		<xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="generate-id(.//gmd:individualName)"/>
		</xsl:otherwise>
	</xsl:choose>
<xsl:variable>
    <eposap:Person>
    <vcard:fn><xsl:value-of select="normalize-space(.//gmd:individualName)"/></vcard:fn>
	<vcard:hasAddress>
		<vcard:Address>
			<vcard:street-address><xsl:value-of select="normalize-space(.//gmd:deliveryPoint)"/></vcard:street-address>
			<vcard:locality><xsl:value-of select="normalize-space(.//gmd:city)"/></vcard:locality>
			<vcard:postal-code><xsl:value-of select="normalize-space(.//gmd:postalCode)"/></vcard:postal-code>
			<vcard:country-name><xsl:value-of select="normalize-space(.//gmd:country)"/></vcard:country-name>
		</vcard:Address>
	</vcard:hasAddress>
    <vcard:hasEmail><xsl:value-of select="normalize-space(.//gmd:electronicMailAddress)"/></vcard:hasEmail>
    <vcard:hasTelephone><xsl:value-of select="normalize-space(.//gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice)"/></vcard:hasTelephone>
    <dct:identifier><xsl:value-of select="$persid"/></dct:identifier>
	<eposap:affiliation>	
		<xsl:choose>
			<xsl:when test="normalize-space(.//gmd:organisationName/gmx:Anchor/@xlink:href)!=''">
				<xsl:value-of select=".//gmd:organisationName/gmx:Anchor/@xlink:href"/>
			<xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="generate-id(.//gmd:organisationName)"/>
			</xsl:otherwise>
		</xsl:choose>
	</eposap:affiliation>
    <vcard:hasURL><xsl:value-of select="normalize-space(.//gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL)"/></vcard:hasURL>
    </eposap:Person>
</xsl:template>

<xsl:template name="organizations" match="//gmd:CI_ResponsibleParty[descendant::gmd:organisationName]">

<xsl:variable name="orgid">
	<xsl:choose>
		<xsl:when test="normalize-space(.//gmd:organisationName/gmx:Anchor/@xlink:href)!=''">
			<xsl:value-of select=".//gmd:organisationName/gmx:Anchor/@xlink:href"/>
		<xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="generate-id(.//gmd:organisationName)"/>
		</xsl:otherwise>
	</xsl:choose>
<xsl:variable>

    <eposap:Organisation>
    <vcard:fn><xsl:value-of select="normalize-space(.//gmd:organisationName)"/></vcard:fn>
    <dct:identifier><xsl:value-of select="$orgid"/></dct:identifier>
	<vcard:hasAddress><!-- Postal Address -->
		<vcard:Address>
			<vcard:street-address><xsl:value-of select="normalize-space(.//gmd:deliveryPoint)"/></vcard:street-address>
			<vcard:locality><xsl:value-of select="normalize-space(.//gmd:city)"/></vcard:locality>
			<vcard:postal-code><xsl:value-of select="normalize-space(.//gmd:postalCode)"/></vcard:postal-code>
			<vcard:country-name><xsl:value-of select="normalize-space(.//gmd:country)"/></vcard:country-name>
		</vcard:Address>
	</vcard:hasAddress>

<!--
	<dct:type>
		Organisation Type
	</dct:type>
	<eposap:legalContact>personID01</eposap:legalContact>
<eposap:financialContact>personID01</eposap:financialContact>

-->
    </eposap:Organisation>

</xsl:template>

<xsl:template name="webservices" match="//MD_Metadata">
  <xsl:if test=".//gmd:MD_ScopeCode[@codeListValue='service']">

        <eposap:WebService>
            <dct:title><xsl:value-of select=".//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString"/></dct:title>
            <dct:description><xsl:value-of select=".//gmd:identificationInfo//gmd:abstract/gco:CharacterString"/></dct:description>

            <dct:issued>
                <xsl:choose>
                    <xsl:when test="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:Date)!=''">
                        <xsl:value-of select="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:Date)"/>
                    </xsl:when>
                    <xsl:when test="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:DateTime)!=''">
                        <xsl:value-of select="substring-before(normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:DateTime),'T')"/>
                    </xsl:when>
                </xsl:choose>
            </dct:issued>

            <dct:modified>
                <xsl:choose>
                    <xsl:when test="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:Date)!=''">
                        <xsl:value-of select="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:Date)"/>
                    </xsl:when>
                    <xsl:when test="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:DateTime)!=''">
                        <xsl:value-of select="substring-before(normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:DateTime),'T')"/>
                    </xsl:when>
                </xsl:choose>
            </dct:modified>


            <xsl:for-each select=".//gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useLimitation/gco:CharacterString">
            <dct:license><xsl:value-of select="."/></dct:license>
            </xsl:for-each>

            <xsl:for-each select=".//gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString">
            <dct:license><xsl:value-of select="."/></dct:license>
            </xsl:for-each>

            <foaf:page><foaf:primaryTopic><xsl:value-of select=".//gmd:distributionInfo//gmd:transferOptions//gmd:URL"/></foaf:primaryTopic></foaf:page>

            <xsl:for-each select=".//gmd:distributionInfo//gmd:distributionFormat">
            <dct:format><dct:MediaTypeOrExtent><xsl:value-of select=".//gmd:name/gco:CharacterString"/><xsl:text> </xsl:text><xsl:value-of select=".//gmd:version/gco:CharacterString"/></dct:MediaTypeOrExtent></dct:format>
            </xsl:for-each>

            <xsl:for-each select=".//gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode/@codeListValue">
            <dct:rights><dct:RightsStatement><xsl:value-of select="."/></dct:RightsStatement></dct:rights>
            </xsl:for-each>


            <xsl:for-each select="./gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier">
                <dct:conformsTo><xsl:value-of select="./gmd:codeSpace/gco:CharacterString"/>:<xsl:value-of select="./gmd:version/gco:CharacterString"/>:<xsl:value-of select="./gmd:code/gco:CharacterString"/></dct:conformsTo>
            </xsl:for-each>

            <dct:identifier><xsl:value-of select="generate-id(.)"/></dct:identifier>

            <dct:created>
                <xsl:choose>
                    <xsl:when test="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:Date)!=''">
                        <xsl:value-of select="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:Date)"/>
                    </xsl:when>
                    <xsl:when test="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:DateTime)!=''">
                        <xsl:value-of select="substring-before(normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:DateTime),'T')"/>
                    </xsl:when>
                </xsl:choose>
            </dct:created>



<!--   Domain and subdomain could be special keywords?? -->
            <domain>Geology</domain>
            <subDomain>Geology</subDomain>

            <xsl:if test="normalize-space(.//gmd:keyword/gco:CharacterString)!=''">
		    <dcat:keyword>
			    <xsl:for-each select=".//gmd:keyword/gco:CharacterString">
				<xsl:if test="normalize-space(.)!=''">
				    <xsl:if test="position()>1">
				        <xsl:text>, </xsl:text>
				    </xsl:if>
				    <xsl:value-of select="."/>
				</xsl:if>
			    </xsl:for-each>
		    </dcat:keyword>
            </xsl:if>

            <eposap:operation><xsl:value-of select="normalize-space(.//srv:serviceType/gco:LocalName)"/></eposap:operation>

            <dct:hasVersion><xsl:value-of select="normalize-space(.//srv:serviceTypeVersion/gco:CharacterString)"/></dct:hasVersion>


            <xsl:variable name="wms">
                <xsl:if test="contains(.//gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL,'service=WMS') or contains(.//gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL,'service=wms') or contains(.//gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString,'OGC:WMS')">WMS</xsl:if>
             </xsl:variable>

            <xsl:variable name="wfs">
                <xsl:if test="contains(.//gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL,'service=WFS') or contains(.//gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL,'service=wfs') or contains(.//gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString,'OGC:WFS')">WFS</xsl:if>
             </xsl:variable>


            <xsl:if test="$wfs!='' or $wms!=''">
			    <eposap:parameter>
                    <http:paramName>service</http:paramName>
                    <rdf:label>Service</rdf:label>
                    <dct:type>string</dct:type>
                    <http:paramValue><xsl:value-of select="$wms"/><xsl:if test="$wms!='' and $wfs!=''">,</xsl:if><xsl:value-of select="$wfs"/></http:paramValue>
			    </eposap:parameter>
            </xsl:if>


<!--
			<xs:element name="parameter" minOccurs="0" maxOccurs="unbounded">
				<xs:complexType>
					<xs:sequence>
						<xs:element ref="http:paramName" minOccurs="1" maxOccurs="1" />
						<xs:element ref="rdf:label" minOccurs="1" maxOccurs="1" />
						<xs:element ref="dct:type" minOccurs="1" maxOccurs="1" /> 
						<xs:element ref="http:paramValue" minOccurs="0" maxOccurs="unbounded" />		
						<xs:element ref="schema:minValue" minOccurs="0" maxOccurs="1" />	
						<xs:element ref="schema:maxValue" minOccurs="0" maxOccurs="1" />								
						<xs:element ref="owl:versionInfo" minOccurs="0" maxOccurs="1" />
					</xs:sequence>
				</xs:complexType>
			</xs:element>
			<xs:element ref="schema:documentation" minOccurs="0" maxOccurs="unbounded" />
			<xs:element ref="dcat:contactPoint" minOccurs="1" maxOccurs="unbounded" />
			<xs:element ref="eposap:publisher" minOccurs="1" maxOccurs="1" />
-->			
	   <xsl:for-each select=".//gmd:CI_ResponsibleParty[descendant::gmd:individualName]">
		<dcat:contactPoint>
			<xsl:choose>
				<xsl:when test="normalize-space(.//gmd:individualName/gmx:Anchor/@xlink:href)!=''">
					<xsl:value-of select=".//gmd:individualName/gmx:Anchor/@xlink:href"/>
				<xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="generate-id(.//gmd:individualName)"/>
				</xsl:otherwise>
			</xsl:choose>
		</dcat:contactPoint>
	   </xsl:for-each>

	   <xsl:for-each select=".//gmd:CI_ResponsibleParty[descendant::gmd:organisationName]">
		<eposap:publisher>
			<xsl:choose>
				<xsl:when test="normalize-space(.//gmd:organisationName/gmx:Anchor/@xlink:href)!=''">
					<xsl:value-of select=".//gmd:organisationName/gmx:Anchor/@xlink:href"/>
				<xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="generate-id(.//gmd:organisationName)"/>
				</xsl:otherwise>
			</xsl:choose>
		</eposap:publisher>
	   </xsl:for-each>

<!-- 
http://resource.europe-geology.eu/service/wmsBorehole?service=WMS&amp;version=1.3.0&amp;request=GetCapabilities
-->


<!--
-1.3.0-http-get-capabilities
-->



            <xsl:variable name="minlat" select="//gmd:southBoundLatitude/gco:Decimal"/>
            <xsl:variable name="maxlat" select="//gmd:northBoundLatitude/gco:Decimal"/>
            <xsl:variable name="minlon" select="//gmd:westBoundLongitude/gco:Decimal"/>
            <xsl:variable name="maxlon" select="//gmd:eastBoundLongitude/gco:Decimal"/>

            <dct:spatial><dct:Location><locn:geometry><xsl:text>POLYGON(</xsl:text>
            <xsl:value-of select="$minlon"/><xsl:text> </xsl:text><xsl:value-of select="$minlat"/><xsl:text>, </xsl:text>
            <xsl:value-of select="$maxlon"/><xsl:text> </xsl:text><xsl:value-of select="$minlat"/><xsl:text>, </xsl:text>
            <xsl:value-of select="$maxlon"/><xsl:text> </xsl:text><xsl:value-of select="$maxlat"/><xsl:text>, </xsl:text>
            <xsl:value-of select="$minlon"/><xsl:text> </xsl:text><xsl:value-of select="$maxlat"/><xsl:text>, </xsl:text>
            <xsl:value-of select="$minlon"/><xsl:text> </xsl:text><xsl:value-of select="$minlat"/><xsl:text>)</xsl:text></locn:geometry></dct:Location></dct:spatial>
<!--
valid for datasets?
-->
<!--
            <adms:representationTechnique><xsl:value-of select=".//gmd:MD_SpatialRepresentationTypeCode/@codeListValue"/></adms:representationTechnique>
-->
<!--
http://resource.europe-geology.eu/service/wfsBorehole?service=wfs&amp;version=2.0.0&amp;request=GetCapabilities
-->

        <xsl:for-each select=".//gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod">
		<dct:temporal> 
			<dct:PeriodOfTime>
				<schema:startDate><xsl:value-of select=".//gml:beginPosition"/></schema:startDate>
				<schema:endDate><xsl:value-of select=".//gml:endPosition"/></schema:endDate>
			</dct:PeriodOfTime>
        </dct:temporal>
        </xsl:for-each>

        </eposap:WebService>

        </xsl:if>

</xsl:template>

<xsl:template name="datasetrecords" match="//MD_Metadata">

   <xsl:if test=".//gmd:MD_ScopeCode[@codeListValue='dataset']">


	<eposap:Catalog>
		<dct:title><xsl:value-of select=".//gmd:hierarchyLevelName/gco:CharacterString"/>g</dct:title>
		<dct:description></dct:description>
		   <xsl:for-each select=".//gmd:CI_ResponsibleParty[descendant::gmd:organisationName]">
			<dct:publisher><foaf:name><xsl:value-of select=".//gmd:organisationName"/></foaf:name></dct:publisher>
		   </xsl:for-each>

		<xsl:call-template name="dataset" select="."/>

		<!-- Attribute specific to the metadata -->
		<eposap:CatalogRecord><!-- ATTRIBUTE SPECIFIC TO METADATA -->
			<foaf:primaryTopic><xsl:value-of select=".//gmd:topicCategory/gmd:MD_TopicCategoryCode"/></foaf:primaryTopic> <!-- Topic -->
			<dct:modified><xsl:value-of select="normalize-space(.//gmd:dateStamp)"/></dct:modified> <!-- Updated -->
			<dct:language><!-- Language.  Two-letters encoding (e.g. en). -->
				<dct:LinguisticSystem><xsl:value-of select="./gmd:language/gmd:LanguageCode/@codeListValue"/></dct:LinguisticSystem>
			</dct:language>
			<dct:title><xsl:value-of select=".//gmd:metadataStandardName/gco:CharacterString"/></dct:title><!-- Standard Name -->
			<dct:identifier><xsl:value-of select=".//gmd:fileIdentifier/gco:CharacterString"/></dct:identifier><!-- File identifier -->
			<owl:versionInfo><xsl:value-of select=".//gmd:metadataStandardVersion/gco:CharacterString"/></owl:versionInfo><!-- Standard Version -->
			<cnt:characterEncoding><xsl:value-of select="./gmd:characterSet/gmd:MD_CharacterSetCode/@codeListValue"/></cnt:characterEncoding><!-- Characterset -->

			   <xsl:for-each select=".//gmd:CI_ResponsibleParty[descendant::gmd:individualName]">
				<dcat:contactPoint>
					<xsl:choose>
						<xsl:when test="normalize-space(.//gmd:individualName/gmx:Anchor/@xlink:href)!=''">
							<xsl:value-of select=".//gmd:individualName/gmx:Anchor/@xlink:href"/>
						<xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="generate-id(.//gmd:individualName)"/>
						</xsl:otherwise>
					</xsl:choose>
				</dcat:contactPoint>
			   </xsl:for-each>
			<dct:created><xsl:value-of select="normalize-space(.//gmd:dateStamp)"/></dct:created> <!-- Created -->
		</eposap:CatalogRecord>
	</eposap:Catalog>

  </xsl:if>

</xsl:template>

<xsl:template name="dataset" match="//MD_Metadata">
      <eposap:Dataset>

            <dct:identifier><xsl:value-of select="generate-id(.)"/></dct:identifier>

            <dct:title><xsl:value-of select=".//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString"/></dct:title>
            <dct:description><xsl:value-of select=".//gmd:identificationInfo//gmd:abstract/gco:CharacterString"/></dct:description>

            <dct:issued>
                <xsl:choose>
                    <xsl:when test="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:Date)!=''">
                        <xsl:value-of select="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:Date)"/>
                    </xsl:when>
                    <xsl:when test="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:DateTime)!=''">
                        <xsl:value-of select="substring-before(normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:DateTime),'T')"/>
                    </xsl:when>
                </xsl:choose>
            </dct:issued>

            <dct:modified>
                <xsl:choose>
                    <xsl:when test="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:Date)!=''">
                        <xsl:value-of select="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:Date)"/>
                    </xsl:when>
                    <xsl:when test="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:DateTime)!=''">
                        <xsl:value-of select="substring-before(normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:DateTime),'T')"/>
                    </xsl:when>
                </xsl:choose>
            </dct:modified>


		<dct:language><!-- Language.  Two-letters encoding (e.g. en). -->
			<dct:LinguisticSystem><xsl:value-of select=".//gmd:identificationInfo//gmd:language/gmd:LanguageCode/@codeListValue"/></dct:LinguisticSystem>
		</dct:language>
		<dct:provenance><!-- Lineage -->
				<dct:ProvenanceStatement><xsl:value-of select=".//gmd:lineage//gmd:statement/gcoCharacterString"/></dct:ProvenanceStatement>
		</dct:provenance>

		<dct:type><xsl:value-of select=".//gmd:MD_ScopeCode/@codeListValue"/></dct:type>

            <xsl:if test="normalize-space(.//gmd:keyword/gco:CharacterString)!=''">
		    <dcat:keyword>
			    <xsl:for-each select=".//gmd:keyword/gco:CharacterString">
				<xsl:if test="normalize-space(.)!=''">
				    <xsl:if test="position()>1">
				        <xsl:text>, </xsl:text>
				    </xsl:if>
				    <xsl:value-of select="."/>
				</xsl:if>
			    </xsl:for-each>
		    </dcat:keyword>
            </xsl:if>


            <xsl:for-each select=".//gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode/@codeListValue">
            <dct:rights><dct:RightsStatement><xsl:value-of select="."/></dct:RightsStatement></dct:rights>
            </xsl:for-each>

            <xsl:for-each select="./gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier">
                <dct:conformsTo><xsl:value-of select="./gmd:codeSpace/gco:CharacterString"/>:<xsl:value-of select="./gmd:version/gco:CharacterString"/>:<xsl:value-of select="./gmd:code/gco:CharacterString"/></dct:conformsTo>
            </xsl:for-each>

            <dcat:landingPage><foaf:primaryTopic><xsl:value-of select=".//gmd:distributionInfo//gmd:transferOptions//gmd:URL"/></foaf:primaryTopic></dcat:landingPage>


            <xsl:variable name="minlat" select="//gmd:southBoundLatitude/gco:Decimal"/>
            <xsl:variable name="maxlat" select="//gmd:northBoundLatitude/gco:Decimal"/>
            <xsl:variable name="minlon" select="//gmd:westBoundLongitude/gco:Decimal"/>
            <xsl:variable name="maxlon" select="//gmd:eastBoundLongitude/gco:Decimal"/>

            <dct:spatial><dct:Location><locn:geometry><xsl:text>POLYGON(</xsl:text>
            <xsl:value-of select="$minlon"/><xsl:text> </xsl:text><xsl:value-of select="$minlat"/><xsl:text>, </xsl:text>
            <xsl:value-of select="$maxlon"/><xsl:text> </xsl:text><xsl:value-of select="$minlat"/><xsl:text>, </xsl:text>
            <xsl:value-of select="$maxlon"/><xsl:text> </xsl:text><xsl:value-of select="$maxlat"/><xsl:text>, </xsl:text>
            <xsl:value-of select="$minlon"/><xsl:text> </xsl:text><xsl:value-of select="$maxlat"/><xsl:text>, </xsl:text>
            <xsl:value-of select="$minlon"/><xsl:text> </xsl:text><xsl:value-of select="$minlat"/><xsl:text>)</xsl:text></locn:geometry></dct:Location></dct:spatial>


	    <xsl:for-each select=".//gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod">
		<dct:temporal> 
			<dct:PeriodOfTime>
				<schema:startDate><xsl:value-of select=".//gml:beginPosition"/></schema:startDate>
				<schema:endDate><xsl:value-of select=".//gml:endPosition"/></schema:endDate>
			</dct:PeriodOfTime>
	   </dct:temporal>
	   </xsl:for-each>


		<eposap:distribution>
				<dcat:Distribution>
					<dct:title><xsl:value-of select=".//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString"/></dct:title>
					<dct:description><xsl:value-of select=".//gmd:identificationInfo//gmd:abstract/gco:CharacterString"/></dct:description>
					<dcat:accessURL/>
					<dcat:downloadURL><xsl:value-of select=".//gmd:distributionInfo//gmd:transferOptions//gmd:URL"/></dcat:downloadURL>
				    <dct:issued>
					<xsl:choose>
					    <xsl:when test="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:Date)!=''">
						<xsl:value-of select="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:Date)"/>
					    </xsl:when>
					    <xsl:when test="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:DateTime)!=''">
						<xsl:value-of select="substring-before(normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:DateTime),'T')"/>
					    </xsl:when>
					</xsl:choose>
				    </dct:issued>

				    <dct:modified>
					<xsl:choose>
					    <xsl:when test="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:Date)!=''">
						<xsl:value-of select="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:Date)"/>
					    </xsl:when>
					    <xsl:when test="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:DateTime)!=''">
						<xsl:value-of select="substring-before(normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:DateTime),'T')"/>
					    </xsl:when>
					</xsl:choose>
				    </dct:modified>

					    <xsl:for-each select=".//gmd:distributionInfo//gmd:distributionFormat">
					    <dct:format><dct:MediaTypeOrExtent><xsl:value-of select=".//gmd:name/gco:CharacterString"/><xsl:text> </xsl:text><xsl:value-of select=".//gmd:version/gco:CharacterString"/></dct:MediaTypeOrExtent></dct:format>
					    </xsl:for-each>
					    <xsl:for-each select=".//gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useLimitation/gco:CharacterString">
					    <dct:license><xsl:value-of select="."/></dct:license>
					    </xsl:for-each>

					    <xsl:for-each select=".//gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString">
					    <dct:license><xsl:value-of select="."/></dct:license>
					    </xsl:for-each>

				</dcat:Distribution>
		</eposap:distribution>



            <domain>Geology</domain>
            <subDomain>Geology</subDomain>


           <dct:created>
                <xsl:choose>
                    <xsl:when test="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:Date)!=''">
                        <xsl:value-of select="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:Date)"/>
                    </xsl:when>
                    <xsl:when test="normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:DateTime)!=''">
                        <xsl:value-of select="substring-before(normalize-space(.//gmd:identificationInfo//gmd:citation/gmd:CI_Citation/gmd:date//gco:DateTime),'T')"/>
                    </xsl:when>
                </xsl:choose>
            </dct:created>

<!--   Domain and subdomain could be special keywords?? -->

	    <dct:subject><xsl:value-of select=".//gmd:topicCategory/gmd:MD_TopicCategoryCode"/></dct:subject>


	   <cnt:characterEncoding><xsl:value-of select=".//gmd:identificationInfo//gmd:characterSet/gmd:MD_CharacterSetCode/@codeListValue"/></cnt:characterEncoding><!-- Characterset -->

	   <xsl:for-each select=".//gmd:CI_ResponsibleParty[descendant::gmd:individualName]">
		<dcat:contactPoint>
			<xsl:choose>
				<xsl:when test="normalize-space(.//gmd:individualName/gmx:Anchor/@xlink:href)!=''">
					<xsl:value-of select=".//gmd:individualName/gmx:Anchor/@xlink:href"/>
				<xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="generate-id(.//gmd:individualName)"/>
				</xsl:otherwise>
			</xsl:choose>
		</dcat:contactPoint>
	   </xsl:for-each>

	   <xsl:for-each select=".//gmd:CI_ResponsibleParty[descendant::gmd:organisationName]">
		<eposap:responsibleParty>
			<xsl:choose>
				<xsl:when test="normalize-space(.//gmd:organisationName/gmx:Anchor/@xlink:href)!=''">
					<xsl:value-of select=".//gmd:organisationName/gmx:Anchor/@xlink:href"/>
				<xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="generate-id(.//gmd:organisationName)"/>
				</xsl:otherwise>
			</xsl:choose>
		</eposap:responsibleParty>
	   </xsl:for-each>


	  <rdf:comment>1:<xsl:value-of select=".//gmd:spatialResolution//gmd:equivalentScale//gmd:denominator/gco:Integer"/></rdf:comment><!-- Spatial Resolution -->
        
          <adms:representationTechnique><xsl:value-of select=".//gmd:MD_SpatialRepresentationTypeCode/@codeListValue"/></adms:representationTechnique>


<!---<eposap:providedBy>COUPLED RESOURCEe</eposap:providedBy>-->

        </eposap:Dataset>

</xsl:template>

</xsl:stylesheet>

