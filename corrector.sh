awk '{
	if($0~"\"Feature\""){
		print sprintf("%s \"id\":\"%d\",",$0, i); 
		i++;
	}
	else{
		print $0;
	};
}' $1 
