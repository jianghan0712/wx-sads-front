<template>
	<view class="progress-box">
		<view  v-for="(i, index) in pgList" >
			<view class="progress-detail">
				<view class="title">
		<!-- 			<view style="text-align: left;">{{i.name}}  {{i.percent}}%</view>
					<view style="text-align: right;">{{i.data}}</view> -->
					<view >{{i.name}}  </view>
					<view >{{i.percent}}%</view>
					<view >{{i.data}}</view>
				</view>			        
				<progress :percent="i.percent" active :activeColor="i.color" stroke-width="4" />
				<!-- <progress :percent="i.percent" active activeColor="#F89A25" stroke-width="4" /> -->
			</view>
		</view>
	</view>
</template>

<script>
	import uniIcons from '@/components/uni/uni-icons/uni-icons.vue'
	import numberFun from '@/common/tools/number.js';
	
	export default {
		props: {
			dataAs: {
				//数据
				type: Object,
				default: () => ({})
			},
		},
		components: {
		    uniIcons
		},
		data() {
			return {
				title:'',
				dataList:{},
				pgList:[],
				colors: ['#F5A623', '#F8C61C','#BDD064', '#5BB35F', '#3FA4A4', '#398FEE', '#90ed7d'],
			}
		},
		methods: {
			showProgress(pieData) {
				// this.dataList = this.dataAs;
				this.dataList=pieData
				let series = this.dataList.series;
				console.log("progress: dataList=",this.dataList);
				console.log("progress: series=",series);
				let total = 0;
				let i = 0;
				let len = 0;
				
				var max = 0
				for(i = 0,len=series.length; i < len; i++) {
					if(max<series[i].data){
						max = series[i].data
					}
				}
				var format0 = numberFun.formatCNumber(max);
				
				for(i = 0,len=series.length; i < len; i++) {
					total = total + series[i].data;
					console.log("i=" + i+",name="+series[i].name+",value="+series[i].data);
				}
				console.log("total=" + total);
				i=0
				for(i= 0; i < len; i++) {
					var xx=(series[i].data/total*100).toFixed(2);
					if(xx=="NaN"){
						xx=0;
					}
					var jsonObj = {"name": series[i].name,
					               "data" : (series[i].data/format0.value).toFixed(2) + format0.name,
								   "percent":xx,
								   "color":this.colors[i]};			
					this.pgList[i]=jsonObj;
				}
				console.log("pgList=" + this.pgList);
			}
		},
	}
</script>

<style>
	.sale-row-2{
		display: flex;
		flex-direction: row;	
		margin: 20rpx 10rpx 20rpx 10rpx;
		/* padding: 20rpx 10rpx 20rpx 10rpx;	 */
	}
	.title{
		display: flex;
		flex-direction: row;
		width: 100%;
		margin: 0rpx 5rpx;
		padding: 0 10rpx; 
		justify-content: space-between;
		font-size: 30rpx;
	}
	.progress-detail{
		flex-direction: row;
		margin: 20rpx 20rpx 40rpx 20rpx;
		width: 100%;
		height: 40px;
	}
	
    .progress-box {
		/* display: flex; */
		flex-direction: row;	
		margin: 20rpx 10rpx 20rpx 10rpx;
/*       display: flex;
        height: 50rpx; */
		width: 100%;
        /* margin-bottom: 60rpx; */
    }

    .uni-icon {
        line-height: 1.5;
    }

    .progress-cancel {
        margin-left: 40rpx;
    }
    
    .progress-control button{
        margin-top: 20rpx;
    }
	
</style>
