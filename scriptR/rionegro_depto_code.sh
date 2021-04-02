#awk 'BEGIN{FS=","}{if($4=="\"RIONEGRO\"") print $1,$2}' ../mapeo.csv | sed 's/"//g' > rionegro_codes.dat

#cat Covid19Casos.csv | gawk 'BEGIN{FS=","}{if($6=="\"Río Negro\"") print $7}' | sed 's/ //g' | tr '[:lower:]' '[:upper:]' | sed 's/"//g' | sort -u > rionegro_casos.dat

f1="rionegro_casos.dat"
f2="rionegro_codes.dat"

while read str1; do
    codigo=$(tre-agrep -i -2 -e $str1 $f2) #| awk '{print $1}' | awk 'FS=":"{print $1}'
    echo $str1 "del file" $f1 "tiene codigo" $codigo
done < "$f1"

