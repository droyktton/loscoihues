echo "nombre1,rho7,ia14,producto" > zzz
for i in Riesgo*
do 
	echo $i","$(tail -n 1 $i | gawk 'BEGIN{FS=",";OFS=",";}{print $2,$3,$2*$3}'); 
done >> zzz

#gawk 'BEGIN{
#	FS=","; OFS=FS;
#}
#{
#	print $0, 9999,9999
#}' zzz

#echo "nombre2,Latitud,Longitud,Texto"
paste -d "," zzz coordenadasLocalidades.csv
