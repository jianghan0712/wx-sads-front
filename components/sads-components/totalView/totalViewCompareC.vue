<template>
	<view>
		<view class="box-contaniner">
			<view class="arcbarChart-tab">
			    <view @tap="change(0)" :class="btnnum ==0?'btna':'hide'" style="width: 50%;" >足球</view>
			    <view @tap="change(1)" :class="btnnum ==1?'btna':'hide'" style="width: 50%;" >篮球</view>
			</view>
			<view class="end-cont" :class="{dis:btnnum == 0}">
				<dataContainerTwoCol ref="dataContain" :dataAs="topDataFB"></dataContainerTwoCol>
			</view>
			<view class="end-cont" :class="{dis:btnnum == 1}">		　
				<dataContainerTwoCol ref="dataContain1" :dataAs="topDataBK"></dataContainerTwoCol>
			</view>
		</view>
		
		<!-- 折线图区域-->
		<view class="box-contaniner">
			<view class="clineChart-title">
				<view style="font-size: 30rpx;font-weight: bold;">竞彩销量及票数走势</view>
				<view class="linechart-tab">
				　　<view @tap="change1(0)" :class="btnnum1 == 0?'btna':'hide'">销量</view>
				  　<view @tap="change1(1)" :class="btnnum1 == 1?'btna':'hide'">票数</view>
				</view>
			</view>		
			<view class="end-cont" :class="{dis:btnnum1 == 0}">		
				<line-chart ref="lineData2" canvasId="index_line_2" :dataAs="lineData2" :colors="colorList"
							:xAxisAs="{scrollShow:false}" 
							:yAxisAs="{formatter: {type: 'number', name:'元',fixed: 0}}"/>
			</view>
			<view class="end-cont" :class="{dis:btnnum1 == 1}">		　
				<line-chart ref="lineData1" canvasId="index_line_1" :dataAs="lineData1" 	
							:xAxisAs="{scrollShow:false}" 
							:yAxisAs="{formatter: {type: 'number', name:'张',fixed: 0}}"/>
			</view>		
		</view>
		
		<!-- 排名对比 -->
		<view class="box-contaniner">
			<view class="shop-title">排名对比</view>
			<dataContainerTwoCol ref="dataContain2" :dataAs="rankData"></dataContainerTwoCol>
		</view>
		<!-- 竞彩足篮球销量及占比对比 -->
		<view class="box-contaniner">
			<view class="shop-title">竞彩足篮球销量及占比对比</view>
			<dataContainerTwo ref="dataContain3" :dataAs="compareData"></dataContainerTwo>
			<dataContainerTwo ref="dataContain4" :dataAs="compareDataCompare"></dataContainerTwo>
		</view>	
		<slot />
	</view>
</template>

