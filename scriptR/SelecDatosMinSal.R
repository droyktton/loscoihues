###Karina Laneri Junio de 2020####
###Leo base de datos Publica que me bajo de 
#### http://datos.salud.gob.ar/dataset/covid-19-casos-registrados-en-la-republica-argentina
#### y como es muy pesada selecciono los casos confirmados y sospechosos de CABA
#####y los guardo  en un archivo ###########

setwd("~/backupOct2019/COVID19/DIAGRAMAS_DE_RIESGO/PaisDatosMinSal/")
library(tidyverse)
library(dplyr)
library(readxl)
library(lubridate)
library(xts)
#Leo base de datos del MInSal que viene en formato .csv pero GUARDA!!!! tiene algo raro ocupa 126MB
#Entonces antes de leerla aca la abro con libreoffice y la vuelvo a guardar como .csv
#pasa a ocupar 46MB!!!!!!
DatosPais<-read_csv("Covid19Casos.csv",col_names =TRUE)
#DatosPais<-read.csv("Covid19Casos.csv",header =TRUE)
#DatosPais<-read_xlsx("Covid19Casos.xlsx")
DatosCABAconVillas<-DatosPais %>% filter(residencia_provincia_nombre == "CABA")

# DatosCABA<-DatosPais %>% filter((clasificacion_resumen =="Confirmado" | 
#                                    clasificacion_resumen =="Sospechoso"), 
#                                 residencia_provincia_nombre == "CABA", 
#                                 grepl("COMUNA",residencia_departamento_nombre)
# )

write.csv(DatosCABAconVillas,"CasosCABACompleto.csv",row.names = FALSE)

###################CHACO
Chaco<-DatosPais %>% filter(DatosPais$residencia_provincia_nombre=="Chaco")
write.csv(Chaco,"CasosChaco.csv",row.names = FALSE)

#################Rio Negro
RN<-DatosPais %>% filter(DatosPais$residencia_provincia_nombre=="Río Negro")
write.csv(RN,"CasosRioNegroMinSal.csv",row.names = FALSE)

###############AMBA y Prov BsAs
ProvBsAs<-DatosPais %>% filter(DatosPais$residencia_provincia_nombre=="Buenos Aires")
write.csv(ProvBsAs,"CasosProvBuenosAires.csv",row.names = FALSE)

####CORDOBA####
ProvCordoba<-DatosPais %>% filter(DatosPais$residencia_provincia_nombre=="Córdoba")
write.csv(ProvCordoba,"CasosCordoba.csv",row.names = FALSE)

####Neuquen####
ProvNeuquen<-DatosPais %>% filter(DatosPais$residencia_provincia_nombre=="Neuquén")
write.csv(ProvNeuquen,"CasosNeuquen.csv",row.names = FALSE)

####Rio Negro####
ProvRioNegro<-DatosPais %>% filter(DatosPais$residencia_provincia_nombre=="Río Negro")
write.csv(ProvRioNegro,"CasosRioNegroMinSal.csv",row.names = FALSE)

### Jujuy ####
ProvJujuy<-DatosPais %>% filter(DatosPais$residencia_provincia_nombre=="Jujuy")
write.csv(ProvJujuy,"CasosJujuy.csv",row.names = FALSE)

### Salta ####
ProvSalta<-DatosPais %>% filter(DatosPais$residencia_provincia_nombre=="Salta")
write.csv(ProvSalta,"CasosSalta.csv",row.names = FALSE)

### Tucuman ####
ProvTucuman<-DatosPais %>% filter(DatosPais$residencia_provincia_nombre=="Tucumán")
write.csv(ProvTucuman,"CasosTucuman.csv",row.names = FALSE)

### Mendoza ####
ProvMendoza<-DatosPais %>% filter(DatosPais$residencia_provincia_nombre=="Mendoza")
write.csv(ProvMendoza,"CasosMendoza.csv",row.names = FALSE)

### SantaFe ####
ProvSantaFe<-DatosPais %>% filter(DatosPais$residencia_provincia_nombre=="Santa Fe")
write.csv(ProvSantaFe,"CasosSantaFe.csv",row.names = FALSE)

### SantaCruz ####
ProvSantaCruz<-DatosPais %>% filter(DatosPais$residencia_provincia_nombre=="Santa Cruz")
write.csv(ProvSantaCruz,"CasosSantaCruz.csv",row.names = FALSE)

### Tierra del Fuego ####
ProvTierraDelFuego<-DatosPais %>% filter(DatosPais$residencia_provincia_nombre=="Tierra del Fuego")
write.csv(ProvTierraDelFuego,"CasosTierraDelFuego.csv",row.names = FALSE)

### La Rioja ####
ProvLaRioja<-DatosPais %>% filter(DatosPais$residencia_provincia_nombre=="La Rioja")
write.csv(ProvLaRioja,"CasosLaRioja.csv",row.names = FALSE)

### Entre Ríos ####
ProvEntreRios<-DatosPais %>% filter(DatosPais$residencia_provincia_nombre=="Entre Ríos")
write.csv(ProvEntreRios,"CasosEntreRios.csv",row.names = FALSE)
