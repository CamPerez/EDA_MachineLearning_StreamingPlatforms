library(plotly) #Animated graphics
library(tidyverse) #Data science packages
library(dplyr)
library(emojifont) #Emoji icons
library(gridExtra) #Miscellaneous Functions for "Grid" Graphics
library(fmsb) #Radar charts
library(ggradar) #Radar charts
library(formattable) #Format table
library(DT) #Format table
library(htmltools)
library(rgdal) #Read files polygon
library(leaflet) #Color map
library(RColorBrewer) #Color palette
library(rsconnect) #Deploy app
library(ElemStatLearn) #Graphics classification
library(caTools) #MachileLearning
library(class) #MachileLearning
library(caret) #MachileLearning
library(e1071) #MachileLearning
library(randomForest) #MachilerLearning



# Define colors and titles
colors = c("firebrick2", "dodgerblue4", "cyan2", "lightgreen")
titles = c("Netflix", "Prime Video", "Disney +", "Hulu")


#################################################################################
#                           DATA WRANGLING                                      #
#################################################################################

#Export movies dataset, delete unused columns and change column names
movies = read.csv("www/data/movies.csv", encoding = "UTF-8", na.strings=c("",NA)) %>%
  select(-Rotten.Tomatoes, -X) %>%
  rename(
    MediaType = Type,
    Disney = Disney.,
    PrimeVideo = Prime.Video,
    Director = Directors,
    Genre = Genres
  ) %>%
  mutate(Genres = Genre)

#Export tv shows data set
tvshows = read.csv("www/data/tv_shows.csv", encoding = "UTF-8", na.strings=c("", NA)) %>%
  select(-Rotten.Tomatoes) %>%
  rename(
    ID = X,
    MediaType = type,
    Disney = Disney.,
    PrimeVideo = Prime.Video
  )

#Unique ID between movies and tv shows
tvshows$ID = paste("tv", tvshows$ID, sep="_")
movies$ID = paste("mv", movies$ID, sep="_")

#Function to obtain Mode in dataframe variable
Mode <- function(x) {
  ux <- na.omit(unique(x, na.rm = TRUE))
  ux[which.max(tabulate(match(x, ux)))]
}

#Check NA's
naByRow_Movies = as.data.frame(colSums(is.na(movies)))
naByRow_TVShows = as.data.frame(colSums(is.na(tvshows)))

#Change IMDb's NA for the mean score
movies$IMDb = ifelse(is.na(movies$IMDb),
                     ave(movies$IMDb, FUN = function(x) round(mean(x, na.rm = TRUE),2)),
                     movies$IMDb)

tvshows$IMDb = ifelse(is.na(tvshows$IMDb),
                      ave(tvshows$IMDb, FUN = function(x) round(mean(x, na.rm = TRUE),2)),
                      tvshows$IMDb)

#Change Age's NA for the mode
tvshows$Age = ifelse(is.na(tvshows$Age), Mode(tvshows$Age), tvshows$Age)
movies$Age = ifelse(is.na(movies$Age), Mode(tvshows$Age), movies$Age)

#Change Runtime's NA for the mode
movies$Runtime = ifelse(is.na(movies$Runtime), Mode(movies$Runtime), movies$Runtime)

#Change Director, Genre, Country and Language NA for "Unknown"
movies$Director = ifelse(is.na(movies$Director), "Unknown", movies$Director)
movies$Country = ifelse(is.na(movies$Country), "Unknown", movies$Country)
movies$Language = ifelse(is.na(movies$Language), "Unknown", movies$Language)
movies$Genre = ifelse(is.na(movies$Genre), "Unknown", movies$Genre)
movies$Genres = ifelse(is.na(movies$Genres), "Unknown", movies$Genres)

#Outliers
movies$Runtime[movies$Runtime == 1256] = 90

#Binary Variables to Factor
movies = movies %>%
  mutate_at(c("Age", "MediaType", "Netflix", "PrimeVideo", "Disney", "Hulu"), factor)

tvshows = tvshows %>%
  mutate_at(6:10, factor)


