<template>
	<view>
		<view class ='centerView' style="width: 100%; padding-top: 30rpx;">
			<view style="text-align: center;width: 100%;padding-bottom: 20rpx;color: blue;">总览</view>
			<view class="arcbarChart-tab">
			    <view @tap="changeTop('周同比')"  :class="arcbarNumTop =='周同比'?'btna':'hide'" style="width: 12%;border-radius:50rpx 0rpx 0rpx 50rpx;border:solid;border-right: 0;border-color: #C0C0C0;font-size: 30rpx;align-content: center;" >周同比</view>
			    <view @tap="changeTop('环比')" :class="arcbarNumTop =='环比'?'btna':'hide'" style="width: 11%;border:solid; border-radius:0rpx 50rpx 50rpx 0rpx;border-color: #C0C0C0;font-size: 30rpx;align-content: center;" >环比</view>
			</view>
			<view class ="column-box viewborder" style="width: 700rpx; display: flex;" >
				<view style="width: 450rpx;">
					<view class="small-text">日销量(亿元)</view>
					<view class="big-text">{{pagedata[0]}}</view>
				</view>
				<view >
					<view class="small-text">{{arcbarNumTop}}</view>
					<view class="big-text">{{((pagedata[0]-pagedatacompare[0])*100/pagedatacompare[0]).toFixed(2)}}%</view>
				</view>
				<view class="row-box"style="width: 33%;">
					<view class="small-text">红箭头</view>
				</view>
			</view>	
			<view class ="column-box viewborder" style="width: 700rpx; display: flex;" >
				<view style="width: 450rpx;">
					<view class="small-text">日票数(百万张)</view>
					<view class="big-text">{{pagedata[1]}}</view>
				</view>
				<view >
					<view class="small-text">{{arcbarNumTop}}</view>
					<view class="big-text">{{((pagedata[1]-pagedatacompare[1])*100/pagedatacompare[1]).toFixed(2)}}%</view>
				</view>
				<view class="row-box"style="width: 33%;">
					<view class="small-text">红箭头</view>
				</view>
			</view>
			<view class ="column-box viewborder" style="width: 700rpx; display: flex;" >
				<view style="width: 450rpx;">
					<view class="small-text">有销量门店数</view>
					<view class="big-text">{{pagedata[2]}}</view>
				</view>
				<view >
					<view class="small-text">{{arcbarNumTop}}</view>
					<view class="big-text">{{((pagedata[2]-pagedatacompare[2])*100/pagedatacompare[2]).toFixed(2)}}%</view>
				</view>
				<view class="row-box"style="width: 33%;">
					<view class="small-text">绿箭头</view>
				</view>
			</view>
			<view class ="column-box" style="width: 100%; display: flex;" >
				<view style="width: 350rpx;">
					<view class="small-text">足球日销量(亿元)</view>
					<view class="big-text">{{pagedata[3]}}</view>
					<view class="small-text">{{arcbarNumTop}} +{{((pagedata[3]-pagedatacompare[3])*100/pagedatacompare[3]).toFixed(2)}}%</view>
				</view>
				<view style="width: 350rpx;">
					<view class="small-text">蓝球日销量(亿元)</view>
					<view class="big-text">{{pagedata[4]}}</view>
					<view class="small-text">{{arcbarNumTop}} +{{((pagedata[4]-pagedatacompare[4])*100/pagedatacompare[4]).toFixed(2)}}%</view>
				</view>
			</view>
			<view class ="column-box" style="width: 100%; display: flex;" >
				<view style="width: 350rpx;">
					<view class="small-text">1-2关次销量(亿元)</view>
					<view class="big-text">{{pagedata[5]}}</view>
					<view class="small-text">{{arcbarNumTop}} +{{((pagedata[5]-pagedatacompare[5])*100/pagedatacompare[5]).toFixed(2)}}%</view>
				</view>
				<view style="width: 350rpx;">
					<view class="small-text">单票金额(元)</view>
					<view class="big-text">{{pagedata[6]}}</view>
					<view class="small-text">{{arcbarNumTop}} +{{((pagedata[6]-pagedatacompare[6])*100/pagedatacompare[6]).toFixed(2)}}%</view>
				</view>
			</view>
			<view class ="column-box" style="width: 100%; display: flex;" >
				<view style="width: 350rpx;">
					<view class="small-text">返奖率</view>
					<view class="big-text">{{pagedata[7]}}</view>
					<view class="small-text">{{arcbarNumTop}} +{{((pagedata[7]-pagedatacompare[7])*100/pagedatacompare[7]).toFixed(2)}}%</view>
				</view>
				<view style="width: 350rpx;">
					<view class="small-text">"0"销量门店数</view>
					<view class="big-text">{{pagedata[8]}}</view>
					<view class="small-text">{{arcbarNumTop}} +{{((pagedata[8]-pagedatacompare[8])*100/pagedatacompare[8]).toFixed(2)}}%</view>
				</view>
			</view>
			<view class ="column-box" style="width: 100%; display: flex;" >
				<view style="width: 350rpx;">
					<view class="small-text">本月累计销量(亿元)</view>
					<view class="big-text">{{pagedata[9]}}</view>
					<view class="small-text">{{arcbarNumTop}} +{{((pagedata[9]-pagedatacompare[9])*100/pagedatacompare[9]).toFixed(2)}}%</view>
				</view>
				<view style="width: 350rpx;">
					<view class="small-text">本年累计销量(亿元)</view>
					<view class="big-text">{{pagedata[10]}}</view>
					<view class="small-text">{{arcbarNumTop}} +{{((pagedata[10]-pagedatacompare[10])*100/pagedatacompare[10]).toFixed(2)}}%</view>
				</view>
			</view>
		</view>
		<backTop :src="backTop.src"  :scrollTop="backTop.scrollTop"></backTop>
	</view>
