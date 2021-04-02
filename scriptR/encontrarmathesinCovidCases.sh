#lee mapeo codigo y encuentra math in covidcases

#!/bin/bash

declare -a MuertosDepto
for ((i=1;i<527;i++))
do
    MuertosDepto[$i]=0
done

#grep -i CABA mapeocorregido.csv > caba.tmp
cat mapeocorregido.csv > caba.tmp 

#preproceso fallecidos confirmados
cat Covid19Casos.csv | sed 's/ //g' | grep -i FALLECIDO | grep -i CONFIRMADO > Covid19Casos.tmp
#echo "listo preprocesados"

while read str 
do 
    dep=$(echo $str | awk -F, '{print toupper($2)}'); 
    pro=$(echo $str | awk -F, '{print toupper($4)}'); 
    id=$(echo $str | awk -F, '{print $1}'); 

    #echo "codigo="$id

    cat Covid19Casos.tmp | grep -i $dep | grep -i $pro > fallecidos.tmp
    #echo "listo fallecidos.tmp"

    #awk -i '/$dep/ && /$pro/ && /Fallecido/' Covid19Casos.csv > fallecidos.tmp

    MuertosDepto[$id]=0;

    while read str2
    do
        #echo $str2
        #echo $dep $pro "===>" $str2 
        #echo 
        MuertosDepto[$id]=$(echo ${MuertosDepto[$id]}+1 | bc)
        #echo $id","${MuertosDepto[$id]}
    done < fallecidos.tmp

    #echo "listo MuertosDepto"

done < caba.tmp 

#echo ${MuertosDepto[@]}

echo "DATO"
for ((i=1;i<527;i++))
do
    #echo $i" "${MuertosDepto[$i]}
    echo ${MuertosDepto[$i]}
done

#for i in "${!MuertosDepto[@]}"; do 
#  printf "%s\t%s\n" "$i" "${MuertosDepto[$i]}"
#done
