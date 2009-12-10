<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:output method="text" indent="yes" encoding="ISO-8859-1"/>
  
  <xsl:template match="*">
    <xsl:apply-templates select="*"/>
  </xsl:template>

  <xsl:template match="//tr">
	  <xsl:text>company_</xsl:text>
	  <xsl:value-of select="position() - 1" />
	  <xsl:text>:&#x0A;</xsl:text>
	  <xsl:text>  id:           </xsl:text>
	  <xsl:value-of select="position() - 1" />
	  <xsl:text>&#x0A;</xsl:text>
    <xsl:apply-templates select="*"/>
  </xsl:template>

  <xsl:template match="//td[position() = 2]">
	  <xsl:text>  name:         "</xsl:text>
	  <xsl:value-of select="." />
	  <xsl:text>"&#x0A;</xsl:text>
	  <xsl:text>  description:  "company description"&#x0A;</xsl:text>
  </xsl:template>

  <xsl:template match="//td[position() = 3]">
	  <xsl:text>  url:          "http://www.</xsl:text>
	  <xsl:value-of select="." />
	  <xsl:text>/"&#x0A;</xsl:text>
	  <xsl:text>  created_at:   &lt;%= Time.now.to_s(:db) %>&#x0A;</xsl:text>
	  <xsl:text>  updated_at:   &lt;%= Time.now.to_s(:db) %>&#x0A;&#x0A;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
