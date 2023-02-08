<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Gc2Csv.xsl 5236 2012-05-12 09:29:59Z arjan $ 
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/">
	<!-- 
		Transform a GC file to CSV file. 
		Each value is quoted.
		No comma for last column.
		When quote occurs in value, escaped as double quote.
	-->
	<!--	<xsl:output method="text" encoding="UTF-8"/>  vervangen door onderdstaande voor goede speciale karakters
-->
	<xsl:output method="text" encoding="UTF-8" byte-order-mark="yes"/>
	<xsl:variable name="dq" select="'&quot;'"/>
	<xsl:variable name="crlf" select="'&#13;&#10;'"/>
	<!-- Ids of columns to record in CSV -->
	<xsl:variable name="column-ids" select="/gc:CodeList/ColumnSet/Column/@Id"/>
	<xsl:template match="/">
		<xsl:apply-templates select="gc:CodeList/ColumnSet"/>
		<xsl:apply-templates select="gc:CodeList/SimpleCodeList/Row"/>
	</xsl:template>
	<!-- for header line -->
	<xsl:template match="ColumnSet">
		<xsl:for-each select="Column">
			<xsl:value-of select="concat($dq,ShortName,$dq)"/>
			<xsl:value-of select="if (position() = last()) then $crlf else ','"/>
		</xsl:for-each>
	</xsl:template>
	<!-- for each value-list line -->
	<xsl:template match="SimpleCodeList/Row">
		<xsl:variable name="row" select="."/>
		<xsl:for-each select="$column-ids">
			<xsl:variable name="v" select="$row/Value[@ColumnRef=current()]/SimpleValue"/>
			<xsl:variable name="sv" select="replace($v,$dq,concat($dq,$dq))"/>
			<xsl:value-of select="if ($sv) then concat($dq,$sv,$dq) else ''"/>
			<xsl:value-of select="if (position() = last()) then $crlf else ','"/>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
