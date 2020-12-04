<template>
	<view>
		<view class ='centerView' style="width: 100%; padding-top: 30rpx;">
			<view style="text-align: center;width: 100%;padding-bottom: 20rpx;color: blue;">渠道</view>
		</view>
		<view class="padding">
			<view style="font-size: 30rpx;padding-left: 20rpx;" >有销量门店数七天走势</view>
			<view style="font-size: 30rpx;padding-left: 20rpx;" >单位(万个)</view>
			<histogram-chart ref="histogramChart1" canvasId="histogramChart1" :dataAs="histogramChart1" />
		</view>
		<view class="padding">
			<view style="font-size: 30rpx;padding-left: 20rpx;" >"0"销量门店数七天走势</view>
			<view style="font-size: 30rpx;padding-left: 20rpx;" >单位(万个)</view>
			<histogram-chart ref="histogramChart2" canvasId="histogramChart2" :dataAs="histogramChart2" />
		</view>
		<view class="padding">
			<view style="font-size: 30rpx;padding-left: 20rpx;" >销量超限门店七天走势</view>
			<view style="font-size: 30rpx;padding-left: 20rpx;" >单位(个)</view>
			<histogram-chart ref="histogramChart3" canvasId="histogramChart3" :dataAs="histogramChart3" />
		</view>
		<backTop :src="backTop.src"  :scrollTop="backTop.scrollTop"></backTop>
	</view>
</template>

<script>
	
	import HistogramChart from '@/components/basic-chart/HistogramChart.vue';
	import LineChart from '@/components/basic-chart/LineChart.vue';
	import urlAPI from '@/common/vmeitime-http/';
	import backTop from '@/components/sads-components/back-top.vue';
	
	export default {
		components: {
			HistogramChart,
			backTop
		},
		/* props: {
			model:{
				type: Object,
				default: () => ({})
			}
		}, */
		data() {
			return {
				backTop: {
										src: '../../static/top.png',
										scrollTop: 0
				},
				scrollTop: 0,
				 histogramChart1: {
						categories: ['周一', '周二','周三', '周四', '周五', '周六','周日'],
						series: [
							{ name: '上周', data: [35, 8, 25, 37, 4, 20] },
							{ name: '本周', data: [35, 8, 25, 37, 4, 20] }
						],
				 },
				 histogramChart2: {
				 						categories: ['周一', '周二','周三', '周四', '周五', '周六','周日'],
				 						series: [
				 							{ name: '上周', data: [35, 8, 25, 37, 4, 20] },
				 							{ name: '本周', data: [35, 8, 25, 37, 4, 20] }
				 						],
				 },
				 histogramChart3: {
				 						categories: ['周一', '周二','周三', '周四', '周五', '周六','周日'],
				 						series: [
				 							{ name: '上周', data: [35, 8, 25, 37, 4, 20] },
				 							{ name: '本周', data: [35, 8, 25, 37, 4, 20] }
				 						],
				 }
			 }
		},
		methods: {
			loadData(){
				var that=this;
				var token =getApp().globalData.token;
				var url = '/pentaho/dailyPaper/getStoreSituSevenTread';
				var param={dateTime:'2020-01-03',
							regionId:'',
							token:token};
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					var data =res.data.data;	
					/* 
					 前7个是上一周 后七个是这一周
					 销量 票数
					 */
					var storeCount=data.storeCount;
					
					var series =[];
					var shangzhou=[];
					var benzhou=[];
					for(var i=0;i<data.length/2;i++){
						shangzhou.push(storeCount[i]);
						benzhou.push(storeCount[i+7]);
					};
					
					var series =[
							{ name: '上周', data: shangzhou },
							{ name: '本周', data: benzhou }
						];
					
					that.$set(that.histogramChart1,'series',series);
					this.$refs['histogramChart1'].showCharts();
					
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				url = '/pentaho/dailyPaper/get0SalesStoreSevenTread';
				param={dateTime:'2020-01-03',
							regionId:'',
							token:token};
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					var data =res.data.data;	
					/* 
					 前7个是上一周 后七个是这一周
					 销量 票数
					 */
					var storeCount=data.storeCount;
					
					var series =[];
					var shangzhou=[];
					var benzhou=[];
					for(var i=0;i<data.length/2;i++){
						shangzhou.push(storeCount[i]);
						benzhou.push(storeCount[i+7]);
					};
					
					var series =[
							{ name: '上周', data: shangzhou },
							{ name: '本周', data: benzhou }
						];
					
					that.$set(that.histogramChart2,'series',series);
					this.$refs['histogramChart2'].showCharts();
					
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				url = '/pentaho/dailyPaper/getfiniteStoreSevenTread';
				param={dateTime:'2020-01-03',
							regionId:'',
							token:token};
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					var data =res.data.data;	
					/* 
					 前7个是上一周 后七个是这一周
					 销量 票数
					 */
					var storeCount=data.storeCount;
					
					var series =[];
					var shangzhou=[];
					var benzhou=[];
					for(var i=0;i<data.length/2;i++){
						shangzhou.push(storeCount[i]);
						benzhou.push(storeCount[i+7]);
					};
					
					var series =[
							{ name: '上周', data: shangzhou },
							{ name: '本周', data: benzhou }
						];
					
					that.$set(that.histogramChart2,'series',series);
					this.$refs['histogramChart2'].showCharts();
					
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				
			}
		},
		mounted() {
			this.loadData();
		},
		onPageScroll(e) {
			this.backTop.scrollTop = e.scrollTop;
		}
	}
</script>

<style>
	.padding{
		padding-top: 20rpx;
		padding-bottom: 30rpx;
	}
</style>
