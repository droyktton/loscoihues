echo "ID,DEPARTAMENTO,CABECERA,PROVINCIA"
for((i=1;i<528;i++))
do
	#grep -A 3 "\"id\": $i," departamentos-argentina.json | awk -F "\":" '{printf($2)}END{printf "\n";}'; 
	#grep -B 3 "provincia" departamentos-argentina-modified.json | awk -F "\":" '{printf($2)}END{printf "\n";}';
	#grep -A 3 "\"id\": $i," departamentos-argentina-modified.json | awk -F "\":" '{printf($2)}END{printf "\n";}';

	grep -A 5 "\"Feature\", \"id\":\"$i\"" departamentos-argentina-modified.json | echo $i, $(tail -n 3 | gawk -F ":" '{printf("%s",$2);}END{printf("\n")}')

done
