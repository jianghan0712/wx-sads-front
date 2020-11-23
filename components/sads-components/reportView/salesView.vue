<template>
	<view>
		<view class ='centerView' style="width: 100%; padding-top: 30rpx;">
			<view style="text-align: center;width: 100%;padding-bottom: 20rpx;color: blue;">销售</view>
		</view>
		<view class="padding" >
			<view style="font-size: 30rpx;padding-left: 20rpx; " >竞猜销量七天走势</view>
			<view style="font-size: 30rpx;padding-left: 20rpx;" >单位(万个)</view>
			<view >
				<histogram-chart ref="histogramChart1" canvasId="histogramChart1" :dataAs="histogramChart1" />
			</view>
		</view>
		<view class="padding">
			<view style="font-size: 30rpx;padding-left: 20rpx;" >竞猜票数七天走势</view>
			<view style="font-size: 30rpx;padding-left: 20rpx;" >单位(百万张)</view>
			<view >
				<histogram-chart ref="histogramChart2" canvasId="histogramChart2" :dataAs="histogramChart2" />
			</view >
		</view>
		<view class="padding">
			<view style="font-size: 30rpx;padding-left: 20rpx;" >1-2关七天走势</view>
			<view style="font-size: 30rpx;padding-left: 20rpx;" >单位(亿元)</view>
			<view >	
				<histogram-chart ref="histogramChart3" canvasId="histogramChart3" :dataAs="histogramChart3" />
			</view >
		</view>
		<view class="padding"> 
			<view style="font-size: 30rpx;padding-left: 20rpx;" >竞猜单票金额七天走势</view>
			<view style="font-size: 30rpx;padding-left: 20rpx;" >单位(元)</view>
			<view >
				<histogram-chart ref="histogramChart4" canvasId="histogramChart4" :dataAs="histogramChart4" />
			</view >
		</view>
		<view class="padding">
			<view style="font-size: 30rpx;padding-left: 20rpx;" >返奖率七天走势</view>
			<view style="font-size: 30rpx;padding-left: 20rpx;" >单位(%)</view>
			<view >
				<histogram-chart ref="histogramChart5" canvasId="histogramChart5" :dataAs="histogramChart5" />
			</view >	
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
				 },
				 histogramChart5: {
				 						categories: ['周一', '周二','周三', '周四', '周五', '周六','周日'],
				 						series: [
				 							{ name: '上周', data: [35, 8, 25, 37, 4, 20] },
				 							{ name: '本周', data: [35, 8, 25, 37, 4, 20] }
				 						],
				 },
			 }
		},
		methods: {
			loadData(){
				var that=this;
				var url = 'pentaho/plugin/cda/api/doQuery15/1/1/2';
				urlAPI.getRequest(url, null).then((res)=>{
					this.loading = false;
					var data =res.data.concreteBean;	
					/* {"2020-11-12", 1122, 1255},
					                {"2020-11-13", 1322, 1355},
					                {"2020-11-14", 1622, 1455},
					                {"2020-11-15", 1922, 1755},
					                {"2020-11-16", 1522, 1855},
					                {"2020-11-17", 1822, 1755},
					                {"2020-11-18", 1722, 1455},
					                {"2020-11-19", 1102, 1235},
					                {"2020-11-20", 1312, 1315},
					                {"2020-11-21", 1632, 1485},
					                {"2020-11-22", 1942, 1795},
					                {"2020-11-23", 1512, 1815},
					                {"2020-11-24", 1882, 1725},
					                {"2020-11-25", 1702, 1435}
									 前7个是上一周 后七个是这一周
									 销量 票数
									 */
					var series =[];
					var shangzhouXL=[];
					var benzhouXL=[];
					var shangzhouPS=[];
					var benzhouPS=[];
					for(var i=0;i<data.length/2;i++){
						shangzhouXL.push(data[i][1]);
						benzhouXL.push(data[i+7][1]);
						shangzhouPS.push(data[i][2]);
						benzhouPS.push(data[i+7][2]);
					};
					
					var series1 =[
							{ name: '上周', data: shangzhouXL },
							{ name: '本周', data: benzhouXL }
						];
					var series2 =
						[
							{ name: '上周', data: shangzhouPS},
							{ name: '本周', data: benzhouPS }
						];
					that.$set(that.histogramChart1,'series',series1);
					that.$set(that.histogramChart2,'series',series2);
					this.$refs['histogramChart1'].showCharts();
					this.$refs['histogramChart2'].showCharts();
					
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				
				
				this.$refs['histogramChart3'].showCharts();
				this.$refs['histogramChart4'].showCharts();
				this.$refs['histogramChart5'].showCharts();
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