#Create new dataset with movies and tv shows
fullcatalog = bind_rows(movies, tvshows) %>%
  select(-Director, -Country, -Language, -Genres, -Genre)

#Separate movie genre in multiple binary variables
movies = movies %>%
  separate_rows(Genre, sep = ",") %>%
  mutate(Value = 1) %>%
  spread(Genre, Value, fill = 0) %>%
  select(-MediaType, -Unknown)

#Binary Variables to Factor
movies = movies %>%
  mutate_at(15:41, factor)


rm(tvshows)



#################################################################################
#                                 IC                                            #
#################################################################################

#¿Qué siglo produce mejores películas/series?
aux = fullcatalog %>%
  mutate(Century = case_when(
    Year <= 2000 ~ "s20",
    Year > 2000 ~ "s21"
  )
  )
aux$Century = as.factor(aux$Century)

catalog_siglo20 = aux %>%
  filter(Century == "s20")

catalog_siglo21 = aux %>%
  filter(Century == "s21")

IC_siglo20 = t.test(catalog_siglo20$IMDb)$conf.int
IC_siglo21 = t.test(catalog_siglo21$IMDb)$conf.int

#¿Qué está mejor valoradas, series o películas?
catalog_series = fullcatalog %>%
  filter(MediaType == 1)

catalog_movies = fullcatalog %>%
  filter(MediaType == 0)

#Las series están mucho mejor votadas que las peliculas
IC_series = t.test(catalog_series$IMDb)$conf.int
IC_movies = t.test(catalog_movies$IMDb)$conf.in

rm(aux, catalog_series, catalog_movies, catalog_siglo20, catalog_siglo21)




#################################################################################
#                     Exploratory data analysis (EDA)                           #
#################################################################################




################## BAR PLOT: Catalog by Platform ##################

#Get number of movies by platform
getCatalogBarPlot = function(selection, year_cat){
  
  catalog = fullcatalog
  

  if(selection == "By Year"){
    catalog = filter(catalog, Year %in% (year_cat[1]:year_cat[2]))
  }
  
  catalogByPlatform = catalog %>%
    group_by(MediaType) %>%
    summarise(across(c("Netflix", "PrimeVideo", "Disney", "Hulu"), 
                     ~sum(.x == 1))) %>%
    pivot_longer(!MediaType, names_to = "Platform", values_to = "count")
  
  bar_plot1 = ggplot(catalogByPlatform, aes(x = Platform, y = count, fill = MediaType)) + 
    geom_bar(stat="identity", 
             width = 0.7, 
             position = position_dodge(width = 0.8)) +
    geom_text(aes(label = count), 
              position = position_dodge(width = 0.8),
              vjust = -0.5,
              size = 6) +
    labs(y = "Number of movies/shows by platform") +
    scale_fill_manual(name="Media Type",
                      labels=c("Movies", "TV Shows"),
                      values=c("chocolate2","darkolivegreen3"))+ 
    theme_classic(base_size = 20)
  
  return(bar_plot1)
}

totalMediaNetflix = sum(fullcatalog$Netflix == 1)
totalMediaPrime = sum(fullcatalog$PrimeVideo == 1)
totalMediaDisney = sum(fullcatalog$Disney == 1)
totalMediaHulu = sum(fullcatalog$Hulu == 1)
###################################################################



################ LOLLIPOP PLOT: Genre by Platform ################

#Create data
getGenreByPlatform = function(platform, name, color){
  genreByPlatform = movies %>%
    select(-`Film-Noir`, -`Game-Show`, -News, -`Reality-TV`, -`Talk-Show`, -Music, -Short, -Crime) %>%
    filter(platform == 1) %>%
    summarise(across(c(Action:Western),
                     ~sum(.x == 1)))  %>%
    pivot_longer(everything(), names_to = "Genre", values_to = "count") %>%
    mutate(countT= sum(count)) %>%
    mutate(percent = round(100*count/countT,2)) %>%
    mutate(Platform = name) %>%
    mutate(Color = color)
}


