res
set logs
set xla 'Casos Acumulados'
set yla 'Casos Activos'
acum=0; 

set key left

#plot [][1:] for[file in system("ls NuevosCasosConfirmadosPorDia*.csv")] \
#sprintf("< awk -F ',' '{acum=acum+$2; print $2,acum;}' %s",file)  u 2:1 t col,x*0.05

# d a14/ dt = -(1/tau) a14 + n (1/tau)
# a14 = a14 -(dt/tau) [a14 + n ]

plot [:][:] for[file in system("ls NuevosCasosConfirmadosPorDia*.csv")] \
sprintf("< awk -F ',' 'BEGIN{a14=0.0; acum=0.0;}{a14 = a14+(-a14 + $2)/14.0; acum=acum+$2; print a14,acum;}' %s",file)  u 2:1 t system(sprintf("echo %s | awk '{nom= substr($1,29); split(nom,a,\".\"); print a[1];}'",file)),\
x**1.0*0.05,x**0.95*0.05

