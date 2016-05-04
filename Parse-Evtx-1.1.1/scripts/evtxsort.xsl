<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:evtx="http://schemas.microsoft.com/win/2004/08/events/event">
	
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
	<xsl:strip-space elements="*" />
	
	<xsl:template match="Events">
		<xsl:copy>
			<xsl:apply-templates select="evtx:Event">
				<xsl:sort select="evtx:System/evtx:EventRecordID" 
					data-type="number" 
					order="ascending"/>
				</xsl:apply-templates>
			</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
