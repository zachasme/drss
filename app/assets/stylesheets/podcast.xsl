<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">

  <xsl:output method="html" version="1.0" encoding="ISO-8859-1" indent="yes" />

  <xsl:template match="channel">
    <html>

      <head>
        <title><xsl:value-of select="title" /></title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link rel="stylesheet" href="/rss.css" />
      </head>

      <body>
        <div id="content">
          <p class="explanation">
            Det her er et podcast RSS feed. Det er meningen at du skal tilføje det til din podcast app.
          </p>

          <header id="channel-header">
            <h1>
              <div id="channel-image">
                <img>
                  <xsl:attribute name="src">
                    <xsl:value-of select="image/url" />
                  </xsl:attribute>
                  <xsl:attribute name="title">
                    <xsl:value-of select="image/title" />
                  </xsl:attribute>
                </img>
              </div>
              <xsl:value-of select="title" />
            </h1>
            <p class="channel-description">
              <xsl:value-of select="description" disable-output-escaping="yes" />
            </p>
          </header>

          <xsl:for-each select="item">
            <article>
              <h2>
                <a>
                  <xsl:attribute name="href">
                    <xsl:value-of select="link" />
                  </xsl:attribute>

                  <xsl:attribute name="target">_blank</xsl:attribute>
                  <xsl:value-of select="title" />
                </a>
              </h2>

              <p class="episode-description">
                  <xsl:value-of select="description" disable-output-escaping="yes" />
              </p>

              <xsl:for-each select="enclosure">
                <audio>
                <xsl:attribute name="src">
                  <xsl:value-of select="@url"/>
                </xsl:attribute>
                <xsl:attribute name="preload">none</xsl:attribute>				
                  <xsl:attribute name="controls"></xsl:attribute>
                </audio>
				      </xsl:for-each>

              <p class="episode_meta">
                <xsl:value-of select="pubDate" />
              </p>
            </article>
          </xsl:for-each>
        </div>
      </body>

    </html>
  </xsl:template>
</xsl:stylesheet>