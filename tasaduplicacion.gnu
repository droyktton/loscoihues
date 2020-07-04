# Tasa de duplicacion: 
# algoritmo del ministerio implementado en gnuplot 

set datafile sep ","

f(x)=a*x+b
set fit quiet

print "#RN"
do for[i=3:14]{
	fit [115-i:115] f(x) 'CasosNuevosRNyBRC.csv' u 0:(log($2)/log(2)) via a,b; 
	print i, 1./a, a_err/a**2, 100*(a_err/a**2)/(1./a), FIT_STDFIT;
}

print ""
print ""
print "#BRC"
print "#desdedia taudup errortaudup %errortaudup STDFIT"
do for[i=3:14]{
	fit [115-i:115] f(x) 'CasosNuevosRNyBRC.csv' u 0:(log($3)/log(2)) via a,b; 
	print i, 1./a, a_err/a**2, 100*(a_err/a**2)/(1./a), FIT_STDFIT;
}


