# **Carga y lectura de datos**

El primer paso es la importación de los ficheros *"movies.csv"* y *"tv_shows.csv"* para su posterior limpieza. 

El fichero de *películas* contiene las siguientes variables: 

* **ID:** Código incremental único para cada película. 
* **Title:** Título de la película.
* **Year:** Año de estreno de la película.
* **Age:** Grupo de edad o clasificación la película.  
* **IMDb:** Puntuación media de la película en la base de datos de [IMDb](https://www.imdb.com/).
* **Rotten Tomatoes:** Puntuación media según el sitio web [Rotten Tomatoes](https://rottentomatoes.com/).
* **Netflix, Prime Video, Disney+ y Hulu:** Variables binarias que indican si la película se encuentra o no en dicha plataforma. 
* **Directors:** Directores de la película. Si hay más de uno, están listados en el mismo valor y divididos por coma. 
* **Genres:** Géneros de la película. Si hay más de uno, están listados en el mismo valor y divididos por coma. 
* **Country:** País de la producción de la película. Si hay más de uno, están listados en el mismo valor y divididos por coma. 
* **Language:** Lengua en la que se grabó la película.
* **Runtime:** Tiempo de duración de la película en minutos.
* **Type:** Variable binaria que indica el tipo de contenido. En este caso siempre es '1' ya que todas las observaciones son películas.


Mientras que el fichero de *series* es más reducido en cuanto a columnas:

* **ID:** Código incremental único para cada serie. 
* **Title:** Título de la serie.
* **Year:** Año de estreno de la serie.
* **Age:** Grupo de edad o clasificación de la película.  
* **IMDb:** Puntuación media de la serie en la base de datos de [IMDb](https://www.imdb.com/).
* **Rotten Tomatoes:** Puntuación media según el sitio web [Rotten Tomatoes](https://rottentomatoes.com/).
* **Netflix, Hulu, Prime Video y Hulu:** Variables binarias que indican si la película se encuentra o no en dicha plataforma. 
* **Type:** Variable binaria que indica el tipo de contenido. En este caso siempre es '0' ya que todas las observaciones son series.


En ambos casos se ha eliminado la variable *'Rotten Tomatoes'* debido a su gran número de valores perdidos (NA) y solo se tendrán en cuenta *'IMDb'* como variable para la puntuación.

Adicionalmente, se ha creado un tercer dataframe *fullcatalog* con la unión de los anteriores con la intención de hacer análisis de las variables que tienen en común y poder comparar el catálogo entero de las diferentes plataformas. La unión se ha realizado teniendo en cuenta la variable *Type* que indica el tipo de media (película o serie).