</template>

<script>
	import urlAPI from '@/common/vmeitime-http/';
	import backTop from '@/components/sads-components/back-top.vue';
	
	export default {
		components: {
			backTop 
		},
		props: {
			model:{
				type: Object,
				default: () => ({})
			}
		},
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
				showModel:{},
				 btnnum: 0,
				 index: 0,
				 arcbarNumTop:'周同比',
				 pagedata:[0,0,0,0,0,0,0,0,0,0,0],
				 pagedatacompare:[0,0,0,0,0,0,0,0,0,0,0],
				 backTop: {
				 	src: '../../static/top.png',
				 	scrollTop: 0
				 },
				 scrollTop: 0
				 }
		},
		methods: {
			returnFromDatePicker(){
				const dateType = uni.getStorageSync("dateType")
				const bussinessDate = JSON.parse(uni.getStorageSync("businessDate"))
				this.selfParam.businessDate = bussinessDate;
				console.log('returnFromDatePicker:dateType=',this.selfParam.businessDate)	
						
				const area = uni.getStorageSync("area")
				const areaName = uni.getStorageSync("areaName")
				console.log('returnFromDatePicker:area=',area,', areaName=',areaName)					
				this.selfParam.provinceCenterId=area
				this.selfParam.provinceCenterName=areaName
				this.selfParam.token=uni.getStorageSync("token");
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
			changeTop(e){
				this.arcbarNumTop = e;;
				this.loadData();
				
			},
			loadData(){
				var token=getApp().globalData.token;
				if('周同比'==this.arcbarNumTop){
					var that=this;
					//日销量 
					var url = '/pentaho/dailyPaper/getSalesAndComRanking';
					var param=this.createParam();
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;
						if(data.length==0){
							this.$set(that.pagedata,0,0);
							this.$set(that.pagedatacompare,0,0);
						}else{
							this.$set(that.pagedata,0,data[1]);
							this.$set(that.pagedatacompare,0,data[2]);
						}
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					//日票数
					url = '/pentaho/dailyPaper/getVotesAndComRanking';
					param=this.createParam();
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;
						if(data.length==0){
							this.$set(that.pagedata,1,0);
							this.$set(that.pagedatacompare,1,0);
						}else{
							this.$set(that.pagedata,1,data[1]);
							this.$set(that.pagedatacompare,1,data[2]);
						}
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					
					//有销量门店
					url = '/pentaho/dailyPaper/getShowCountRanking';
					param=this.createParam();
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;
						if(data.length==0){
							this.$set(that.pagedata,2,0);
							this.$set(that.pagedatacompare,2,0);
							this.$set(that.pagedata,8,0);
							this.$set(that.pagedatacompare,8,0);
						}else{
							this.$set(that.pagedata,2,data[1]);
							this.$set(that.pagedatacompare,2,0);
							this.$set(that.pagedata,8,data[2]);
							this.$set(that.pagedatacompare,8,0);
						}		
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					
					//足球日销量
					url = '/pentaho/dailyPaper/getSalesAndComRanking';
					param=this.createParam();
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;
						if(data.length==0){
							this.$set(that.pagedata,3,0);
							this.$set(that.pagedatacompare,3,0);
						}else{
							this.$set(that.pagedata,3,data[1]);
							this.$set(that.pagedatacompare,3,data[2]);
						}
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					//篮球日销量
					url = '/pentaho/dailyPaper/getSalesAndComRanking';
					param=this.createParam();
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;
						if(data.length==0){
							this.$set(that.pagedata,4,0);
							this.$set(that.pagedatacompare,4,0);
						}else{
							this.$set(that.pagedata,4,data[1]);
							this.$set(that.pagedatacompare,4,data[2]);
						}
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					
					//1-2关次销量
					url = '/pentaho/dailyPaper/getTwoPassSales';
					param=this.createParam();
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;	
						if(data.length==0){
							this.$set(that.pagedata,5,0);
							this.$set(that.pagedatacompare,5,0);
						}else{
							this.$set(that.pagedata,5,data[0]);
							this.$set(that.pagedatacompare,5,data[1]);
						}
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					
					//单票金额
					url = '/pentaho/dailyPaper/getSingleVoteAmount';
					param=this.createParam();
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;
						if(data.length==0){
							this.$set(that.pagedata,6,0);
							this.$set(that.pagedatacompare,6,0);
						}else{
							this.$set(that.pagedata,6,data[0]);
							this.$set(that.pagedatacompare,6,data[1]);
						}
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					//返奖率
					url = '/pentaho/dailyPaper/getReturnRateRanking';
					param=this.createParam();
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;
						if(data.length==0){
							this.$set(that.pagedata,7,0);
							this.$set(that.pagedatacompare,7,0);
						}else{
							this.$set(that.pagedata,7,data[0][1]);
							this.$set(that.pagedatacompare,7,0);
						}
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					
					//本月累计销量
					url = '/pentaho/dailyPaper/getOnMonthSales';
					param=this.createParam();
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;	
						if(data.length==0){
							this.$set(that.pagedata,9,0);
							this.$set(that.pagedatacompare,9,0);
						}else{
							this.$set(that.pagedata,9,data[0]);
							this.$set(that.pagedatacompare,9,data[1]);
						}
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					//本年累计销量
					url = '/pentaho/dailyPaper/getOnYearSales';
					param=this.createParam();
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;
						if(data.length==0){
							this.$set(that.pagedata,10,0);
							this.$set(that.pagedatacompare,10,0);
						}else{
							this.$set(that.pagedata,10,data[0]);
							this.$set(that.pagedatacompare,10,data[1]);
						}
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					
					
				}else {
					//环比
					var that=this;
					//日销量 
					var url = '/pentaho/dailyPaper/getSalesAndComRanking';
					var param=this.createParam();
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;	
						if(data.length==0){
							this.$set(that.pagedata,0,0);
							this.$set(that.pagedatacompare,0,0);
						}else{
							this.$set(that.pagedata,0,data[1]);
							this.$set(that.pagedatacompare,0,data[2]);
						}
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					//日票数
					url = '/pentaho/dailyPaper/getVotesAndComRanking';
					param=this.createParam();
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;
						if(data.length==0){
							this.$set(that.pagedata,1,0);
							this.$set(that.pagedatacompare,1,0);
						}else{
							this.$set(that.pagedata,1,data[1]);
							this.$set(that.pagedatacompare,1,data[2]);
						}
							
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					
					//有销量门店
					url = '/pentaho/dailyPaper/getShowCountRanking';
					param=this.createParam();
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;	
						if(data.length==0){
							this.$set(that.pagedata,2,0);
							this.$set(that.pagedatacompare,2,0);
							this.$set(that.pagedata,8,0);
							this.$set(that.pagedatacompare,8,0);
						}else{
							this.$set(that.pagedata,2,data[1]);
							this.$set(that.pagedatacompare,2,0);
							this.$set(that.pagedata,8,data[2]);
							this.$set(that.pagedatacompare,8,0);
						}
							
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					
					//足球日销量
					url = '/pentaho/dailyPaper/getSalesAndComRanking';
					param=this.createParam();
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;
						if(data.length==0){
							this.$set(that.pagedata,3,0);
							this.$set(that.pagedatacompare,3,0);
						}else{
							this.$set(that.pagedata,3,data[1]);
							this.$set(that.pagedatacompare,3,data[2]);
						}
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					//篮球日销量
					url = '/pentaho/dailyPaper/getSalesAndComRanking';
					param=this.createParam();
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;
						if(data.length==0){
							this.$set(that.pagedata,4,0);
							this.$set(that.pagedatacompare,4,0);
						}else{
							this.$set(that.pagedata,4,data[1]);
							this.$set(that.pagedatacompare,4,data[2]);
						}
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					
					//1-2关次销量
					url = '/pentaho/dailyPaper/getTwoPassSales';
					param=this.createParam();
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;	
						if(data.length==0){
							this.$set(that.pagedata,5,0);
							this.$set(that.pagedatacompare,5,0);
						}else{
							this.$set(that.pagedata,5,data[0]);
							this.$set(that.pagedatacompare,5,data[2]);
						}
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					//单票金额
					url = '/pentaho/dailyPaper/getSingleVoteAmount';
					param=this.createParam();
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;
						if(data.length==0){
							this.$set(that.pagedata,6,0);
							this.$set(that.pagedatacompare,6,0);
						}else{
							this.$set(that.pagedata,6,data[0]);
							this.$set(that.pagedatacompare,6,data[1]);
						}
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					//返奖率
					url = '/pentaho/dailyPaper/getReturnRateRanking';
					param=this.createParam();
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;
						if(data.length==0){
							this.$set(that.pagedata,7,0);
							this.$set(that.pagedatacompare,7,0);
						}else{
							this.$set(that.pagedata,7,0);
							this.$set(that.pagedatacompare,7,0);
						}
							
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					//本月累计销量
					url = '/pentaho/dailyPaper/getOnMonthSales';
					param=this.createParam();
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;
						if(data.length==0){
							this.$set(that.pagedata,9,0);
							this.$set(that.pagedatacompare,9,0);
						}else{
							this.$set(that.pagedata,9,data[0]);
							this.$set(that.pagedatacompare,9,data[2]);
						}
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					//本年累计销量
					url = '/pentaho/dailyPaper/getOnYearSales';
					param=this.createParam();
					param=this.createParam();
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;	
						if(data.length==0){
							this.$set(that.pagedata,10,0);
							this.$set(that.pagedatacompare,10,0);
						}else{
							this.$set(that.pagedata,10,data[0]);
							this.$set(that.pagedatacompare,10,data[2]);
						}
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					
					
				}
				
			}
			
		},
		created() {
			this.returnFromDatePicker();
			this.loadData();
		},
		onPageScroll(e) {
			this.backTop.scrollTop = e.scrollTop;
		}
		
	}
