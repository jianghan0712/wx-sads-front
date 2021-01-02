import http from './interface'

/**
 * 将业务所有接口统一起来便于维护
 * 如果项目很大可以将 url 独立成文件，接口分成不同的模块
 * 
 */

export const getRequest = (url,data) => {	

	http.interceptor.response = (response) => {
		console.log('个性化response....')
		//判断返回状态 执行相应操作
		return response;
	}
    return http.request({
		// baseUrl: 'http://192.168.1.105:8901/',
		// baseUrl: 'http://192.168.54.110:8088/',
		 // baseUrl :'https://m.csljc.com:8443/',
		  baseUrl :'https://m.lottery-sports.com:8443/',
		
		// baseUrl: 'https://www.jianghan0712.com/',
        url,
		dataType: 'json',
        data,
    })
}


// 默认全部导出  import api from '@/common/vmeitime-http/'
export default {
	getRequest
}