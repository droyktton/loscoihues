gawk 'BEGIN{FS=","; OFS=",";rn=0;brc=0;}{if(NR>1){rn=rn+$2;brc=brc+$2;print $1,$2,$3,rn,brc;}}' CasosNuevosRNyBRC.csv > CasosNuevosRNyBRCacum.csv
