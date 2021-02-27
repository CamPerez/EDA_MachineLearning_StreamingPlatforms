# **Introducción y contextualización**

Este Dashboard tiene como objetivo analizar el contenido de las siguientes plataformas de streaming: Netflix, Prime Video, Disney+ y Hulu. Para ello, se ha hecho uso de dos datasets diferentes:

* [Movies on Netflix, Prime Video, Hulu and Disney+](https://www.kaggle.com/ruchi798/movies-on-netflix-prime-video-hulu-and-disney)
* [TV shows on Netflix, Prime Video, Hulu and Disney+](https://www.kaggle.com/ruchi798/tv-shows-on-netflix-prime-video-hulu-and-disney)
                
Ambos indican en qué plataforma se puede encontrar cada una de sus películas o series e incluyen información relevante de cada una de ellas como pueda ser el género, año de estreno, director o la puntuación en [IMDb](https://www.imdb.com/).

Es importante destacar la importancia que han tomado las distintas plataformas de streaming durante el año 2020 con los confinamientos establecidos en diversos países debido a la COVID-19. Tanto el número de usuarios como de visualizaciones se ha multiplicado considerablemente y las plataformas buscan aumentar y mejorar su contenido cada día, ya sea aumentando el catálogo con películas y series de diversos años como de distintos géneros. El catálogo por director, el género, público destinado, el país de producción o incluso el idioma en que se encuentran las películas y series, pueden ser variables determinantes para que un usuario escoga una u otra plataforma.


El Dashboard se ha creado utilizando el paquete [Shiny](https://shiny.rstudio.com/) de **R** con la intención de crear una web app interactiva que refleje el contenido de este análisis descriptivo y estadístico. La estructura del proyecto se divide en los siguientes scripts:

1. **"ui.R":** Interfaz gráfica que acepta los *inputs* del usuario.
2. **"server.R":** Código encargado de procesar los *inputs* y generar los *outputs* que se mostrarán en la aplicación.
3. **"global.R":** Código visible para ambas partes: ui y server.

En el directorio "*www*"" se encuentran todos los recursos utilizados en la aplicación: archivos csv con los dataset, imágenes y archivos markdow con el análisis descrito. 

En este dashboard se podrán encontrar las siguientes secciones: 

* **Carga y limpieza:** Explicación y definición de la construcción y limpieza del modelo de datos.
* **Plataformas:** Análisis exploratorio (EDA) sobre diferentes aspectos de los servicios de streaming estudiados.
* **Géneros y años** Análisis exploratorio en relación a los géneros cinematográficos y años de estrenos.
* **Mapa:** Mapa interactivo con datos por país.
* **Distribución estadísticos:** Análisis exploratorio sobre las puntuaciones de las película/series y resumen de estadísticos.
* **Machine Learning:** Aplicación de diferentes técnicas de Machine Learning: regresión, clasificación y clustering.