netflix = getGenreByPlatform(movies$Netflix, "Netflix", colors[1])
prime = getGenreByPlatform(movies$PrimeVideo, "Prime Video", colors[2])
disney = getGenreByPlatform(movies$Disney,"Disney +", colors[3])
hulu = getGenreByPlatform(movies$Hulu, "Hulu", colors[4])
platformGenres = rbind(netflix, prime, disney, hulu)


icons = c(emoji("runner"), emoji("tent"), emoji("bear"),emoji("notebook_with_decorative_cover"),
          emoji("laughing"), emoji("video_camera"), emoji("cry"),
          emoji("family"), emoji("sparkles"), emoji("scroll"), emoji("ghost"),
          emoji("musical_note"), emoji("question"), emoji("heart"), emoji("alien"),
          emoji("football"),  emoji("hocho"), emoji("bomb"), emoji("cowboy_hat_face"))

lollipop_plot = ggplot(platformGenres, aes(x = Genre, y = percent)) +
  geom_segment(aes(x = Genre, xend = Genre, y = 0, yend = percent), 
               color = platformGenres$Color, size = 2) +
  geom_text(aes(label = rep(icons, times = 4)), cex = 4, family='EmojiOne') +
  theme_light() +
  coord_flip() +
  facet_wrap(~Platform, ncol = 4) +
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1), 
                     limits = c(0, 25)) +
  theme(axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        strip.background = element_rect(fill = "tan"),
        strip.text.x = element_text(colour = 'black', size = 10, face = 'bold'),
        panel.spacing = unit(0.2, "lines"))

lollipop_plot1 = ggplotly(lollipop_plot)
###################################################################






#################### LINE PLOT: Genre by year #####################

getGenresByYearLinePlot = function(selected){
  
  genreByYear = movies %>%
    group_by(Year) %>%
    summarise(across(c(14:40),
                     ~sum(.x == 1))) %>%
    pivot_longer(!Year, names_to = "Genre", values_to = "count") %>%
    group_by(Year) %>%
    mutate(countT = sum(count)) %>%
    mutate(percent = round(100*count/countT,2)) %>%
    group_by(Genre) %>%
    filter(Genre %in% selected)
  
  genreByYear$percent <- unlist(genreByYear$percent)
  
  line_plot = ggplotly(
    ggplot(genreByYear) +
      geom_line(aes(x = Year, y = percent, color = Genre)) +
      ylab("% of movies") +
      xlab("Year") +
      theme_minimal()
  )
  
  return(line_plot)
}
###################################################################




################## RADAR PLOT: Age by Platform ####################

getAgeByPlatform = function(platform){
  result = fullcatalog %>%
    filter(platform == 1) %>%
    group_by(Age) %>%
    tally() %>%
    pivot_wider(names_from = "Age", values_from = "n") %>%
    select(all, `7+`, `13+`,`16+`,`18+`) %>%
    rowwise() %>% 
    mutate(Total = sum(c_across(everything()))) %>%
    summarise(across(c("all", "7+", "13+", "16+", "18+"), 
                     ~ round(.x*100/Total, 2)))
  return(result)
}

netflix = getAgeByPlatform(fullcatalog$Netflix)
prime = getAgeByPlatform(fullcatalog$PrimeVideo)
disney = getAgeByPlatform(fullcatalog$Disney)
hulu = getAgeByPlatform(fullcatalog$Hulu)
platformAge = bind_rows(netflix, prime, disney, hulu)
rownames(platformAge) = c("Netflix","Prime Video","Disney +","Hulu")
max_min <- data.frame(
  all = c(100, 0), `7+` = c(100, 0), `13+` = c(100, 0),
  `16+` = c(100, 0), `18+` = c(100, 0),
  check.names=FALSE
)
rownames(max_min) = c("Max", "Min")
platformAge = rbind(max_min, platformAge)

