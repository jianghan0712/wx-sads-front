import Vue from 'vue'
import App from './App'
// import store from './store'  // 与vue项目中配置相同，可自行配置

import request from './common/request.js'
import api from './api/index.js'
import url from './common/config.js'



import urlAPI from '@/common/vmeitime-http/'
import numberFun from '@/common/tools/number.js'
import dateUtils from '@/common/tools/dateUtils.js'
import commonFun from './common/tools/watcher.js'
import './common/style/style.css'

    // 全局挂载后使用
Vue.prototype.$urlAPI = urlAPI
Vue.prototype.$numberFun = numberFun
Vue.prototype.$dateUtils = dateUtils


Vue.config.productionTip = false
Vue.prototype.$request = request
Vue.prototype.$api = api
Vue.prototype.$url = url
Vue.prototype.$commonFun = commonFun

App.mpType = 'app'

const app = new Vue({
    ...App
	// store
})

const vue =Vue;
const ballType ='足球';
const userId ='';
const userName='';
app.$mount()
