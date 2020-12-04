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
			<view style="text-align: right;">
			    <view @tap="changeTop('1')"  :class="fjltype =='1'?'btna':'hide'" >竞猜</view>
			    <view @tap="changeTop('2')" :class="fjltype =='2'?'btna':'hide'" >足球</view>
				<view @tap="changeTop('3')" :class="fjltype =='3'?'btna':'hide'" >篮球</view>
			</view>
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
				//返奖率类型 1竞猜 2足球 3篮球
				fjltype:'1',
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
				var token =getApp().globalData.token;
				var url = '/pentaho/dailyPaper/salesAndVotesSevenTread';
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
					var xiaoliangAll=data.sales;
					var piaoshuAll=data.votes;
					
					var series =[];
					var shangzhouXL=[];
					var benzhouXL=[];
					var shangzhouPS=[];
					var benzhouPS=[];
					for(var i=0;i<data.length/2;i++){
						shangzhouXL.push(xiaoliangAll[i]);
						benzhouXL.push(xiaoliangAll[i+7]);
						shangzhouPS.push(piaoshuAll[i]);
						benzhouPS.push(piaoshuAll[i+7]);
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
				//1-2关
				url = '/pentaho/dailyPaper/getTwoPassSevenTread';
				param={dateTime:'2020-01-03',
							regionId:'',
							token:token};
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					var data =res.data.data;	
					/* 
					 前7个是上一周 后七个是这一周
					 */
					var votes=data.votes;
					
					var series =[];
					var shangzhouvotes=[];
					var benzhouvotes=[];
					for(var i=0;i<data.length/2;i++){
						shangzhouvotes.push(votes[i]);
						benzhouvotes.push(votes[i+7]);
					};
					
					var series1 =[
							{ name: '上周', data: shangzhouvotes },
							{ name: '本周', data: benzhouvotes }
						];
					that.$set(that.histogramChart3,'series',series1);
					this.$refs['histogramChart3'].showCharts();
					
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				//1-2关
				url = '/pentaho/dailyPaper/getMoneySevenTread';
				param={dateTime:'2020-01-03',
							regionId:'',
							token:token};
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					var data =res.data.data;	
					/* 
					 前7个是上一周 后七个是这一周
					 */
					var votes=data.votes;
					
					var series =[];
					var shangzhouvotes=[];
					var benzhouvotes=[];
					for(var i=0;i<data.length/2;i++){
						shangzhouvotes.push(votes[i]);
						benzhouvotes.push(votes[i+7]);
					};
					
					var series1 =[
							{ name: '上周', data: shangzhouvotes },
							{ name: '本周', data: benzhouvotes }
						];
					that.$set(that.histogramChart4,'series',series1);
					this.$refs['histogramChart4'].showCharts();
					
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				this.loadFJL('1');
				
			},
			changeTop(e){
				this.fjltype = e;
				this.loadFJL(e);
				
			},
			loadFJL(e){
				var that =this;
				var token =getApp().globalData.token;
				//返奖率
				var url = '/pentaho/dailyPaper/getReturnRateSevenTread';
				var param={dateTime:'2020-01-03',
							regionId:'',
							token:token};
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					var data =res.data.data;	
					/* 
					 前7个是上一周 后七个是这一周
					 */
					var votes;
					if(e=='1'){
						votes=data.ALL;
					}else if(e=='2'){
						votes=data.FB;
					}else if(e=='3'){
						votes=data.BK;
					}
					var votes=data.votes;
					
					var series =[];
					var shangzhouvotes=[];
					var benzhouvotes=[];
					for(var i=0;i<data.length/2;i++){
						shangzhouvotes.push(votes[i]);
						benzhouvotes.push(votes[i+7]);
					};
					
					var series1 =[
							{ name: '上周', data: shangzhouvotes },
							{ name: '本周', data: benzhouvotes }
						];
					that.$set(that.histogramChart5,'series',series1);
					this.$refs['histogramChart5'].showCharts();
					
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
	.btna{
		color: #000000;
		background: #ebebeb;
		padding:0px 30rpx 0px 30rpx;
		text-align: center;
		line-height: 60rpx;
		font-family:'Franklin Gothic Medium', 'Arial Narrow', Arial, sans-serif;
		width: 100rpx;
		display: inline;
	}
	.hide{
		color: #000000;
		background: #FFFFFF;
		padding:0px 30rpx 0px 30rpx;
		text-align: center;
		line-height: 60rpx;
		font-family:'Franklin Gothic Medium', 'Arial Narrow', Arial, sans-serif;
		width: 100rpx;
		display: inline;
	}
</style>
