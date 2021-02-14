
###borro el archivo viejo
#rm Covid19Casos.csv
###bajo el archivo nuevo
##wget https://sisa.msal.gov.ar/datos/descargas/covid-19/files/Covid19Casos.csv
###git pull
###git add Covid19Casos.csv
###git commit -m "Ministerio"
###git push
##para sacar los caracteres raros del csv del ministerio
#tr -cd '\11\12\40-\176' < Covid19Casos.csv > /home/karina/backupOct2019/COVID19/DIAGRAMAS_DE_RIESGO/PaisDatosMinSal/Covid19Casos.csv
#arreglar comando de arriba para que no me borre las ñ ni los acentos

#desde aca
####copio


cp /home/koltona/Codigos/loscoihues/Riesgo* /home/koltona/Codigos/loscoihues/riesgos_dia_anterior/


#######hago las cuentas
cd /home/koltona/Codigos/loscoihues/scriptR/
##borro file viejo
rm Covid19Casos.csv
#bajo el nuevo
wget https://sisa.msal.gov.ar/datos/descargas/covid-19/files/Covid19Casos.csv
####
R CMD BATCH SelecDatosMinSal.R
R CMD BATCH NUEVORiskDiag_CABA.R
R CMD BATCH NUEVORiskDiag_CHACO.R
R CMD BATCH NUEVORiskDiag_PROVBSAS.R
R CMD BATCH NUEVORiskDiag_CORDOBA.R
R CMD BATCH NUEVORiskDiag_NEUQUEN.R
R CMD BATCH NUEVORiskDiag_RIONEGROMinSal.R
R CMD BATCH NUEVORiskDiag_JUJUY.R
R CMD BATCH NUEVORiskDiag_SALTA.R
R CMD BATCH NUEVORiskDiag_TUCUMAN.R
R CMD BATCH NUEVORiskDiag_SANTAFE.R
R CMD BATCH NUEVORiskDiag_MENDOZA.R
R CMD BATCH NUEVORiskDiag_SANTACRUZ.R
R CMD BATCH NUEVORiskDiag_TIERRADELFUEGO.R
R CMD BATCH NUEVORiskDiag_LARIOJA.R
R CMD BATCH NUEVORiskDiag_ENTRERIOS.R
R CMD BATCH NUEVORiskDiag_CORRIENTES.R
R CMD BATCH NUEVORiskDiag_MISIONES.R
R CMD BATCH NUEVORiskDiag_CATAMARCA.R

##copio nuevos archivos
cp Riesgo* /home/koltona/Codigos/loscoihues/ 
cp NuevosCasosConfirmadosPorDia* /home/koltona/Codigos/loscoihues/datos_crudos/
cp Fechas* /home/koltona/Codigos/loscoihues/datos_crudos/

###### subo al repositorio
cd /home/koltona/Codigos/loscoihues
git pull
git add Riesgo* datos_crudos
git commit -m "actualizacion"
git push

#####hago graficos para comparar ayer y hoy
cd riesgos_dia_anterior
gnuplot comparar_ayer_hoy.gnu

#rm  /home/koltona/Codigos/loscoihues/scriptR/*.csv

#lo siguiente es para usar la base de datos del tablero
#cd /home/karina/backupOct2019/ProgsBitbucket/CovidBariloche/TableroPrivado/tablero-privado
#git pull
#cd /home/karina/backupOct2019/COVID19/DIAGRAMAS_DE_RIESGO/RioNegroDatosDaniela
#cp /home/karina/backupOct2019/ProgsBitbucket/CovidBariloche/TableroPrivado/tablero-privado/html/Tendencia\ Rio\ Negro.xlsx .
#R CMD BATCH NUEVORNDatosTableroParaRiskDiag.R 
#cp Riesgo* /home/karina/backupOct2019/ProgsBitbucket/loscoihues 
#cp CasosNuevos* /home/karina/backupOct2019/ProgsBitbucket/loscoihues
#cd ..

###Instrucciones para actualizar los casos etc de CovidBariloche
###git pull
#cd /home/karina/backupOct2019/ProgsBitbucket/CovidBariloche/TableroPrivado/tablero-privado
#git pull
####ir al archivo index.html

###OJO no hacer push ni nada ahi!!!!!!!!!!!!!!!!
#hacer en linea de comando grep Muertes index.html
#editar el siguiente archivo con este prog

#editar: datos_crudos/DatosCovidBariloche.js
#editar: loscoihues/datos_crudos/DatosCovidBariloche.js
#matchear: Fechas, Activos, Recuperados, Muertes. Borrar antiguos arrays [0,0,1,2,....];
#no olvidar el ";" al final de cada array
