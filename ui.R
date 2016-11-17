library(shinydashboard)

models <- c("JC", "F81", "K80", "HKY", "SYM", "GTR")

header <- dashboardHeader(title = "shinyPhangorn")

sidebar <- dashboardSidebar(
  hr(),
  sidebarMenu(id="tabs",
              menuItem("Choose data source:", tabName="datasource", icon=icon("download"), selected=TRUE),
              menuItem("Analyse", tabName="analyse", icon=icon("line-chart")),
              menuItem("ReadMe", tabName = "readme", icon=icon("mortar-board")),
              menuItem("About", tabName = "about", icon = icon("question"))
  ),
  hr(),
  conditionalPanel("input.tabs=='datasource'",
                   radioButtons("datasource", HTML('<font size="4"> Choose data source:</font>'),
                                list("Example: Laurasiatherian"="exLaura", 
                                     #               "Example: chloroplast"="exChloroplast",
                                     "Input file"="file")),
                   conditionalPanel(condition = "input.datasource=='file'",
                                    fileInput("file1", "Load alignment"),
                                    radioButtons("format", "Format:",
                                                 c("Phylip" = "phylip",
                                                   "Nexus" = "nexus",
                                                   "FASTA" = "fasta")),
                                    radioButtons("type", "Type:",
                                                 c("Nucleotide" = "DNA",
                                                   "Amino acid" = "AA"))
                   )
  ),
  
  conditionalPanel(condition = "input.tabs=='analyse'",
                   selectInput("recon", "Reconstruction method:",
                               c("Distance" = "dist",
                                 "Maximum Parsimony" = "MP",
                                 "Maximum Likelihood" = "ML")),
                   conditionalPanel(condition = "input.recon=='dist'",
                                    selectInput('dist_method', 'Method:', c("NJ", "BIONJ", "fastME (OLS)", "fastME (BAL)", "UPGMA", "WPGMA") )
                   ),
                   conditionalPanel(condition = "input.recon=='ML'",
                                    tagList(
                                      checkboxInput("inv", "Invariant sites:", FALSE),
                                      checkboxInput("gamma", "Gamma:", FALSE, width="45%"),
                                      numericInput("k", "k:", value=1, min=1, max=20, step=1, width="45%"),
                                      selectInput('ML_model', 'Model:', models),
                                      actionButton("pmlButton", "Compute!")
                                    ) 
                   )
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "about",
            includeMarkdown("about.Rmd")
    ),
    tabItem(tabName = "analyse",
        box(width = NULL, plotOutput("distPlot",height="500px"), collapsible = TRUE,
            title = "Plot", status = "primary", solidHeader = TRUE),  
        box(width = NULL, textOutput("reconText"), collapsible = TRUE, 
            title = "Summary", status = "primary", solidHeader = TRUE)
    )
  )
)

dashboardPage(
  header, 
  sidebar,
  body
)