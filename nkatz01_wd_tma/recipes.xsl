<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" >
    <xsl:output method="html" doctype-system="about:legacy-compact" encoding="UTF-8" indent="yes"
        omit-xml-declaration="yes"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Recipes</title>
                <meta charset="utf-8"/>
                <link rel="stylesheet" type="text/css" href="styles.css"/>
            </head>
            <body>
                <h1>Recipes</h1>
                
                <xsl:for-each select="recipes/recipe">
                    <xsl:sort  select="cooktime/activityTime"   data-type="number" />  
                        <xsl:sort  select="title"    data-type="text"  /> 
                    <!-- https://stackoverflow.com/questions/34087/dividing-a-list-of-nodes-in-half-->
                    <xsl:variable name="nodes" select="./method/instruction"/>
                    <xsl:variable name="mid" select="ceiling(count($nodes) div 2)"/>
                    <table border="1">
                        <tr>
                            <th colspan="2">
                                <xsl:value-of select="title"/>
                            </th>

                            <th
                                colspan="{count(ingredients)+ceiling(count(./method/instruction) div 2)}  "> <!--We want the description to cover all method columns.-->
                                <xsl:value-of select="description"/>
                            </th>

                        </tr>

                        <tr>

                            <tr>
                                <td>Rating</td>
                                <td>
                                    <xsl:value-of
                                        select="concat(./ratingWithAttr/rating, ' (', ./ratingWithAttr/@howManyRated, ' rated)')"
                                    />
                                </td>
                                <xsl:for-each select="./ingredients">
                                    <th id="IngFormat"> Ingredients<br/>
                                        <small>
                                            <xsl:value-of select="@id"/></small>
                                    </th>
                                </xsl:for-each>
                                <xsl:for-each select="$nodes[position() &lt;= $mid]">

                                    <th>Method </th>
                                </xsl:for-each>
                            </tr>
                            <tr>
                                <td>Author</td>
                                <td>
                                    <a href="{authorType/@authorLink}">
                                        <xsl:value-of select="authorType/author"/>
                                    </a>
                                </td>
                                <xsl:for-each select="./ingredients">
                                    <td id="IngFormat" class="thickBorder" rowspan="11"><!--We want the  row belonging to the Ingredients column to span down the maximum number of rows in the first two columns, that might follow.  -->
                                        
                                        <xsl:for-each select="ingredient"> - <xsl:value-of
                                                select="./text()"/><br/>
                                        </xsl:for-each>
                                    </td>
                                </xsl:for-each>


                                <xsl:apply-templates select="./method"/>
                            </tr>
                            <tr>
                                <td>Prep</td>
                                <td>
                                    <xsl:value-of
                                        select="concat(./preptime/activityTime, ' ', preptime/@units)"
                                    />
                                </td>
                               
                                <xsl:for-each select="$nodes[$mid &lt; position()]">
                                    <td class="bigCell" rowspan="11">
                                        <strong>
                                            <xsl:value-of select="concat(position() + $mid, '.')"/>
                                        </strong>
                                        <xsl:value-of select="concat(' ', .)"/>
                                    </td>
                                </xsl:for-each>
                            </tr>
                            <xsl:if test="./cooktime and ./cooktime/activityTime &gt; 0">
                                <tr>
                                    <td>Cook</td>
                                    <td>
                                        <xsl:value-of
                                            select="concat(./cooktime/activityTime, ' ', cooktime/@units)"
                                        />
                                    </td>
                                </tr>

                                <xsl:choose>
                                    <xsl:when test="./cooktime/activityTime &lt; 30">
                                        <tr>
                                            <td colspan="2">Quick and Easy</td>
                                        </tr>
                                    </xsl:when>
                                    <xsl:when test="./cooktime/activityTime &lt; 61">
                                        <tr>
                                            <td colspan="2">Medium Burner</td>
                                        </tr>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <tr>
                                            <td colspan="2">Slow Burner</td>
                                        </tr>
                                    </xsl:otherwise>

                                </xsl:choose>
                            </xsl:if>

                            <xsl:if test="./marinatingTime">
                                <tr>
                                    <td>Marinate</td>
                                    <td>
                                        <xsl:value-of
                                            select="concat(./marinatingTime/activityTime, ' ', marinatingTime/@units)"
                                        />
                                    </td>
                                </tr>
                            </xsl:if>
                            <xsl:if test="./ExtraTime">
                                <tr>
                                    <td>Additional</td>
                                    <td>
                                        <xsl:value-of select="./ExtraTime"/>
                                    </td>
                                </tr>
                            </xsl:if>


                            <tr>
                                <td>DiffcultyLevel</td>
                                <td>
                                    <xsl:value-of select="difficultyLevel"/>
                                </td>
                            </tr>
                            <tr>
                                <td>Serves</td>
                                <td>
                                    <xsl:value-of select="serves"/>
                                </td>


                            </tr>
                            <xsl:if test="./notes">
                                <tr>
                                    <td>Notes</td>
                                    <td>
                                        <xsl:for-each select="notes">
                                            <smal>
                                                <xsl:value-of select="concat('*', ./text(), ' ')"/>
                                            </smal>
                                        </xsl:for-each>
                                    </td>
                                </tr>
                            </xsl:if>
                            <tr>
                                <xsl:choose>
                                    <xsl:when test="nutritionPerServing/@perServing">
                                        <td>NutritionPerServing <br/><smal>(<xsl:value-of
                                                  select="nutritionPerServing/@perServing"
                                            />)</smal></td>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <td>NutritionPerServing</td>
                                    </xsl:otherwise>

                                </xsl:choose>
                                <td>
                                    <xsl:for-each select="nutritionPerServing/*">

                                        <strong>
                                            <xsl:value-of select="concat(name(.), ':', ' ')"/>
                                        </strong>
                                        <xsl:value-of select="./text()"/>
                                        <br/>
                                    </xsl:for-each>
                                </td>
                            </tr>
                            <tr>
                                <td class="thickBorder">Credits</td>
                                <td class="thickBorder">
                                    <a href="{creditType/@creditLink}">
                                        <xsl:value-of select="creditType"/>
                                    </a>
                                </td>
                            </tr>


                        </tr>

                    </table>
                   
                     
                </xsl:for-each>
            
            </body>


        </html>
    </xsl:template>



    <xsl:template match="method">
        <xsl:variable name="nodes" select="./instruction"/>
        <xsl:variable name="mid" select="ceiling(count($nodes) div 2)"/>
        <xsl:for-each select="$nodes[position() &lt;= $mid]">
            <xsl:choose>
                <xsl:when test="position() = last() and count($nodes) mod 2 = 1">
                    <td class="bigCell" rowspan="11"><!--We want the second row belonging to the method column to span down the maximum number of rows in the first two columns, that might follow.  -->
                        <strong>
                            <xsl:value-of select="concat(position(), '.')"/>
                        </strong>
                        <xsl:value-of select="concat(' ', .)"/>
                    </td>
                </xsl:when>
                <xsl:otherwise>
                    <td class="bigCell">
                        <strong>
                            <xsl:value-of select="concat(position(), '.')"/>
                        </strong>
                        <xsl:value-of select="concat(' ', .)"/>
                    </td>
                </xsl:otherwise>


            </xsl:choose>
        </xsl:for-each>
    </xsl:template>


 </xsl:stylesheet> 