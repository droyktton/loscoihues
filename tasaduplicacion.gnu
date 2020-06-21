# Tasa de duplicacion: 
# algoritmo del ministerio implementado en gnuplot 

do for[i=3:14]{
	fit [115-i:115] f(x) 'CasosNuevosRNyBRC.csv' u 0:(log($3)/log(2)) via a,b; 
	print i, 1./a, a_err/a**2, 100*a/a_err, FIT_STDFIT;
}
