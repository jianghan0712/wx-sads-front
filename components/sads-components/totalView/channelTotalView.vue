<template>
	<view>
		<!-- <view class="box-contaniner"> -->
			<view class="box-contaniner">
				<dataContainer ref="dataContain" :dataAs="totalData"></dataContainer>
			</view>
			
			<!-- 折线图区域-->
			<view class="box-contaniner">
				<view class="clineChart-title">
					<view style="font-size: 30rpx;font-weight: bold;">竞彩销量及票数走势</view>
					<view class="linechart-tab">
					　　<view @tap="change(0)" :class="btnnum == 0?'btna':'hide'">销量</view>
					  　<view @tap="change(1)" :class="btnnum == 1?'btna':'hide'">票数</view>
					</view>
				</view>		
				<view v-if="btnnum == 0">		
					<area-chart ref="lineData2" canvasId="index_line_2" :dataAs="lineData2" 
								:xAxisAs="{scrollShow:false, gridEval:(lineData2.categories.length / 4).toFixed(0)}"/>
				</view>
				<view v-if="btnnum == 1">		　
					<area-chart ref="lineData1" canvasId="index_line_1" :dataAs="lineData1" 	
								:xAxisAs="{scrollShow:false, gridEval:(lineData1.categories.length / 4).toFixed(0)}"/>
				</view>		
			</view>
			
			<!-- 排名区域-->
			<view class="box-contaniner">
				<view class="shop-title">排名</view>
				<view class="line">
					<view class="shop-item-title">
						<view style="width: 50%;">全国排名</view>				
						<view style="width: 25%;">周同比</view>
						<view style="-webkit-flex: 1;flex: 1;">环比</view>
					</view>
					<view class="shop-item-content">
						<view style="width: 50%;">{{shopData.shop.sum}}</view>
						<view :class="shopData.shop.tongbi>= 0?'small-text-red':'small-text-green'" style="width: 25%;">{{shopData.shop.tongbi>0?"↑"+shopData.shop.tongbi:"↓"+shopData.shop.tongbi}}名</view>
						<view :class="shopData.shop.huanbi>= 0?'small-text-red':'small-text-green'" style="-webkit-flex: 1;flex: 1;">{{shopData.shop.huanbi>0?"↑"+shopData.shop.huanbi:"↓"+shopData.shop.huanbi}}名</view>
					</view>
				</view>
			</view>		
			<view class="box-contaniner">
				<view class="line">
					<view class="shop-item-title">
						<view style="width: 50%;">省内排名</view>				
						<view style="width: 25%;">周同比</view>
						<view style="-webkit-flex: 1;flex: 1;">环比</view>
					</view>
					<view class="shop-item-content">
						<view style="width: 50%;">{{shopData.rate.sum}}</view>				
						<view :class="shopData.rate.tongbi>= 0?'small-text-red':'small-text-green'" style="width: 25%;">{{shopData.rate.tongbi>0?"↑"+shopData.rate.tongbi:"↓"+shopData.rate.tongbi}}名</view>
						<view :class="shopData.rate.huanbi>= 0?'small-text-red':'small-text-green'" style="-webkit-flex: 1;flex: 1;">{{shopData.rate.huanbi>0?"↑"+shopData.rate.huanbi:"↓"+shopData.rate.huanbi}}名</view>
					</view>
				</view>
			</view>
			<!-- 圆环图区域 -->
			<view class="box-contaniner">
				<view class="clineChart-title">
					<view style="font-size: 30rpx;font-weight: bold;">竞彩足篮球销量及占比</view>
					<view class="linechart-tab">
						<view @tap="changeArcbar(0)" :class="arcbarNum == 0?'btna':'hide'" >足球</view>
						<view @tap="changeArcbar(1)" :class="arcbarNum == 1?'btna':'hide'" >篮球</view>
					</view>
				</view>	
				<view v-if="arcbarNum == 0" >
					<view class="arcbarChart-content">
						<view class="arcbar" style="width: 50%;">
							<arcbar-chart :canvasId="`index_arcbar_0`" :ref="`arcbar0`" :dataAs="arcbar0" :basicAs="{colors: ['#ff7600']}"/>
						</view>
						<view class="arcbar-text" style="width: 50%;">
							<dataContainerTwo  ref="dataContain2" :dataAs="footballData"></dataContainerTwo>
						</view>					
					</view>
					<view class="sale-row-2">
						<view class="row-box">
							<view class="lineTwo">
								<view class="row_box_2">全国足球销量占比</view>
								<view class="row_box_2">{{allData.footRate+"%"}}</view>				
							</view>
						</view>
						<view class="row-box">
							<view class="lineTwo">
								<view class="row_box_2">全省足球销量占比</view>
								<view class="row_box_2">{{provinceData.footRate+"%"}}</view>
							</view>
						</view>
					</view>
				</view>
				<view v-if="arcbarNum == 1" >		　						 
					<view class="arcbarChart-content">
						<view class="arcbar" style="width: 50%;">
							<arcbar-chart :canvasId="`index_arcbar_1`" :ref="`arcbar1`" :dataAs="arcbar1" :basicAs="{colors: ['#ff7600']}"/>
						</view>
						<view class="arcbar-text" style="width: 50%;">
							<dataContainerTwo  ref="dataContain3" :dataAs="basketballData"></dataContainerTwo>
						</view>
					</view>
					<view class="sale-row-2">
						<view class="row-box">
							<view class="lineTwo">
								<view class="row_box_2">全国篮球销量占比</view>
								<view class="row_box_2">{{allData.baskRate+"%"}}</view>				
							</view>
						</view>
						<view class="row-box">
							<view class="lineTwo">
								<view class="row_box_2">全省篮球销量占比</view>
								<view class="row_box_2">{{provinceData.baskRate+"%"}}</view>
							</view>
						</view>
					</view>
				</view>				
			</view>		
		
			<block v-if="today!= selfParam.businessDate.view">	 
				<view class="box-contaniner">
					<view class="shop-title">返奖情况</view>
					<view class="line">
						<view class="shop-item-title">
							<view style="width: 40%;">返奖率</view>				
							<view style="width: 35%;">同比</view>
							<view style="width: 20%;">环比</view>
						</view>
						<view class="shop-item-content">
							<view style="width: 40%;">{{returnData.rate.sum +'%'}}</view>
							<view :class="returnData.rate.tongbi>= 0?'small-text-red':'small-text-green'" style="width: 35%;">{{returnData.rate.tongbi>0?"+"+returnData.rate.tongbi+'%':returnData.rate.tongbi+'%'}}</view>
							<view :class="returnData.rate.huanbi>= 0?'small-text-red':'small-text-green'" style="width: 20%;">{{returnData.rate.huanbi>0?"+"+returnData.rate.huanbi+'%':returnData.rate.huanbi+'%'}}</view>
						</view>
					</view>
				</view>			
			</block>
			
			<!-- 返奖率走势-->
			<block v-if="selfParam.businessDate.dateType!='date'">
				<view class="shop-title">返奖率走势</view>
				<view class="box-contaniner" >
					<area-chart ref="lineData3" canvasId="index_line_3" :dataAs="lineData3"  
								:xAxisAs="{scrollShow:false, gridEval:(lineData3.categories.length / 4).toFixed(0)}"
								:yAxisAs="{formatter: {type: 'percent', name:'',fixed: 2}}"/>
				</view>
			</block>
			
			<slot />
		<!-- </view> -->
	</view>
