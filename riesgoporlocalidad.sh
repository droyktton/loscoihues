#!/bin/bash
mv RiesgoCABASINESPECIFICAR nova_RiesgoCABASINESPECIFICAR
rm ultimos.csv
for i in Riesgo*
do 
	localidad=$(echo $i | awk '{print substr($0,7,20)}'); 
	
	if [ $i = RiesgoCABACOMUNA1 ] ||  [ $i = RiesgoCABACOMUNA3 ] ||  [ $i = RiesgoCABACOMUNA4 ] ||  [ $i = RiesgoCABACOMUNA7 ] ||  [ $i = RiesgoCABACOMUNA8 ] || [ $i = RiesgoCABACABANA ] ||  [ $i = RiesgoBuenosAires ] || [ $i = RiesgoBuenosAires ] ||  [ $i = RiesgoAvellanedaNA ] ||  [ $i = RiesgoLanúsNA ] ||  [ $i = RiesgoLaMatanza ] ||  [ $i = RiesgoLaPlata ] ||  [ $i = RiesgoQuilmesNA ] ||  [ $i = RiesgoLomasde ]
	then 
		#echo "error:"
		datos=$(tail -n 10 $i | head -n 1);	
	else
		datos=$(tail -n 1 $i);		
	fi
	
	#tomamos los indicadores 10 dias antes
	datos=$(tail -n 10 $i | head -n 1);	
	
	latlong=$(grep $i coordenadasLocalidades.csv)
	
	echo $localidad,$datos,$latlong >> ultimos.csv
done

echo "Localidad,Fecha,RHO7,IA14,riesgox10,file,lat,lon,label" > ultimos.sorted.csv
sort --field-separator=',' --key=5 ultimos.csv -g >> ultimos.sorted.csv


