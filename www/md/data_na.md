En las tablas de este panel se puede observar por cada dataset sus variables y el número de valores *NA* de cada uno. En algunas de estas variables se ha considerado necesario evitarlo y se han seguido diferentes criterios para completar los valores de dichas observaciones.

Para las puntuaciones **IMDb** se ha seguido el criterio de completar los valores faltantes con la media obtenida del resto de películas (5.9) o series (7.11). En cambio, para la variable **Age** y **Runtime** se ha completado los valores utilizando la moda, puesto que se consideran que son valores no tan diversos como pueda ser una nota y combiene utilizar el valor más común en el dataset. 

Para el resto de variables como **director**, **language** o **género** se ha optado por no rellenar los valores y dejarlos como desconocidos.

En cuanto a *valores atípicos* se ha podido encontrar en la variable **Runtime** una película con una duración de 1256 (21h), lo cual se ha identificado y comprobado como un valor erróneo y se ha corregido sustituyéndolo por la moda de la duración de todas las películas.

