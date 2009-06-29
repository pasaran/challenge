<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:str="http://exslt.org/strings"
    exclude-result-prefixes=" str "
    >

<xsl:param name="k"/>
<xsl:param name="N"/>
<xsl:param name="repeat" select="1"/>

<xsl:variable name="iterator" select="str:tokenize(str:padding($repeat, '*'), '')"/>

<xsl:variable name="root" select="/"/>

<xsl:template match="/">
    <xsl:for-each select="$iterator">
        <xsl:apply-templates select="$root" mode="random"/>
    </xsl:for-each>
</xsl:template>

<!-- Для замеров скорости отключаем весь вывод, чтобы считать только выбор случайных нод -->
<xsl:template match="/items/item" mode="random"/>

<!-- Для отладки можно раскомментировать этот шаблон -->
<!--
<xsl:template match="/items/item" mode="random">
    <xsl:copy-of select="."/>
</xsl:template>
-->

</xsl:stylesheet>

