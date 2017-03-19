
<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
     <xsl:template match="/">

          <html>
               <head>
                    <style rel="stylesheet" type="text/css">
                         table{width:100%;border:1px solid}
                         th{background-color:#cdd8f6}
                         td,tr,th{border:1px solid;padding:2px;vertical-align:top}
                         span{color:green;padding-left:5px}
                    </style>
               </head>

               <body>
                    <h2>Examen de Historia. Corrección</h2>

                    <table>
                         <tr>
                              <th>Preguntas</th>
                              <th>Opciones</th>
                              <th>Respuestas dadas por el usuario</th>
                         </tr>

                         <xsl:for-each select="questions/question">      
                              <tr>
                                   <td><xsl:value-of select="title"/></td>

                                   <td>
                                        <xsl:for-each select="answer">
                                             <xsl:choose>
                                                  <xsl:when test="../type = 'text'">
                                                       <span><xsl:value-of select="text()"/></span>
                                                  </xsl:when>
                                             </xsl:choose>         
                                        </xsl:for-each>

                                        <xsl:for-each select="option">
                                             <xsl:variable name="optposition" select="position()-1"/>
                                             O<xsl:value-of select="$optposition+1"/>: <xsl:value-of select="text()"/>
                                             <xsl:for-each select="../answer">
                                                  <xsl:variable name="correctanswer" select="text()"/>
                                                  <xsl:if test="$optposition=$correctanswer">
                                                       <span>&#x2713;</span>
                                                  </xsl:if>
                                             </xsl:for-each><br/><br/>
                                        </xsl:for-each>
                                   </td>

                                   <td>
                                        <xsl:for-each select="useranswer">
                                             <xsl:variable name="useranswers" select="text()"/>
                                             <xsl:value-of select="text()"/>
                                             <xsl:for-each select="../answer">
                                                  <xsl:choose>
                                                       <xsl:when test="../type = 'text'">
                                                            <xsl:variable name="correctanswertext" select="text()"/>
                                                            <xsl:if test="$useranswers=$correctanswertext">
                                                                 <span>&#x2713;</span>
                                                            </xsl:if>
                                                       </xsl:when>
                                                       <xsl:otherwise>
                                                            <xsl:variable name="correctanswer" select="text()+1"/>
                                                            <xsl:if test="$useranswers=$correctanswer">
                                                                 <span>&#x2713;</span>
                                                            </xsl:if>
                                                       </xsl:otherwise>
                                                  </xsl:choose>
                                             </xsl:for-each><br/><br/>
                                        </xsl:for-each>       
                                   </td>
                              </tr>
                         </xsl:for-each>
                    </table>
               </body>
          </html>

     </xsl:template>
</xsl:stylesheet>
