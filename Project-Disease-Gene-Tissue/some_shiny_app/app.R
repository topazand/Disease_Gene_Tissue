#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#save(all_dis,gene_disease_tissue,SemanticType,get_pn,get_des,pw_print,showrel,enc_analysis,get_disease,wpid2name,wpid2gene,all_relation,gene_d,ffile = "all.shiny")
# c(all_dis,SemanticType,get_pn,get_des,pw_print,showrel,enc_analysis,get_disease,wpid2name,wpid2gene,all_relation,gene_d)
# save

library(shiny)
library(shinydashboard)
library(DT)
library(cyjShiny)
library(tidyverse)
library(XML)
library(xml2)
library(httr)
library(BiocManager)
library(RCy3)
library(rWikiPathways)
library(RColorBrewer)
library(pathview)
library(clusterProfiler)
#load("all.shiny")
#runApp('some_shiny_app',port=8080,host="172.16.101.105")
# Define UI for application that draws a histogram
process<-function(type,semantic,cls){
    #type<-c("disease","phenotype","group")
    org<-all_dis
    org<-org%>%filter(diseaseType %in% type)
    if(! "All" %in% semantic){
        org<-org%>%filter(diseaseSemanticType %in% semantic)
    }
    if(! "All" %in% cls){
        if(is.null(cls)) org<-org%>%filter(diseaseClass=="普林斯顿国际数理中学")
        org<-org%>%filter(str_detect(diseaseClass,cls))
    }
    #print(org)
    org
}
ui <- dashboardPage(
    dashboardHeader(
        title="DS Project"
    ),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Data",tabName = "data"),
            menuItem("Chooose Disease",tabName = "disease"),
            menuItem("Tissue",tabName = "tissue"),
            menuItem("Cytoscape Pathway",tabName = "pathway")
        )
    ),
    dashboardBody(
        tabItems(
            
            tabItem(
                
                tabName = "data",
                fluidRow(
                     box(
                         solidHeader=TRUE,
                         status="primary",
                     width=6,
                         title="GTEX data",
                        
                         HTML("<p style=\"font-size: 18px\"><a target=”_blank” href=\"https://gtexportal.org/home/datasets\">The Gtex data</a> comes from the \"Median gene-level TPM by tissue. Median expression was calculated from the file GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_tpm.gct.gz.\" data in the website. It shows each gene's expression level in each tissue.<br><br>Each row in the data is a specific gene, and each column is a tissue.</p>")),
                box(
                    solidHeader=TRUE,
                    status="success",
                    width=6,
                    title="Disgenet data",
                    
                    HTML("<p style=\"font-size: 18px\"><a target=”_blank” href=\"https://www.disgenet.org/downloads\">The Disgenet data</a> comes from the \"Curated gene-disease associations\" data in the website. It shows each disease's related genes.<br><br>Each row in the data shows the correlation between one gene and one disease specific gene.</p>"))),
            fluidRow(
                box(
                    solidHeader=TRUE,
                    status="warning",
                    width=6,
                    title="rWikiPathway data",
                    
                    HTML("<p style=\"font-size: 18px\"><a target=”_blank” href=\"https://www.wikipathways.org/index.php/Download_Pathways\">The rWikiPathway</a> comes from the \"Homo Sapiens\" data in the website. It shows the genes in each pathway.<br><br>This data is combined with the cytoscape data to visualize networks</p>"))
            ,
            box(
                solidHeader=TRUE,
                status="danger",
                width=6,
                title="Cytoscape",
                
                HTML("<p style=\"font-size: 18px\"><a target=”_blank” href=\"https://cytoscape.org/\">Cytoscape</a> is an free, open source software for network data integration, analysis, and visualization.<br><br>In this project, cytoscape is used to show disease-related pathways</p>")
            )
            )),
            tabItem(
                tabName = "disease",
                fluidRow(
                    box(
                        width=4,
                        h3("Filter"),
                        checkboxGroupInput("type","Select Disease Types",choices=c("disease","phenotype","group"),selected = c("disease","phenotype","group")),
                        selectizeInput("semantic","Select Disease Semantic Types",choices=SemanticType,selected = c("All"),multiple=T),
                        selectizeInput('class', 'Select Disease Classes', choices = list(
                            `C01 - bacterial infections and mycoses`="C01",
                            `C02 - virus diseases`="C02",
                            `C03 - parasitic diseases`="C03",
                            `C04 - neoplasms`="C04",
                            `C05 - musculoskeletal diseases`="C05",
                            `C06 - digestive system diseases`="Co6",
                            `C07 - stomatognathic diseases`="C07",
                            `C08 - respiratory tract diseases`="C08",
                            `C09 - otorhinolaryngologic diseases`="C09",
                            `C10 - nervous system diseases`="C10",
                            `C11 - eye diseases`="C11",
                            `C12 - urologic and male genital diseases`="C12",
                            `C13 - female genital diseases and pregnancy complications`="C13",
                            `C14 - cardiovascular diseases`="C14",
                            `C15 - hemic and lymphatic diseases`="C15",
                            `C16 - congenital, hereditary, and neonatal diseases and abnormalities`="C16",
                            `C17 - skin and connective tissue diseases`="C17",
                            `C18 - nutritional and metabolic diseases`="C18",
                            `C19 - endocrine system diseases`="C19",
                            `C20 - immune system diseases`="C20",
                            `C21 - disorders of environmental origin`="C21",
                            `C22 - animal diseases`="C22",
                            `C23 - pathological conditions, signs and symptoms`="C23",
                            `F01 - Behavior and Behavior Mechanisms`="F01",
                            `F02 - Psychological Phenomena and Processes`="F02",
                            `F03 - Mental Disorders`="F03",
                            "All"="All"
                            
                        ),
                        multiple = TRUE,selected=c("All"))
                        
                    ),
                    box(
                        
                        width=8,
                        h3("Search and Select"),
                        dataTableOutput("chs")
                        
                    )
                )
            ),
            tabItem(
                tabName = "tissue",
                fluidRow(
                    box(
                        title="Disease - Tissue relation",
                        width=12,
                        plotOutput("gtex")
                    )
                )
                
            ),
            tabItem(
                tabName = "pathway",
                fluidRow(
                   box(
                       title="Select Pathway",
                       width=4,
                       htmlOutput("pw"),
                       tags$script('
                function getSelectionText() {
                    var text = "";
                    if (window.getSelection) {
                        text = window.getSelection().toString();
                    } else if (document.selection) {
                        text = document.selection.createRange().text;
                    }
                    return text;
                }

        document.onmouseup = document.onkeyup = document.onselectionchange = function() {
            var selection = getSelectionText();
            Shiny.onInputChange("mydata", selection);
        };
        ')
                   ),
                fluidRow(
                    box(
                        title="Description",
                        
                        width=7,
                        htmlOutput("des"),
                        h4("Cytoscape pathway:"),
                        htmlOutput("la")
                    ),
                )
                )
            )
        )
        
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    curtbl<-reactiveVal(all_dis)
    selectedpw<-reactiveVal(NA)
    output$des<-renderUI({
        
        s<-input$mydata
        if(is.na(str_match(s,"WP[0-9]+"))) {HTML("No pathway name selected")}
        else {
            selectedpw(str_match(s,"WP[0-9]+")[1])
        HTML(paste0("Pathway ID:",str_match(s,"WP[0-9]+")[1],"<br>","Pathway Name:",get_pn(str_match(s,"WP[0-9]+")[1]),"<br>","Description:",get_des(str_match(s,"WP[0-9]+")[1])))}
        
        
    })
    output$la<-renderUI({
        if(!is.na(selectedpw())){
        draw_disease_pathway(isolate(curtbl())$diseaseId[isolate(input$chs_rows_selected)],selectedpw())
        tt<-file.remove("test.svg")
        exportImage(
                filename = "test",
                type="SVG",
                resolution = 600,
                width = 600
                
        )
        HTML(read_file("test.svg"))}
    })
    output$ki<-renderDT({gene_tt})
    
    output$pw<-renderUI({
        pre(HTML(pw_print(curtbl()$diseaseId[input$chs_rows_selected])))
    })
    output$gtex<-renderPlot({
        print(curtbl()$diseaseName[input$chs_rows_selected])
        showrel(curtbl()$diseaseId[input$chs_rows_selected],curtbl()$diseaseName[input$chs_rows_selected])
    })
    observe({
        tm<-process(input$type,input$semantic,input$class)
        curtbl(tm)
    })
    observeEvent(input$chs_rows_selected,{
        print(input$chs_rows_selected)
    })
    output$chs<-renderDataTable({curtbl()},
                                options=list(
                                    
                                ),selection = 'single')
    
}

# Run the application 
shinyApp(ui = ui, server = server)
