######## PARA GENERAR codes de departamentos por provincia
#for p in BUENOSAIRES CATAMARCA CHACO CHUBUT CABA CORDOBA CORRIENTES ENTRERIOS FORMOSA JUJUY LAPAMPA LARIOJA MENDOZA MISIONES NEUQUEN RIONEGRO SALTA SANJUAN SANLUIS SANTACRUZ SANTAFE SANTIAGODELESTERO TIERRADELFUEGO TUCUMAN
#do 
#    #echo $p
#    cat mapeocorregido.csv | awk -v prov=$p 'BEGIN{FS=","}{p=sprintf("\"%s\"",prov); if($4==p) printf("%s %s\n",$1,$2)}' | sed 's/"//g' > $p"_codes.dat"
#done

#for p in CIUDADAUTONOMADEBUENOSAIRES
#do 
#    awk -v prov=$p 'BEGIN{FS=","}{p=sprintf("\"%s\"",prov); if($4==p) print $1,$2}' mapeocorregido.csv | sed 's/"//g' > CABA"_codes.dat"
#done
#sed -i -e 's/COMUNA1/COMUNA01/g' -e 's/COMUNA2/COMUNA02/g' -e 's/COMUNA3/COMUNA03/g' -e 's/COMUNA4/COMUNA04/g' -e 's/COMUNA5/COMUNA05/g' -e 's/COMUNA6/COMUNA06/g' -e 's/COMUNA7/COMUNA07/g' -e 's/COMUNA8/COMUNA08/g' -e 's/COMUNA9/COMUNA09/g' CABA_codes.dat
#############################

#cat Covid19Casos.csv | gawk 'BEGIN{FS=","}{if($6=="\"Río Negro\"") print $7}' | sed 's/ //g' | tr '[:lower:]' '[:upper:]' | sed 's/"//g' | sort -u > rionegro_casos.dat

file=$1"_casos".dat

if [ ! -f $file ]; then
    printf "no existe $file, lo voy a crear..."
    provincia=$(echo $1)

    #if [[ provincia == "CABA" ]]; then provincia="CIUDADAUTONOMADEBUENOSAIRES"; fi

    cat Covid19Casos.csv | iconv -f utf8 -t ascii//TRANSLIT | gawk -v prov=$provincia 'BEGIN{FS=","}{gsub(/ /,"");p=sprintf("\"%s\"",prov);if(toupper($6)==p) print $7}' | iconv -f utf8 -t ascii//TRANSLIT | sed 's/ //g' | tr '[:lower:]' '[:upper:]' | sed 's/"//g' | sort -u > $file
    printf "listo! \n"
fi

f1="$1_casos.dat"

f2=$(echo $1 | tr '[:lower:]' '[:upper:]')"_codes.dat"

#declare -A encriptado

#recorre el file f1 buscando el mas cercano de f2
while read str1; do
    #debug:
    #codigo=$(echo $(tre-agrep -i -0 -w $str1 $f2) | awk '{print}' | awk 'FS=":"{print $1,"(",$2,")"}')

    codigo=$(echo $(tre-agrep -0 -i -w $str1 $f2) | awk '{print}' | awk 'FS=":"{print $1}')
    #echo $str1 "del file" $f1 "tiene codigo" $codigo
    echo $1_$str1 $codigo

    #encriptado["$1_$str1"]=$codigo
done < "$f1"

#lugar="$1_TUPUNGATO"
#echo "TUPUNGATO tiene codigo" ${encriptado[$lugar]}

