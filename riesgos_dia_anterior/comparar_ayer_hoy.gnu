set datafile sep ','; 
plot 'RiesgoBariloche' u 3:2 t 'ayer' w lp,\
'../RiesgoBariloche' u 3:2 w lp t 'hoy',1
