### Support vector machine (SVM)

Las máquinas de vectores de soporte pertenecen al subcampo del machine learning supervisado que establece un modelo para identificar a qué conjunto de categorías pertenece una observación. Así pues, los problemas de clasificación se realizan sobre una variable discreta.

En este apartado se pretende predecir la variable *Disney*, con el objetivo de averiguar si una película se encontrará en su catálogo o no y, por ejemplo, anticipar el precio o la campaña de marketing antes de que la compañía la compre. Para este caso, el conjunto de datos se ha reducido a 12899 películas que son aquellas que se pueden encontrar actualmente en Disney+ o en Prime Video. La simplificación del problema estudiando los datos de solo dos plataformas se realiza para obtener un resultado que pueda ser analizado en este Dashboard.

Las variables independientes que se tienen en cuenta para el modelo son: 

* Numéricas: *Year* y *Runtime*.
* OneHot: 
  * Clasificación: De las cinco posibles opciones que hay para clasificar el público, se tienen en cuenta solo: *7+*, *13+*, *16+* y *18+*. No se incluye la opción *All* ya que sería redundante.
  * Género: De los diferentes géneros al que puede pertenecer una película, se han dividido y creado como variables de tipo OneHot. En total hay 23 géneros diferentes. 

En total se obtienen 30 variables independientes para predecir *Disney*. Al ser un número elevado de predictores, se hará uso de la técnica del análisis de componentes principales que ayudará a reducir la dimensionalidad del conjunto de datos.

### Escalado y ACP

Como se ha visto en los problemas de regresión, el primer paso será dividir los datos en un conjunto de entrenamiento (70%) y un conjunto de testing (30%).

A continuación, para realizar el análisis de las componentes principales, es necesario escalar el valor de las variables independientes, ya que, otra vez, pueden tomar valores con rangos muy diferentes entre ellas. 

Por último, una vez se obtiene el conjunto de datos de entrenamiento y de prueba escalado, se aplica la técnica de ACP para obtener 2 componentes principales. 


### SVM y Matriz de confusión

Una vez se dispone de las componentes principales a utilizar para predecir la variable dependiente *Disney*, se procede a ajustar el modelo SVM en el conjunto de entrenamiento. En los gráficos de este panel se puede observar el resultado de la clasificación tanto en el conjunto de entrenamiento como en el conjunto de testing en relación a las dos componentes principales obtenidas. 

En color azul celeste se encuentran los puntos que representan que la película sí se puede encontrar en el catálogo de Disney+, mientras que amarillo las que no. En ambos conjuntos se observa la categorización claramente junto con los errores de predicción, ya que no todos los puntos se encuentran en el lado correcto. 

Para especificar con detalle los resultados se representa también la matriz de confusión, una herramienta que permite visualizar el desempeño del algoritmo con cifras. La matriz representa los valores predichos y los reales. El color verde y rojo de fondo ayudan a visualizar el nivel de precisión según su tonalidad. 

En este caso, del total de películas utilizadas en el conjunto de testing, 3701 no se encuentran en el catálogo de la compañía Disney, de las cuales el algoritmo ha predicho que 3661 no lo están y 40 sí. Así pues, estas 40 películas no han sido predichas correctamente. De la misma manera, un total de 169 películas sí están en el catálogo de Disney y el algoritmo ha indicado que 97 lo están y 72 no. En este último caso, el error ha sido mayor.  