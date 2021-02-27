library(shinydashboard) #Dashboard
library(shinyWidgets) #Drowdown button
library(shinycssloaders) #Load spinner

#Dashboard SideBar element
sideBar = dashboardSidebar(
    
    #Styles
    tags$style(HTML(".js-irs-0 .irs-single, .js-irs-0 .irs-bar-edge, .js-irs-0 .irs-bar {background: teal}")),
    tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
    
    #Sidebar
    sidebarMenu(
        HTML(paste0(
            "<br>",
            "<img style = 'display: block; margin-left: auto; margin-right: auto;' src='imgs/tv-icon.png' width = '186'>",
            "<br>"
        )),
        menuItem("Introducción", tabName = "about", icon = icon("info")),
        menuItem("Carga y limpieza", tabName = "data", icon = icon("database")),
        menuItem("Plataformas", icon = icon("tv"), startExpanded = TRUE,
                 menuSubItem("Catálogo", tabName = "barplot", icon = icon("chart-bar")),
                 menuSubItem("Público", tabName = "radar", icon = icon("spider")),
                 menuSubItem("Videoclub", tabName = "videoclub", icon = icon("sliders"))
                 ),
        menuItem("Géneros y años", tabName = "genres", icon = icon("search")),
        menuItem("Mapa", tabName = "map", icon = icon("globe-americas")),
        menuItem("Distribución estadísticos", tabName = "score", icon = icon("stream")),
        menuItem("Machine Learning", icon = icon("brain"), startExpanded = TRUE,
                 menuItem("Regresión", icon = icon("chart-line"),
                          menuSubItem("MLR", tabName = "regression_mlr"),
                          menuSubItem("Random Forest (RF)", tabName = "regression_rf")
                          ),
                 menuItem("Clasificación", icon = icon("object-group"),
                          menuSubItem("SVM", tabName = "classification_svm"),
                          menuSubItem("K-NN", tabName = "classification_knn")
                          ),
                 menuSubItem("Clustering", tabName = "clustering", icon = icon("boxes"))
                 
        )
    )
)
   
