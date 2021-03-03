#!/usr/bin/gnuplot -persist

p(x,ACH,V)=1-exp(-Q*Cavg(x,ACH,V)*x)
Cavg(x,ACH,V)=(E/(ACH*V))*(1.0-(1./(ACH*x))*(1.0-exp(-ACH*x)))
GNUTERM = "qt"
E = 3.1
Q = 0.54


set xlabel "tiempo de ocupación [horas]"
set ylabel "probabilidad de contagio con 1 infectado en la sala"

plot [0:6] p(x,3,30) t 'sala chica 1 ventana abierta', \
p(x,7,30) t 'sala chica ventana y puerta abiertas', \
p(x,9,290) t 'sala grande, dos ventanas y una puerta abiertas'



#    EOF
