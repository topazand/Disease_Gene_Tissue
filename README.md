
# Disease_Gene_Tissue
For ds project

- General Intro:
This project focuses on visualizating the correlation between disease, 
tissue, and biological pathways

- Packages used
library(shiny):shiny
library(shinydashboard):shinyDB
library(DT):shiny Datatable
library(cyjShiny):not used
library(tidyverse):very useful
library(XML):navigate in html documnt
library(xml2):same as above
library(httr):used to retrieve information on rwikipathway website to add description to pathways
library(BiocManager):used to install some packages
library(RCy3):connect with Cytoscape
library(rWikiPathways):get pathway data
library(RColorBrewer):not used
library(pathview):convert gene name
library(clusterProfiler):do enrichment analysis
library(DOSE):cannot remember what it does
library(plyr):same as above
library(purrr):same as above
library(Biostrings):same as above

- Datasets used
See shiny app

- GTEX.Rmd && do.Rmd && Rcy3.Rmd
These three files finishes data analysis. They provides several functions for the shiny app.

print_pw(dis) will print all pathways related to one disease(as text) which can be used for selection

draw_disease_pathway(dis,pw) draws the given pathway and highlight genes in the pathway
that are related to the given disease in Cytoscape.

showrel(dn,nmsl) will draw a horizontal col plot for the tissues mostly related
to the given disease(dn) and with a title(nmsl)

get_des(wp) will use httr and xml and xml2 packages to retrieve the description of a pathway from wikipathway website.

-shiny App
	menuitems:
	-Data:
		Show all data used.
	-Choose Disease:
		This page is used for selecting the disease to study. The viewer may select the disease directly,
		search by string, or select by category(disease types, Disease Semantic Types, or disease class).
	-Tissue:
		call showrel() to produce a plot showing the correlation between different tissues and the 
		selected disease
	-Cytoscape Pathway:
		On the left panel, a text description of the result of enrichment analysis on the selected
		disease and all pathways produced by print_pw() is shown. The viewer may select one pathway name for 
		visualization, and the description of that pathway would be shown. Then, shiny will call draw_disease_pathway
		to draw the pathway diagram in Cytoscape and save it to a svg file and show it in a htmloutput.