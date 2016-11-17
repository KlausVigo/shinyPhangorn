library(shinydashboard)
library(phangorn)


aa_models <- c("WAG", "LG", "JTT")
dna_models <- c("JC", "F81", "K80", "HKY", "SYM", "GTR")

dist_choices <- c("nj", "bionj", "fastME.ols", "fastME.bal", "upgma", "wpgma")  

dist_tree <- function(x, type) {
  switch(type,
         "NJ" = nj(x),
         "BIONJ" = bionj(x),
         "fastME (OLS)" = fastme.ols(x),
         "fastME (BAL)" = fastme.bal(x, nni=TRUE, spr = FALSE, tbr = FALSE),
         "UPGMA" = upgma(x), 
         "WPGMA" = wpgma(x))  
}


shinyServer(function(input, output) {

  if(!require("ape")) stop("package ape is required")
  if(!require("phangorn")) stop("package phangorn is required")
  if(!require("phytools")) stop("package phytools is required")
  if(!require("magrittr")) stop("package magrittr is required")
  
  
  getDataType <- reactive({
    input$datasource
  })
  
  getData <- reactive({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    dataType <- getDataType()
    if(dataType=="exLaura"){
      data("Laurasiatherian")
      align <- Laurasiatherian
    }
#    if(dataType=="exChloroplast"){
#      data("chloroplast")
#      align <- chloroplast
#    }
    if(dataType=="file"){
      inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
      align <- read.phyDat(inFile$datapath, format=input$format, type = input$type)
    }  
    return(align)
  })
# renderTable  
  
  
  output$reconText <- renderText({ input$recon })
    
  output$distPlot <- renderPlot({
    align <- isolate(getData())  
    input$goButton
        if(input$recon=="dist"){
        if(!is.null(align)){
          dm <- dist.ml(align)
          tree <- dist_tree(dm, type=isolate(input$dist_method))
          tree <- ladderize(tree)
          if(is.rooted(tree)) plot(tree)
          else  plot(tree, "u")
          add.scale.bar()
        }
      }
      if(input$recon=="MP"){
        if(!is.null(align)){
          dm <- dist.ml(align)
          tree <- nj(dm)
          tree <- optim.parsimony(tree, align)
          tree <- acctran(tree, align)
          tree <- ladderize(tree)
          plot(tree, "u")
          add.scale.bar()
        }
      }  
      if(input$recon=="ML"){
        if(!is.null(align)){
         dm <- dist.ml(align)
         tree <- nj(dm)
         fit <- pml(tree, align, k=input$k)
         fit <- optim.pml(fit, rearrangement = "NNI", model=input$ML_model, optInv = input$inv, optGamma = input$gamma)
         tree <- ladderize(fit$tree)
         plot(tree, "u")
         add.scale.bar()
#         output$reconText <- renderText({ print(fit) })
        }
      }
  })
    
#  output$distPlot <- renderPlot({

    # generate bins based on input$bins from ui.R
#    x    <- faithful[, 2]
#    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
#    hist(x, breaks = bins, col = 'darkgray', border = 'white')

#  })

})