<script>
	import LineChart from '@/components/basic-chart/LineChart.vue';
	import ArcbarChart from '@/components/basic-chart/ArcbarChart.vue';
	import vTable from "@/components/table/table.vue";
	import dataContainer from '@/components/sads-components/dataContainer.vue';
	import dataContainerTwo from '@/components/sads-components/dataContainerTwo.vue';
	import dataContainerTwoCol from '@/components/sads-components/dataContainerTwoCol.vue';
	import dataContainerTwoColTwo from '@/components/sads-components/dataContainerTwoColTwo.vue';
	import urlAPI from '@/common/vmeitime-http/';
	import numberFun from '@/common/tools/number.js';
	import PieChart from '@/components/basic-chart/PieChart.vue';
	import RingChart from "@/components/basic-chart/RingChart.vue";
	
	export default {
		name: 'Index',
		components: {
			PieChart,
			RingChart,
			LineChart,
			ArcbarChart,
			vTable,
			dataContainer,
			dataContainerTwo,
			dataContainerTwoCol,dataContainerTwoColTwo
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
				selfParam:{
					token:'',
					provinceCenterId:'',//当前查看的省份，如果之前是全国，这里可能会变动
					cityCenterId:'',
					provinceCenterName:'',
					shopNo:'',
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
						viewLeft:'',//用于展示日期、年、月等
						viewRight:'',
						dateLeft:{startDate:'', endDate:''},
						dateRight:{startDate:'', endDate:''},
						weekLeft:{startDate:'', endDate:''},
						weekRight:{startDate:'', endDate:''},
						monthLeft:{startDate:'', endDate:''},
						monthRight:{startDate:'', endDate:''},
						yearLeft:{startDate:'', endDate:''},
						yearRight:{startDate:'', endDate:''},
					},	
					userId:'',			
					selfProvinceCenterId:''//存登录时候的id
				},
				topDataFB:{	left:{title1:'销量（万）',amount1:0,title2:'票数（张）',amount2:0},
							right:{title1:'销量（万）',amount1:0,title2:'票数（张）',amount2:0}},
				topDataBK:{	left:{title1:'销量（万）',amount1:0,title2:'票数（张）',amount2:0},
							right:{title1:'销量（万）',amount1:0,title2:'票数（张）',amount2:0}},
				btnnum:0,
				btnnum1:0,
				lineData2: {},
				lineData1: {},
				rankData:{	left:{title1:'全国排名',amount1:1,title2:'全省排名',amount2:1},
							right:{title1:'全国排名',amount1:1,title2:'全省排名',amount2:1}},
				compareData: {big1:{name:"足球",value:"",
									left:{name:"销量",value:0},
									right:{name:"占比",value:0},
									},
							 big2:{name:"篮球",value:"",
												left:{name:"销量",value:0},
												right:{name:"占比",value:0},
												}},
				compareDataCompare:  {big1:{name:"足球",value:"",
									left:{name:"销量",value:0},
									right:{name:"占比",value:0},
									},
							 big2:{name:"篮球",value:"",
												left:{name:"销量",value:0},
												right:{name:"占比",value:0},
												}},
			};
		},
		created() {
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			this.returnFromDatePicker()
			this.getServerData();
			this.showView();
			this.refresh();
		},
		onLoad() {
			_self = this;
			this.cWidth=uni.upx2px(750);
			this.cHeight=uni.upx2px(500);
			this.returnFromDatePicker()
			this.getServerData();
			this.showView();
			this.refresh();
		},
		onShow() {
			_self = this;
			this.cWidth=uni.upx2px(750);
			this.cHeight=uni.upx2px(500);
			this.returnFromDatePicker()
			this.getServerData();
			this.showView();
			this.refresh();
		},
		methods: {
			getServerData() {
				this.getTopData();
				this.getMidData();
				this.getLastData();
				this.getLinesData();
			},
			showView(){
				this.$refs['dataContain'].showDataContainer();
				this.$refs['dataContain1'].showDataContainer();
				this.$refs['dataContain2'].showDataContainer();
				this.$refs['dataContain3'].showDataContainer();
				this.$refs['dataContain4'].showDataContainer();
			},
			returnFromDatePicker(){
				const dateType = uni.getStorageSync("compareDateType")
				const leftDate = JSON.parse(uni.getStorageSync("leftBusinessDate"))
				const rightDate = JSON.parse(uni.getStorageSync("rightBusinessDate"))
				console.log("dateType:",dateType)
				console.log("leftDate:",leftDate)
				console.log("rightDate:",rightDate)
				
				if(leftDate==null || rightDate==null){
					return
				}
				
				if(leftDate.dateType!=dateType || rightDate.dateType!=dateType){
					console.log("dateType不匹配:")
					const compareDate={
							dateType:dateType,
							viewLeft:leftDate.view,//用于展示日期、年、月等
							viewRight:rightDate.view,
							dateLeft:{startDate:leftDate.date.startDate, endDate:leftDate.date.endDate},
							dateRight:{startDate:rightDate.date.startDate, endDate:rightDate.date.endDate},
							weekLeft:{startDate:leftDate.week.startDate, endDate:leftDate.week.endDate},
							weekRight:{startDate:rightDate.week.startDate, endDate:rightDate.week.endDate},
							monthLeft:{startDate:leftDate.month.startDate, endDate:leftDate.month.endDate},
							monthRight:{startDate:rightDate.month.startDate, endDate:rightDate.month.endDate},
							yearLeft:{startDate:leftDate.year.startDate, endDate:leftDate.year.endDate},
							yearRight:{startDate:rightDate.year.startDate, endDate:rightDate.year.endDate},
						}
					this.selfParam.compareDate=compareDate
					return
				}
				console.log("leftDate:",leftDate)
				const compareDate={
						dateType:dateType,
						viewLeft:leftDate.view,//用于展示日期、年、月等
						viewRight:rightDate.view,
						dateLeft:{startDate:leftDate.date.startDate, endDate:leftDate.date.endDate},
						dateRight:{startDate:rightDate.date.startDate, endDate:rightDate.date.endDate},
						weekLeft:{startDate:leftDate.week.startDate, endDate:leftDate.week.endDate},
						weekRight:{startDate:rightDate.week.startDate, endDate:rightDate.week.endDate},
						monthLeft:{startDate:leftDate.month.startDate, endDate:leftDate.month.endDate},
						monthRight:{startDate:rightDate.month.startDate, endDate:rightDate.month.endDate},
						yearLeft:{startDate:leftDate.year.startDate, endDate:leftDate.year.endDate},
						yearRight:{startDate:rightDate.year.startDate, endDate:rightDate.year.endDate},
					}
				this.selfParam.compareDate=compareDate
				console.log("compareDate:",compareDate)
				const bussinessDate = JSON.parse(uni.getStorageSync("businessDate"))
				this.selfParam.businessDate = bussinessDate;
				console.log('returnFromDatePicker:dateType=',this.selfParam.businessDate)	
						
				const area = uni.getStorageSync("area")
				const areaName = uni.getStorageSync("areaName")
				console.log('returnFromDatePicker:area=',area,', areaName=',areaName)					
				this.selfParam.provinceCenterId=area
				this.selfParam.provinceCenterName=areaName
				this.selfParam.token=uni.getStorageSync("token")
				this.selfParam.shopNo = uni.getStorageSync("shopNo");
				uni.setStorageSync("selfParam",JSON.stringify(this.selfParam))
			},
			createParam(){
				console.log("createParam begin")
				var dateType = this.selfParam.compareDate.dateType
				var param = {}
			
				if(dateType=='date'){
					param = {dateTimeStart: this.selfParam.compareDate.dateLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.dateLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.dateRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.dateRight.endDate,
							 dateFlag:"1",
							 showNumber:this.selfParam.shopNo,
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='week'){
					param = {dateTimeStart: this.selfParam.compareDate.weekLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.weekLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.weekRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.weekRight.endDate,
							 dateFlag:"2",
							 showNumber:this.selfParam.shopNo,
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='month'){
					param = {dateTimeStart: this.selfParam.compareDate.monthLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.monthLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.monthRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.monthRight.endDate,
							 dateFlag:"3",
							 showNumber:this.selfParam.shopNo,
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='year'){
					param = {dateTimeStart: this.selfParam.compareDate.yearLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.monthLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.monthRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.monthRight.endDate,
							 dateFlag:"4",
							 regionId:this.selfParam.provinceCenterId,
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}	
				console.log("createParam end:",param)
				return param
			},
			// 获取最上层的两个tab
			getTopData(){
				var url = '/pentaho/shows/gamesContrast/getComGamesContrastSales';
				var param = this.createParam()
				param.token=getApp().globalData.token;
				var that =this;
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
						console.log('request success', res)
						var data = res.data.data;
						
						var FB= data.FB;
						var BK= data.BK;
						
						var amountFB1 = FB[0];
						var saleNumberFB1 = FB[1];
						var amountFB2 = FB[2];
						var saleNumberFB2 = FB[3];
						
						var formatFB00 = numberFun.formatCNumber(amountFB1);
						var formatFB01 = numberFun.formatCNumber(saleNumberFB1);
						var formatFB10 = numberFun.formatCNumber(amountFB2);
						var formatFB11 = numberFun.formatCNumber(saleNumberFB2);
						var leftFB = {'title1':'销量（'+formatFB00.name +'元）', 'amount1':amountFB1/formatFB00.value, 'title2':'票数（'+formatFB01.name +'张）', 'amount2':saleNumberFB1/formatFB01.value};
						var rightFB = {'title1':'销量（'+formatFB10.name +'元）', 'amount1':amountFB2/formatFB10.value, 'title2':'票数（'+formatFB11.name +'张）', 'amount2':saleNumberFB2/formatFB11.value};
						this.$set(that.topDataFB, 'left', leftFB);
						this.$set(that.topDataFB, 'right', rightFB);
						console.log('request topData', that.topDataFB);
						this.$refs['dataContain'].showDataContainer();
						
						var amountBK1 = BK[0];
						var saleNumberBK1 = BK[1];
						var amountBK2 = BK[2];
						var saleNumberBK2 = BK[3];
						
						var formatBK00 = numberFun.formatCNumber(amountBK1);
						var formatBK01 = numberFun.formatCNumber(saleNumberBK1);
						var formatBK10 = numberFun.formatCNumber(amountBK2);
						var formatBK11 = numberFun.formatCNumber(saleNumberBK2);
						var leftBK = {'title1':'销量（'+formatBK00.name +'元）', 'amount1':amountBK1/formatBK00.value, 'title2':'票数（'+formatBK01.name +'张）', 'amount2':saleNumberBK1/formatBK01.value};
						var rightBK = {'title1':'销量（'+formatBK10.name +'元）', 'amount1':amountBK2/formatBK10.value, 'title2':'票数（'+formatBK11.name +'张）', 'amount2':saleNumberBK2/formatBK11.value};
						this.$set(that.topDataBK, 'left', leftBK);
						this.$set(that.topDataBK, 'right', rightBK);
						this.$refs['dataContain1'].showDataContainer();
						console.log('request topData', that.topDataBK);
						this.res = '请求结果 : ' + JSON.stringify(res);
					}).catch((err)=>{
						this.loading = false;
						var leftFB = {'title1':'销量（元）', 'amount1':0, 'title2':'票数（张）', 'amount2':0};
						var rightFB = {'title1':'销量（元）', 'amount1':0, 'title2':'票数（张）', 'amount2':0};
						this.$set(that.topDataFB, 'left', leftFB);
						this.$set(that.topDataFB, 'right', rightFB);
						var leftBK = {'title1':'销量（元）', 'amount1':0, 'title2':'票数（张）', 'amount2':0};
						var rightBK = {'title1':'销量（元）', 'amount1':0, 'title2':'票数（张）', 'amount2':0};
						this.$set(that.topDataBK, 'left', leftBK);
						this.$set(that.topDataBK, 'right', rightBK);
						this.$refs['dataContain1'].showDataContainer();
						console.log('request fail', err);
					})						
			},
			getLinesData(){
				var url = '/pentaho/showsContrast/showSalesVotesTrendCom'
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
					var comSales = data.comSales
					var comDates = data.comDates
					var comVotes = data.comVotes
					
					var categories=[];
					var series=[];
					var amountData = [];
					var volData = [];
					
					var categoriesComp=[];
					var seriesComp=[];
					var amountDataComp = [];
					var volDataComp = [];
					var j=0,k = 0,tempAmount=0,tempVol=0,tempAmountComp=0,tempVolComp=0;;
					
					for(var i=0;i<dates.length;i++){	
						if(j==3){
							categories[k] = dates[i];
							amountData[k] = sales[i];
							volData[k] = votes[i];
							categoriesComp[k] = comDates[i];
							amountDataComp[k] = comSales[i];
							volDataComp[k] = comVotes[i];
							k++;
							j=0;
						}else{
							tempAmount = tempAmount+sales[i];
							tempVol = tempVol+votes[i];
							tempAmountComp = tempAmountComp + comSales[i];
							tempVolComp = tempVolComp + comVotes[i];
							j=j+1;
						}
					}
					
					// var json1 = {'name':'销量','data':amountData};
					// var json2 = {'name':'销量','data':amountDataComp};
					var series = [ {'name':this.selfParam.compareDate.viewLeft +'销量','data':amountData}, {'name':this.selfParam.compareDate.viewRight +'销量','data':amountDataComp}];	
					
					this.$set(this.lineData2, 'categories', categories);
					this.$set(this.lineData2, 'series', series);
					
					// var json3 = {'name':'销量','data':volData};
					var series2 = [{'name':this.selfParam.compareDate.viewLeft +'票数','data':volData},{'name':this.selfParam.compareDate.viewRight +'票数','data':volDataComp}];
					// series2[0] = json2;
					this.$set(this.lineData1, 'categories', categories);
					this.$set(this.lineData1, 'series', series2);
					this.$refs['lineData2'].showCharts();
					this.$refs['lineData1'].showCharts();
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			getMidData(){
				//全国
				var url = '/pentaho/showsContrast/getShowRankingProCom';
				var param =this.createParam();
				param.token=getApp().globalData.token;
				var left = {'title1':'全国排名', 'amount1':0, 'title2':'全省排名', 'amount2':1};
				var right = {'title1':'全国排名', 'amount1':0, 'title2':'全省排名', 'amount2':1};
				var that =this;
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					var data = res.data.data;
					this.$set(left, 'amount1', data[0]);
					this.$set(right, 'amount1', data[1]);
					this.$set(that.rankData, 'left', left);
					this.$set(that.rankData, 'right', right);
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				
				
				//全省排名
				url = '/pentaho/showsContrast/getShowRankingProCom';
				param =this.createParam();
				param.regionId= this.selfParam.provinceCenterId
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					var data = res.data.data;
					this.$set(left, 'amount2', data[0]);
					this.$set(right, 'amount2', data[1]);
					this.$set(that.rankData, 'left', left);
					this.$set(that.rankData, 'right', right);
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				console.log('request==============', that.rankData);
				this.$refs['dataContain2'].showDataContainer();
				
			},
			getLastData(){
				var url='/pentaho/showsContrast/getShowsGameSalesCom'
				var param = this.createParam();
				param.token=getApp().globalData.token;
				var that =this;
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					
					
					var data = res.data.data;
					
					var FB= data.FB;
					var BK= data.BK;
					var big1={name:"足球",value:"",
										left:{name:"销量",value:FB[0]},
										right:{name:"占比",value:FB[1]},
										};
					var big2={name:"篮球",value:"",
										left:{name:"销量",value:BK[0]},
										right:{name:"占比",value:BK[1]},
										};
					var big1C={name:"足球",value:"",
										left:{name:"销量",value:FB[2]},
										right:{name:"占比",value:FB[3]},
										};
					var big2C={name:"篮球",value:"",
										left:{name:"销量",value:BK[2]},
										right:{name:"占比",value:BK[3]},
										};
															
					this.$set(that.compareData, 'big1', big1);
					this.$set(that.compareData, 'big2', big2);
					that.compareData.big1=big1;
					that.compareData.big2=big2;
					this.$set(that.compareDataCompare, 'big1', big1C);
					this.$set(that.compareDataCompare, 'big2', big2C);
					that.compareDataCompare.big1=big1C;
					that.compareDataCompare.big2=big2C;
					this.$refs['dataContain3'].showDataContainer();
					this.$refs['dataContain4'].showDataContainer();
					this.res = '请求结果 : ' + JSON.stringify(res);
					console.log('request+++++', compareData);
					console.log('request+++++', compareDataCompare);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
					var big1={name:"足球",value:"",
										left:{name:"销量",value:0},
										right:{name:"占比",value:0},
										};
					var big2={name:"篮球",value:"",
										left:{name:"销量",value:0},
										right:{name:"占比",value:0},
										};
					var big1C={name:"足球",value:"",
										left:{name:"销量",value:0},
										right:{name:"占比",value:0},
										};
					var big2C={name:"篮球",value:"",
										left:{name:"销量",value:0},
										right:{name:"占比",value:0},
										};
															
					this.$set(that.compareData, 'big1', big1);
					this.$set(that.compareData, 'big2', big2);
					that.compareData.big1=big1;
					that.compareData.big2=big2;
					this.$set(that.compareDataCompare, 'big1', big1C);
					this.$set(that.compareDataCompare, 'big2', big2C);
					that.compareDataCompare.big1=big1C;
					that.compareDataCompare.big2=big2C;
					this.$refs['dataContain3'].showDataContainer();
					this.$refs['dataContain4'].showDataContainer();
				});
			},
			change(e) {
			      this.btnnum = e
			},
			change1(e) {
			      this.btnnum1 = e
			},
			refresh(selfParam){
				this.selfParam.token = uni.getStorageSync("token")
				this.returnFromDatePicker();
				this.getServerData();
				this.showView();
			},
			valueToPercent(value) {
				let temp = value;
				value = value + '';
				const pointIndex = value.indexOf('.');
				if (pointIndex === -1) return (value - 0) * 100;
				const powIndex = value.length - pointIndex - 1;
				let result = (value.replace('.', '') - 0) * Math.pow(10, 2 - powIndex);
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
			this.getServerData();
			this.showView();
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
		background-color: #FFFFFF;
	}
	
	.shop-item-title{
		width: 100%;
		display: flex;
		margin: 0rpx 10rpx 0rpx 10rpx;
		padding: 0 10rpx 0 10rpx;
		flex-direction: row;
		background-color: #ebebeb;
		font-size: 30rpx;
	}
	.shop-item-content{
		width: 100%;
		display: flex;
		margin: 0rpx 10rpx 0rpx 10rpx;
		padding: 0 10rpx 0rpx 10rpx;
		flex-direction: row;
		background-color: #ebebeb;
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
		flex-direction: row;
		font-weight: bold;
		border-color:#FFFFFF;
	}
	
	.title {
		/* line-height: 40px; */
		font-weight: bold;
		border-color:#FFFFFF;
	}
	
	.clineChart-title{
		display: flex;
		justify-content:space-between;
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
	
	.arcbarChart-box{
		margin: 20rpx 10rpx 20rpx 10rpx;
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
	.btna{
		color: #000000;
		background: #ebebeb;
		padding:0px 30rpx 0px 30rpx;
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
	.small-text-green{
		color: #00FF00;
		/* font-size: 30rpx; */
	}
	
	.small-text-red{
		color: #FF0000;
		/* font-size: 30rpx; */
	}
	.left-row-box {
		display: flex;
		width: 65%;
		margin: 0rpx 5rpx;
		/* padding: 0 10rpx; */
		/* background-color: #ebebeb; */
		flex-direction: column;
	}
	.right-row-box {
		display: flex;
		width: 35%;
		margin: 0rpx 5rpx;
		/* padding: 0 10rpx; */
		/* background-color: #ebebeb; */
		flex-direction: column;
	}
	.sale-row-2{
		display: flex;
		flex-direction: row;	
		margin: 20rpx 10rpx;
		/* padding: 20rpx 10rpx 20rpx 10rpx;	 */
	}
	.box-contaniner{
		width: 100%;
	}
	.box-contaniner1{
		width: 100%;
		margin: 10px 10px 10px 10px;
	}
</style>