</template>

<script>
	import LineChart from '@/components/basic-chart/LineChart.vue';
	import AreaChart from '@/components/basic-chart/AreaChart.vue';
	import ArcbarChart from '@/components/basic-chart/ArcbarChart.vue';
	import vTable from "@/components/table/table.vue";
	import dataContainer from '@/components/sads-components/dataContainer.vue';
	import dataContainerTwo from '@/components/sads-components/dataContainerTwo.vue';
	import urlAPI from '@/common/vmeitime-http/';
	import numberFun from '@/common/tools/number.js';
	import dateUtils from '@/common/tools/dateUtils.js';
	
	export default {
		name: 'Index',
		components: {
			LineChart,
			ArcbarChart,
			vTable,
			dataContainer,
			dataContainerTwo,AreaChart
		},
		props: {
			param:{
				//数据
				type: Object,
				default: () => ({})
			}
		},
		data() {
			return {			
				selfParam:{},
				today:dateUtils.getToday(),
				totalData:{},	
				footballData:{
					// big1:{
					// 			name:"销量",
					// 			value:"--",
					// 			left:{name:"周同比",value:"--"},
					// 			right:{name:"环比",value:"--"},
					// 				},
					// 		  big2:{name:"占比",value:"--",
					// 			left:{name:"周同比",value:"--"},
					// 			right:{name:"环比",value:"--"},
					// 		},
							},		
				basketballData:{
					// big1:{name:"销量",value:"--",
					// 				left:{name:"周同比",value:"--"},
					// 				right:{name:"环比",value:"--"},
					// 				},
					// 		 big2:{name:"占比",value:"--",
					// 							left:{name:"周同比",value:"--"},
					// 							right:{name:"环比",value:"--"},
					// 							},
				},	
				btnnum: 0,
				arcbarNum: 0,
				gateInfo:"",
				ballType:'足球',
				lineData2: {series:[
							
					],},
				lineData1: {series:[
							
					],},
				lineData3:{},
				arcbar0: {},
				arcbar1: {},
				shopData: {shop:{sum:0,tongbi:0,huanbi:0},
						   rate:{sum:0,tongbi:0,huanbi:0}},
				returnData: {rate:{sum:0,tongbi:0,huanbi:0}},
				allData: {footRate:0, baskRate:0},
			    provinceData: {footRate:0, baskRate:0},
			};
		},
		onLoad() {
			// _self = this;
			// this.cWidth=uni.upx2px(750);
			// this.cHeight=uni.upx2px(500);
			// try{
			// 	this.returnFromDatePicker();
			// 	this.getServerData();
			// 	this.showView();
			// 	this.refresh();
			// } catch (e) {
			// 	this.changeArcbar(0)
			// };
			
			
			// this.changeArcbar(0)
		},
		onShow() {
			// _self = this;
			// this.returnFromDatePicker();
			// this.getServerData();
			// this.showView()
			// this.refresh();
		},
		created() {
			try{
				this.returnFromDatePicker();
				this.getServerData();
				this.showView();
				// this.refresh();
			} catch (e) {
				this.changeArcbar(0)
			};
			
		},
		methods: {
			showView(){
				this.$nextTick(() => {
					this.$refs['arcbar0'].showCharts();
					this.$refs['arcbar1'].showCharts();
					this.$refs['lineData2'].showCharts();
					this.$refs['lineData1'].showCharts();
					this.$refs['dataContain'].showDataContainer();
					this.$refs['dataContain2'].showDataContainer();
					this.$refs['dataContain3'].showDataContainer();
				})
			},
			returnFromDatePicker(){
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				const dateType = uni.getStorageSync("dateType")
				const bussinessDate = JSON.parse(uni.getStorageSync("businessDate"))
				this.selfParam.businessDate = bussinessDate;
				console.log('returnFromDatePicker:dateType=',this.selfParam.businessDate)	
						
				const area = uni.getStorageSync("area")
				const areaName = uni.getStorageSync("areaName")
				console.log('returnFromDatePicker:area=',area,', areaName=',areaName)					
				this.selfParam.provinceCenterId=area
				this.selfParam.provinceCenterName=areaName	
				this.selfParam.shopNo = uni.getStorageSync("shopNo")
				this.selfParam.token=getApp().globalData.token
				this.gateInfo = JSON.parse(uni.getStorageSync("gateInfo"))
				uni.setStorageSync("selfParam",JSON.stringify(this.selfParam))
			},
			createParam(){
				console.log("createParam begin")
				var dateType = this.selfParam.businessDate.dateType
				var param = {}
				if(dateType=='date'){
					param = {dateTimeStart: this.selfParam.businessDate.date.startDate,
							 dateTimeEnd: this.selfParam.businessDate.date.endDate,
							 dateFlag:"1",
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}else if(dateType=='week'){
					param = {dateTimeStart: this.selfParam.businessDate.week.startDate,
							 dateTimeEnd: this.selfParam.businessDate.week.endDate,
							 dateFlag:"2",
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}else if(dateType=='month'){
					param = {dateTimeStart: this.selfParam.businessDate.month.startDate,
							 dateTimeEnd: this.selfParam.businessDate.month.endDate,
							 dateFlag:"3",
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}else if(dateType=='year'){
					param = {dateTimeStart: this.selfParam.businessDate.year.startDate,
							 dateTimeEnd: this.selfParam.businessDate.year.endDate,
							 dateFlag:"4",
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}	
				console.log("createParam end:",param)
				return param
			},
			getDataSet(){
				var url = '/pentaho/shows/getShowSalesAndVotes';
				var param = this.createParam()
				
				urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						console.log('request success', res)
						var data = res.data.data;
						var amount = data[0]
						var saleNumber = data[1]
						
						console.log("amount=",amount,"saleNumber=",saleNumber)
						var format0 = numberFun.formatCNumber(amount[0]);
						var format1 = numberFun.formatCNumber(saleNumber[0]);
						console.log("format0=",format0,"format1=",format1)
						var left1 = {'name':'周同比','value':amount[1] + '%'};
						var right1 = {'name':'环比','value':amount[2] + '%'};
						var big1 = {'name':'销量（'+format0.name +'元）', 'value':(amount[0]/format0.value).toFixed(2), 'left': left1,'right':right1};
						
						var left2 = {'name':'周同比','value':saleNumber[1] + '%'};
						var right2 = {'name':'环比','value':saleNumber[2] + '%'};
						var big2 = {'name':'票数（'+format1.name +'张）','value':saleNumber[0]/format1.value, 'left':left2,'right':right2};
									 			
						this.$set(this.totalData, 'big1', big1);
						this.$set(this.totalData, 'big2', big2);
						this.$refs['dataContain'].showDataContainer();
						console.log('request totalData', this.totalData);
												
						this.res = '请求结果 : ' + JSON.stringify(res);
											
					}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			},
			getLinesData(){
				var url = '/pentaho/shows/showSalesVotesTrendChart';
				var param = this.createParam()
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					uni.showToast({
						title: '请求成功',
						icon: 'success',
						mask: true
					});
					var data = res.data.data;	
					var sales = data.sales
					var dates = data.dates
					var votes = data.votes
					
					var categories=[];
					var series=[];
					var amountData = [];
					var volData = [];
					var j=0,k = 0,tempAmount=0,tempVol=0;
					var maxAmount = 0;
					var maxVote = 0;
					for(var i=0;i<dates.length;i++){	
						if(maxAmount<sales[i]){
							maxAmount = sales[i]
						}
						if(maxVote<votes[i]){
							maxVote = votes[i]
						}
					}
					var amountFormat = numberFun.formatCNumber(maxAmount);
					var voteFormat= numberFun.formatCNumber(maxVote);
					for(var i=0;i<dates.length;i++){	
						categories[i] = dates[i];
						amountData[i] = (sales[i]/amountFormat.value).toFixed(2);
						volData[i] = (votes[i]/voteFormat.value).toFixed(2);
					}
					
					var json = {'name':'销量('+amountFormat.name +'元）' ,'data':amountData};
					var series = [];
					series[0] = json;	
					
					this.$set(this.lineData2, 'categories', categories);
					this.$set(this.lineData2, 'series', series);
					
					
					var json2 = {'name':'票数('+voteFormat.name +'张）','data':volData};
					var series2 = [];
					series2[0] = json2;
					this.$set(this.lineData1, 'categories', categories); 
					this.$set(this.lineData1, 'series', series2);
					
					if(this.btnnum==0){
						this.$refs['lineData2'].showCharts();
					}else{
						this.$refs['lineData1'].showCharts();
					}
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			},
			getDataContainerTwo(type){
				var url='/pentaho/shows/getShowsGameSales'
				var param = this.createParam()
				var big1 = {'name':'销量',value:"--"};
				var left1 = {'name':'周同比',value:"--"};
				var right1 = {'name':'环比',value:"--"};				

				var big2 = {'name':'占比',value:"--"};
				var left2 = {'name':'周同比',value:"--"};
				var right2 = {'name':'环比',value:"--"};
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					var data = res.data.data;	
					var that =this;
					console.log("getShowsGameSales :",data) 
					if(data==null){
						return;
					}
					var tempObj;
					if(type=='足球'){
						tempObj = data.football
					}else{
						tempObj = data.basketball
					}
				
					var format0 = numberFun.formatCNumber(tempObj[0]);
					var amount0 = (tempObj[0]/format0.value).toFixed(2) + format0.name +'元';
					left1.value = tempObj[1];
					right1.value = tempObj[2];
					big1.value = amount0;
					big1.left = left1;
					big1.right = right1;
					
					var amount1 = tempObj[3];					
					left2.value = tempObj[4];
					right2.value = tempObj[5];
					big2.value = amount1;
					big2.left = left2;
					big2.right = right2;							
					
					if(type=='足球'){					
						that.$set(that.footballData, 'big1', big1);
						that.$set(that.footballData, 'big2', big2);
						var json = [{name: '足球',data: (tempObj[3]/100).toFixed(2)}]
						that.arcbar0.series = json
						console.log("this.arcbar0=",that.arcbar0)
						// this.$set(this.arcbar0, 'series', json);
						this.$refs['arcbar0'].showCharts();
						this.$refs['dataContain2'].showDataContainer();
						console.log('request basketballData', this.footballData);
					}else{
						that.$set(that.basketballData, 'big1', big1);
						that.$set(that.basketballData, 'big2', big2);
						var json = [{name: '篮球',data: (tempObj[3]/100).toFixed(2)}]
						that.arcbar1.series= [{name: '篮球',data: (tempObj[3]/100).toFixed(2)}]
						console.log("this.arcbar1=",that.arcbar1)
						// this.$set(this.arcbar1, 'series', json);
						this.$refs['arcbar1'].showCharts();
						this.$refs['dataContain3'].showDataContainer();
						console.log('request basketballData', this.basketballData);
					}
			
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			},
			getShopData(){
				var url = '/pentaho/shows/getShowRankingCountry';
				var param = this.createParam()
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					uni.showToast({
						title: '请求成功',
						icon: 'success',
						mask: true
					});
					var data = res.data.data;	
					if(data==null || data.length==0){
						return;
					}
					this.shopData.shop.sum=data[0];
					this.shopData.shop.tongbi=data[1];
					this.shopData.shop.huanbi=data[2];
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
					this.shopData.shop.sum=0;
					this.shopData.shop.tongbi=0;
					this.shopData.shop.huanbi=0;
				});
			},
			getRankByProvince(){
				var url = '/pentaho/shows/getShowRankingPro';
				// var url = '/pentaho/shows/getShowRankingCity';
				var param = this.createParam()
				param.provincialId = this.gateInfo.provincialId
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					uni.showToast({
						title: '请求成功',
						icon: 'success',
						mask: true
					});
					var data = res.data.data;	
					if(null==data[0]){
						this.shopData.rate.sum=0;
					}else{
						this.shopData.rate.sum=data[0];
					}
					this.shopData.rate.tongbi=data[1];
					this.shopData.rate.huanbi=data[2];
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
					this.shopData.rate.sum=1;
					this.shopData.rate.tongbi=0;
					this.shopData.rate.huanbi=0;
				});
			},
			getShowReturnRate(){
				var url = '/pentaho/shows/getShowReturnRate';
				var param = this.createParam()
				param.token =getApp().globalData.token;
				// param.regionId = this.gateInfo.provincialId
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					uni.showToast({
						title: '请求成功',
						icon: 'success',
						mask: true
					});
					var data = res.data.data;
					if(null==data[0]){
						this.returnData.rate.sum=0;
					}else{
						this.returnData.rate.sum=data[0];
					}
					
					this.returnData.rate.tongbi=data[1];
					this.returnData.rate.huanbi=data[2]
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
					this.returnData.rate.sum=0;
					this.returnData.rate.tongbi=0;
					this.returnData.rate.huanbi=0
				});
			},
			getServerData() {
				this.getDataSet();
				this.getLinesData();
				this.getDataContainerTwo('足球');
				this.getDataContainerTwo('篮球');
				this.getShopData();
				this.getRankByProvince();		
				this.getShowReturnRate();
				this.getGameSalesByAll()
				this.getGameSalesByProvince()
				if(this.selfParam.businessDate.dateType!='date'){
					this.getReturnRateLine()
				}				
			},
			getGameSalesByAll(){
				var url='/pentaho/sales/getGameSales'
				var param = this.createParam()
				
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					var data = res.data.data;	
					if(data==null){
						return;
					}
					
					this.allData.footRate = data.football[3]
					this.allData.baskRate = data.basketball[3]
							
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			},
			getGameSalesByProvince(){
				var url='/pentaho/sales/getGameSales'
				var param = this.createParam()
				param.regionId=this.gateInfo.provincialId
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					var data = res.data.data;	
					if(data==null){
						return;
					}
					
					this.provinceData.footRate = data.football[3]
					this.provinceData.baskRate = data.basketball[3]
							
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			},
			refresh(){
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				console.log("刷新页面，日期为",this.selfParam)
				this.getServerData();
				this.showView();
				this.getServerData();
				this.showView();
			},
			change(e) {
			      this.btnnum = e
			      console.log(this.btnnum)
				  this.getServerData();
				  this.showView()
			},
			changeArcbar(e){
				//pentaho/sales/getGameSales
				this.arcbarNum = e
				if(e==0){
					this.ballType='足球'
				}else {
					this.ballType='篮球'
				}
				this.getServerData();
				this.showView()
			},
			goSaleRank(tableData, tableColumns){
				uni.navigateTo({
					url:"/pages/common/tableDetail?tableData= " + JSON.stringify(tableData) + '&tableColumns=' + JSON.stringify(tableColumns)
				});
			},
			getReturnRateLine(){
				var url = '/pentaho/shows/getShowReturnRateTrendChart';
				var param = this.createParam()
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					var data = res.data.data;
					if(data==null || data.length==0){
						return;
					}
					var dates = data.dates
					var ALL = data.ALL
					var FB = data.FB
					var BK=data.BK
					for(var i=0;i<dates.length;i++){
						ALL[i] = (data.ALL[i]/100).toFixed(2)
						FB[i] = (data.FB[i]/100).toFixed(2)
						BK[i] = (data.BK[i]/100).toFixed(2)
					}
					
					var categories=[];
					var series=[];
					
					var json = {'name':'竞彩返奖率' ,'data':ALL};
					var json1 = {'name':'足球返奖率' ,'data':FB};
					var json2 = {'name':'篮球返奖率' ,'data':BK};
					var series = [json,json1,json2];		
					this.$set(this.lineData3, 'categories', dates);
					this.$set(this.lineData3, 'series', series);
					
					this.$refs['lineData3'].showCharts();
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			},
			valueToPercent(value) {
				let temp = value;
				value = value + '';
				const pointIndex = value.indexOf('.');
				if (pointIndex === -1) return (value - 0) * 100;
				const powIndex = value.length - pointIndex - 1;
				// let result = (value.replace('.', '') - 0) * Math.pow(10, 2 - powIndex);
				let result = value;
				if(value>=0){
					result = "+" + result + "%";
				}else{
					result = result + "%";
				}
				return result;
			},
			valueToPercent2(value) {
				let temp = value;
				value = value + '';
				const pointIndex = value.indexOf('.');
				if (pointIndex === -1) return (value - 0) * 100;
				const powIndex = value.length - pointIndex - 1;
				let result = (value.replace('.', '') - 0) * Math.pow(10, 2 - powIndex);

				return result + "%";
			}
		},
		mounted(){
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			// this.showView();
		},
		watch: {
			'$route':'showView'
		}
	}
