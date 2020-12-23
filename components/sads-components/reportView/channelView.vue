<template>
	<view>
		<view class = "box-container">
			<view style="text-align: center;font-size: 50rpx; width: 100%;padding-bottom: 20rpx;color: blue;">
				<image style="width: 50rpx;height: 40rpx;padding-right: 20rpx;" src="../../../static/left.png" mode="aspectFill">
				 渠道
				<image style="width: 50rpx;height: 40rpx;padding-left: 20rpx;" src="../../../static/right.png" mode="aspectFill">
			</view>
			<view class="padding">
				<view style="font-size: 30rpx;padding-left: 20rpx;" >有销量门店数七天走势</view>
				<view style="font-size: 30rpx;padding-left: 20rpx;" >单位(万个)</view>
				<histogram-chart cWidth="2rpx" ref="histogramChart1" canvasId="histogramChart1" :dataAs="histogramChart1" :basicAs="{colors:['#E5E5E5','#6E8BFB']}"/>
			</view>
			<view class="padding">
				<view style="font-size: 30rpx;padding-left: 20rpx;" >"0"销量门店数七天走势</view>
				<view style="font-size: 30rpx;padding-left: 20rpx;" >单位(万个)</view>
				<histogram-chart ref="histogramChart2" canvasId="histogramChart2" :dataAs="histogramChart2" :basicAs="{colors:['#E5E5E5','#2BC5FE']}"/>
			</view>
			<view class="padding">
				<view style="font-size: 30rpx;padding-left: 20rpx;" >日销量超限门店七天走势</view>
				<view style="font-size: 30rpx;padding-left: 20rpx;" >单位(个)</view>
				<histogram-chart ref="histogramChart3" canvasId="histogramChart3" :dataAs="histogramChart3" :basicAs="{colors:['#E5E5E5','#FFCD23']}"/>
			</view>
			<backTop :src="backTop.src"  :scrollTop="backTop.scrollTop"></backTop>
		</view>
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
							{ name: '上周', data: [0, 0, 0, 0,0, 0] },
							{ name: '本周', data: [0, 0, 0, 0,0, 0] }
						],
				 },
				 histogramChart2: {
				 						categories: ['周一', '周二','周三', '周四', '周五', '周六','周日'],
				 						series: [
				 							{ name: '上周', data: [0, 0, 0, 0,0, 0] },
				 							{ name: '本周', data: [0, 0, 0, 0,0, 0] }
				 						],
				 },
				 histogramChart3: {
				 						categories: ['周一', '周二','周三', '周四', '周五', '周六','周日'],
				 						series: [
				 							{ name: '上周', data: [0, 0, 0, 0,0, 0] },
				 							{ name: '本周', data: [0, 0, 0, 0,0, 0] }
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
						
				var area = uni.getStorageSync("area")
				const areaName = uni.getStorageSync("areaName")
				console.log('returnFromDatePicker:area=',area,', areaName=',areaName)
				if(-1==area){
					area=0;
				}
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
				var token =getApp().globalData.token;
				var url = '/pentaho/dailyPaper/getStoreSituSevenTread';
				var param=this.createParam();
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					var data =res.data.data;	
					/* 
					 前7个是上一周 后七个是这一周
					 销量 票数
					 */
					var votes=data.votes;
					var series =[];
					var shangzhou=[];
					var benzhou=[];
					for(var i=0;i<votes.length/2;i++){
						shangzhou.push((votes[i]/10000).toFixed(2));
						benzhou.push((votes[i+7]/10000).toFixed(2));
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
				param=this.createParam();
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
					for(var i=0;i<storeCount.length/2;i++){
						shangzhou.push((storeCount[i]/10000).toFixed(2));
						benzhou.push((storeCount[i+7]/10000).toFixed(2));
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
				param=this.createParam();
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					var data =res.data.data;	
					/* 
					 前7个是上一周 后七个是这一周
					 销量 票数
					 */
					var storeCount=data.storeCount;
					
					var series =[];
					var shangzhou1=[];
					var benzhou1=[];
					for(var i=0;i<storeCount.length/2;i++){
						shangzhou1.push(storeCount[i]);
						benzhou1.push(storeCount[i+7]);
					};
					var series =[
							{ name: '上周', data: shangzhou1 },
							{ name: '本周', data: benzhou1 }
						];
					
					that.$set(that.histogramChart3,'series',series);
					this.$refs['histogramChart3'].showCharts();
					
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				
			},
			refresh(){
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				this.returnFromDatePicker();
				this.loadData();
			},
			
		},
		mounted() {
			this.returnFromDatePicker();
			this.loadData();
			this.refresh();
		},
		onLoad() {
			_self = this;	
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			this.returnFromDatePicker();
			this.loadData();
			this.refresh();
		},
		onShow() {
			_self = this;	
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			this.returnFromDatePicker();
			this.loadData();
			this.refresh();
		},
		created() {
			// this.selfParam=this.param
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
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
		padding-bottom: 30rpx;
	}
	.box-contaniner{
		width: 100%;
		margin: 20rpx 10rpx 40rpx 10rpx;
	}
</style>