createRadarchart = function(data, color = "#00AFBB", 
                            vlabels = colnames(data), vlcex = 1.2,
                            caxislabels = NULL, title = NULL, ...){
  radarchart(
    data, axistype = 1,
    # Customize the polygon
    pcol = color, pfcol = scales::alpha(color, 0.5), plwd = 3, plty = 1,
    # Customize the grid
    cglcol = "grey", cglty = 1, cglwd = 0.8,
    # Customize the axis
    axislabcol = "grey",
    # Variable labels
    vlcex = vlcex, vlabels = vlabels,
    caxislabels = caxislabels, calcex = 1.2, title = title, ...
  )
}

caxislabels = c(0, 25, 50, 75, 100)
###################################################################




##################### DATA TABLE: Videoclub #######################

#Platform column format
platform_imprv = formatter("span", 
                           x ~ icontext(ifelse(x == 0, "remove", "ok"), ifelse(x == 0, "No", "Yes")),
                           style = x ~ style(color = ifelse(x == 0, "red", "green"))
)

getVideoClubTable = function(minScore, year){
  
  data = movies %>%
    filter(Year %in% (year[1]:year[2]) & IMDb %in% (minScore[1]:minScore[2]))
  
  #Movies formattable table
  moviesFormattable = select(data, Title, Year, Age, IMDb, Netflix, PrimeVideo, Disney, Hulu, Director, Genres, Runtime) %>%
    formattable(align = c("l", rep("r", NCOL(movies) - 1)),
                list(`Title` = formatter("span", 
                                         style = ~ style(color = "black", font.weight = "bold")), 
                     `Netflix` = platform_imprv, 
                     `PrimeVideo` = platform_imprv,
                     `Disney` = platform_imprv,
                     `Hulu` = platform_imprv,
                     area(col = 4) ~ color_tile("red", "green")
                )
    )
  
  
  moviesFormattable = as.datatable(moviesFormattable,
                                   escape = FALSE,
                                   options = list(
                                     pageLength = 10,
                                     lengthMenu = c(5, 10, 15, 20),
                                     order = list(list(2, 'des')),
                                     filter = 'top',
                                     scrollX = TRUE,
                                     autoWidth = TRUE,
                                     columnDefs = list(list(width = 300, targets = list(1)))
                                   )
  )
  
  return(moviesFormattable)
}
###################################################################






##################### MAP: Country movies #########################

# split the 'x' & 'y' columns in lists
xl = strsplit(as.character(movies$Country), ',')
# get the maximum length of the strings for each row
reps = pmax(lengths(xl))
# replicate the rows of 'df' by the vector of maximum string lengths
countryMovies = movies[rep(1:nrow(movies), reps), c("Title", "Country", "IMDb")]
countryMovies$Country = unlist(mapply(function(x,y) c(x, rep(NA, y)), xl, reps - lengths(xl)))
countryMovies %<>%
  group_by(Country) %>%
  summarise(mean = round(mean(IMDb),2), 
            count = n(), 
            best_movie = Title[which(IMDb == max(IMDb))], 
            max_IMDb = max(IMDb), 
            min_IMDb = min(IMDb)) %>% 
  distinct(Country, .keep_all = TRUE)

# Read this shape file with the rgdal library. 
world_spdf <- readOGR( 
  dsn= paste0(getwd(),"/www/data/world_shape_file") , 
  layer="TM_WORLD_BORDERS_SIMPL-0.3",
  verbose=FALSE
)

aux = as.data.frame(world_spdf$NAME)
colnames(aux) = "Country"
aux = left_join(aux, countryMovies, by = "Country")
world_spdf$num_movies = aux$count 
world_spdf$mean_IMDb = aux$mean
world_spdf$max_IMDb = aux$max_IMDb
world_spdf$min_IMDb = aux$min_IMDb
world_spdf$best_movie = aux$best_movie

# Create a color palette with handmade bins.
mybins = c(0,10,20,50,100,500,1000, 1500, Inf)
mypalette = colorBin(palette="YlOrBr", domain=world_spdf@data$num_movies, na.color="transparent", bins=mybins)

