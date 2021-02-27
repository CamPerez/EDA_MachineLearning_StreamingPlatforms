### K-Means Clustering 

Al contrario que en los casos anteriores, en este panel se hará hincapié en uno de los algoritmos del machine learning no supervisado: el clustering. Este método pretende clasificar los datos de entrada no etiquetados mediante la búsqueda de patrones o relaciones entre ellos.

En este caso se han tenido en cuenta todas las observaciones del tipo película del dataset (16774).

Las variables que se tienen en cuenta para el modelo son: 

* Numéricas: *IMDb*, *Year* y *Runtime*.
* OneHot: 
  * Plataformas: *Netflix*, *Hulu*, *PrimeVideo*, *Disney*. Una película puede estar en varias plataformas a la vez, por lo que no son excluyentes entre si y se tienen en cuenta todas ellas.
  * Clasificación: De las cinco posibles opciones que hay para clasificar el público, se tienen en cuenta solo: *7+*, *13+*, *16+* y *18+*. No se incluye la opción *All* ya que sería redundante.
  * Género: De los diferentes géneros al que puede pertenecer una película, se han dividido y creado como variables de tipo OneHot. En total hay 23 géneros diferentes. 

En total se obtienen 34 variables independientes para predecir *IMDb*. Al ser un número elevado de predictores, se hará uso de la ténica del análisis de componentes principales que ayudará a reducir la dimensionalidad del conjunto de datos.

### Escalado, ACP y K-means

En el clustering, al ser un algoritmo supervisado, no es necesario separar los datos en conjunto de entrenamiento y testing, sino que en este caso el análisis de las componentes principales se aplicará al conjunto entero, escalando los valores previamente. 

Una vez se han obtenido 2 componentes principales, se utilizarán como entrada para que el clustering pueda clasificar los datos de salida. La técnica de K-means agrupa los resultados en *k* grupos. Para obtener el número óptimo de *k* se ha hecho uso del método del codo representado en este panel. Se escoge pues el punto en donde ya no se producen variaciones importantes del valor de WCSS (within-cluster sums of squares). En este caso, k = 5 será el valor adoptado para representar el clustering.


### Representación

Aplicando el número seleccionado de clusters al algoritmo se obtiene la representación de clusters visible en este panel. 

Cada uno de estos clusters contiene diferentes películas que han sido agrupadas por distintos patrones o relaciones. Para ayudar a visualizar las características del cluster se ha agregado un *tooltip* que al pasar el puntero por cada punto nos diga qué pélicula es, sus géneros, año de estreno y clasificación por edad del público. Los puntos amarillos representan el baricentro de cada cluster o grupo. 

Como se puede observar, a cada uno de los grupos se le ha asignado un nombre intuitivo en relación al género o estilo de la película, pero es no significa que todas las películas de dicho grupo contengan ese género. Por ejemplo, en el grupo rosa llamado "Animation - Fantasy" podemos encontrar en su mayoría películas de animación clasificadas para todos los públicos o para los más jóvenes, como por ejemplo "Aladdin", "Las Crónicas de Narnia", "Los 101 dálmatas", "Big Hero 6"... 

En el grupo morado "Horror - Thriller" se encuentran películas dirigidas en su mayoría a un público +16 o +18, cuyos géneros están relacionados con el terror, el thriller o el misterio ("Criminally Insane", "La casa del exorcismo", "Horror Hospital"). El grupo naranja, por el contrario, engloba documentales, biografías o similares. Por últimos, los grupos restantes se han dividido en "Comedy - Drama" ya que engloba en su mayoría películas de este estilo para un público +16 y en "Family -General", ya que son películas enfocadas a todos los públicos y al género 'Family'.