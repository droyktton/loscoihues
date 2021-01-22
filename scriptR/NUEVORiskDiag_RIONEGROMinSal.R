##### Karina Laneri, Alejandro Kolton, Junio 2020
####Leo datos de CABA y calculo rho7, AI14 y rho para CABA
####guardo datos en un archivo que luego serán leídos por 
####otro programa que hará el diagrama de riesgo

setwd("~/backupOct2019/COVID19/DIAGRAMAS_DE_RIESGO/PaisDatosMinSal/")
library(tidyverse)
library(dplyr)
library(readxl)
library(lubridate)
library(xts)
library(stringi)
library(plotly)
#Leo base de datos del MInSal
DatosMinSalTodo<-read.csv("CasosRioNegroMinSal.csv")
## SELECCIONO SOLO LOS CONFIRMADOS
DatosMinSal<-DatosMinSalTodo %>% filter(clasificacion_resumen =="Confirmado")
#####Cipolleti esta la mitad en Roca y la otra mitad en El Cuy
localidades<-c("Río Negro","Bariloche","General Roca","Adolfo Alsina","Avellaneda")
#en "Adolfo Alsina" esta viedma
#en Avellaneda está Choele Choel
#Cipolleti esta dividida entre General Roca y el Cuy
#,"Avellaneda","El Cuy") ###por ahora no las agregamos porque tienen muy baja poblacion y muchas fluctuaciones
Poblocalidades<-c(747610,163743,370245,65450,40349)
#,40349,6781) #estimado indec al 2020
names(Poblocalidades)<-localidades
###https://sitioanterior.indec.gob.ar/nivel4_default.asp?id_tema_1=2&id_tema_2=24&id_tema_3=119

nombreprovinciasinacento<-gsub(" ", "",stri_trans_general(localidades[1],"Latin-ASCII"), fixed = TRUE)

#sumo todos los casos que tengo en la misma fecha
#ANTES:considero fecha inicio de sintomas y si no hay le pongo la fecha de ingreso al SISA
###colfechas<-as.Date(ifelse(is.na(DatosMinSal$fecha_inicio_sintomas),as.Date(DatosMinSal$fecha_apertura),as.Date(DatosMinSal$fecha_inicio_sintomas)))
### AHORA: como hay un 40% de fechas inicio de sintomas que no estan en la base y vemos que el 
###desfasaje con fecha de apertura es en promedio 5 dias, entonces uso fecha de apertura-5dias
#colfechas<-as.Date(ifelse(is.na(DatosMinSal$fecha_inicio_sintomas),as.Date(DatosMinSal$fecha_apertura)-5,as.Date(DatosMinSal$fecha_inicio_sintomas)))
colfechas<-vector()
for(i in 1:length(DatosMinSal$fecha_inicio_sintomas))
{
  if(is.na(DatosMinSal$fecha_inicio_sintomas[i]))
  {
    diasentrefechas<-ceiling(runif(1,min=0,max=8))
    colfechas[i]<-as.Date(as.Date(DatosMinSal$fecha_apertura[i])-diasentrefechas)
  }else{
    colfechas[i]<-as.Date(DatosMinSal$fecha_inicio_sintomas[i])
  }
}

DatosMinSal$fechcompleta<-as.Date(colfechas)
############################################################################
###############################################
suma_casosDiariosMinSal<-list(lenght=length(localidades))
###RIONEGRO TOTAL PROVINCIA
suma_casosDiariosMinSal[[1]]<-DatosMinSal %>% group_by(fechcompleta) %>% summarise(casos_diarios=n()) 
###RIONEGRO LOCALIDADES
for(i in 2:length(localidades))
  {
suma_casosDiariosMinSal[[i]]<-DatosMinSal %>% filter(residencia_departamento_nombre==localidades[[i]]) %>% group_by(fechcompleta) %>% summarise(casos_diarios=n()) 
  }

