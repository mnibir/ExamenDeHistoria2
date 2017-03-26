
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
     <xsl:template match="/">
          <html>
               <head>
                    <style rel="stylesheet" type="text/css">                        

                         html,body{ margin:0px; }

                         body{
                              width:90%;
                              padding-left:5%;
                              padding-right:5%;
                              background-color: black; 
                         }

                         body,table,span{ font-size: 2vw; }
                         
                         h2{
                              font-size: 3vw;
                              color: white;
                         }

                         table{
                              text-shadow: -2px 2px 5px white;
                              padding: 5vw 5vw 15vw 5vw;
                              background-image: url("https://rawgit.com/mnibir/ExamenDeHistoria2/master/img/greece-1594689_1920.jpg");
                              background-size: cover;
                              background-repeat: no-repeat; 
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

                         span{ padding-left:5px; }
                         #aspa_roja{ color: red; }
                         #visto_verde{ color: green; }

                         a{ text-decoration: none; }

                         #boton4{
                              border: double 5px white;
                              color: black;
                              border-radius: 5px;
                              font-style: bold;
                              width:auto;
                              padding: 1%;
                              margin: 10px;
                              background-color: lightgrey;
                              text-shadow: none; 
                         }

                         #boton4:hover{
                              background-color: dodgerblue;
                              color: cyan;
                              cursor:pointer; cursor: hand;
                         }

                         #nota{
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

                              body{
                                   width:96%;
                                   padding-left:2%; padding-right:2%;
                              }

                              body,table,span{ font-size: 4.5vw; }

                              table{ padding: 5vw 1vw 15vw 1vw; }

                              th,td{ 
                                   padding: 0.5%;
                              }

                              h2{ font-size: 6vw; }

                              #nota{ font-size: 6vw; }
                         }

                    </style>
               </head>

               <body>
               		<h2>Examen de Historia. Informe de resultados.</h2>
                    <table:block>
                         <a id='boton4' href="https://rawgit.com/mnibir/ExamenDeHistoria2/master/index.html">VOLVER</a>
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
                                             <xsl:value-of select="text()"/>
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
                                                            <xsl:if test="$useranswers=$correctanswer">
                                                                 <span id='visto_verde'>&#x2714;</span>
                                                            </xsl:if>
                                                       </xsl:otherwise>
                                                  </xsl:choose>
                                             </xsl:for-each><br/><br/>
                                        </xsl:for-each>       
                                   </td>
                              </tr>
                         </xsl:for-each>
                    </table:block>
               </body>
          </html>

     </xsl:template>
</xsl:stylesheet>
