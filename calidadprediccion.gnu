res
set datafile sep ','; 

set xla 'día'
#set yla 'Predicción y Observación'

set key left

set multi lay 2,2

set title 'Bariloche-Rio Negro (datos MSN)'
plot 'RiesgoBariloche' u ($0+7):($2*$3) w lp t 'Predicción hecha 7 días antes' lc 7 pt 6, '' u 0:3 w lp t 'reporte'

set title 'CABA-Comuna 1 (datos MSN)'
plot 'RiesgoCABACOMUNA1' u ($0+7):($2*$3) w lp t '' lc 7 pt 6, '' u 0:3 w lp t ''


set title 'Ledesma-Jujuy (datos MSN)'
plot 'RiesgoJujuyLedesma' u ($0+7):($2*$3) w lp t '' lc 7 pt 6, '' u 0:3 w lp t ''


set title 'Avellaneda-Buenos Aires (datos MSN)'
plot 'RiesgoAvellanedaNA' u ($0+7):($2*$3) w lp t '' lc 7 pt 6, '' u 0:3 w lp t ''

unset multi