###############Plot para ver las fechas sintomas vs fecha apertura ##############
png(paste("Fechas",nombreprovinciasinacento,".png",sep=""))
paresdefechas<-DatosMinSal[,c("fecha_inicio_sintomas","fecha_apertura")]
paresdefechasordenadas<-dplyr::arrange(paresdefechas, fecha_apertura)
paresfechasnoNA<-na.omit(paresdefechasordenadas)
yfechasiguales<-as.Date(paresfechasnoNA$fecha_inicio_sintomas)
plot(as.Date(paresfechasnoNA$fecha_inicio_sintomas),yfechasiguales,col="red",ty="l",
     ylab=c("Fecha de apertura"),xlab=c("Fecha de inicio de síntomas"))
polygon(c(as.Date(paresfechasnoNA$fecha_inicio_sintomas)[1:length(paresfechasnoNA$fecha_inicio_sintomas)],
        as.Date(paresfechasnoNA$fecha_inicio_sintomas)[length(paresfechasnoNA$fecha_inicio_sintomas):1]),
        c(as.Date(paresfechasnoNA$fecha_inicio_sintomas)[1:length(paresfechasnoNA$fecha_inicio_sintomas)],
          rep(as.Date(paresfechasnoNA$fecha_apertura[1]),length(paresfechasnoNA$fecha_inicio_sintomas))),
        col=gray(0.9), border=NA) 
#Desde i=2 porque solo dibujo los departamentos NO la Provincia
for (i in 2:length(localidades))
  {
paresdefechas<-DatosMinSal[,c("residencia_departamento_nombre","fecha_inicio_sintomas","fecha_apertura")] %>% filter(residencia_departamento_nombre==localidades[[i]])
paresdefechasordenadas<-dplyr::arrange(paresdefechas, fecha_apertura)
paresfechasnoNA<-na.omit(paresdefechasordenadas)

#######plot comun
points(as.Date(paresfechasnoNA$fecha_inicio_sintomas),as.Date(paresfechasnoNA$fecha_apertura),
       col=i+1,pch=20)
}
lines(as.Date(paresfechasnoNA$fecha_inicio_sintomas),as.Date(paresfechasnoNA$fecha_inicio_sintomas),col="red",lwd=2)

legend("topleft",inset=0.005,col=3:(length(localidades)+1),legend=localidades[-1],pch=20,box.lty=0,y.intersp=1.5)
textogris <- "Fecha de apertura de caso anterior\na la fecha de inicio de sintomas"
textoblanco <- "Fecha de apertura de caso posterior\na la fecha de inicio de sintomas"
posCoordsVec <- c(ymd("2020-06-01"),ymd("2020-03-25"))
posCoordsVec2 <- c(ymd("2020-04-15"),ymd("2020-06-15"))
text(posCoordsVec[1],posCoordsVec[2],textogris)
text(posCoordsVec2[1],posCoordsVec2[2],textoblanco)
dev.off()
####dibujo interactivo plotly
#figurafechas <- plot_ly(paresfechasnoNA, x = ~fecha_inicio_sintomas, y = ~fecha_apertura, name = 'Fechas sintomas vs. apertura', type = 'scatter', mode = 'markers',color = I('black'))%>% 
#  add_trace(y = ~as.Date(fecha_inicio_sintomas), name = 'Fechas iguales', type = 'scatter',mode = 'lines', color = I('red')) %>% 
#  layout(title = "",   yaxis=list(title=""),xaxis=list(title=""),legend=list(x=0.9, y=0.1))
#figurafechas
#############################


###Completo fechas que no están con cero casos ese día
start_date<-suma_casosDiariosMinSal[[1]]$fechcompleta[1]
end_date<-suma_casosDiariosMinSal[[1]]$fechcompleta[length(suma_casosDiariosMinSal[[1]]$fechcompleta)]
fechas_consecutivas<-ymd(seq(start_date,end_date,by='days'))
xts_consecutivo<-xts(rep(0,length(fechas_consecutivas)),order.by=fechas_consecutivas)
xts_casosdiarios<-list()
casos_consecutivos<-list()
para_archivo<-data_frame()