# Prepare the text for tooltips:
mytext = paste(
  "<b>Country: </b>", world_spdf@data$NAME, "<br/>", 
  "<b>Nº movies: </b>", world_spdf@data$num_movies, "<br/>", 
  "<b>Average IMDb score: </b>", world_spdf@data$mean_IMDb, "<br/>",
  "<b>Max IMDb score: </b>", world_spdf@data$max_IMDb, "<br/>",
  "<b>Min IMDb score: </b>", world_spdf@data$min_IMDb, "<br/>",
  "<b>Best movie: </b>", world_spdf@data$best_movie, 
  sep="") %>%
  lapply(htmltools::HTML)

# Final Map
leaflet_map = leaflet(world_spdf, options = leafletOptions(scrollWheelZoom = "false")) %>% 
  addTiles()  %>% 
  setView(lat=10, lng=0 , zoom=2) %>%
  addPolygons( 
    fillColor = ~mypalette(num_movies), 
    stroke=TRUE, 
    fillOpacity = 0.9, 
    color="white", 
    weight=0.3,
    label = mytext,
    labelOptions = labelOptions( 
      style = list("font-weight" = "normal", padding = "3px 8px"), 
      textsize = "13px", 
      direction = "auto"
    )
  ) %>%
  addLegend(pal=mypalette, values=~num_movies, opacity=0.9, 
            title = "Nº Movies by country", position = "bottomleft" ) %>%
  addProviderTiles("Esri.WorldGrayCanvas",
                   options = providerTileOptions(minZoom=10, maxZoom=18))

rm(world_spdf, xl, countryMovies, mytext, mypalette)
###################################################################







################# VIOLIN/BOX PLOT: Scores #########################

IMDbByPlatform = fullcatalog %>%
  select(Title, IMDb, Netflix, PrimeVideo, Disney, Hulu) %>%
  pivot_longer(-c(Title,IMDb), names_to = "Platform", values_to = "value") %>%
  filter(value == 1) 


violinbox_plot = IMDbByPlatform %>%
  plot_ly(
    x = ~Platform,
    y = ~IMDb,
    split = ~Platform,
    type = 'violin',
    color = ~Platform,
    colors = c("cyan2", "lightgreen", "firebrick2", "dodgerblue4"),
    box = list(
      visible = T
    ),
    meanline = list(
      visible = T
    )
  )  %>%
  layout(
    xaxis = list(
      title = "Platform"
    ),
    yaxis = list(
      title = "IMDb",
      zeroline = F
    )
  )

rm(IMDbByPlatform)
###################################################################




##################### DATA TABLE: Statics #########################

#Function to generate statics of numeric variables
getStatic = function(var, name, filter){
  
  aux = fullcatalog
  
  if(!missing(filter)){
    aux = filter(aux, filter == 1) 
  }
  
  statics = aux %>%
    summarise_at(c(var), 
                 list(Mean = mean, 
                      Median = median,
                      Max_Value = max, 
                      Min_Value = min,
                      SD = sd,
                      IQR = IQR,
                      IQ_25 = ~quantile(.,0.25, na.rm = TRUE),
                      IQ_50 = ~quantile(.,0.50, na.rm = TRUE),
                      IQ_75 = ~quantile(.,0.75, na.rm = TRUE),
                      N_Unique = n_distinct
                 ), 
                 na.rm = TRUE
    ) %>%
    mutate(Platform = name,
           Variable = var)
  
  return(statics)
}

#Generate differente variables statics by platform
statics = c()
vars = c("IMDb", "Year", "Runtime")
for(i in vars){
  staticsGlobal = getStatic(i, "All platforms")
  staticsNetflix = getStatic(i, "Netflix", fullcatalog$Netflix)
  staticsPrimerVideo = getStatic(i, "Prime Video", fullcatalog$PrimeVideo)
  staticsDisney = getStatic(i, "Disney+", fullcatalog$Disney)
  staticsHulu = getStatic(i, "Hulu", fullcatalog$Hulu)
  statics = rbind(statics, staticsGlobal, staticsNetflix, staticsPrimerVideo, staticsDisney, staticsHulu)
}

statics = statics %>%
  select("Platform", everything())

