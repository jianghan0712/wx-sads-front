<template>
	<view class="progress-box">
		<!-- <view class="uni-padding-wrap uni-common-mt"> -->
		    <!-- <view class="progress-box"> -->
			<view  v-for="i in pgList" >
			    <view class="progress-detail">
					<view class="title">
						<view style="text-align: left;">{{i.name}}  {{i.percent}}%</view>
						<view style="text-align: right;">{{i.data}}</view>
					</view>			        
			        <progress :percent="i.percent" active activeColor="#10AEFF" stroke-width="3" />
			    </view>
			</view>
	</view>
</template>

<script>
	import uniIcons from '@/components/uni/uni-icons/uni-icons.vue'
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
				dataList:{},
				pgList:[],
			}
		},
		methods: {
			showProgress() {
				this.dataList = this.dataAs;
				let series = this.dataList.series;
				let total = 0;
				let i = 0;
				let len = 0;
				for(i = 0,len=series.length; i < len; i++) {
					total = total + series[i].data;
					console.log("i=" + i+",name="+series[i].name+",value="+series[i].data);
				}
				console.log("total=" + total);
				i=0
				for(i= 0; i < len; i++) {
					var jsonObj = {"name": series[i].name,
					               "data" : series[i].data,
								   "percent":(series[i].data/total*100).toFixed(2)
									};			
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
	}
	.progress-detail{
		flex-direction: row;
		margin: 20rpx 20rpx 40rpx 20rpx;
		width: 100%;
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