for(j in 1:length(localidades))
{
  xts_casosdiarios[[j]]<-xts(suma_casosDiariosMinSal[[j]]$casos_diarios,order.by=suma_casosDiariosMinSal[[j]]$fechcompleta)
  casos_consecutivos[[j]]<-merge.xts(xts_consecutivo,xts_casosdiarios[[j]],fill=0,join="left")
  names(casos_consecutivos[[j]])<-c("ceros","casos_diarios")
}

#plot(index(casos_consecutivos[[1]]),casos_consecutivos[[1]]$casos_diarios,ty="b")
#plot(index(casos_consecutivos[[1]]),cumsum(casos_consecutivos[[1]]$casos_diarios))

####IMPRIMO CASOS POR DIA PARA GRAFICAR y ver delay en carga ultimos puntos 
para_archivo<-matrix(nrow=length(index(casos_consecutivos[[1]])),ncol=length(localidades))

for(k in 1:length(localidades)){
para_archivo[,k]<-as.numeric(casos_consecutivos[[k]]$casos_diarios)
}
outprint<-data.frame(as.Date(index(casos_consecutivos[[1]])),para_archivo)
names(outprint)<-c("fecha",localidades)
nombre<-strsplit(localidades[1]," ")
write.csv(outprint,paste("NuevosCasosConfirmadosPorDia",nombre[[1]][1],nombre[[1]][2],".csv",sep=""),row.names = FALSE)

##### FUNCION QUE CALCULA rho###########################
##dias_ventana<-3 (puedo cambiar el numero de dias de la ventana que uso para calcular rho)
##extrapolacion para que los valores extra no sean ceros.

calculo_rho_extrap<-function(newcases,fechas,casos_acumulados){
nuevas_fechas<-vector()
rho<-vector()
fin<-length(fechas)
##casosfit<-casos_acumulados$casos_diarios[(fin-7):fin]
##fechasfit<-ymd(seq(fechas[fin]-7,fechas[fin],by='days'))
##fitlineal<-lm(casosfit ~ fechasfit) 

#plot(index(casos_consecutivos[[1]]),cumsum(casos_consecutivos[[1]]$casos_diarios))
#lines(fechasfit,predict(fitlineal),col="red")

##fechasfit<-ymd(seq(fechas[fin]-7,fechas[fin]+10,by='days'))
#names(alargo_fechas)<-fechasfit
##prediction_next = predict(fitlineal, 
##                             newdata = data.frame(time = fechasfit), 
##                             interval = "prediction")

#lines(fechasfit,prediction_next[,1],col="blue")
##xtspredictnext<-xts(prediction_next[,1],order.by=fechasfit)
##names(xtspredictnext)<-c("prednext")
##xtscasosoriginales<-xts(casos_acumulados$casos_diarios,order.by=fechas)

#predcasesxts<-merge.xts(xtscasosoriginales,xtspredictnext,join="outer")  
#predictedcases<-ifelse(is.na(predcasesxts$prednext),predcasesxts$casos_diarios,predcasesxts$prednext) 
#newpredcases<-diff(predictedcases)
##################otraforma de extrapolar
mediaextendida<-rep(mean(newcases[(length(newcases)-6):length(newcases)]),10)
newpredcases<-c(as.numeric(newcases),mediaextendida)
fechasnewpredcases<-ymd(seq(fechas[1],fechas[fin]+10,by='days'))
#tengo que calcular rho hasta 3 días después del ultimo paar despues poder promediar el rho7  
  for (i in 1:(fin+3)){
  im1=i-1
  ip1=i+1
  im6=i-6
  im5=i-5
  im4=i-4
#  numerador=ifelse(im1>0,newcases[im1],0.0)+newcases[i]+ifelse(ip1>fin,0.0,newcases[ip1])
#  denom=ifelse(im6>0,newcases[im6],0.0)+ifelse(im5>0,newcases[im5],0.0)+ifelse(im4>0,newcases[im4],0.0)
  numerador=ifelse(im1>0 & im1<fin,newcases[im1],0.0)+
  ifelse(im1>fin,newpredcases[im1],0.0)+
  ifelse(i>fin,newpredcases[i],newcases[i])+
  ifelse(ip1>fin,newpredcases[ip1],newcases[ip1])

    denom=ifelse(im6>0 & im6<fin,newcases[im6],0.0)+
    ifelse(im6>fin,newpredcases[im6],0.0)+
    ifelse(im5>0 & im5<fin,newcases[im5],0.0)+
    ifelse(im5>fin,newpredcases[im5],0.0)+
    ifelse(im4>0 & im4<fin,newcases[im4],0.0)+
    ifelse(im4>fin,newpredcases[im4],0.0)
  
  if(denom == 0)denom=1
  rho[i]=min((numerador/denom),4)
  #nuevas_fechas[i]=as.Date(index(predcasesxts)[i])
  nuevas_fechas[i]=fechasnewpredcases[i]
  }
rhofechas<-data_frame(rho,as.Date(nuevas_fechas))
names(rhofechas)<-c("rhodays","nuevasfechas")
return(rhofechas)
}
##### HASTA ACA ######
##########FUNCION QUE CALCULA LA MEDIA DE rho7, el A14 #####