#Generate table with statics information
getStaticsTable = function(variable){
  
  if(!missing(variable)){
    statics = filter(statics, Variable == variable) 
  }
  
  statics$Mean = round(statics$Mean,2)
  statics$SD = round(statics$SD,2)
  
  #Statics formattable table
  staticsFormattable = select(statics, -Variable) %>%
    formattable(align = c("l", rep("r", NCOL(movies) - 1)),
                list(`Platform` = formatter("span", 
                                            style = ~ style(color = "black", font.weight = "bold"))
                )
    )
  
  
  #Interactive table with datatable library
  staticsFormattable = as.datatable(staticsFormattable,
                                    escape = FALSE,
                                    options = list(
                                      pageLength = 5,
                                      lengthMenu = c(5, 10, 15, 20),
                                      order = list(list(2, 'des')),
                                      filter = 'top',
                                      scrollX = TRUE,
                                      autoWidth = TRUE,
                                      columnDefs = list(list(width = 50, targets = list(1)))
                                    )
  )
  return(staticsFormattable)
}
###################################################################









#################################################################################
#                           MACHINE LEARNING                                    #
#################################################################################


######################### REGRESSION ##############################

#############
#### ACP ####
#############

# Filter data
data_reg = head(movies, 5000) %>%
  pivot_wider(
    names_from = "Age",
    values_from = 'Age',
    values_fill = 0,
    values_fn = function(x) 1) %>%
  select(-all, -ID, -Title, -Director, -Genres, -Country, -Language, -`Talk-Show`, -`Game-Show`, -`Film-Noir`, -`Reality-TV`)

data_reg = data.frame(lapply(data_reg, function(x) as.numeric(as.character(x))))

# Split in training and testing set
set.seed(110)
split = sample.split(data_reg$IMDb, SplitRatio = 0.7)
training_set_reg = subset(data_reg, split == TRUE)
testing_set_reg = subset(data_reg, split == FALSE)

# Scale values
training_set_reg[,-2] = scale(training_set_reg[,-2])
testing_set_reg[,-2] = scale(testing_set_reg[,-2])

# Principal component analysis (PCA)
pca = preProcess(x = training_set_reg[,-2], method = "pca", pcaComp = 2)
training_set_reg = predict(pca, training_set_reg)
training_set_reg = training_set_reg[, c(2, 3, 1)]
testing_set_reg = predict(pca, testing_set_reg)
testing_set_reg = testing_set_reg[, c(2, 3, 1)]

rm(data_reg)

#############
#### MLR ####
#############
# # Multiple linear regression model with training set
regression = lm(formula = IMDb ~ .,
                data = training_set_reg)

summary_mlr = summary(regression)

# Plot MLR prediction
getMLR_Plot = function(set){
  res = ggplot() +
    geom_point(aes(x = set$PC1, y = set$IMDb),
               colour = "red") +
    geom_line(aes(x = set$PC1,
                  y = predict(regression, newdata = set)),
              colour = "blue") +
    ggtitle("Multiple Linear Regression") +
    xlab("CP1") +
    ylab("IMDb Score")

  return(res)
}

MLR_plot_training = getMLR_Plot(training_set_reg)
MLR_plot_testing = getMLR_Plot(testing_set_reg)

#############
#### RF  ####
#############
# Random forest model with training set
regression = randomForest(x = training_set_reg[1],
                          y = training_set_reg$IMDb,
                          ntree = 500)

# Plot RF prediction
getRF_Plot = function(set){
  x_grid = seq(min(set$PC1), max(set$PC1), 0.01)
  res = ggplot() +
    geom_point(aes(x = set$PC1 , y = set$IMDb),
               color = "darkorchid") +
    geom_line(aes(x = x_grid, y = predict(regression,
                                          newdata = data.frame(PC1 = x_grid))),
              color = "goldenrod1") +
    ggtitle("Random Forest Prediction") +
    xlab("CP1") +
    ylab("IMDb Score")
  return(res)
}


RF_plot_training = getRF_Plot(training_set_reg)
RF_plot_testing = getRF_Plot(testing_set_reg)

###################################################################




####################### CLASSIFICATION ############################

