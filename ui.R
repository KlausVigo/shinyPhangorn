
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

if(!require("shiny")) stop("package shiny is required")

models <- c("JC", "F81", "K80", "HKY", "SYM", "GTR")

shinyUI(navbarPage("",position="fixed-top", collapsible = TRUE,
                   theme = "bootstrap.simplex.css", 

                   
# Application title
#  titlePanel("shinyPhangorn"),
#   tabPanel("Tree landscape explorer",
#           tags$link(rel = 'stylesheet', type = 'text/css', href = 'styles.css'))
## SERVER INFO ##
#  tabPanel("System info", 
#         tags$style(type="text/css", "body {padding-top: 40px;}"),
#         verbatimTextOutput("systeminfo"))
#), # end of tabsetPanel

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      
      ## SPECIFIC TO TREE LANDSCAPE EXPLORER ##
#      conditionalPanel(condition = "$('li.active a').first().html()== 'Tree landscape explorer'",
        ## INPUT
        ## choice of type of data source
#        img(src="img/line.png", width="100%"),
#        hr(),
        h2(HTML('<font color="#6C6CC4" size="6"> > Input </font>')),
        radioButtons("datasource", HTML('<font size="4"> Choose data source:</font>'),
          list("Example: Laurasiatherian"="exLaura", 
#               "Example: chloroplast"="exChloroplast",
               "Input file"="file")),
                       
        ## choice of dataset if source is a file
       conditionalPanel(condition = "input.datatype=='file'",
          fileInput("file1", "Load alignment"),
          radioButtons("format", "Format:",
             c("Phylip" = "phylip",
               "Nexus" = "nexus",
               "FASTA" = "fasta")),
          radioButtons("type", "Type:",
             c("Nucleotide" = "DNA",
             "Amino acid" = "AA"))
         ),
      hr(),
      selectInput("recon", "Reconstruction method:",
                  c("Distance" = "dist",
                    "Maximum Parsimony" = "MP",
                    "Maximum Likelihood" = "ML")), 
      
      conditionalPanel(condition = "input.recon=='dist'",
          selectInput('dist_method', 'Method:',
                      c("NJ", "BIONJ", "fastME (OLS)", "fastME (BAL)", "UPGMA", "WPGMA") )
      ),
      
      conditionalPanel(condition = "input.recon=='ML'",
#        if(input$type=="DNA") 
#          models = c("JC", "F81", "K80", "HKY", "SYM", "GTR"),
#        else models = phangorn:::.aamodels,

        tagList(
          checkboxInput("inv", "Invariant sites:", FALSE),
          checkboxInput("gamma", "Gamma:", FALSE, width="45%"),
          numericInput("k", "k:", value=1, min=1, max=20, step=1, width="45%"),
          selectInput('ML_model', 'Model:', models)
        )
      ),
      
#      uiOutput('dist_UI'),
#      uiOutput('ML_UI'),
      actionButton("goButton", "Compute!")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      textOutput("reconText"),
      plotOutput("distPlot")
    )
  )
))
