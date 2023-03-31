<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <!-- Configuration de la sortie -->
    <xsl:strip-space elements="*"/> <!-- Suppression des espaces blancs inutiles -->
    <xsl:output method="text" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>
    
    <!-- Définition de variables -->
    <xsl:variable name="title" select="/TEI/teiHeader[1]/fileDesc[1]/titleStmt[1]/title[1]"/>
    <xsl:variable name="author" select="/TEI/teiHeader[1]/fileDesc[1]/titleStmt[1]/author[1]"/>
    
    <xsl:template match="/">
        <!-- Configuration du document LaTeX -->
        \documentclass[12pt,a4paper,openany]{book}
        \usepackage[utf8]{inputenc}
        \usepackage[T1]{fontenc}
        \usepackage{geometry}
        \geometry{
        left=2.5cm, % marge gauche
        right=2.5cm, % marge droite
        top=2.5cm, % marge supérieure
        bottom=2.5cm, % marge inférieure
        includeheadfoot, % inclure l'en-tête et le pied de page dans les marges
        headheight=14pt % hauteur de l'en-tête
        }
        \usepackage[french]{babel}
        \usepackage{fancyhdr}
        
        <!-- Configuration des titres de chapitre -->
        \usepackage{titlesec}
        \titleformat{\chapter}[block]{\Large\bfseries}{}{1em}{}
        
        <!-- Configuration des index -->
        \usepackage[splitindex]{imakeidx}
        \makeindex[name=persName,title=Index des noms de personnes]
        \makeindex[name=placeName,title=Index des noms de lieux]
        
        <!-- Configuration du titre, de l'auteur et de la date -->
        \title{\textbf{<xsl:value-of select="$title"/>}}
        \author{<xsl:value-of select="$author/forename"/> <xsl:value-of select="$author/surname"/>}
        \date{<xsl:value-of select="/TEI/teiHeader[1]/fileDesc[1]/publicationStmt[1]/date[1]"/>}
        
        <!-- Début du document LaTeX -->
        \begin{document}
        <!-- Configuration de l'en-tête et du pied de page -->
        \pagestyle{fancy}
        \fancyhf{}
        \fancyfoot[C]{\thepage}
        \renewcommand{\headrulewidth}{0pt}
        
        <!-- Affichage du titre, de l'auteur et de la date -->
        \maketitle
        
        <!-- Texte supplémentaire avant le début du contenu -->
        \vspace*{3cm}
        \begin{Large}
        Ce document PDF a été compilé à partir d'une feuille de style XSL rédigée dans le cadre du Master TNAH de l'École nationale des chartes. Il contient \textit{<xsl:value-of select="//titleStmt/title"/>} de  \textit{<xsl:value-of select="//titleStmt/author"/>}.
        <xsl:text>
            \end{Large}
       
       <!-- Saut de page et traitement du corps du texte -->
            \newpage
            
            </xsl:text>
        <xsl:apply-templates select="//body"/>
        
        <!-- Affichage des index et de la table des matières -->
        \printindex[persName]
        \addcontentsline{toc}{chapter}{Index des noms de personnes}
        \printindex[placeName]
        \addcontentsline{toc}{chapter}{Index des noms de lieux}
        
        \tableofcontents
        \addcontentsline{toc}{chapter}{Table des matières}
        
        \end{document}
        
    </xsl:template>
    <xsl:template match="//body">
        <xsl:for-each select="./div/head">
            
            <!-- Affichage des titres de chapitres -->
            \chapter{<xsl:value-of select="./text()"/>}
            
            <!-- Affichage des paragraphes -->
            <xsl:for-each select="//body//p">
                <xsl:apply-templates/><xsl:text>
                </xsl:text>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <!-- Traitement des noms propres et utilisation des conditions -->
    <xsl:template match="//body//persName | //body//placeName">
        <xsl:choose>
            <xsl:when test="self::persName">
                <xsl:value-of select="."/>
                <xsl:text>\index[persName]{</xsl:text>
                <!-- Supression des "#" et des "_" présent dans les références -->
                <xsl:value-of select="translate(substring-after(@ref, '#'), '_', ' ')"/>
                <xsl:text>}</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
                <xsl:text>\index[placeName]{</xsl:text>
                <!-- Supression des "#" et des "_" présent dans les références -->
                <xsl:value-of select="translate(substring-after(@ref, '#'), '_', ' ')"/>
                <xsl:text>}</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Changement des guillemets pour Latex -->
    <xsl:template match="p">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:value-of select="replace(replace(., '«', '\\og'), '»', '\\fg')"/>
    </xsl:template>
    
    
    
    
</xsl:stylesheet>