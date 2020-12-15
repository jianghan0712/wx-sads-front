<template>
	<view>
		 <view class="header">
		    <view class="user" hoverClass="none">
		      <view class="user_box">
		        <view catchtap="previewImage" class="logo">
		          <image src="../../static/头像.png"></image>
		          <view class="cu-tag badge"></view>
		        </view>
		          <view class="user_info">
		            <view class="user_name">
		              <view>{{userInfo.nickName}}</view>
		            </view>
		            <view class="vip_expires" bindtap='joinVip'>
		             {{areaName}}
		            </view>
		            <view class="vip_expires" bindtap='joinVip'>
		              {{userInfo.lastLoginTime}}
		            </view>          
		          </view>
		        <!-- </block> -->
		      </view>
		    </view>
		  </view>
		  <view class="nav">
		      <view bindtap="openPage" class="item"  formType="submit" hoverClass="none">
		        <view class='telphone'>
		          <text class='icon-news icon'></text>
		          <text>手机号</text>
		        </view>
		        <view class="icon">
		          <view class='icon-right'>{{userInfo.phone}}</view>
		        </view>
		      </view>
		      <view bindtap="openPage" class="item"  formType="submit" hoverClass="none">
		        <view class='email'>
		          <text class='icon-favor icon'></text>
		          <!-- <text decode="{{true}}" space="{{true}}">&nbsp;&nbsp;</text> -->
		          <text>电子邮箱</text>
		        </view>
		        <view class="icon">
		          <view class='icon-right'>{{userInfo.userEmail}}</view>
		        </view>
		      </view>
		   </view>
		   <view class="buttom">
			   <view class="btn-row">
					<button  class="logout"  @tap="bindLogout">退出登录</button>
			   </view>
		   </view>
	</view>
</template>

<script>
	import urlAPI from '@/common/vmeitime-http/'
	
	export default {

		data() {
			return {
				userInfo:{
					userId:'',
					nickName:'',
					userName:'',
					userEmail:'',
					phone:'',
					lastLoginTime:''
				},
				area:'',
				token:''
			}
		},
		created() {
			this.userInfo = JSON.parse(uni.getStorageSync("userInfo"))
			this.areaName = uni.getStorageSync("areaName")
			this.token = uni.getStorageSync("token")
			console.log("mine:",this.userInfo)
		},
		methods: {
			bindLogout(){
				var url = '/pentaho/user/logOut'
				var param = {token:this.token}
				urlAPI.getRequest(url, param).then((res)=>{
					setTimeout(() => {
						this.loading = false;
							console.log('request success', res)
							uni.showToast({
								title: '请求成功',
								icon: 'success',
								mask: true
							});

							console.log('request logout success');					
							this.res = '请求结果 : ' + JSON.stringify(res);
							uni.navigateTo({
								url:"/pages/login/login"
							});
						}).catch((err)=>{
							this.loading = false;
							uni.showToast({
								title: err.errMsg,
								duration: 5000
							});
							console.log('request fail', err);
						})						
					}, 10000);
			}
		}
	}
</script>

<style>
button {
	width: 100%;
	position:absolute;
	bottom:0;
}
page {
  padding-bottom: 50rpx;
  background: #f8f8f8;
}

.header {
  padding: 0 25rpx;
  padding-top: 40rpx;
  padding-bottom: 50rpx;
  width: 100%;
  /* background: linear-gradient(#c21327, #e42e42); */
  background: linear-gradient( #00BFFF , #00BFFF);
 
  position:relative;
}

.user {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.header .gif-wave{
  position: absolute;
  width: 100%;
  bottom: 0;
  left: 0;
  z-index: 99;
  mix-blend-mode: screen;  
  height: 100rpx;   
}
.user_box {
  display: flex;
  align-items: center;
}

.edit {
  display: flex;
  width: 70rpx;
  height: 70rpx;
  padding: 18rpx;
  box-sizing: border-box;
}

.edit image {
  width: 100%;
  height: 100%;
  transform: rotate(180deg);
}

.logo {
  width: 150rpx;
  height: 150rpx;
  border-radius: 50%;
  background: #fff;
  will-change: transform;
  position:relative;
}

.logo image {
  width: 100%;
  height: 100%;
}

.logo image {
  width: 100%;
  height: 100%;
  border-radius: 100%;
  will-change: transform;
}

.user_info {
  padding-left: 32rpx;
}

.user_name {
  display: flex;
  align-items: center;
  font-size: 36rpx;
  font-weight: bold;
  color: #fff;
}

.user_name image {
  margin-left: 16rpx;
  width: 84rpx;
  height: 31rpx;
}

.vip_expires {
  margin-top: 12rpx;
  font-size: 27rpx;
  color: #fff;
}

.info {
  display: flex;
  margin-top: 62rpx;
  width: 100%;
  height: 110rpx;
}

.info .item {
  flex: 1;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-direction: column;
  line-height: 1.5;
  border-right: 1px solid #fff;
  /* padding: 10px;
  display: flex;
  justify-content: space-between; */
}

.info .item:last-child {
  border-right: none;
}

.info .item .count {
  font-size: 46rpx;
  color: #fff;
}

.info .item .title {
  font-size: 24rpx;
  color: #fff;
}

.card {
  display: flex;
  justify-content: space-between;
  padding: 25rpx;
  background: #fff;
}

.card .item {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 340rpx;
  height: 200rpx;
  font-size: 34rpx;
  color: #fff;
  border-radius: 16rpx;
  background: #d2d2d2;
  overflow: hidden;
  will-change: transform;
}

.card .item image {
  width: 100%;
  height: 100%;
}

.nav {
  padding: 0 25rpx;
  font-size: 34rpx;
  background: #fff;
}

.nav .item {
  display: flex;
  justify-content: space-between;
  border-bottom: 1px solid #e5e5e5;
  padding: 30rpx 0;
}

.nav .exit {
  display: flex;
  justify-content: center;
  border-bottom: 1px solid #e5e5e5;
  padding: 30rpx;
  text-align:center;
}

.nav button.exit {
  margin: 0;
  line-height: inherit;
  font-size: inherit;
  text-align: inherit;
}

.nav button.item {
  margin: 0;
  line-height: inherit;
  font-size: inherit;
}

.nav button.item .new_tips {
  position: relative;
}

.nav button.item .new_tips:before {
  content: '';
  position: absolute;
  top: -2rpx;
  right: -14rpx;
  width: 20rpx;
  height: 20rpx;
  background-color: #f43530;
  border-radius: 100%;
}

.nav .icon {
  display: flex;
  align-items: center;
  font-size: 40rpx;
  color:#333;
}
.nav .wallet{
  display:inline-flex;
}
.nav .wallet .icon {
  color: #c21327;
}

.nav .discount_coupon .icon {
  color: #bd9445;
}

.nav image {
  margin-left: 20rpx;
  width: 40rpx;
  height: 40rpx;
}
.joinVip{
  font-size:27rpx;
  line-height:27rpx;
  display:inline-block;
  color:#dab643;
  text-decoration:underline;
}
  .logout{
        margin-top: 150rpx;
		justify-content: center;
		background-color: #00BFFF;
		color: #FFFFFF;
    }
</style>
