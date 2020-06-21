setwd("~/backupOct2019/COVID19/BaseDatosDaniela/")
library(tidyverse)
library(dplyr)
library(readxl)
library(lubridate)
library(xts)
#Leo base de datos desagregada por localidades de Rio Negro
DatosRioNegro<-read_xlsx("TendenciaRioNegro_14Junio.xlsx")
PobBari<-135704 #estimado al 2020
PobRN<-747610  #Daniela
#sumo todos los casos que tengo en la misma fecha
suma_casosacumrionegro<-DatosRioNegro %>% group_by(fecha) %>% summarise(casos_acumul=sum(acumulado)) %>% filter(casos_acumul!=0)
suma_casosacumbariloche<-DatosRioNegro %>% filter(code =="bariloche") %>% select(fecha,acumulado) %>% filter(acumulado!=0)
start_date<-ymd('2020-02-25')
primera_fecha_datos<-ymd(suma_casosacumbariloche$fecha[1])-1
ultima_fecha_datos<-ymd(suma_casosacumbariloche$fecha[length(suma_casosacumbariloche$fecha)])
#csv para leer con prog diagrama de riesgo
fechas_prev<-ymd(seq(start_date,primera_fecha_datos, by = 'days'))
fechapad<-xts(rep(0,length(fechas_prev)),order.by=fechas_prev)
sumcasosacumbari_xts<-xts(suma_casosacumbariloche$acumulado,order.by=suma_casosacumbariloche$fecha)
CasosAcumBari<-rbind(fechapad,sumcasosacumbari_xts)
names(CasosAcumBari)<-"casosacBRC"
######################################################################
primera_fecha_datosRN<-ymd(suma_casosacumrionegro$fecha[1])-1
ultima_fecha_datosRN<-ymd(suma_casosacumrionegro$fecha[length(suma_casosacumrionegro$fecha)])
fechas_prevRN<-ymd(seq(start_date,primera_fecha_datosRN, by = 'days'))
fechapadRN<-xts(rep(0,length(fechas_prevRN)),order.by=fechas_prevRN)
sumcasosacumRN_xts<-xts(suma_casosacumrionegro$casos_acumul,order.by=suma_casosacumrionegro$fecha)
CasosAcumRN<-rbind(fechapadRN,sumcasosacumRN_xts)
names(CasosAcumRN)<-"casosacRN"

#  Karina Barcelona
#-----------------------------------------------------

#finBRC=nrow(CasosAcumBari$casosacBRC)-1
#fin=dia_fin-1
casosaccbari<-as.numeric(CasosAcumBari$casosacBRC)
new_casesbari<-diff(casosaccbari)
fechas_newcasesbari<-index(CasosAcumBari)[-1]

#finRN=nrow(CasosAcumRN$casosacRN)-1
casosaccrionegro<-as.numeric(CasosAcumRN$casosacRN)
new_casesrionegro<-diff(casosaccrionegro)
fechas_newcasesrionegro<-index(CasosAcumRN)[-1]

CasosNuevosBRCyRN<-data.frame(fechas_newcasesrionegro,new_casesrionegro,new_casesbari)
names(CasosNuevosBRCyRN)<-c("fecha","nuevoscasosRN","nuevoscasosBRC")
write.csv(CasosNuevosBRCyRN,"CasosNuevosRNyBRC.csv",row.names = FALSE)
##### FUNCION QUE CALCULA rho###########################

calculo_rho<-function(newcases,fechas){
nuevas_fechas<-vector()
rho<-vector()
  
  fin<-length(fechas)
  
  for (i in 1: fin){
  im1=i-1
  ip1=i+1
  im6=i-6
  im5=i-5
  im4=i-4
  numerador=ifelse(im1>0,newcases[im1],0.0)+newcases[i]+ifelse(ip1>fin,0.0,newcases[ip1])
  denom=ifelse(im6>0,newcases[im6],0.0)+ifelse(im5>0,newcases[im5],0.0)+ifelse(im4>0,newcases[im4],0.0)
  if(denom == 0)denom=1
  rho[i]=min((numerador/denom),4)
  nuevas_fechas[i]=as.Date(fechas[i])

  }
rhofechas<-data_frame(rho,as.Date(nuevas_fechas))
names(rhofechas)<-c("rhodays","nuevasfechas")
return(rhofechas)
}


##########FUNCION QUE CALCULA LA MEDIA DE rho7, el A14 #####

calcmeanRho7yA14<-function(rhosolo,fechasrhosolo,newcases,pop){
  p_seven<-vector(length=length(newcases))
  n_14_days<-vector(length=length(newcases))
  a_14_days<-vector(length=length(newcases))
  risk<-vector(length=length(newcases))
  risk_per_10<-vector(length=length(newcases))
  fechas<-vector(length=length(newcases))
  end<-length(fechasrhosolo)
  
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
    fechas[j]=as.Date(fechasrhosolo[j])
    }
  riesgo<-data.frame(as.Date(fechas),p_seven,a_14_days,risk_per_10)
  colnames(riesgo)<-c("fecha","rho7dpromedio","incidenciaAcum14d","riesgopor10")
  return(riesgo)
}

#### Bariloche #######
rhoBRC<-calculo_rho(new_casesbari,as.Date(fechas_newcasesbari))
riesgoBRC<-calcmeanRho7yA14(rhoBRC$rhodays,rhoBRC$nuevasfechas,new_casesbari,PobBari)
write.csv(riesgoBRC,"RiesgoBariloche.csv",row.names = FALSE)

###Rio Negro ######
rhoRN<-calculo_rho(new_casesrionegro,as.Date(fechas_newcasesrionegro))
riesgoRN<-calcmeanRho7yA14(rhoRN$rhodays,rhoRN$nuevasfechas,new_casesrionegro,PobRN)
write.csv(riesgoRN,"RiesgoRioNegro.csv",row.names = FALSE)






          
