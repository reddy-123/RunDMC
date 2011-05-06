<!-- This stylesheet renders the pre-generated XML TOC
     into HTML to be cached by browsers.
-->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xs">

  <!-- Optional version-specific prefix for link hrefs, e.g., "/4.2" -->
  <xsl:param name="prefix-for-hrefs"/>

  <xsl:template match="/">
    <div>
      <script type="text/javascript">
      $(function() {
        $("#apidoc_tree").treeview({
          collapsed: true,
  /*        animated: "medium",*/
  /*        control:"#sidetreecontrol",*/
          persist: "cookie"
        });
      })
      </script>

      <!--
      <div>API Reference</div>
      -->
      <ul id="apidoc_tree">
        <xsl:apply-templates select="/toc/node"/>
      </ul>
      <div id="toc_footnote">
        <span class="footnote_marker">*</span>
        <xsl:text> </xsl:text>
        <span class="footnote">Built-in functions (not written in XQuery)</span>
      </div>
    </div>
  </xsl:template>

          <!-- We hide the "all" container so it doesn't appear in the TOC -->
          <xsl:template match="node[@hidden eq 'yes']">
            <xsl:apply-templates select="node"/>
          </xsl:template>

          <xsl:template match="node">
            <li>
              <xsl:apply-templates mode="class-att" select="."/>
              <xsl:apply-templates mode="link"      select="."/>
              <xsl:apply-templates mode="children"  select="."/>
            </li>
          </xsl:template>

                  <xsl:template mode="class-att" match="node"/>
                  <xsl:template mode="class-att" match="node[@initially-expanded]">
                    <xsl:attribute name="class" select="'open'"/>
                  </xsl:template>
                  <!-- re-enable should we need this
                  <xsl:template mode="class-att" match="node[@type eq 'function']">
                    <xsl:attribute name="class" select="'function_name'"/>
                  </xsl:template>
                  -->

                  <xsl:template mode="link" match="node">
                    <span>
                      <xsl:value-of select="@display"/>
                    </span>
                  </xsl:template>

                  <xsl:template mode="link" match="node[@href]">
                    <a href="{$prefix-for-hrefs}{@href}">
                      <xsl:apply-templates mode="title-att" select="."/>
                      <xsl:value-of select="@display"/>
                    </a>
                    <xsl:if test="@footnote">
                      <a href="#toc_footnote" class="footnote_marker" title="Built-in functions">*</a>
                    </xsl:if>
                  </xsl:template>

                          <xsl:template mode="title-att" match="node"/>
                          <xsl:template mode="title-att" match="node[@namespace]">
                            <xsl:attribute name="title" select="@namespace"/>
                          </xsl:template>

                  <xsl:template mode="children" match="node"/>
                  <xsl:template mode="children" match="node[node]">
                    <ul>
                      <xsl:apply-templates select="node"/>
                    </ul>
                  </xsl:template>

</xsl:stylesheet>