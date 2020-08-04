set datafile sep ','; 

fechaayer=system("tail -n 1 RiesgoBariloche | awk -F ',' '{print $1}'")
fechahoy=system("tail -n 1 ../RiesgoBariloche | awk -F ',' '{print $1}'")

set term png 
set out sprintf("RiesgoBariloche_%s_%s.png",fechaayer,fechahoy);

set xla 'A14'
set yla 'R7'

set title 'RiesgoBariloche'
plot 'RiesgoBariloche' u 3:2 t fechaayer w lp,\
'../RiesgoBariloche' u 3:2 w lp t fechahoy,1 t ''