#Dashboard body
body = dashboardBody(
    
    # shinyDashboardThemes(
    #     theme = "grey_dark"
    # ),
    
    tabItems(
        # First tab content
        tabItem(tabName = "about",
                fluidRow(box(width = 12, 
                             solidHeader = TRUE,
                             div(style="text-align:justify",includeMarkdown("www/md/about.md"),
                                  HTML(paste0(
                                      "<br>",
                                      "<img style = 'display: block; margin-left: auto; margin-right: auto;' src='imgs/header2.gif' width = '50%'>",
                                      "<br>"))
                                  )
                             )
                         )
                ),
        
        # Second tab content
        tabItem(tabName = "data",
                fluidRow(
                    box(width = 12,
                        solidHeader = TRUE,
                        div(style="text-align:justify", includeMarkdown("www/md/data.md"))
                        )
                    ),
                fluidRow(
                    box(width = 4,
                        title = "Tratando los valores NA (Not Available) y valores atípicos",
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        div(style="text-align:justify", includeMarkdown("www/md/data_na.md"))
                    ), 
                    box(width = 4,
                        title = "Número de NA's en la tabla 'movies'",
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        dataTableOutput("na_movies")
                    ),
                    box(width = 4, 
                        title = "Número de NA's en la tabla 'tvshows'",
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        dataTableOutput("na_tvshows")
                    )
                ),
                fluidRow(
                    box(width = 12,
                        solidHeader = TRUE,
                        div(style="text-align:justify", includeMarkdown("www/md/data_structure.md"))
                    )
                ),
                fluidRow(
                    valueBox(3, "DataSet", icon = icon("database"), color = "yellow"),
                    valueBox(15, "Variables", icon = icon("table"), color = "maroon"),
                    valueBox(nrow(fullcatalog), "Observaciones en total", icon = icon("tv"), color = "yellow")
                    )
                ),
        
        # Chart tab content
        tabItem(tabName = "barplot",
                fluidRow(
                    box(title = "Catálogo por plataforma de streaming",
                                  solidHeader = TRUE,
                                  width = 8,
                        column(width = 12, withSpinner(plotOutput("bar_plot1", height = 600),
                                                       type = 1,
                                                       color = "orange")
                               )
                        ),
                    
                    column(width = 4,
                        fluidRow(box(title = "Catálogo por año",
                            solidHeader = TRUE,
                            collapsible = TRUE,
                            background = "yellow",
                            width = 12,
                            column(width = 12,
                                   selectInput("selection", "Escoge una opción", choices = c("Total", "By Year")),
                                   conditionalPanel(
                                       "input.selection == 'By Year'",
                                       sliderInput("year_catalog", "Año de estreno:",
                                                   min = 1901, max = 2020,
                                                   step = 1, sep = "",
                                                   value = c(1901,2020)
                                       )
                                   )
                            )
                        )),
                        fluidRow(valueBox(width = 12, sum(fullcatalog$PrimeVideo == 1), "Total películas y series en Prime Video", color = "blue", icon = icon("film"))),
                        fluidRow(valueBox(width = 12, sum(fullcatalog$Netflix == 1), "Total películas y series en Netflix", color = "red",icon = icon("tv"))),
                        fluidRow(valueBox(width = 12, sum(fullcatalog$Disney == 1), "Total películas y series en Disney+", color = "aqua", icon = icon("fort-awesome"))),
                        fluidRow(valueBox(width = 12, sum(fullcatalog$Hulu == 1), "Total películas y series en Hulu", color = "olive", icon = icon("play")))
                    )
                ),
                fluidRow(
                    box(width = 12, 
                        title = "¿Qué plataforma tiene el catálogo más amplio?",
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        div(style="text-align:justify",includeMarkdown("www/md/barplot_catalog.md"))
                    )
                )
        ),
        
        # Chart tab content
        tabItem(tabName = "radar",
                fluidRow(
                    column(
                        width = 8,
                        fluidRow(
                            width = 12,
                            box(title = "Netflix",
                                solidHeader = TRUE,
                                status = "danger",
                                width = 6,
                                column(width = 12, withSpinner(plotOutput("radar_plot_netflix"),
                                                               type = 1,
                                                               color = "orange"))
                            ),
                            box(title = "Prime Video",
                                solidHeader = TRUE,
                                status = "primary",
                                width = 6,
                                column(width = 12, withSpinner(plotOutput("radar_plot_prime"),
                                                               type = 1,
                                                               color = "orange"))
                            )
                        ),
                        fluidRow(
                            width = 12,
                            box(title = "Disney+",
                                solidHeader = TRUE,
                                status = "info",
                                width = 6,
                                column(width = 12, withSpinner(plotOutput("radar_plot_disney"),
                                                               type = 1,
                                                               color = "orange"))
                            ),
                            box(title = "Hulu",
                                solidHeader = TRUE,
                                status = "success",
                                width = 6,
                                column(width = 12, withSpinner(plotOutput("radar_plot_hulu"),
                                                               type = 1,
                                                               color = "orange"))
                            )
                        )
                    ),
                    column(
                        width = 4,
                        fluidRow(
                            box(width = 12,
                                title = "¿A qué público esta dirigida cada plataforma?",
                                solidHeader = TRUE,
                                div(style="text-align:justify", includeMarkdown("www/md/radarplot_age.md"))
                                )
                            )
                        )
                    )
                ),
        
        # Chart tab content
        tabItem(tabName = "table",
                h3("¿Qué películas podemos encontrar en cada plataforma?"),
                
        ),
        
        # Chart tab content
        tabItem(tabName = "genres",
                fluidRow(
                    box(title = "Géneros cinematográficos en cada plataforma",
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        width = 12,
                        column(width = 12,  withSpinner(plotlyOutput("lollipop_plot1", height = 500),
                                                        type = 1,
                                                        color = "orange"))
                    )
                ),
                fluidRow(
                    box(width = 12,
                        title = "¿Qué género predomina en cada plataforma?",
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        div(style="text-align:justify", includeMarkdown("www/md/lollipop_genres.md"))
                    )
                ),
                fluidRow(
                    column(width = 4,
                           box(width = 12,
                               solidHeader = TRUE,
                               dropdownButton(
                                   icon = icon("sliders"),
                                   status = "warning",
                                   circle = FALSE,
                                   label = "Selecciona los géneros a representar",
                                   tags$label("Géneros:"),
                                   fluidRow(
                                       column(
                                           width = 6,
                                           checkboxGroupInput(
                                               inputId = "check_genreA",
                                               label = NULL,
                                               choices = names(movies[15:28]),
                                               selected = c("Drama", "Film-Noir", "Animation")
                                           )
                                       ),
                                       column(
                                           width = 6,
                                           checkboxGroupInput(
                                               inputId = "check_genreB",
                                               label = NULL,
                                               choices = names(movies[29:41]),
                                               selected = c("Western")
                                           )
                                       )
                                   )
                               )
                           ),
                           box(width = 12,
                               solidHeader = TRUE,
                               div(style="text-align:justify", includeMarkdown("www/md/lineplot_genrebyyear.md"))
                           )
                    ),
                    column(width = 8,
                           box(title = "¿Destaca algún género cinematográfico en algún año?",
                               solidHeader = TRUE,
                               width = 12,
                               column(width = 12, withSpinner(plotlyOutput("line_plot1", height = 500),
                                                              type = 1,
                                                              color = "orange"))
                               )
                           )
                    )
        ),
        
        # Chart tab content
        tabItem(tabName = "videoclub",
                fluidRow(
                    box(
                        width = 6, 
                        title = "Nota mínima (IMDb)",
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        status = "warning",
                        sliderInput(
                            "score", "Indica una nota",
                            min = 0, max = 10,
                            value = c(5,10))
                           ),
                    box(
                        width = 6, 
                        title = "Año de estreno",
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        status = "warning",
                        sliderInput(
                            "year", "Indica un rango",
                            min = 1900, max = 2020, step = 1, sep = "",
                            value = c(1950,2000))
                           )
                ),
                fluidRow(
                    box(
                        width = 12,
                        withSpinner(dataTableOutput("table_videoclub"),
                                    type = 1,
                                    color = "orange")
                        )
                    ),
                fluidRow(
                    box(
                        solidHeader = TRUE,
                        width = 12,
                        div(style="text-align:justify", includeMarkdown("www/md/videoclub.md"))
                        )
                    ),
                fluidRow(
                    box(
                        width = 6,
                        status = "primary",
                        title = "¿Película o serie?",
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        div(style="text-align:justify", includeMarkdown("www/md/ic_movietvshow.md"))
                        ),
                    box(
                        width = 6,
                        status = "primary",
                        title = "¿Antigua o moderna?",
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        div(style="text-align:justify", includeMarkdown("www/md/ic_century.md"))
                        )
                    )
                ),
        
        # 4 tab content
        tabItem(tabName = "map",
                fluidRow(
                    box(
                        width = 12,
                        solidHeader = TRUE,
                        withSpinner(leafletOutput("map"),
                                    type = 1,
                                    color = "orange")
                        )
                ),
                fluidRow(
                    box(
                        width = 12,
                        solidHeader = TRUE,
                        div(style="text-align:justify", includeMarkdown("www/md/map.md"))
                    )
                )
        ),
        
        # 4 tab content
        tabItem(tabName = "score",
                fluidRow(
                    box(
                        title = "Distribución IMDb por servicio de streaming",
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        width = 12,
                        column(width = 12, withSpinner(plotlyOutput("violinbox_plot", height = 500),
                                                       type = 1,
                                                       color = "orange"))
                    )
                ),
                fluidRow(
                    box(
                        width = 12,
                        title = "¿Cómo se distribuye la puntuación IMDb por plataforma?",
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        div(style="text-align:justify", includeMarkdown("www/md/violinboxplot_platforms.md"))
                    )
                ),
                fluidRow(
                    column(
                        width = 6,
                        box(
                            width = 12,
                            solidHeader = TRUE,
                            background = "yellow",
                            column(12,
                                   selectInput("variable",
                                               "Variable:",
                                               c("IMDb", "Year", "Runtime"))
                            )
                        ),
                        box(
                            width = 12,
                            withSpinner(dataTableOutput("table_statics"),
                                        type = 1,
                                        color = "orange")
                        )
                    ),
                    column(
                        width = 6,
                        fluidRow(
                            box(
                                width = 12,
                                solidHeader = TRUE,
                                collapsible = TRUE,
                                div(style="text-align:justify", includeMarkdown("www/md/staticstable.md"))
                                )
                            )
                        )
                    )
                ),
                
        # 5 tab content
        tabItem(tabName = "regression_mlr",
                fluidRow(
                    box(
                        solidHeader = TRUE,
                        width = 12,
                        div(style="text-align:justify", includeMarkdown("www/md/mlr_regression.md"))
                        )
                    ),
                fluidRow(
                    box(
                        title = "Conjunto de entrenamiento",
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        width = 6,
                        withSpinner(plotOutput("MLR_plot_training"),
                                    type = 1,
                                    color = "orange")
                    ),
                    box(
                        title = "Conjunto de testing",
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        width = 6,
                        withSpinner(plotOutput("MLR_plot_testing"),
                                    type = 1,
                                    color = "orange")
                    )
                )
        ),
        
        # 5 tab content
        tabItem(tabName = "regression_rf",
                fluidRow(
                    box(
                        solidHeader = TRUE,
                        width = 12,
                        div(style="text-align:justify", includeMarkdown("www/md/rf_regression.md"))
                    )
                ),
                fluidRow(
                    box(
                        title = "Conjunto de entrenamiento",
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        width = 6,
                        withSpinner(plotOutput("RF_plot_training"),
                                    type = 1,
                                    color = "orange")
                    ),
                    box(
                        title = "Conjunto de testing",
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        width = 6,
                        withSpinner(plotOutput("RF_plot_testing"),
                                    type = 1,
                                    color = "orange")
                    )
                )
        ),
        
        # 6 tab content
        tabItem(tabName = "classification_svm",
                fluidRow(
                    column(
                        width = 6,
                        box(
                           width = 12,
                           solidHeader = TRUE,
                           div(style="text-align:justify", includeMarkdown("www/md/svm_classification.md"))
                       )
                    ),
                    column(
                        width = 6,
                        box(
                           title = "SVM (Conjunto de entrenamiento)",
                           solidHeader = TRUE,
                           width = 12,
                           withSpinner(plotOutput("SVM_plot_training"),
                                        type = 1,
                                        color = "orange")
                        ),
                        box(
                           title = "SVM (Conjunto de test)",
                           solidHeader = TRUE,
                           width = 12,
                           withSpinner(plotOutput("SVM_plot_testing"),
                                       type = 1,
                                       color = "orange")
                        ),
                        box(
                            title = "Matriz de confusión",
                            width = 12,
                            solidHeader = TRUE,
                            collapsible = TRUE,
                            withSpinner(plotOutput("cm_svm"),
                                        type = 1,
                                        color = "orange")
                        )
                    )
                )
        ),

        # 7 tab content
        tabItem(tabName = "classification_knn",
                fluidRow(
                    column(
                        width = 6,
                        box(
                            title = "KNN (Conjunto de entrenamiento)",
                            width = 12,
                            solidHeader = TRUE,
                            withSpinner(plotOutput("KNN_plot_training"),
                                        type = 1,
                                        color = "orange")
                        ),
                        box(
                            title = "KNN (Conjunto de test)",
                            width = 12,
                            solidHeader = TRUE,
                            withSpinner(plotOutput("KNN_plot_testing"),
                                        type = 1,
                                        color = "orange")
                        )
                    ),
                    column(
                        width = 6,
                        box(width = 12,
                            solidHeader = TRUE,
                            div(style="text-align:justify", includeMarkdown("www/md/knn_classification.md"))
                        ),
                        box(
                            title = "Matriz de confusión",
                            width = 12,
                            solidHeader = TRUE,
                            collapsible = TRUE,
                            withSpinner(plotOutput("cm_knn"),
                                        type = 1,
                                        color = "orange")
                        )
                    )
                )
        ),

        # 8 tab content
        tabItem(tabName = "clustering",
                fluidRow(
                    box(
                        width = 12,
                        solidHeader = TRUE,
                        div(style="text-align:justify", includeMarkdown("www/md/clustering.md"))
                    )
                ),
                fluidRow(
                    box(
                        width = 8,
                        title = "Clustering",
                        solidHeader = TRUE,
                        withSpinner(plotlyOutput("cluster_plot"),
                                    type = 1,
                                    color = "orange")
                    ),
                    box(
                        width = 4,
                        title = "Método del codo",
                        solidHeader = TRUE,
                        withSpinner(plotlyOutput("elbow_plot"),
                                    type = 1,
                                    color = "orange")
                    )
                )
        )
    )
)


dashboardPage(
    
    dashboardHeader(title = "Streaming Platforms"),
    sideBar,
    body
)




