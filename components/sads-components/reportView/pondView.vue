<template>
	<view>
		<view class ='centerView' style="width: 100%; padding-top: 30rpx;">
			<view style="text-align: center;width: 100%;padding-bottom: 20rpx;color: blue;">奖池</view>
		</view>
		<view class="padding">
			<view style="font-size: 30rpx;padding-left: 20rpx;" >足球奖池七天走势</view>
			<view style="font-size: 30rpx;padding-left: 20rpx;" >单位(万个)</view>
			<histogram-chart ref="histogramChart1" canvasId="histogramChart1" :dataAs="histogramChart1" />
		</view>
		<view class="padding">
			<view style="font-size: 30rpx;padding-left: 20rpx;" >足球调节基金七天走势</view>
			<view style="font-size: 30rpx;padding-left: 20rpx;" >单位(百万张)</view>
			<histogram-chart ref="histogramChart2" canvasId="histogramChart2" :dataAs="histogramChart2" />
		</view>
		<view class="padding">
			<view style="font-size: 30rpx;padding-left: 20rpx;" >篮球奖池七天走势</view>
			<view style="font-size: 30rpx;padding-left: 20rpx;" >单位(亿元)</view>
			<histogram-chart ref="histogramChart3" canvasId="histogramChart3" :dataAs="histogramChart3" />
		</view>
		<view class="padding"> 
			<view style="font-size: 30rpx;padding-left: 20rpx;" >篮球调节基金七天走势</view>
			<view style="font-size: 30rpx;padding-left: 20rpx;" >单位(元)</view>
			<histogram-chart ref="histogramChart4" canvasId="histogramChart4" :dataAs="histogramChart4" />
		</view>
		<backTop :src="backTop.src"  :scrollTop="backTop.scrollTop"></backTop>
	</view>
</template>

<script>
	
	import HistogramChart from '@/components/basic-chart/HistogramChart.vue';
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
				 },
				 histogramChart4: {
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
				var token=getApp().globalData.token;
				//地区日销量及周同比
				var param={dateTime:'2020-01-03',
							regionId:'',
							token:token};
				var url = '/pentaho/dailyPaper/getAwardAndSystem';
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					var data =res.data.data;	
					
					var fbCum = data.fbCum;
					var fbAdjust = data.fbAdjust;
					var bkCum = data.bkCum;
					var bkAdjust = data.bkAdjust;
					
					//上周等于这周
					var shangzhou1=[];
					var benzhou1=[];
					var shangzhou2=[];
					var benzhou2=[];
					var shangzhou3=[];
					var benzhou3=[];
					var shangzhou4=[];
					var benzhou4=[];
					//先按7条记录
					for(var i=0;i<data.length/2;i++){
						shangzhou1.push(fbCum[i]);
						shangzhou2.push(fbAdjust[i]);
						shangzhou3.push(bkCum[i]);
						shangzhou4.push(bkAdjust[i]);
						benzhou1.push(fbCum[i+7]);
						benzhou2.push(fbAdjust[i+7]);
						benzhou3.push(bkCum[i+7]);
						benzhou4.push(bkAdjust[i+7]);
					};
					
					var series1 =[
							{ name: '上周', data: shangzhou1 },
							{ name: '本周', data: benzhou1 }
						];
					var series2 =
						[
							{ name: '上周', data: shangzhou2},
							{ name: '本周', data: benzhou2 }
						];
					var series3 =
						[
							{ name: '上周', data: shangzhou3},
							{ name: '本周', data: benzhou3 }
						];
					var series4 =
						[
							{ name: '上周', data: shangzhou4},
							{ name: '本周', data: benzhou4 }
						];
					that.$set(that.histogramChart1,'series',series1);
					that.$set(that.histogramChart2,'series',series2);
					that.$set(that.histogramChart3,'series',series3);
					that.$set(that.histogramChart4,'series',series4);
					this.$refs['histogramChart1'].showCharts();
					this.$refs['histogramChart2'].showCharts();
					this.$refs['histogramChart3'].showCharts();
					this.$refs['histogramChart4'].showCharts();
					
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
		padding-bottom: 15rpx;
	}
</style>
