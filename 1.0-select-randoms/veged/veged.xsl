<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:ya="urn:yandex-functions"
    xmlns:math="http://exslt.org/math"
    extension-element-prefixes="ya math"
    >

    <xsl:output
        encoding="UTF-8"
        method="xml"
        indent="no"
    />

    <xsl:include href="../common.xsl"/>

    <xsl:template match="/" mode="random">
        <xsl:apply-templates select="items"/>
    </xsl:template>


    <xsl:template match="items">
        <xsl:variable name="n" select="$N"/>
        <xsl:variable name="k" select="$k - 1"/>
        <xsl:variable name="tmp-rnd" select="ceiling(math:random() * $n)"/>
        <xsl:variable name="tmp-dir" select="boolean(round(math:random()))"/>

        <xsl:variable name="n1" select="$n - $tmp-rnd"/>
        <xsl:variable name="n11" select="$n1 - $k"/>
        <xsl:variable name="n2" select="$tmp-rnd - 1"/>
        <xsl:variable name="n22" select="$n2 - $k"/>

        <xsl:variable name="dir" select="($tmp-dir and $n11 &gt; 0) or (not($tmp-dir) and $n22 &gt; 0)"/>
        <xsl:variable name="rnd">
            <xsl:choose>
                <xsl:when test="$dir">
                    <xsl:value-of select="$tmp-rnd + ($n11 * number($n11 &lt; 0))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$tmp-rnd - ($n22 * number($n22 &lt; 0))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:apply-templates select="item[number($rnd)]">
            <xsl:with-param name="n">
                <xsl:choose>
                    <xsl:when test="$dir">
                        <xsl:value-of select="$n - $rnd"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$rnd - 1"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="k" select="$k"/>
            <xsl:with-param name="dir" select="$dir"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="item">
        <xsl:param name="n"/>
        <xsl:param name="k"/>
        <xsl:param name="dir"/>

        <xsl:apply-templates select="." mode="random"/>

        <xsl:if test="$k &gt; 0">
            <xsl:variable name="rnd" select="ceiling(math:random() * floor($n div $k))"/>

            <xsl:choose>
                <xsl:when test="$dir">
                    <xsl:apply-templates select="following-sibling::item[$rnd]">
                        <xsl:with-param name="n" select="$n - $rnd"/>
                        <xsl:with-param name="k" select="$k - 1"/>
                        <xsl:with-param name="dir" select="$dir"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="preceding-sibling::item[$rnd]">
                        <xsl:with-param name="n" select="$n - $rnd"/>
                        <xsl:with-param name="k" select="$k - 1"/>
                        <xsl:with-param name="dir" select="$dir"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
