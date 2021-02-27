En este panel se representa un mapa coroplético generado con la librería [Leaflet](https://rstudio.github.io/leaflet/shiny.html), donde cada área está marcada con una tonalidad según el número de películas que se han producido en el país. Además, se ha incluido una etiqueta sobre cada país que indica la información siguiente: 

* **Country:** Nombre del país que refleja el área.
* **Nº movies**: Número de películas producidas en el pais. 
* **Average IMDb score:** Puntuación media de todas las películas producidas en dicho pais.
* **Max IMDb score:** Puntuación máxima en IMDb de todas las películas producidas en el pais.
* **Min IMDb score:** Puntuación mínima en IMDb de todas las películas producidas en el pais.
* **Best movie:** Nombre de la pélicula con la puntuación máxima en IMDb producida en el pais.

*Ya que una película puede estar producida en varios países, la misma película se ha contabilizado como propia de todos ellos.*

Se observa que el área más oscura es Estados Unidos con 10486 películas, seguido del Reino Unido con 1713 y la India con 1157. En sudamerica el que más películas produce es Argentina, mientras que en África es Sudáfrica y en Oceania es Australia.