#############
#### ACP ####
#############
# Create data with PrimeVideo and Disney movies
data_class = movies %>%
  filter(PrimeVideo == 1 | Disney == 1) %>%
  pivot_wider(
    names_from = "Age",
    values_from = 'Age',
    values_fill = 0,
    values_fn = function(x) 1) %>%
  select(-all, -ID, -Title, -Director, -Genres, -Country, -Language, -Hulu, -Netflix)

data_class = data.frame(lapply(data_class, function(x) as.numeric(as.character(x))))
data_class$Disney = as.factor(data_class$Disney)

# Split in training and testing set
set.seed(110)
split = sample.split(data_class$Disney, SplitRatio = 0.7)
training_set_class = subset(data_class, split == TRUE)
testing_set_class = subset(data_class, split == FALSE)

# Scale values
training_set_class[,-4] = scale(training_set_class[,-4])
testing_set_class[,-4] = scale(testing_set_class[,-4])

# Principal component analysis (PCA)
pca = preProcess(x = training_set_class[,-4], method = "pca", pcaComp = 2)
training_set_class = predict(pca, training_set_class)
training_set_class = training_set_class[, c(2, 3, 1)]
testing_set_class = predict(pca, testing_set_class)
testing_set_class = testing_set_class[, c(2, 3, 1)]

rm(data_class)

#############
#### SVM ####
#############
# SVM model with training set
classifier = svm(formula = Disney ~ .,
                 data = training_set_class,
                 type = "C-classification",
                 kernel = "linear")

# Prediction results testing set
y_pred_svm = predict(classifier, newdata = testing_set_class[,-3])

#Create confusion matrix
cm_svm = as.data.frame(table(testing_set_class[, 3], y_pred_svm))
cm_svm = cm_svm %>%
  rename(
    Target = Var1,
    Prediction = y_pred_svm
  ) %>%
  mutate(Accuracy = ifelse(Prediction == Target, "good", "bad")) %>%
  group_by(Target) %>%
  mutate(prop = Freq/sum(Freq))

# Function to generate plot with a specific set
getSMV_Plot = function(set){
  X1 = seq(min(set[, 1]) - 1, max(set[, 1]) + 1, by = 0.025)
  X2 = seq(min(set[, 2]) - 1, max(set[, 2]) + 1, by = 0.025)
  grid_set = expand.grid(X1, X2)
  colnames(grid_set) = c('PC1', 'PC2')
  y_grid = predict(classifier, newdata = grid_set)
  plot(set[, -3],
       xlab = 'CP1', ylab = 'CP2',
       xlim = range(X1), ylim = range(X2))
  contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)
  points(grid_set, pch = '.', col = ifelse(y_grid==1, 'cyan3', 'goldenrod1'))
  points(set, pch = 21, bg = ifelse(set[, 3] == 1, 'darkslategray1', 'goldenrod2'))
}


#Function to generate confusion matrix plot
getConfusionMatrix_Plot = function(plotTable){
  res = ggplot(data = plotTable, mapping = aes(x = Target, y = Prediction, fill = Accuracy, alpha = prop)) +
    geom_tile() +
    geom_text(aes(label = Freq), vjust = .5, fontface  = "bold", alpha = 1) +
    scale_fill_manual(values = c(good = "forestgreen", bad = "firebrick")) +
    theme_minimal() +
    xlim(rev(levels(plotTable$Target)))

  return(res)
}


#############
#### KNN ####
#############
#KNN model and prediction results
y_pred_knn = knn(train = training_set_class[,-3],
                 test = testing_set_class[,-3],
                 cl = training_set_class[,3],
                 k = 5)

#Create confusion matrix
cm_knn = as.data.frame(table(testing_set_class[, 3], y_pred_knn))
cm_knn = cm_knn %>%
  rename(
    Target = Var1,
    Prediction = y_pred_knn
  ) %>%
  mutate(Accuracy = ifelse(Prediction == Target, "good", "bad")) %>%
  group_by(Target) %>%
  mutate(prop = Freq/sum(Freq))

