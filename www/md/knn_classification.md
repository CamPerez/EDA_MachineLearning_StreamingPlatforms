### K-NN (K Nearest Neighbours)

Otro de los algoritmos de machine learning para la clasificación es el de los K vecinos más cercaos o K-NN (K Nearest Neighbours). De la misma forma que con SVM, este es un algortimo supervisado y se utilizarán los conjuntos de training y testing generados anteriormente para predecir la variable *Disney* y comparar resultados.


### Representación y Matriz de confusión

Una vez se dispone de las componentes principales a utilizar para predecir la variable dependiente *Disney*, se procede a ajustar el modelo K-NN con un valor k de 5 instancias. En los gráficos de este panel se puede observar el resultado de la clasificación tanto en el conjunto de entrenamiento como en el conjunto de testing en relación a las dos componentes principales obtenidas. 

Como en SVM, en color azul celeste se encuentran los puntos que representan que la película sí se puede encontrar en el catálogo de Disney+, mientras que amarillo las que no. En ambos conjuntos se observa la categorización claramente junto con los errores de predicción, ya que no todos los puntos se encuentran en el lado correcto. 

Para especificar con detalle los resultados se representa también la matriz de confusión. En este caso, del total de películas utilizadas en el conjunto de testing, 3701 no se encuentran en el catálogo de la compañía Disney, de las cuales el algoritmo ha predicho que 3657 no lo están y 44 sí. Por otro lado, un total de 169 películas sí están en el catálogo de Disney y el algoritmo ha indicado que 119 lo están y 50 no. Aunque con KNN ha aumentado ligeramente el error al clasificar las películas que no están en la plataforma, podemos ver una considerable mejora al predecir las que sí están. 

De la misma forma, en la representación gráfica se puede ver como la clasificación es más precisa en K-NN respecto a SVM, ya que en este caso los colores de ambos grupos se se adaptan mejor a los puntos o películas. 