<template>
    <view class="content">
        <view class="title">
            <p>登录</p>
        </view>
        <view>
            <p>账号</p>
            <input type="text" v-model="loginInfo.username" class="username">
            <p>密码</p>
            <input type="password" v-model="loginInfo.password" class="username">
        </view>
        <view>
            <button type="primary" class="login" @click="submit">登录</button>
        </view>
    </view>
</template>

<script>
    import {mapActions} from 'vuex'
	import urlAPI from '@/common/vmeitime-http/';
	import dateUtils from '@/common/tools/dateUtils.js';
	import loginUtil from '@/common/tools/util.js'
	
    export default {
        data() {
            return {
                loginInfo:{
                    username: '',
                    password: '',
                },
				selfParam:{
					token:'',
					provinceCenterId:'',
					provinceCenterName:'',
					businessDate:{
						view:dateUtils.getToday(),
						date:{startDate:dateUtils.getToday(), endDate:dateUtils.getToday()},
						week:{startDate:'', endDate:''},
						month:{startDate:'', endDate:''},
						year:{startDate:'', endDate:''},
					},					
					startDate:'',
					endDate:'',
					cityCenterId:'',
					userId:'',
					countyCenterId:'',
					dateType:'date',
					compareType:'date',
					compareOne:dateUtils.getToday(),
					compareTwo:'',
					selfProvinceCenterId:''
				},
				userinfo:{
					userId:'',
					nickName:'',
					userName:'',
					userEmail:'',
					phone:'',
					lastLoginTime:''
				},
				areaMap:[]
            }
        },
        onLoad() {

        },
        methods: {
			getUserInfo(){
				var url = '/pentaho/user/getUserInfo';
				var param = {userName:this.loginInfo.userame,token:this.selfParam.token}
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
						console.log('request success', res)
						uni.showToast({
							title: '请求成功',
							icon: 'success',
							mask: true
						});
						
						var data = res.data.data;
						this.userinfo.userId = data.userId
						this.userinfo.nickName = data.nickName
						this.userinfo.userName = data.userName
						this.userinfo.userEmail = data.userEmail
						this.userinfo.phone = data.phone
						this.userinfo.lastLoginTime = dateUtils.getTime()
						uni.setStorageSync("userInfo",JSON.stringify(this.userinfo))
												
						this.res = '请求结果 : ' + JSON.stringify(res);
						console.log('getUserInfo=', this.userinfo)
						
						// this.gotoMainPage(JSON.stringify(selfParam))
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					})			
			},
			getUserRight(){
				var url = '/pentaho/user/getUserPower';
				var param = {userId:this.userinfo.userId, token:this.selfParam.token}
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
						console.log('request success', res)
						uni.showToast({
							title: '请求成功',
							icon: 'success',
							mask: true
						});
						
						var data = res.data.data;
						this.selfParam.provinceCenterId = data.provincialId
						this.selfParam.selfProvinceCenterId = data.provincialId
						this.selfParam.userId = data.userId
					
						this.res = '请求结果 : ' + JSON.stringify(res);
						console.log('getUserRight=', this.selfParam)
						
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					})
					this.getAreaMap()
			},
			getAreaMap(){
				var url = '/pentaho/shows/getProvincialList';
				var param = {token:this.selfParam.token}
				var result = [] 
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
						console.log('request success', res)
						uni.showToast({
							title: '请求成功',
							icon: 'success',
							mask: true
						});
						
						var data = res.data.data;
						for(var i=0;i<data.length;i++){
							var json = {id:data[i][0],name:data[i][1]}
							result[i]=json
							if(data[i][0]==this.selfParam.provinceCenterId){
								 this.selfParam.provinceCenterName = data[i][1]
							}
						}	
						this.areaMap=result;
						
						console.log('login this.areaMap', this.areaMap);
						this.res = '请求结果 : ' + JSON.stringify(res);	
						// this.gotoMainPage(JSON.stringify(this.selfParam))
						this.gotoMainPage(this.selfParam)
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					})
				
			
			},
			gotoMainPage(selfParam){
				console.log("gotoMainPage =",selfParam)
				uni.setStorageSync("dateType",selfParam.dateType)
				uni.setStorageSync("selfParam",JSON.stringify(selfParam))
				uni.setStorageSync("areaMap", JSON.stringify(this.areaMap))
				uni.setStorageSync("area",selfParam.provinceCenterId)
				uni.setStorageSync("areaName",selfParam.provinceCenterName)
				uni.setStorageSync("businessDate", JSON.stringify(selfParam.businessDate));
				uni.setStorageSync("token",selfParam.token)
				// uni.navigateBack()
				uni.switchTab({
					url: "/pages/sales/index"
				});
			},
            submit(){		
				console.log(this.form)
				var url = '/pentaho/user/logIn';
				//,this.loginInfo.password
				var password = loginUtil.encrypt('0000zxcv.','');
				var param={userName:'Test001', userPwd:password}
				//'dRZ9LYoPExQPDWhTBFWRNw==   0000zxcv.'
				//var param={userName:this.loginInfo.username, userPwd:password}
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					uni.showToast({
						title: '请求成功',
						icon: 'success',
						mask: true
					});
					
					var data = res.data.data;
					this.selfParam.token = data.msg;
					getApp().globalData.token=data.msg;
					console.log(data)
					if(data.flag){
						this.getUserInfo()
						this.getUserRight()
					}else{
						console.log('request fail', err);
						uni.showToast({
							title: '登陆失败',
							// icon: 'success',
							mask: true
						});
					}
					console.log(checkResult)
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
					uni.showToast({
						title: '登陆失败',
						// icon: 'success',
						mask: true
					});
				})
            }
        }
    }
</script>

<style scoped>
    .title{
        font-weight: bold;
        margin: 10rpx 0 40rpx 0;
        font-size: 44rpx;
        color: white;
    }
    .username{
        height: 80rpx;
        margin:10rpx 0 40rpx 0;
        width: 600rpx;
        border-radius: 10rpx;
        border: #007aff 2rpx solid;
        background-color: rgba(200, 199, 204, 0.36);
    }
    .content {
        background-size: 100% 100%;
        padding: 70rpx;
        margin: 0 auto;
        text-align: center;
        height: 90.3vh;
    }
    .login{
        width: 400rpx;
        margin-top: 150rpx;
        color: white;
		background-color: rgba(200, 199, 204, 0.36);
    }
</style>