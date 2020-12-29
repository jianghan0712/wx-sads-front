<template>
	<view>
		<view class = "box-container">
			<view style="text-align: center;font-size: 50rpx; width: 100%;padding-bottom: 20rpx;color: blue;">
				<image style="width: 50rpx;height: 40rpx;padding-right: 20rpx;" src="../../../static/left.png" mode="aspectFill">
				 奖池
				<image style="width: 50rpx;height: 40rpx;padding-left: 20rpx;" src="../../../static/right.png" mode="aspectFill">
			</view>
			<view class="padding">
				<view style="font-size: 30rpx;padding-left: 20rpx;" >足球奖池七天走势</view>
				<view style="font-size: 30rpx;padding-left: 20rpx;" >单位(亿元)</view>
				<histogram-chart ref="histogramChart1" canvasId="histogramChart1" :dataAs="histogramChart1" :basicAs="{colors:['#E5E5E5','#4A94FF']}" />
			</view>
			<view class="padding">
				<view style="font-size: 30rpx;padding-left: 20rpx;" >足球调节基金七天走势</view>
				<view style="font-size: 30rpx;padding-left: 20rpx;" >单位(亿元)</view>
				<histogram-chart ref="histogramChart2" canvasId="histogramChart2" :dataAs="histogramChart2" :basicAs="{colors:['#E5E5E5','#FFAD26']}" />
			</view>
			<view class="padding">
				<view style="font-size: 30rpx;padding-left: 20rpx;" >篮球奖池七天走势</view>
				<view style="font-size: 30rpx;padding-left: 20rpx;" >单位(亿元)</view>
				<histogram-chart ref="histogramChart3" canvasId="histogramChart3" :dataAs="histogramChart3"  :basicAs="{colors:['#E5E5E5','#FE7123']}"/>
			</view>
			<view class="padding"> 
				<view style="font-size: 30rpx;padding-left: 20rpx;" >篮球调节基金七天走势</view>
				<view style="font-size: 30rpx;padding-left: 20rpx;" >单位(亿元)</view>
				<histogram-chart ref="histogramChart4" canvasId="histogramChart4" :dataAs="histogramChart4" :basicAs="{colors:['#E5E5E5','#C8E154']}" />
			</view>
			<backTop :src="backTop.src"  :scrollTop="backTop.scrollTop"></backTop>
		</view>
	</view>
</template>

<script>
	
	import HistogramChart from '@/components/basic-chart/HistogramChart.vue';
	import urlAPI from '@/common/vmeitime-http/';
	import backTop from '@/components/sads-components/back-top.vue';
	import dateUtils from '@/common/tools/dateUtils.js';
	
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
				selfParam:{
					token:'',
					provinceCenterId:'',//当前查看的省份，如果之前是全国，这里可能会变动
					cityCenterId:'',
					provinceCenterName:'',
					countyCenterId:'',	
					compareType:'date',
					compareFlag:false,
					businessDate:{
						dateType:'',// date/week/month/year
						view:'',//用于展示日期、年、月等
						date:{startDate:'', endDate:''},
						week:{startDate:'', endDate:''},
						month:{startDate:'', endDate:''},
						year:{startDate:'', endDate:''},
					},
					compareDate:{
						dateType:'date',
						view:'',//用于展示日期、年、月等
						date:{startDate:'', endDate:''},
						week:{startDate:'', endDate:''},
						month:{startDate:'', endDate:''},
						year:{startDate:'', endDate:''},
					},	
					userId:'',			
					selfProvinceCenterId:''//存登录时候的id
				},
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
			returnFromDatePicker(){
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				const dateType = uni.getStorageSync("dateType")
				const bussinessDate = JSON.parse(uni.getStorageSync("businessDate"))
				this.selfParam.businessDate = bussinessDate;
				console.log('returnFromDatePicker:dateType=',this.selfParam.businessDate)	
				if(this.selfParam.businessDate.date.startDate==dateUtils.getToday()){
					this.selfParam.businessDate.view =dateUtils.getYesterday();
					this.selfParam.businessDate.date.startDate =dateUtils.getYesterday();
				}		
				const area = uni.getStorageSync("area")
				const areaName = uni.getStorageSync("areaName")
				console.log('returnFromDatePicker:area=',area,', areaName=',areaName)
				this.selfParam.provinceCenterId=area
				this.selfParam.provinceCenterName=areaName			
				this.selfParam.token=getApp().globalData.token
				uni.setStorageSync("selfParam",JSON.stringify(this.selfParam))		
			},
			createParam(){
				console.log("createParam begin")
				var dateType = this.selfParam.businessDate.dateType
				var param = {}
				if(dateType=='date'){
					param = {dateTime: this.selfParam.businessDate.date.startDate,
							 dateFlag:"1",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='week'){
					param = {dateTime: this.selfParam.businessDate.week.startDate,
							 dateFlag:"2",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='month'){
					param = {dateTime: this.selfParam.businessDate.month.startDate,
							 dateFlag:"3",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='year'){
					param = {dateTime: this.selfParam.businessDate.year.startDate,
							 dateFlag:"4",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}	
				console.log("createParam end:",param)
				return param
			},
			loadData(){
				var that=this;
				var token=getApp().globalData.token;
				//地区日销量及周同比
				var param=this.createParam();
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
					for(var i=0;i<fbCum.length/2;i++){
						shangzhou1.push((fbCum[i]/100000000).toFixed(2));
						shangzhou2.push((fbAdjust[i]/100000000).toFixed(2));
						shangzhou3.push((bkCum[i]/100000000).toFixed(2));
						shangzhou4.push((bkAdjust[i]/100000000).toFixed(2));
						benzhou1.push((fbCum[i+7]/100000000).toFixed(2));
						benzhou2.push((fbAdjust[i+7]/100000000).toFixed(2));
						benzhou3.push((bkCum[i+7]/100000000).toFixed(2));
						benzhou4.push((bkAdjust[i+7]/100000000).toFixed(2));
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
				
			},refresh(){
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				this.returnFromDatePicker();
				this.loadData();
				this.loadData();
			},
		},
		mounted() {
			this.returnFromDatePicker();
			this.loadData();
			this.refresh();
		},
		onShow() {
			this.returnFromDatePicker();
			this.loadData();
			this.refresh();
		},
		onLoad() {
			this.returnFromDatePicker();
			this.loadData();
			this.refresh();
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
	.box-contaniner{
		width: 100%;
		margin: 20rpx 10rpx 40rpx 10rpx;
	}
</style>
