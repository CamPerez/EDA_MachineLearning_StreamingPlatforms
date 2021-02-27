# **Estructura del modelo de datos**

A continuación se muestra la estructura final del modelo de datos con los nombres finales y el tipo de variable tras las transformaciones pertinentes: 

* **ID:** Variable cuantitativa discreta que identifica cada película/serie.
* **Title:** Variable cualitativa que representa el título de cada una de las películas/series identificadas con un ID en la variable “ID”.
* **Year:** Variable cuantitativa discreta que determina el año de estreno de la película.
* **Age:** Variable cualitativa ordinal que determina el grupo de edad al que está dirigida la película/serie. Los valores ordenados son: "All", "+7","+13","+16" y "+18".
* **IMDb:** Variable cuantitativa continua que representa la calificación media de la película/serie.
* **Netflix, Hulu, PrimeVideo y Hulu:** Variables cuantitativas que indican si la película se encuentra o no en dicha plataforma. 
* **Directors:** Variable cualitativa nominal que indica el director. Solo disponible para películas.
* **Genres:** Variable cualitativa nominal que indica el género de la película. Solo disponible para películas.
* **Country:** Variable cualitativa nominal que indica el país de la producción de la película. Solo disponible para películas.
* **Language:** Variable cualitativa nominal que indica el idioma en la que se grabó la película.
* **Runtime:** Variable cuantitativa discreta que indica en minutos la duración de la película.
* **MediaType:** Variable cuantitativa binaria que indica el tipo de contenido ("1" para las películas y "0" para las series). 

