#extrae departamento y provincia del file del ministerio
#saca espacios, lleva a mayusculas
#imprime las lineas con strings a una distancia de levenshtein de $1  de un string dado $2

gawk 'BEGIN{FS=","}{print $6,$7}' Covid19Casos.csv | sed 's/ //g' | tr '[:lower:]' '[:upper:]' | tre-agrep -i -s -$1 -w $2
