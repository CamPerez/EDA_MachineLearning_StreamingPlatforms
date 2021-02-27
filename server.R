#Define server logic required to draw a histogram
shinyServer(function(input, output) {

  #Checkbox
  valuesCheck1 <- reactiveValues(x = NULL)
  observeEvent(input$check_genreA, valuesCheck1$x <- unique(c(input$check_genreB, input$check_genreA)))
  observeEvent(input$check_genreB, valuesCheck1$x <- unique(c(input$check_genreA, input$check_genreB)))
  
  #Charts EDA
  output$bar_plot1 = renderPlot(getCatalogBarPlot(input$selection, input$year_catalog))
  output$lollipop_plot1 = renderPlotly(lollipop_plot1)
  output$line_plot1 = renderPlotly(getGenresByYearLinePlot(valuesCheck1$x))
  output$radar_plot_netflix = renderPlot(createRadarchart( data = platformAge[c(1, 2, 1+2), ], caxislabels = caxislabels, color = colors[1]))
  output$radar_plot_prime = renderPlot({createRadarchart( data = platformAge[c(1, 2, 2+2), ], caxislabels = caxislabels, color = colors[2])})
  output$radar_plot_disney = renderPlot({createRadarchart( data = platformAge[c(1, 2, 3+2), ], caxislabels = caxislabels, color = colors[3])})
  output$radar_plot_hulu = renderPlot({createRadarchart( data = platformAge[c(1, 2, 4+2), ], caxislabels = caxislabels, color = colors[4])})
  output$violinbox_plot = renderPlotly(violinbox_plot)
  
  
  #Charts Machine Learning
  output$MLR_plot_training = renderPlot(MLR_plot_training)
  output$MLR_plot_testing = renderPlot(MLR_plot_testing)
  output$RF_plot_training = renderPlot(RF_plot_training)
  output$RF_plot_testing = renderPlot(RF_plot_testing)
  
  output$SVM_plot_training = renderPlot(getSMV_Plot(training_set_class))
  output$SVM_plot_testing = renderPlot(getSMV_Plot(testing_set_class))
  output$cm_svm = renderPlot(getConfusionMatrix_Plot(cm_svm))

  output$KNN_plot_training = renderPlot(getKNN_Plot(training_set_class))
  output$KNN_plot_testing = renderPlot(getKNN_Plot(testing_set_class))
  output$cm_knn = renderPlot(getConfusionMatrix_Plot(cm_knn))
   
   output$elbow_plot = renderPlotly(elbow_plot)
   output$cluster_plot = renderPlotly(cluster_plot)
  
  
  #Datatable
  output$na_movies = renderDataTable(naByRow_Movies, options = list(pageLength = 5, dom = 't'))
  output$na_tvshows = renderDataTable(naByRow_TVShows, options = list(pageLength = 5, dom = 't'))
  output$table_videoclub = renderDataTable(getVideoClubTable(input$score, input$year))
  output$table_statics = renderDataTable(getStaticsTable(input$variable))

  
  #Leaflet Map
  output$map = renderLeaflet(leaflet_map)

  })







