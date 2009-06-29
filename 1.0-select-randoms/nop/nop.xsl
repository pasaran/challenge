<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:lego="https://lego.yandex-team.ru"
    xmlns:ya="http://www.yandex.ru"
    xmlns:x="http://www.yandex.ru/xscript"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:math="http://exslt.org/math"
    xmlns:str="http://exslt.org/strings"
    xmlns:exsl="http://exslt.org/common"
    xmlns:dyn="http://exslt.org/dynamic"
    xmlns:crypto="http://exslt.org/crypto"
    xmlns:func="http://exslt.org/functions"
    xmlns:saxon="http://icl.com/saxon"
    exclude-result-prefixes=" lego ya x date math str exsl dyn crypto func saxon "
    extension-element-prefixes=" func "
    >

<xsl:include href="../common.xsl"/>

<xsl:variable name="p" select="($k * 1.05) div $N"/>

<xsl:template match="/" mode="random">
    <xsl:choose>

        <!-- Когда k маленькое, просто выбираем случайные, пока не наберем k разных -->
        <xsl:when test="$k &lt;= 10">
            <xsl:call-template name="random-set"/>
        </xsl:when>

        <!-- Когда N большое, надеемся на удачу -->
        <xsl:when test="$N &gt; 1000">
            <xsl:for-each select="items/item[math:random() &lt;= $p]">
                <xsl:if test="position() &lt;= $k">
                    <xsl:apply-templates select="." mode="random"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:when>

        <!-- Первый вариант тормозит, второй часто не дает нужное количество элементов, поэтому заляпа -->
        <xsl:otherwise>
            <xsl:for-each select="items/item">
                <xsl:sort select="math:random()" data-type="number"/>
                <xsl:if test="position() &lt;= $k">
                    <xsl:apply-templates select="." mode="random"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="random-set">
<xsl:param name="result" select="/.."/>
    <xsl:choose>
        <xsl:when test="count($result) &lt; $k">
            <xsl:call-template name="random-set">
                <xsl:with-param name="result" select="$result | dyn:evaluate(concat('/items/item[', floor(math:random() * $N) + 1, ']'))"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates select="$result" mode="random"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>

