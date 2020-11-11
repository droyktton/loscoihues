#https://stackoverflow.com/questions/13242469/how-to-use-sed-grep-to-extract-text-between-two-words

echo
echo \
"Muertes=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"$(grep Muertes index.html | grep -oP '(?<=\[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0).*?(?=\])')"];"

echo
echo \
"Recuperados=[0,0,0,0,0,0,0,0,0,0,0,0,2,4,8,8,8,8,8,9,11,13"$(grep Muertes index.html | grep -oP '(?<=\[0,0,0,0,0,0,0,0,0,0,0,0,2,4,8,8,8,8,8,9,11,13).*?(?=\])')"];"


echo
echo \
"Activos=[1,4,5,6,6,10,14,24,38,38,39,49,49,50,48,50,50"$(grep Muertes index.html | grep -oP '(?<=\[1,4,5,6,6,10,14,24,38,38,39,49,49,50,48,50,50).*?(?=\])')"];"


echo
echo \
"Totales=[1,4,5,6,6,10,14,24,38,38,39,49,51,54,56,58,58"$(grep Muertes index.html | grep -oP '(?<=\[1,4,5,6,6,10,14,24,38,38,39,49,51,54,56,58,58).*?(?=\])')"];"


echo 
echo "Fechas=[\"2020-04-03\""$(grep Muertes index.html | \
grep -oP '(?<=\"data\":\[\{\"x\":\[\"2020-04-03\").*?(?=\],\"y\":\[1,4,5,6,6,10)')"];";