#Function to generate plot with a specific set
getKNN_Plot = function(set){
  X1 = seq(min(set[, 1]) - 1, max(set[, 1]) + 1, by = 0.01)
  X2 = seq(min(set[, 2]) - 1, max(set[, 2]) + 1, by = 0.01)
  grid_set = expand.grid(X1, X2)
  colnames(grid_set) = c('PC1', 'PC2')
  y_grid = knn(train = training_set_class[,-3],
               test = grid_set,
               cl = training_set_class[,3],
               k = 5)
  plot(set[, -3],
       main = "Movies on Disney+?",
       xlab = 'CP1', ylab = 'CP2',
       xlim = range(X1), ylim = range(X2))
  contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)
  points(grid_set, pch = '.', col = ifelse(y_grid == 1, 'cyan3', 'goldenrod1'))
  points(set, pch = 21, bg = ifelse(set[, 3] == 1, 'darkslategray1', 'goldenrod2'))
}

###################################################################



######################### CLUSTERING ##############################
#Prepare dataset to user

#Separate movie age in multiple binary variables to use for clustering
clustering = movies %>%
  separate_rows(Age, sep = ",") %>%
  mutate(Value = 1) %>%
  spread(Age, Value, fill = 0) %>%
  select(-all, -ID, -Title, -Director, -Genres, -Country, -Language, -Disney, -`Talk-Show`, -`Game-Show`, -`Film-Noir`, -`Reality-TV`)


clustering = as.data.frame(lapply(clustering, function(x) as.numeric(as.character(x))))

# Scale values
clustering = scale(clustering)

#Principal comoponent analysis (PCA)
pca = preProcess(x = clustering, method = "pca", pcaComp = 2)
clustering = predict(pca, clustering)

# Elbow method
set.seed(110)
wcss = vector()
for (i in 1:10){
  wcss[i] <- sum(kmeans(clustering, i)$withinss)
}

# Plot wcss results:
aux = data.frame("Nº of clusters" = c(1:10), "WCSS" = wcss)
elbow_plot = ggplotly(ggplot(aux) +
                        geom_line(aes(x = `Nº.of.clusters`, y = WCSS), size = 1, color = "#69b3a2") +
                        geom_point(aes(x = `Nº.of.clusters`, y = WCSS), color = "darkseagreen4") +
                        labs(title = "Elbow method",
                             y = "WCSS(k)",
                             x = "Nº of clusters (k)") +
                        theme_minimal())

# Kmeans method
set.seed(110)
df_kmeans = kmeans(clustering, 5, iter.max = 300, nstart = 10)
clustering = as.data.frame(clustering)
clustering$Group = as.factor(unlist(df_kmeans$cluster))
levels(clustering$Group) = c("Comedy - Drama", "Documentary", "Horror - Thriller", "Animation - Fantasy", "Family - General")
centers = as.data.frame(df_kmeans$centers)

#Hover text
clustering$Text = paste(
  "<b>Movies: </b>", movies$Title, "<br>",
  "<b>Genres: </b>", movies$Genres, "<br>",
  "<b>Age: </b>", movies$Age, "<br>",
  "<b>IMDb: </b>", movies$IMDb, "<br>",
  "<b>Year: </b>", movies$Year, "<br>",
  "<b>Group: </b>", clustering$Group, "<br>",
  sep="") %>%
  lapply(htmltools::HTML)



#Plot clustering
cluster_pal = RColorBrewer::brewer.pal(n=5, name = "Dark2")
set.seed(110)
cluster_plot = ggplotly(
    ggplot(data = clustering) +
      geom_point(data = clustering, mapping = aes(x = PC1, y = PC2, color = Group, text = Text), size = 1, shape = 21) +
      geom_point(data = centers, aes(x = PC1, 
                            y = PC2),
                 color = "yellow", size = 3) +
      theme_bw() +
      scale_color_manual(values = c(cluster_pal)) +
      scale_fill_manual(values=c(paste(cluster_pal, "66", sep = ""))),
    tooltip = "Text"
    )

rm(aux, df_kmeans, wcss, pca)
###################################################################
