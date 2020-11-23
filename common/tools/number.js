
export const formatCNumber = (number) => {
	var temp = number/100000000;

	if(temp>1){
		return {"name":"亿","value":100000000};
	}
	
	temp=number/1000000;
	if(temp>1){
		return {"name":"百万","value":1000000};
	}
	
	temp=number/10000;
	if(temp>1){
		return {"name":"万","value":10000};
	}
	
	return {"name":"","value":1};
}

export default {
	formatCNumber
}