calcmeanRho7yA14_extrap<-function(rhosolo,fechasrhosolo,newcases,fechasdatos,pop){
  p_seven<-vector(length=length(newcases))
  n_14_days<-vector(length=length(newcases))
  a_14_days<-vector(length=length(newcases))
  risk<-vector(length=length(newcases))
  risk_per_10<-vector(length=length(newcases))
  fechas<-vector(length=length(newcases))
  end<-length(fechasdatos)
  
  for (j in 1:end)
  {
    jm3=j-3 
    jm3=ifelse(jm3<1,1,jm3)
    jp3=j+3
    jp3=ifelse(jp3>end,end,jp3)
    
    p_seven[j] = mean(rhosolo[jm3:jp3])
    #p_seven[j] = mean(rhosolo[j - 7:j])
    jm14=j-13
    jm14=ifelse(jm14<1,1,jm14)
    n_14_days[j] = sum(newcases[jm14: j])
    #n_14_days[j] = sum(newcases[j - 13: j + 1])
    a_14_days[j] = (n_14_days[j] / pop) * 100000
    risk[j] = n_14_days[j] * p_seven[j]
    risk_per_10[j] = a_14_days[j] * p_seven[j]
    fechas[j]=as.Date(fechasdatos[j])
    }
  riesgo<-data.frame(as.Date(fechas),p_seven,a_14_days,risk_per_10)
  colnames(riesgo)<-c("fecha","rho7dpromedio","incidenciaAcum14d","riesgopor10")
  return(riesgo)
}


#### Localidades #######
rhoTODAS<-list(length=length(localidades))
riesgoTODAS<-list(length=length(localidades))

for(j in 1:length(localidades))
  {
rhoTODAS[[j]]<-calculo_rho_extrap(casos_consecutivos[[j]]$casos_diarios,index(casos_consecutivos[[j]]),cumsum(casos_consecutivos[[j]]$casos_diarios))
riesgoTODAS[[j]]<-calcmeanRho7yA14_extrap(rhoTODAS[[j]]$rhodays,rhoTODAS[[j]]$nuevasfechas,casos_consecutivos[[j]]$casos_diarios,index(casos_consecutivos[[j]]),Poblocalidades[j])
nombresparaarchivo<-gsub(" ", "",stri_trans_general(localidades[j],"Latin-ASCII"), fixed = TRUE)
if(j>3) ###esto es un parcha para no modificar los nombres de los 3 primeros archivos 
{
  write.csv(riesgoTODAS[[j]],paste("Riesgo",nombreprovinciasinacento,nombresparaarchivo[[1]][1],sep=""),row.names = FALSE)
   }else{
     write.csv(riesgoTODAS[[j]],paste("Riesgo",nombresparaarchivo,sep=""),row.names = FALSE)
  }
  }







          
