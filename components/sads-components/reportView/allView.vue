<template>
	<view>
		<view class ='box-container' style="width: 100%; padding-top: 5rpx;">
			<view style="text-align: center;font-size: 50rpx; width: 100%;padding-bottom: 20rpx;color: blue;">
				<image style="width: 50rpx;height: 40rpx;padding-right: 20rpx;" src="../../../static/left.png" mode="aspectFill">
				 总览
				<image style="width: 50rpx;height: 40rpx;padding-left: 20rpx;" src="../../../static/right.png" mode="aspectFill">
			</view>
			<view class="arcbarChart-tab">
			    <view @tap="changeTop('周同比')"  :class="arcbarNumTop =='周同比'?'btna':'hide'" style="width: 12%;border-radius:50rpx 0rpx 0rpx 50rpx;border:solid;border-right: 0;border-color: #C0C0C0;font-size: 30rpx;align-content: center;" >周同比</view>
			    <view @tap="changeTop('环比')" :class="arcbarNumTop =='环比'?'btna':'hide'" style="width: 11%;border:solid; border-radius:0rpx 50rpx 50rpx 0rpx;border-color: #C0C0C0;font-size: 30rpx;align-content: center;" >环比</view>
			</view>
			<view v-if="selfParam.provinceCenterId!=0" class ="column-box viewborder" style="width: 700rpx; display: flex;" >
				<view style="width: 450rpx;">
					<view class="small-text">日销量(百万元)</view>
					<view class="big-text">{{pagedata[0]}}</view>
				</view>
				<view >
					<view class="small-text">{{arcbarNumTop}}</view>
					<view class="big-text">{{pagedatacompare[0]}}%</view>
				</view>
			</view>
			<view v-if="selfParam.provinceCenterId==0" class ="column-box viewborder" style="width: 700rpx; display: flex;" >
				<view style="width: 450rpx;">
					<view class="small-text">日销量(亿元)</view>
					<view class="big-text">{{pagedata[0]}}</view>
				</view>
				<view >
					<view class="small-text">{{arcbarNumTop}}</view>
					<view class="big-text">{{pagedatacompare[0]}}%</view>
				</view>
			</view>
			<view v-if="selfParam.provinceCenterId!=0"  class ="column-box viewborder" style="width: 700rpx; display: flex;" >
				<view style="width: 450rpx;">
					<view class="small-text">日销量排名</view>
					<view class="big-text">{{pagedata[11]}}</view>
				</view>
				<view >
					<view class="small-text">{{arcbarNumTop}}</view>
					<view class="big-text">{{pagedatacompare[11]}}%</view>
				</view>
			</view>
			<view  v-if="selfParam.provinceCenterId!=0"  class ="column-box viewborder" style="width: 700rpx; display: flex;" >
				<view style="width: 450rpx;">
					<view class="small-text">日票数(万张)</view>
					<view class="big-text">{{pagedata[1]}}</view>
				</view>
				<view >
					<view class="small-text">{{arcbarNumTop}}</view>
					<view class="big-text">{{pagedatacompare[1]}}%</view>
				</view>
			</view>
			<view  v-if="selfParam.provinceCenterId==0"  class ="column-box viewborder" style="width: 700rpx; display: flex;" >
				<view style="width: 450rpx;">
					<view class="small-text">日票数(百万张)</view>
					<view class="big-text">{{pagedata[1]}}</view>
				</view>
				<view >
					<view class="small-text">{{arcbarNumTop}}</view>
					<view class="big-text">{{pagedatacompare[1]}}%</view>
				</view>
			</view>
			<view class ="column-box viewborder" style="width: 700rpx; display: flex;" >
				<view style="width: 450rpx;">
					<view class="small-text">有销量门店数</view>
					<view class="big-text">{{pagedata[2]}}</view>
				</view>
				<view >
					<view class="small-text">{{arcbarNumTop}}</view>
					<view class="big-text">{{pagedatacompare[2]}}%</view>
				</view>
			</view>
			<view v-if="selfParam.provinceCenterId!=0"  class ="column-box" style="width: 100%; display: flex;" >
				<view style="width: 350rpx;">
					<view class="small-text">足球日销量(百万元)</view>
					<view class="big-text">{{pagedata[3]}}</view>
					<view class="small-text">{{arcbarNumTop}} {{pagedatacompare[3]}}%</view>
				</view>
				<view style="width: 350rpx;">
					<view class="small-text">蓝球日销量(万元)</view>
					<view class="big-text">{{pagedata[4]}}</view>
					<view class="small-text">{{arcbarNumTop}} {{pagedatacompare[4]}}%</view>
				</view>
			</view>
			<view v-if="selfParam.provinceCenterId==0"  class ="column-box" style="width: 100%; display: flex;" >
				<view style="width: 350rpx;">
					<view class="small-text">足球日销量(亿元)</view>
					<view class="big-text">{{pagedata[3]}}</view>
					<view class="small-text">{{arcbarNumTop}} {{pagedatacompare[3]}}%</view>
				</view>
				<view style="width: 350rpx;">
					<view class="small-text">蓝球日销量(百万元)</view>
					<view class="big-text">{{pagedata[4]}}</view>
					<view class="small-text">{{arcbarNumTop}} {{pagedatacompare[4]}}%</view>
				</view>
			</view>
			<view v-if="selfParam.provinceCenterId!=0"  class ="column-box" style="width: 100%; display: flex;" >
				<view style="width: 350rpx;">
					<view class="small-text">1-2关次销量(百万元)</view>
					<view class="big-text">{{pagedata[5]}}</view>
					<view class="small-text">{{arcbarNumTop}} {{pagedatacompare[5]}}%</view>
				</view>
				<view style="width: 350rpx;">
					<view class="small-text">单票金额(元)</view>
					<view class="big-text">{{pagedata[6]}}</view>
					<view class="small-text">{{arcbarNumTop}} {{pagedatacompare[6]}}%</view>
				</view>
			</view>
			<view v-if="selfParam.provinceCenterId==0"  class ="column-box" style="width: 100%; display: flex;" >
				<view style="width: 350rpx;">
					<view class="small-text">1-2关次销量(亿元)</view>
					<view class="big-text">{{pagedata[5]}}</view>
					<view class="small-text">{{arcbarNumTop}} {{pagedatacompare[5]}}%</view>
				</view>
				<view style="width: 350rpx;">
					<view class="small-text">单票金额(元)</view>
					<view class="big-text">{{pagedata[6]}}</view>
					<view class="small-text">{{arcbarNumTop}} {{pagedatacompare[6]}}%</view>
				</view>
			</view>
			<view class ="column-box" style="width: 100%; display: flex;" >
				<view style="width: 350rpx;">
					<view class="small-text">返奖率</view>
					<view class="big-text">{{pagedata[7]}}</view>
					<view class="small-text">{{arcbarNumTop}} {{pagedatacompare[7]}}%</view>
				</view>
				<view style="width: 350rpx;">
					<view class="small-text">"0"销量门店数</view>
					<view class="big-text">{{pagedata[8]}}</view>
					<view class="small-text">{{arcbarNumTop}} {{pagedatacompare[8]}}%</view>
				</view>
			</view>
			<view v-if="selfParam.provinceCenterId==0" class ="column-box" style="width: 100%; display: flex;" >
				<view style="width: 350rpx;">
					<view class="small-text">本月累计销量(亿元)</view>
					<view class="big-text">{{pagedata[9]}}</view>
					<view class="small-text">{{arcbarNumTop}} {{pagedatacompare[9]}}%</view>
				</view>
				<view style="width: 350rpx;">
					<view class="small-text">本年累计销量(亿元)</view>
					<view class="big-text">{{pagedata[10]}}</view>
					<view class="small-text">{{arcbarNumTop}} {{pagedatacompare[10]}}%</view>
				</view>
			</view>
			<view v-if="selfParam.provinceCenterId!=0" class ="column-box" style="width: 100%; display: flex;" >
				<view style="width: 350rpx;">
					<view class="small-text">本月累计销量(百万元)</view>
					<view class="big-text">{{pagedata[9]}}</view>
					<view class="small-text">{{arcbarNumTop}} {{pagedatacompare[9]}}%</view>
				</view>
				<view style="width: 350rpx;">
					<view class="small-text">本年累计销量(亿元)</view>
					<view class="big-text">{{pagedata[10]}}</view>
					<view class="small-text">{{arcbarNumTop}} {{pagedatacompare[10]}}%</view>
				</view>
			</view>
		</view>
		<backTop :src="backTop.src"  :scrollTop="backTop.scrollTop" z-index=999></backTop>
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
				 pagedata:[0,0,0,0,0,0,0,0,0,0,0,0],
				 pagedatacompare:[0,0,0,0,0,0,0,0,0,0,0,0],
				 backTop: {
				 	src: '../../static/top.png',
				 	scrollTop: 0
				 },
				 scrollTop: 0
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
				if(this.selfParam.provinceCenterId==0){
					if(dateType=='date'){
						param = {dateTime: this.selfParam.businessDate.date.startDate,
								 dateFlag:"1",
								 token:this.selfParam.token }
					}else if(dateType=='week'){
						param = {dateTime: this.selfParam.businessDate.week.startDate,
								 dateFlag:"2",
								 token:this.selfParam.token }
					}else if(dateType=='month'){
						param = {dateTime: this.selfParam.businessDate.month.startDate,
								 dateFlag:"3",
								 token:this.selfParam.token }
					}else if(dateType=='year'){
						param = {dateTime: this.selfParam.businessDate.year.startDate,
								 dateFlag:"4",
								 token:this.selfParam.token }
					}	
				}else {
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
					//日销量 pentaho/sales/getSalesOverview
					var url = '';
					var param={}
					
					//销量排名 只有全国有
					if(this.selfParam.provinceCenterId!=0){
						url = '/pentaho/sales/getProSalesRanking';
						param= {dateTimeStart: this.selfParam.businessDate.date.startDate,
								dateTimeEnd:this.selfParam.businessDate.date.startDate,
								 dateFlag:"1",
								 provincialId:this.selfParam.provinceCenterId,
								 token:this.selfParam.token }
						urlAPI.getRequest(url, param).then((res)=>{
							this.loading = false;
							var data =res.data.data;
							if(data.length==0){
								this.$set(that.pagedata,11,0);
								this.$set(that.pagedatacompare,11,0);
							}else{
								var all =[];
								for(var i=0;i<data.length;i++){
									all.push(data[0])
								};
								this.$set(that.pagedata,11,all);
								this.$set(that.pagedatacompare,11,data[0][1]);
							}
							
						}).catch((err)=>{
							this.loading = false;
							console.log('request fail', err);
						});
					}
					
					//日票数
					url = '/pentaho/sales/getSalesOverview';
					param= {dateTimeStart: this.selfParam.businessDate.date.startDate,
							dateTimeEnd:this.selfParam.businessDate.date.startDate,
							 dateFlag:"1",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
					param.regionId=this.selfParam.provinceCenterId,
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;
						if(data.length==0){
							this.$set(that.pagedata,0,0);
							this.$set(that.pagedatacompare,0,0);
							this.$set(that.pagedata,1,0);
							this.$set(that.pagedatacompare,1,0);
						}else{
							if(this.selfParam.provinceCenterId==0){
								this.$set(that.pagedata,1,(data[1][0]/1000000).toFixed(2));
							}else {
								this.$set(that.pagedata,1,(data[1][0]/10000).toFixed(2));
							}
							
							this.$set(that.pagedatacompare,1,data[1][1]);
							if(this.selfParam.provinceCenterId==0){
								this.$set(that.pagedata,0,(data[0][0]/100000000).toFixed(2));
							}else {
								this.$set(that.pagedata,0,(data[0][0]/1000000).toFixed(2));
							}
							this.$set(that.pagedatacompare,0,data[0][1]);
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
							var all =0;
							var all1 =0;
							for(var i=0;i<data.length;i++){
								all=all+data[i][1]
								all1=all1+data[i][2]
							};
							this.$set(that.pagedata,2,all);
							this.$set(that.pagedatacompare,2,0);
							this.$set(that.pagedata,8,all1);
							this.$set(that.pagedatacompare,8,0);
						}		
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					
					//足球日销量
					url = '/pentaho/sales/getGameSales';
					param= {dateTimeStart: this.selfParam.businessDate.date.startDate,
							dateTimeEnd:this.selfParam.businessDate.date.startDate,
							 dateFlag:"1",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;
						if(data.length==0){
							this.$set(that.pagedata,3,0);
							this.$set(that.pagedatacompare,3,0);
							this.$set(that.pagedata,4,0);
							this.$set(that.pagedatacompare,4,0);
						}else{
							var bk=data.basketball;
							var fb=data.football;
							if(this.selfParam.provinceCenterId==0){
								this.$set(that.pagedata,3,(fb[0]/100000000).toFixed(2));
							}else {
								this.$set(that.pagedata,3,(fb[0]/1000000).toFixed(2));
							}
							
							this.$set(that.pagedatacompare,3,fb[1]);
							
							if(this.selfParam.provinceCenterId==0){
								this.$set(that.pagedata,4,(bk[0]/1000000).toFixed(2));
							}else {
								this.$set(that.pagedata,4,(bk[0]/10000).toFixed(2));
							}
							this.$set(that.pagedatacompare,4,bk[1]);
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
							if(this.selfParam.provinceCenterId==0){
								this.$set(that.pagedata,5,(data[0]/100000000).toFixed(2));
							}else {
								this.$set(that.pagedata,5,(data[0]/1000000).toFixed(2));
							}
							
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
					url = '/pentaho/sales/getReturnRateState';
					param= {dateTimeStart: this.selfParam.businessDate.date.startDate,
							dateTimeEnd:this.selfParam.businessDate.date.startDate,
							 dateFlag:"1",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;
						if(data.length==0){
							this.$set(that.pagedata,7,0);
							this.$set(that.pagedatacompare,7,0);
						}else{
							this.$set(that.pagedata,7,data[0]);
							this.$set(that.pagedatacompare,7,data[1]);
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
							if(this.selfParam.provinceCenterId==0){
								this.$set(that.pagedata,9,(data[0]/100000000).toFixed(2));
							}else {
								this.$set(that.pagedata,9,(data[0]/1000000).toFixed(2));
							}
							
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
							if(this.selfParam.provinceCenterId==0){
								this.$set(that.pagedata,10,(data[0]/100000000).toFixed(2));
							}else {
								this.$set(that.pagedata,10,(data[0]/100000000).toFixed(2));
							}
							
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
					var url = '';
					var param={};
					//销量排名 只有非全国有
					if(this.selfParam.provinceCenterId!=0){
						url = '/pentaho/sales/getProSalesRanking';
						param= {dateTimeStart: this.selfParam.businessDate.date.startDate,
								dateTimeEnd:this.selfParam.businessDate.date.startDate,
								 dateFlag:"1",
								 provincialId:this.selfParam.provinceCenterId,
								 token:this.selfParam.token }
						urlAPI.getRequest(url, param).then((res)=>{
							this.loading = false;
							var data =res.data.data;
							if(data.length==0){
								this.$set(that.pagedata,11,0);
								this.$set(that.pagedatacompare,11,0);
							}else{
								var all =[];
								for(var i=0;i<data.length;i++){
									all.push(data[0])
								};
								this.$set(that.pagedata,11,all);
								this.$set(that.pagedatacompare,11,data[0][2]);
							}
							
						}).catch((err)=>{
							this.loading = false;
							console.log('request fail', err);
						});
					}
					//日票数
					url = '/pentaho/sales/getSalesOverview';
					param= {dateTimeStart: this.selfParam.businessDate.date.startDate,
							dateTimeEnd:this.selfParam.businessDate.date.startDate,
							 dateFlag:"1",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
					param.regionId=this.selfParam.provinceCenterId,
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;
						if(data.length==0){
							this.$set(that.pagedata,0,0);
							this.$set(that.pagedatacompare,0,0);
							this.$set(that.pagedata,1,0);
							this.$set(that.pagedatacompare,1,0);
						}else{
							if(this.selfParam.provinceCenterId==0){
								this.$set(that.pagedata,1,(data[1][0]/1000000).toFixed(2));
							}else {
								this.$set(that.pagedata,1,(data[1][0]/10000).toFixed(2));
							}
							
							this.$set(that.pagedatacompare,1,data[1][2]);
							if(this.selfParam.provinceCenterId==0){
								this.$set(that.pagedata,0,(data[0][0]/100000000).toFixed(2));
							}else {
								this.$set(that.pagedata,0,(data[0][0]/1000000).toFixed(2));
							}
							this.$set(that.pagedatacompare,0,data[0][2]);
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
							var all =0;
							var all1 =0;
							for(var i=0;i<data.length;i++){
								all=all+data[i][1]
								all1=all1+data[i][2]
							};
							this.$set(that.pagedata,2,all);
							this.$set(that.pagedatacompare,2,0);
							this.$set(that.pagedata,8,all1);
							this.$set(that.pagedatacompare,8,0);
						}
							
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					
					//足球日销量
					url = '/pentaho/sales/getGameSales';
					param= {dateTimeStart: this.selfParam.businessDate.date.startDate,
							dateTimeEnd:this.selfParam.businessDate.date.startDate,
							 dateFlag:"1",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;
						if(data.length==0){
							this.$set(that.pagedata,3,0);
							this.$set(that.pagedatacompare,3,0);
							this.$set(that.pagedata,4,0);
							this.$set(that.pagedatacompare,4,0);
						}else{ 
							var bk=data.basketball;
							var fb=data.football;
							if(this.selfParam.provinceCenterId==0){
								this.$set(that.pagedata,3,(fb[0]/100000000).toFixed(2));
							}else {
								this.$set(that.pagedata,3,(fb[0]/1000000).toFixed(2));
							}
							
							this.$set(that.pagedatacompare,3,fb[2]);
							
							if(this.selfParam.provinceCenterId==0){
								this.$set(that.pagedata,4,(fb[0]/1000000).toFixed(2));
							}else {
								this.$set(that.pagedata,4,(fb[0]/10000).toFixed(2));
							}
							this.$set(that.pagedatacompare,4,fb[2]);
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
							if(this.selfParam.provinceCenterId==0){
								this.$set(that.pagedata,5,(data[0]/100000000).toFixed(2));
							}else {
								this.$set(that.pagedata,5,(data[0]/1000000).toFixed(2));
							}
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
					url = '/pentaho/sales/getReturnRateState';
					param= {dateTimeStart: this.selfParam.businessDate.date.startDate,
							dateTimeEnd:this.selfParam.businessDate.date.startDate,
							 dateFlag:"1",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;
						if(data.length==0){
							this.$set(that.pagedata,7,0);
							this.$set(that.pagedatacompare,7,0);
						}else{
							this.$set(that.pagedata,7,data[0]);
							this.$set(that.pagedatacompare,7,data[2]);
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
							if(this.selfParam.provinceCenterId==0){
								this.$set(that.pagedata,9,(data[0]/100000000).toFixed(2));
							}else {
								this.$set(that.pagedata,9,(data[0]/1000000).toFixed(2));
							}
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
							this.$set(that.pagedata,10,(data[0]/100000000).toFixed(2));
							this.$set(that.pagedatacompare,10,data[2]);
						}
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					
					
				}
				
			},
			refresh(){
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				this.returnFromDatePicker();
				this.loadData();
			},
			
		},
		created() {
			this.returnFromDatePicker();
			this.loadData();
		},
		onShow() {
			this.returnFromDatePicker();
			this.loadData();
		},
		onLoad() {
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
	.box-contaniner{
		width: 100%;
		margin: 20rpx 10rpx 40rpx 10rpx;
	}
</style>
