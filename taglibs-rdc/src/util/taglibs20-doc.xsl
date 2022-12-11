<?xml version="1.0" encoding="ISO-8859-1"?>
<!--$Id$-->
<!--Description:
Cloning taglib-doc.xsl to process jsp20 tag-file and additional  constructs.-->
<!--
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
-->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
  <xsl:param name="generationtarget"/>
  <xsl:output method="xml"
              encoding="ISO-8859-1"
              indent="yes" 
              omit-xml-declaration="no"/>
  <!--
      This XSL is used to transform Tag library Documentation XML files into
      HTML documents formatted for the Jakarta Taglibs Web site.
      
      The Tag Library Documentation file(s) are standalone XML documents based
      on the Tag Library Descriptor format (i.e., they have no DTD or DOCTYPE 
      declaration).
      
      The TLD forms the basis for the Documentation, much of it used here as the
      a natural base for the HTML documentation.  Added to it are arbitrary, but 
      conventional (the conventions determined by the Jakarta Taglibs project 
      for the time being), XML elements used to provide information extraneous to 
      the TLD proper.  For example, info elements are added for tag attributes 
      (a request has been made to the JSP expert group to add such an element to 
      the TLD proper), and example elements are added for usage examples.
      
      Scott Stirling
      sstirling@mediaone.net
      1/1/2001  
  -->

  <!--
      How some of the non-obvious TLD==>HTML mappings are used here:

HTML <title> : TLD <taglib><info></info></taglib>
HTML page title <h1>: TLD <taglib><info></info></taglib>