</script>

<style>
	/* 将三个内容view的display设置为none(隐藏) */
	.arcbarChart-tab{
		/* padding:0rpx 5rpx 0rpx 5rpx; */
		flex-direction: row;
		display: flex;
		justify-content:center;
		font-size: 45rpx;
		font-family: 'Courier New', Courier, monospace;
	}
	.btna{
		color: #000000;
		background: #ebebeb;
		padding:0px 30rpx 0px 30rpx;
		text-align: center;
		line-height: 60rpx;
		font-family:'Franklin Gothic Medium', 'Arial Narrow', Arial, sans-serif;

	}
	.hide{
		color: #000000;
		background: #FFFFFF;
		padding:0px 30rpx 0px 30rpx;
		text-align: center;
		line-height: 60rpx;
		font-family:'Franklin Gothic Medium', 'Arial Narrow', Arial, sans-serif;
	}
	.row-box {
		display: flex;
		margin: 0rpx 10rpx;
		padding: 0 10rpx;
	}
	
	.column-box{
		margin: 25rpx 20rpx;
	}
	
	.big-text{
		text-align: left;
		color:#000000;
		font-size: 36rpx;
		margin: 20rpx 50rpx;
	}
	
	.small-text{
		color: #777;
		font-size: 27rpx;
		margin: 20rpx 50rpx 0rpx 50rpx;
	}
	.viewborder{
		border: 3rpx solid #faca82;
		border-color: #777777;
		border-radius: 20rpx;
		padding: 0rpx 0rpx 0rpx 0rpx;
		border-color:initial;
	}
	
</style>
