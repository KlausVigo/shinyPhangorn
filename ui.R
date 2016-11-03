
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

if(!require("shiny")) stop("package shiny is required")

models <- c("JC", "F81", "K80", "HKY", "SYM", "GTR")

shinyUI(
  navbarPage("shinyPhangorn", position="fixed-top", collapsible = TRUE,
                   theme = "bootstrap.simplex.css", 

  tabPanel("Analyse",                   

# Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
        h2(HTML('<font color="#6C6CC4" size="5"> > Input </font>')),
        radioButtons("datasource", HTML('<font size="4"> Choose data source:</font>'),
          list("Example: Laurasiatherian"="exLaura", 
#               "Example: chloroplast"="exChloroplast",
               "Input file"="file")),
                       
        ## choice of dataset if source is a file
       conditionalPanel(condition = "input.datasource=='file'",
          fileInput("file1", "Load alignment"),
          radioButtons("format", "Format:",
             c("Phylip" = "phylip",
               "Nexus" = "nexus",
               "FASTA" = "fasta")),
          radioButtons("type", "Type:",
             c("Nucleotide" = "DNA",
             "Amino acid" = "AA"))
         ),
#      hr(),
      h2(HTML('<font color="#6C6CC4" size="5"> > Inference </font>')),
      selectInput("recon", "Reconstruction method:",
                  c("Distance" = "dist",
                    "Maximum Parsimony" = "MP",
                    "Maximum Likelihood" = "ML")), 
      
      conditionalPanel(condition = "input.recon=='dist'",
          selectInput('dist_method', 'Method:',
                      c("NJ", "BIONJ", "fastME (OLS)", "fastME (BAL)", "UPGMA", "WPGMA") )
      ),
      
      conditionalPanel(condition = "input.recon=='ML'",

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
  ), # end tabPanel
tabPanel("About",
         HTML("
              <p>shinyPhangorn is ansimple  interface to infer phylogentic trees using the               R packages ape and phangorn.</p>
              <p>It is possible to run it from within R:</p>
              <p><code>shiny::runGitHub('shinyPhangorn', 'KlausVigo')</code></p>
              
              <p>The source code of shinyPhangorn is available on <a
              href='https://github.com/KlausVigo/shinyPhangorn'>GitHub</a>. shinyPhangorn
              is in early development so I am happy to recieve suggestions or bug reports. </p>
              <p> </p>
              <p><strong>References</strong> </p>
              <p><a href='http://www.rstudio.com/shiny'>shiny</a></p>
              <p><a href='http://ape-package.ird.fr/'>ape</a> </p>
              <p><a href='http://cran.r-project.org/web/packages/phangorn/'>phangorn</a></p>
              <p></p>
              <p><strong>License</strong> </p>
              <p>shinyPhangorn is licensed under the GPLv3. </p>
              ")
)

))
