
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
     <xsl:template match="/">
          <html>
               <head>
                    <style rel="stylesheet" type="text/css">    

                    	#bodyDelXSL{
							width:100%;
							padding-left:0%;
							padding-right:0%;
							background-color: transparent; 
						}                    
                         
                         table,span{ font-size: 2vw; }

                         table{
                              text-shadow: -2px 2px 5px white;
                              padding: 3vw 3vw 10vw 3vw;
                         }

                         tr{ background-color: cyan; }

                         th{ 
                              vertical-align: middle; 
                              border: 2px solid black;
                              padding: 2%;
                         }

                         td{
                              border: 2px solid black;
                              padding: 2%;
                              vertical-align: top;
                         }

                         span{ padding-left:5px; color: black;}
                         #aspa_roja{ color: red; }
                         #visto_verde{ color: green; }

                         #notaFinal{
                              font-size: 3vw;
                              font-style: bold;
                              color: red;
                              background-color: white;
                              border: 5px solid red;
                              border-radius: 100%;
                              padding: 1%;
                              margin: 5%;
                         }


                         @media screen and (max-width: 750px){

                              table,span{ font-size: 4.5vw; }

                              table{ padding: 3vw 1vw 10vw 1vw; }

                              th,td{ 
                                   padding: 0.5%;
                              }

                              #notaFinal{
                                   font-size: 6vw;
                              }

                         }

                    </style>
               </head>

               <body id="bodyDelXSL">             		
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
                                                       <span id='visto_verde'>&#x2714;</span>
                                                  </xsl:if>
                                             </xsl:for-each><br/><br/>
                                        </xsl:for-each>
                                   </td>

                                   <td>
                                        <xsl:for-each select="useranswer">
                                             <xsl:variable name="useranswers" select="text()"/>
                                             <xsl:choose>
                                                  <xsl:when test="../type = 'text'">                              
                                                       <xsl:value-of select="text()"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                       <xsl:value-of select="text()+1"/>
                                                  </xsl:otherwise>
                                             </xsl:choose>
                                             <xsl:for-each select="../answer">
                                                  <xsl:choose>
                                                       <xsl:when test="../type = 'text'">
                                                            <xsl:variable name="correctanswertext" select="text()"/>
                                                            
                                                            <xsl:if test="$useranswers=$correctanswertext">
                                                                 <span id='visto_verde'>&#x2714;</span>
                                                            </xsl:if>
                                                       </xsl:when>
                                                       <xsl:otherwise>
                                                            <xsl:variable name="correctanswer" select="text()+1"/>                                                        
                                                            
                                                            <xsl:if test="$useranswers+1=$correctanswer">
                                                                 <span id='visto_verde'>&#x2714;</span>
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
