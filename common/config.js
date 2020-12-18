let url_config = ""

if(process.env.NODE_ENV === 'development'){
    // 开发环境
    // url_config = 'http://192.168.54.110:8088'
	 url_config = 'https://m.csljc.com:8443/'
	 // url_config = 'http://192.168.1.105:8901/'
}else{
    // 生产环境
	// url_config = 'http://192.168.54.110:8088'
     url_config = 'https://m.csljc.com:8443/'
}

export default url_config