- Sometimes the <short-name> value of the TLD is used as the taglib name or 
the prefix for various minutiae, other times the <info> line is used.  
Depends on the context, as you can see below.
  -->
  <xsl:template match="/">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="/document">
    <xsl:choose>
      <xsl:when test="$generationtarget = 'xdoc'">
        <document>
          <xsl:apply-templates />
        </document>
      </xsl:when>
      <xsl:otherwise>
        <html>
          <xsl:apply-templates />
        </html>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:variable name="banner-bg" select="'#023264'"/>
  <xsl:variable name="banner-fg" select="'#ffffff'"/>
  
  <xsl:template match="/document/properties">
    <xsl:choose>
      <xsl:when test="$generationtarget = 'xdoc'">
        <xsl:copy>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <head>
          <meta content="{author}" name="author"/>
          <xsl:choose>
            <xsl:when test="title">
              <title><xsl:value-of select="title"/></title>
            </xsl:when>
            <xsl:otherwise>
              <title>
                Jakarta-Taglibs:
                <xsl:value-of select="/document/taglib/display-name"/>
              </title>
            </xsl:otherwise>
          </xsl:choose>
        </head>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="/document/taglib">
    <body bgcolor="white">
      <center>
        <h1>Jakarta Project: <xsl:value-of select="display-name"/></h1>
        <h3>Version: <xsl:value-of select="tlib-version"/></h3>
      </center>

      <!-- Table of Contents -->
      <h3>Table of Contents</h3>
      <ul>
        <li><a href="#overview">Overview</a></li>
        <li><a href="#requirements">Requirements</a></li>
        <li><a href="#config">Configuration</a></li>
        <xsl:call-template name="doctoc"/>
        <li><a href="#summary">Tag Summary</a></li>
        <li><a href="#reference">Tag Reference</a></li>
        <!-- Additional TOC sections, the toc element is undocumented -->
        <xsl:for-each select="toc">
          <li>
            <a>
              <xsl:attribute name="href">#<xsl:value-of select="@href"/>
              </xsl:attribute><xsl:value-of select="@name"/>
            </a>
          </li>
        </xsl:for-each>
        <!-- End Additional TOC sections -->
        <li><a href="#examples">Examples</a></li>
        <xsl:if test="$generationtarget = 'xdoc'">
          <li><a href="#javadocs">Javadocs</a></li>
          <li><a href="#history">Revision History</a></li>
        </xsl:if>
        <xsl:if test="developers-notes">
          <li><a href="#developers-notes">Developers' Notes</a></li>
        </xsl:if>
      </ul>    

      <!-- Overview -->
      <a><xsl:attribute name="name">overview</xsl:attribute></a>
      <h3>Overview</h3>
      <xsl:apply-templates select="description"/>
      
      <!-- Requirements -->
      <a><xsl:attribute name="name">requirements</xsl:attribute></a>
      <h3>Requirements</h3>
      <xsl:apply-templates select="requirements-info"/>

      <!-- Configuration -->
      <xsl:call-template name="configuration"/>

      <!-- Documentation -->
      <xsl:call-template name="documentation"/>

      <!--  Tag Summary Section  -->
      <a><xsl:attribute name="name">summary</xsl:attribute></a>
      <h3>Tag Summary</h3>
      <xsl:for-each select="tagtoc">
        <b><xsl:value-of select="@name"/></b>
        <table border="0" width="90%" cellpadding="3" cellspacing="3">
          <xsl:for-each select="tag|tag-file">
            <tr>
              <td width="25%" valign="top">
                <a>
                  <xsl:attribute name="href">#<xsl:value-of select="name"/>
                  </xsl:attribute><xsl:value-of select="name"/>
                </a>
              </td>
              <td width="75%">
                <xsl:choose>
                  <xsl:when test="description">
                    <xsl:value-of select="description"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <strong>Please add a description.</strong>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
            </tr> 
          </xsl:for-each>
          <!-- The next empty row is for formatting purposes only. -->
          <tr>
            <td colspan="2"><xsl:text>&#160;</xsl:text></td>
          </tr>
        </table>
      </xsl:for-each>

      <!-- Tag Reference Section -->
      <a><xsl:attribute name="name">reference</xsl:attribute></a>
      <h3>Tag Reference</h3>
      <xsl:for-each select="tagtoc">
        <!-- Start for-each to process <tag> elements here -->
        <xsl:apply-templates select="tag"/>
        <xsl:apply-templates select="tag-file"/>
      </xsl:for-each>
      
      <!-- Additional TOC sections -->
      <xsl:for-each select="toc">
        <a><xsl:attribute name="name"><xsl:value-of select="@href"/>
      </xsl:attribute>
        </a>
        <h3><xsl:value-of select="@name"/></h3>
        <xsl:copy-of select="*|text()"/>
      </xsl:for-each>
      <!-- End Additional TOC sections -->
      
      <!-- Footer Section (Examples, Javadoc, History) -->
      <a name="examples"><h3>Examples</h3></a>
      <p>See the example application
      taglibs-<xsl:value-of select="short-name"/>-examples.war for examples of the usage
      of the tags from this custom tag library.</p>

      <xsl:if test="$generationtarget = 'xdoc'">
        <a name="javadocs"><h3>Java Docs</h3></a>
        <p>Java programmers can view the java class documentation for this tag
        library as <a href="apidocs/index.html">javadocs</a>.</p>

        <a name="history"><h3>Revision History</h3></a>
        <p>Review the complete <a href="changes-report.html">revision history</a> of
        this tag library.</p>
      </xsl:if>

      <!-- developers' notes, if any -->  
      <xsl:apply-templates select="developers-notes"/>

    </body>
  </xsl:template>
  <xsl:template match="tag">
    <table border="0" width="90%" cellpadding="3" cellspacing="3">
      <tr bgcolor="{$banner-bg}">
        <td colspan="6">
          <b><font color="{$banner-fg}" face="arial,helvetica,sanserif" size="+1">
            <a><xsl:attribute name="name"><xsl:value-of select="name"/>
            </xsl:attribute><xsl:value-of select="name"/>
            </a>
          </font></b>
        </td>
        <!-- jsp20 tld doesn't take an availability element -->
      </tr>
      <tr><td colspan="6">
          <xsl:apply-templates select="description"/>
        </td>
      </tr>
      <tr>
        <td width="15%"><b>Tag Body</b></td>
        <td width="17%"><xsl:value-of select="body-content"/></td>
        <td width="17%"><xsl:text>&#160;</xsl:text></td>
        <td width="17%"><xsl:text>&#160;</xsl:text></td>
        <td width="17%"><xsl:text>&#160;</xsl:text></td>
        <td width="17%"><xsl:text>&#160;</xsl:text></td>
      </tr>
      <!-- BEGIN xsl:choose
           If tag has attributes, then create headers and iterate
           over the attributes,
           otherwise, skip headers and print
           "None" -->
      <xsl:choose>
        <xsl:when test="attribute">
          <tr> 
            <td><b>Attributes</b></td>
            <td >Name</td>
            <td >Required</td>
            <td colspan="2">
              Runtime<xsl:text>&#160;</xsl:text>Expression<xsl:text>&#160;</xsl:text>Evaluation
            </td>
            <td >Availability</td>
          </tr>
          
          <!-- Start <attribute> for-each here -->
          <xsl:for-each select="attribute">
            <tr bgcolor="#cccccc">
              <td bgcolor="#ffffff"><xsl:text>&#160;</xsl:text></td>
              <td><b><xsl:value-of select="name"/></b></td>
              <td>
                <xsl:apply-templates select="required"/>
              </td>
              <td colspan="2">
                <xsl:apply-templates select="rtexprvalue"/>
              </td>
              <td>
                <xsl:text>&#160;</xsl:text>
                <xsl:value-of select="availability"/>
              </td>
            </tr>
            <tr>
              <td bgcolor="#ffffff"><xsl:text>&#160;</xsl:text></td>
              <td colspan="5">
                <xsl:apply-templates select="description"/>
              </td>
            </tr>
          </xsl:for-each>
          <!-- End <attribute> for-each here -->
        </xsl:when>
        <xsl:otherwise>
          <tr> 
            <td><b>Attributes</b></td>
            <td colspan="5">None</td>
          </tr>
        </xsl:otherwise>
      </xsl:choose>
      <!-- END xsl:choose -->
      
      <!-- BEGIN xsl:choose
           If tag creates a script variable or attribute with
           properties, then create headers and iterate over the
           properties, otherwise, skip headers and print "None" -->
      <xsl:choose>  
        <xsl:when test="variable">
          <tr>
            <td><b>Variables</b></td>
            <td colspan="2">Name</td>
            <td colspan="2">Scope</td>
            <td>Availability</td>
          </tr>
          <xsl:for-each select="variable">
            <tr bgcolor="#cccccc">
              <td bgcolor="#ffffff"><xsl:text>&#160;</xsl:text></td>
              <xsl:choose>
                <xsl:when test="name-given">
                  <td colspan="2">
                    <xsl:text>&#160;</xsl:text>
                    <b><xsl:value-of select="name-given"/></b>
                  </td>
                </xsl:when>
                <xsl:otherwise>
                  <td colspan="2"><xsl:text>&#160;</xsl:text>
                  <b><xsl:value-of select="name-from-attribute"/></b>
                  attribute value
                  </td>
                </xsl:otherwise>
              </xsl:choose>
              <td colspan="2">
                <xsl:text>&#160;</xsl:text>
                <xsl:choose>
                  <xsl:when test="scope='AT_BEGIN'">
                    Start of tag to end of page
                  </xsl:when>
                  <xsl:when test="scope='AT_END'">
                    End of tag to end of page
                  </xsl:when>
                  <xsl:otherwise>
                    Nested within tag
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td>
                <xsl:text>&#160;</xsl:text>
                <xsl:value-of select="availability"/>
              </td>
            </tr>
            <tr>
              <td><xsl:text>&#160;</xsl:text></td>
              <td colspan="5">
                <xsl:apply-templates select="description"/>
              </td>
            </tr>
            <xsl:choose>
              <xsl:when test="beanprop">
                <tr>
                  <td><xsl:text>&#160;</xsl:text></td>
                  <td ><b>Properties</b></td>
                  <td >Name</td>
                  <td >Get</td>
                  <td >Set</td>
                  <td >Availability</td>
                </tr>

                <!-- Start <beanprop> for-each here -->
                <xsl:for-each select="beanprop">
                  <tr bgcolor="#cccccc">
                    <td bgcolor="#ffffff"><xsl:text>&#160;</xsl:text></td>
                    <td bgcolor="#ffffff"><xsl:text>&#160;</xsl:text></td>
                    <td>
                      <xsl:text>&#160;</xsl:text>
                      <b><xsl:value-of select="name"/></b>
                    </td>
                    <td><xsl:text>&#160;</xsl:text>
                    <xsl:value-of select="get"/>
                    </td>
                    <td><xsl:text>&#160;</xsl:text>
                    <xsl:value-of select="set"/>
                    </td>
                    <td><xsl:text>&#160;</xsl:text>
                    <xsl:value-of select="availability"/>
                    </td>
                  </tr>
                  <tr> 
                    <td><xsl:text>&#160;</xsl:text></td>
                    <td><xsl:text>&#160;</xsl:text></td>
                    <td colspan="4">
                      <xsl:apply-templates select="description"/>
                    </td>
                  </tr>
                </xsl:for-each>
                <!-- End <beanprop> for-each here -->
              </xsl:when>
              <xsl:otherwise>
                <tr>
                  <td><xsl:text>&#160;</xsl:text></td>
                  <td><b>Properties</b></td>
                  <td colspan="4">None</td>
                </tr>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <tr>         
            <td><b>Variables</b></td>
            <td colspan="5">None</td>
          </tr>
        </xsl:otherwise>
      </xsl:choose>
      <!-- END xsl:choose -->

      <!-- Examples Section -->
      <xsl:call-template name="examples"/>
      <!-- End Examples Section -->
      
    </table>
  </xsl:template>
  <xsl:template match="tag-file">
    <xsl:variable name="name">
      <xsl:value-of select="name"/>
    </xsl:variable>
    <a name="{$name}"></a>
    <table border="0" width="90%" cellpadding="3" cellspacing="3">
      <tr bgcolor="{$banner-bg}">
        <td colspan="6">
          <font color="{$banner-fg}" face="arial,helvetica,sanserif">
            <strong><xsl:value-of select="name"/></strong> -
            <xsl:value-of select="display-name"/>
          </font>
        </td>
      </tr>
      <tr><td colspan="6">
        <blockquote>
          <xsl:apply-templates select="description"/>
        </blockquote>
      </td></tr>
      <xsl:apply-templates select="tag-extension"/>
      <xsl:call-template  name="examples"/>
    </table>
  </xsl:template>

  <xsl:template match="tag-extension">
    <!-- Assume tooling files are defined in META-INF/tags -->
    <xsl:variable name="href" select="concat('../main/resources', extension-element)"/>
    <xsl:variable name="metadata" select="document($href)" />
    <xsl:choose>
      <xsl:when test="$metadata/ui-config/component/input-params/param">
          <tr> 
		<td><b>Attributes</b></td>
            <td >Name</td>
            <td>Value</td>
            <td >Required</td>
            <td > Runtime<xsl:text>&#160;</xsl:text>Expression<xsl:text>&#160;</xsl:text>Evaluation</td>
            <td>Summary</td>
          </tr>
          
          <!-- Start <input-param> for-each here -->
          <xsl:for-each select="$metadata/ui-config/component/input-params/param">
            <tr bgcolor="#cccccc">
		  <td bgcolor="#ffffff"><xsl:text>&#160;</xsl:text></td>
              <td><b><xsl:value-of select="@name"/></b></td>
              <td><xsl:value-of select="@value"/></td>
              <td> <xsl:apply-templates select="@required"/> </td>
              <td> <xsl:apply-templates select="@rtexprvalue"/> </td>
              <td><em><xsl:value-of select="@description"/></em></td>
            </tr>
            <tr>
              <td colspan="6">
                <xsl:copy-of select="./*"/>
              </td>
            </tr>
          </xsl:for-each>
          <!-- End <attribute> for-each here -->
          <!--
          <xsl:if test="$metadata/ui-config/config">
            <tr>
              <td colspan="6">
                This component accepts a configuration file  with the following
            defaults:</td></tr>
            <tr>
              <td colspan="6">
                <pre>
                  <xsl:text disable-output-escaping="yes">&lt;![CDATA[
                  </xsl:text>
                  <xsl:copy-of
                      select="$metadata/ui-config/config"/>
                  <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
                </pre>
              </td>
            </tr>
          </xsl:if>
          -->
      </xsl:when>
      <xsl:otherwise>
        <tr> 
          <td><b>Attributes</b></td>
          <td colspan="5">None</td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
  <xsl:template match="requirements-info">
    <xsl:call-template name="uri"/>
  </xsl:template>

  <xsl:template match="restrictions">
    <xsl:call-template name="uri"/>
  </xsl:template>

  <xsl:template match="description">
    <xsl:call-template name="uri"/>
  </xsl:template>

  <xsl:template match="docs">
    <xsl:call-template name="uri"/>
  </xsl:template>

  <xsl:template match="developers-notes">
    <h3><a name="developers-notes">Developers' Notes</a></h3>
    <font size="2" color="blue">
      Last updated: <xsl:value-of select="@last-updated"/>
    </font>  

    <xsl:call-template name="uri"/>
  </xsl:template>

  <xsl:template name="uri">
    <xsl:choose>
      <xsl:when test="@uri">
        <xsl:copy-of select="document(@uri)"/>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <xsl:copy-of select="*|text()"/>  
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="/document/revision"/>

  <xsl:template name="documentation">
    <xsl:if test="documentation">
      <a><xsl:attribute name="name">documentation</xsl:attribute></a>
      <h3>Documentation</h3>
      <xsl:apply-templates select="documentation/docs"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="doctoc">

    <xsl:if test="documentation">
      <li><a href="#documentation">Documentation</a></li>
    </xsl:if>

    <xsl:if test="documentation/doctoc">
      <ul><xsl:apply-templates select="documentation/doctoc"/></ul>
    </xsl:if>
  </xsl:template>

  <xsl:template match="li">
    <li>

      <xsl:choose>
        <xsl:when test="@anchor">
          <a>
            <xsl:attribute name="href">#<xsl:value-of select="@anchor"/></xsl:attribute>
            <xsl:apply-templates/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>

    </li>
  </xsl:template>

  <xsl:template match="ul">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template name="examples">
    <xsl:choose>
      <xsl:when test="example">
        <tr><td><b>Usage:</b></td>
          <td colspan="5">
            <i><xsl:apply-templates select="example"/></i>
          </td>
        </tr>
      </xsl:when>	
      <xsl:otherwise>
        <tr>
          <td><b>Examples</b></td>
          <td colspan="5">None</td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="usage">
    <tr>
      <!-- not sure why it's 2 and not 1  :) -->
      <td><xsl:if test="position() = 2"><b>Examples</b></xsl:if></td>
      <xsl:if test="comment">
        <td colspan="5" bgcolor="#cccccc">
          <xsl:copy-of select="comment/*"/>
          <xsl:text>&#160;</xsl:text>
        </td>
      </xsl:if>
    </tr>

    <tr>
      <td><xsl:text>&#160;</xsl:text></td>
      <td colspan="5">
        <xsl:for-each select="scriptlet">
          &lt;%<xsl:value-of select="."/>%&gt;<br/> 
        </xsl:for-each>
        <!-- A little trick here: the XML element <code> in our
             TLDoc matches the HTML element <code> on purpose so
             that we can just copy the whole node, including the
             opening and closing <code> tags.
        -->
        <p><pre><xsl:copy-of select="code"/></pre></p>
      </td>
    </tr> 
  </xsl:template>
  <xsl:template match="required" name="reqd">
    <xsl:text>&#160;</xsl:text>
    <xsl:choose>
      <xsl:when test=".='true'">
        Yes
      </xsl:when>
      <xsl:when test=".='yes'">
        Yes
      </xsl:when>
      <xsl:otherwise>
        No
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="rtexprvalue" name="rtexpr">
    <xsl:text>&#160;</xsl:text>
    <xsl:choose>
      <xsl:when test=".='true'">
        Yes
      </xsl:when>
      <xsl:when test=".='yes'">
        Yes
      </xsl:when>
      <xsl:otherwise>
        No
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@required">
    <xsl:call-template name="reqd"/>
  </xsl:template>

  <xsl:template match="@rtexprvalue">
    <xsl:call-template name="rtexpr"/>
  </xsl:template>

  <xsl:template name="configuration">
    <a><xsl:attribute name="name">config</xsl:attribute></a>
    <h3>Configuration</h3>
    <p>Follow these steps to configure your web application with this tag
    library:</p>
    <ul>
      <li>Use a servlet container that implements the JavaServer Pages
      Specification, version 2.0 or higher (Example: Tomcat 5.x) or an
      application server that supports J2EE 1.4 or higher (Example: 
      Websphere Application Server 6.x)</li>
      <li>Use a Servlet 2.4 web application descriptor for your web
      application.</li>
      <li>Copy the tag library JAR file 
      (taglibs-<xsl:value-of select="prefix"/>.jar)
      to the /WEB-INF/lib subdirectory of your web application.</li>
    </ul>
    <p>To use the tags from this library in your JSP pages, add the following
    directive at the top of each page: </p>
    <pre>
      &lt;%@ taglib uri=&quot;<xsl:value-of select="uri"/>&quot; prefix=&quot;<xsl:value-of select="prefix"/>&quot; %&gt;
    </pre>
    <p>where &quot;<i><xsl:value-of select="prefix"/></i>&quot; is the tag
    name prefix you wish to use for tags from this library. You can change
    this value to any prefix you like.</p>
  </xsl:template>

</xsl:stylesheet>

