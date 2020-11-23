<template>
	<view class="content">
		 <progress ref="progress_1" :dataAs="pieData"></progress>
	</view>
</template>

<script>
	import "@/common/uni.css";
	import progress from "@/components/sads-components/progress.vue";
	
	export default {
		components: {
			progress
		},
		data(){
			return{
				btnum : 0,
				series: [{name: '单关', zhanbi:'34%',data: 400},
					{name: '2X1', zhanbi:'24%', data: 350},
					{name: '3X1', zhanbi:'29%', data: 330}
				],
				pieData:{}
			}
		},
		methods: {

		},
		onLoad(option){//opthin为object类型，会序列化上页面传递的参数
			this.btnum = option.btnnum
			this.pieData = JSON.parse(option.data); // 字符串转对象
			console.log("btnum=",this.btnum)
			console.log("data=",this.pieData)
			this.$refs['progress_1'].showProgress(this.pieData);
		}
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
