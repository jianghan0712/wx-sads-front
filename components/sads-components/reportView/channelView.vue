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
				var url = 'pentaho/plugin/cda/api/doQuery17/1/1/1/1/1';
				urlAPI.getRequest(url, null).then((res)=>{
					this.loading = false;
					var data =res.data.concreteBean;	
					
					console.log(data)				
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
					for(var i=0;i<data.length;i++){
						shangzhou1.push(data[i][1]);
						shangzhou2.push(data[i][2]);
						shangzhou3.push(data[i][3]);
						benzhou1.push(data[i][1]);
						benzhou2.push(data[i][2]);
						benzhou3.push(data[i][3]);
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
					that.$set(that.histogramChart1,'series',series1);
					that.$set(that.histogramChart2,'series',series2);
					that.$set(that.histogramChart3,'series',series3);
					this.$refs['histogramChart1'].showCharts();
					this.$refs['histogramChart2'].showCharts();
					this.$refs['histogramChart3'].showCharts();
					
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
