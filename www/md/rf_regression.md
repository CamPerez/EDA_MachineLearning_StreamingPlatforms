### Random Forest

En este panel se ejecuta otro de los algoritmos de regresión para predecir la variable *IMDb*: Random Forest o Árboles aleatorios. Este algoritmo es una combinación de múltiples árboles predictores de tal manera que se obtiene una gran colección de ellos (bosque) y se realiza un promedio de todos para predecir la variable. 

Para este modelo y con el objetivo de comparar los resultados, se ha utilizado el mismo conjunto de entrenamiento y de testing generados en el apartado anterior de la regresión lineal múltiple. 


### Representación

Utilizando las componentes principales calculadas anteriormente se procede a ajustar el modelo de Random Forest en el conjunto de entrenamiento calculado con un total de 500 árboles. En los gráficos de este panel se puede observar el resultado tanto en el conjunto de entrenamiento como en el conjunto de testing en relación a la componente principal 1. 

Los puntos púrpuras representan las puntuaciones de las películas del conjunto de datos, mientras que la línea amarilla representa la recta que mejor se ajusta a ellos.

Como se observa y, comparando los resultados obtenidos con la regresión lineal múltiple, la predección es muy similar, con saltos más visibles en la parte central que es donde hay más dispersión en las diferentes puntuaciones de las películas. Es ligeramente visible también al inicio de la linea los saltos más escalonados que sigue este modelo a diferencia de la regresión lineal múltiple.