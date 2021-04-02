#carga el mapeo
declare -A Mapeo
declare -A Departamento
while read str1; do
    depto=$(echo $str1 | awk '{print $1}')
    codigo=$(echo $str1 | awk '{print $2}')
    Mapeo[$depto]=$codigo
    Departamento[$((codigo))]=$depto
    #echo $depto
done < mapeo_datosministerio_mapadepartamentos.dat

#test
depto="BUENOSAIRES_MORON"
codigo=${Mapeo[$depto]} 
echo $codigo ${Departamento[$codigo]} 

#for depto in "BUENOSAIRES_MORON" "BUENOSAIRES_HURLINGHAM"
#do 
#    echo $depto  ${Mapeo[$depto]}
#    #echo $(echo $depto | sed 's/ //g') #${Mapeo[$depto]}
#done

#cat Covid19Casos.csv | grep "Fallecido" | grep "Confirmado" | awk -F, 'BEGIN{FS=","}{gsub(/ /,"");printf("%s_%s\n",toupper($6),toupper($7))}' | sed 's/"//g' | iconv -f utf8 -t ascii//TRANSLIT > fallecidos.dat
#while read depto; do
#    echo $depto  ${Mapeo[$depto]}
#done < fallecidos.dat


#inprimo los deptos con fallecidos confirmados
#for depto in $(cat Covid19Casos.csv | grep "Fallecido" | grep "Confirmado" | awk -F, 'BEGIN{FS=","}{gsub(/ /,"");printf("%s_%s\n",toupper($6),toupper($7))}' | sed 's/"//g' | iconv -f utf8 -t ascii//TRANSLIT)
#do 
#    echo $depto  ${Mapeo[$depto]}
#done

for((i=1;i<527;i++))
do 
    depto=${Departamento[$i]}
    echo $i $depto
done


#declare -A Fallecidos
#while read str2; do
#    depto=$(echo $str2 | grep "Fallecido" | awk -F, 'BEGIN{FS=","}{gsub(/ /,"");printf("%s_%s\n",toupper($6),toupper($7))}' | sed 's/"//g')
#    echo $depto
    #, ${Mapeo["$depto"]}
    #echo $depto, $codigo
#done < Covid19Casos.csv