</script>

<style>	
	
	.shop-title{
		width: 100%;
		margin: 0rpx 5rpx;
		padding: 0 10rpx;
		font-size: 30rpx;
		font-weight: bold;
	}
	
	.shop-item-title{
		width: 100%;
		display: flex;
/* 		margin: 0rpx 10rpx 0rpx 10rpx;
		padding: 0 10rpx 0 10rpx; */
		flex-direction: row;
		font-size: 30rpx;
	}
	.shop-item-content{
		width: 100%;
		display: flex;
/* 		margin: 0rpx 10rpx 0rpx 10rpx;
		padding: 0 10rpx 0rpx 10rpx; */
		flex-direction: row;
		font-size: 40rpx;
	}
	
	.rankTable{
		width: 100%;
		height: 500upx;
		margin: 0rpx 5rpx 0rpx 5rpx;
		padding: 0 10rpx;
		font-size: 30rpx;
		font-weight: bold;
		background-color: #FFFFFF;
	}
	.btna{
			color: #FFFFFF;
			background:rgba(47, 98, 248 ,0.5);	
	 }
	.backWidth{
		width: 50%;
	}
	.dis{
		display: block;
		/* padding:0px 30rpx 0px 30rpx; */
	} 
	.hide{
		color: #000000;
		background: #FFFFFF;
		padding:0px 30rpx 0px 30rpx;
	}
	.rankTable-title{
		width: 100%;
		margin: 0rpx 5rpx;
		padding: 0 10rpx; 
		display: flex;
		justify-content: space-between;
		font-weight: bold;
	}
	
	.rankTable-more{
		margin: 0rpx 5rpx;
		padding: 0 0rpx;
		text-align: right;
	}
		
	
	.example {
		/* line-height: 40px; */
		font-weight: bold;
		border-color:#FFFFFF;
	}
	
	.title {
		/* line-height: 40px; */
		font-weight: bold;
		border-color:#FFFFFF;
	}
	.box-contaniner{
		width: 100%;
	}
	
	.clineChart-title{
		display: flex;
		justify-content:space-between;
	}
	/* 将三个内容view的display设置为none(隐藏) */
	.linechart-tab{
		/* padding:0rpx 5rpx 0rpx 5rpx; */
		flex-direction: row;
		display: flex;
		text-align: right;
		justify-content:space-around;
		font-size: 30rpx;
	}
	
	.arcbarChart-box{
		/* margin: 20rpx 10rpx 20rpx 10rpx; */
		/* padding: 20rpx 0rpx 20rpx 0rpx; */
	}
	
	.arcbarChart-title{
		display: flex;
		justify-content:space-between;
	}
	/* 将三个内容view的display设置为none(隐藏) */
	.arcbarChart-tab{
		margin: 20rpx 10rpx 20rpx 10rpx;
		padding:0rpx 5rpx 0rpx 5rpx;
		flex-direction: row;
		display: flex;
		text-align: right;
		justify-content:flex-end;
		font-size: 30rpx;
	}
	.arcbarChart-content{
		display: flex;
		flex-direction: row;
	}
	.arcbar-text{
		flex-direction: column;
		display: flex;
		padding:20px 10px ;
		/* justify-content:space-between; */
	}
	.arcbar-text-line{
		width: 100%;
		display: flex;
		flex-direction: row;
	}
	.end-cont{
		display: none;
		background: #FFFFFF;
	}
	
	.small-text-green{
		color: ##1FCE58;
		/* font-size: 30rpx; */
	}
	
	.small-text-red{
		color: #E83838;
		/* font-size: 30rpx; */
	}
	
	.sale-row-2{
		display: flex;
		flex-direction: row;	
		/* margin: 20rpx 10rpx 20rpx 10rpx; */
	}
	/* 将三个内容view的display设置为none(隐藏) */
	.linechart-tab{
		padding:0rpx 5rpx 0rpx 5rpx;
		flex-direction: row;
		display: flex;
		text-align: right;
		justify-content:flex-end;
		font-size: 30rpx;
	}
	
	.row-box {
		display: flex;
		width: 50%;
		flex-direction: column;
	}
	
	.row_box_2{
		display: flex;
		flex-direction: row;	
	}
	
	.line{
		/* margin: 30px 10px; */
		width: 100%;
		padding:20px 10px;
		display: flex;
		flex-direction: column;
		background:rgba(128,139,150,0.1);
		border-radius: 15px;
	}
	
	.lineTwo{
		margin: 10px 10px;
		padding:10px 5px ;
		display: flex;
		flex-direction: column;
		background:rgba(220, 241, 250 ,0.5);
		border-radius: 15px;
	}
	/* 将三个内容view的display设置为none(隐藏) */
	.arcbarChart-tab{
		margin: 20rpx 10rpx 20rpx 10rpx;
		padding:0rpx 5rpx 0rpx 5rpx;
		flex-direction: row;
		display: flex;
		text-align: right;
		justify-content:flex-end;
		font-size: 30rpx;
	}
</style>
