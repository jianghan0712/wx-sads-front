<template>
	<view class="content">
	         <view class="uni-list">
	             <view class="uni-list-cell" v-for="(item,index) in series" :key="index">
	                  <view class="uni-navigate-right" style="font-size: 40rpx;">
	                       {{item.name}}
	                  </view>
					  <view class="uni-navigate-right" style="font-size: 40rpx;">
					       {{item.zhanbi}}
					  </view>
					  <view class="uni-navigate-right" style="font-size: 40rpx;">
					       {{item.data}}元
					  </view>
	             </view>
	         </view>
	    </view>
</template>

<script>
	import "@/common/uni.css";
	
	export default {
		data(){
			return{
				btnum : 0,
				series: [{name: '单关', zhanbi:'34%',data: 400},
					{name: '2X1', zhanbi:'24%', data: 350},
					{name: '3X1', zhanbi:'29%', data: 330}
				]
			}
		},
		methods: {

		},
		onLoad(option){//opthin为object类型，会序列化上页面传递的参数
			this.btnum = option.btnnum
		},

	}

</script>

<style>
.uni-list-cell {
	margin: 20rpx 10rpx 20rpx 10rpx;
	padding: 20rpx 10rpx 20rpx 10rpx;	
	height: 60px;
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	/* align-items: center; */
}

.title{
	font-size: 15px;
	width: 200rpx;
}
.zhanbi{
	font-size: 15px; 
	width: 200rpx;
}
.data{
	font-size: 15px; 
	-webkit-flex: 1;
	flex: 1;
	text-align: right;
}

</style>
