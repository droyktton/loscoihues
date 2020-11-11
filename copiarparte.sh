PATHACTUAL=$PWD
PATHTABLERO="/home/ale/Codigos/webexp/tablero-publico/html"
PATHTCOIHUES="/home/ale/Codigos/webexp/loscoihues/"

cd $PATHTABLERO
printf "bajando tablero...\n"
git pull
printf "listo\n"

printf "\nrobando arrays...\n"
bash extraerdatos.sh > $PATHTCOIHUES/datos_crudos/DatosCovidBariloche.js
printf "listo\n"

printf "\nactualizando loscoihues...\n"
cd $PATHTCOIHUES
git pull
git add datos_crudos/DatosCovidBariloche.js
git commit -m "actualizando parte oficial"
git push
printf "listo\n"

cd $PATHACTUAL
