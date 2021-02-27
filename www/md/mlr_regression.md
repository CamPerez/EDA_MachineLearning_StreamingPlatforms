### Regresión Lineal Múltiple

El análisis de regresión es uno de los subcampos del machine learning supervisado que establece un modelo para la relación entre diversas variables independientes y una variable dependiente continua. 

En este apartado se pretende predecir la variable de puntuación de las películas de las plataformas de streaming en IMDb con el modelo de regresión lineal múltiple. Para este caso, el conjunto de datos se ha reducido a 5000 películas para que sea reproducible en la memoria del Dashboard. 

Las variables que se tienen en cuenta para el modelo son: 

* Numéricas: *Year* y *Runtime*.
* OneHot: 
  * Plataformas: *Netflix*, *Hulu*, *PrimeVideo*, *Disney*. Una película puede estar en varias plataformas a la vez, por lo que no son excluyentes entre ellas y se tienen en cuenta todas ellas.
  * Clasificación: De las cinco posibles opciones que hay para clasificar el público, se tienen en cuenta solo: *7+*, *13+*, *16+* y *18+*. No se incluye la opción *All* ya que sería redundante.
  * Género: De los diferentes géneros al que puede pertenecer una película, se han dividido y creado como variables de tipo OneHot. En total hay 23 géneros diferentes. 

En total se obtienen 34 variables independientes para predecir *IMDb*. Al ser un número elevado de predictores, se hará uso de la ténica del análisis de componentes principales que ayudará a reducir la dimensionalidad del conjunto de datos.

### Escalado y ACP

Como se ha mencionado, la regresión lineal múltiple es un algoritmo de aprendizaje supervisado, por lo que el primer paso será dividir los datos en un conjunto de entrenamiento (70%) y un conjunto de testing (30%).

A continuación, para realizar el análisis de las componentes principales, es necesario escalar el valor de las variables independientes, ya que, en este caso, pueden tomar valores con rangos muy diferentes entre ellas. 

Por último, una vez se obtiene el conjunto de datos de entrenamiento y de prueba escalado, se aplica la técnica de ACP para obtener 2 componentes principales cuya proyección representen los datos en términos de mínimos cuadrados. 


### Representación

Una vez se dispone de las componentes principales a utilizar para predecir la variable dependiente *IMDb*, se procede a ajustar el modelo de la regresión múltiple en el conjunto de entrenamiento. En los gráficos de este panel se puede observar el resultado de la regresión tanto en el conjunto de entrenamiento como en el conjunto de testing en relación a la componente principal 1, que es la más representativa del modelo. 

Los puntos rojos representan las puntuaciones de las películas del conjunto de datos, mientras que la línea azul representa la recta que mejor se ajusta a ellos.

En este caso, el modelo formado no es bueno para predecir la puntuación, pues las variables predictoras no explican en gran medida el valor de *IMDb*. 