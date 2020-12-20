<template>
	<view>
		<view class="box-contaniner1">
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
		
		<view >
			<view class="clineChart-title">
				<view style="font-size: 30rpx;font-weight: bold;">{{btnnum==0?'足球':'篮球'}}游戏销量及占比对比</view>
			</view>		
			<view class="end-cont" :class="{dis:btnnum == 0}">
				<ring-chart canvasId="arcbar1" ref="arcbar1" :dataAs="arcbar1" />
				<ring-chart canvasId="arcbar11" ref="arcbar11" :dataAs="arcbar11" />
			</view>
			<view class="end-cont" :class="{dis:btnnum == 1}">
				<ring-chart canvasId="arcbar2" ref="arcbar2" :dataAs="arcbar2" />
				<ring-chart canvasId="arcbar22" ref="arcbar22" :dataAs="arcbar22" />
			</view>
			<button type="default" plain="true" @click="gotoTableDetail(btnnum)">查看全部</button>
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
	import RingChart from '@/components/basic-chart/RingChart.vue';
	export default {
		name: 'Index',
		components: {
			LineChart,
			ArcbarChart,
			vTable,
			PieChart,
			RingChart,
			dataContainer,
			dataContainerTwo,
			dataContainerTwoCol,dataContainerTwoColTwo
		},
		props: {
			model:{
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
				btnnum: 0,
				lineData2: {},
				lineData1: {},
				arcbar2: {
						type: 'radar',
						series:[
								{name: '胜平负',data: 100},
								 {name: '半全场胜平负',data: 30},
								 {name: '让球胜平负',data: 50},
						],
						extra: {
							pie: {
								lableWidth: 15,
								ringWidth: 10, //圆环的宽度
								offsetAngle: 0 //圆环的角度
							}
						}
				},
				arcbar22: {
						type: 'radar',
						series:[
								{name: '胜平负',data: 100},
								 {name: '半全场胜平负',data: 30},
								 {name: '让球胜平负',data: 50},
						],
						extra: {
							pie: {
								lableWidth: 15,
								ringWidth: 10, //圆环的宽度
								offsetAngle: 0 //圆环的角度
							}
						}
				},
				arcbar1: {
						type: 'radar',
						series:[
								{name: '胜平负',data: 100},
								 {name: '半全场胜平负',data: 30},
								 {name: '让球胜平负',data: 50},
						],
						extra: {
							pie: {
								lableWidth: 15,
								ringWidth: 10, //圆环的宽度
								offsetAngle: 0 //圆环的角度
							}
						}
				},
				arcbar11: {
							type: 'radar',
							series:[
									{name: '胜平负',data: 100},
									 {name: '半全场胜平负',data: 30},
									 {name: '让球胜平负',data: 50},
							],
							extra: {
								pie: {
									lableWidth: 15,
									ringWidth: 10, //圆环的宽度
									offsetAngle: 0 //圆环的角度
								}
							}
				},
				leftTableData: [{
							id: "1",
							area: "北京市",
							amount: "10233.5"
						},
						{
							id: "2",
							area: "上海市",
							amount: "9965.5"
						},
						{
							id: "3",
							area: "广东省",
							amount: "9754.5"
						},
						{
							id: "4",
							area: "重庆市",
							amount: "6745.6"
						},
						{
							id: "5",
							area: "河北省",
							amount: "6554"
						}
					],
				rightTableData: [{
							id: "1",
							amount: "10233.5"
						},
						{
							id: "2",
							amount: "9965.5"
						},
						{
							id: "3",
							amount: "9754.5"
						},
						{
							id: "4",
							amount: "6745.6"
						},
						{
							id: "5",
							amount: "6554"
						}
					],
				leftTableColumns: [{
							title: "排名",
							key: "id",
							$width:"50px",
						},
						{
							title: '省份',
							key: 'area',
							$width:"100px"
						},
						{
							title: '销量',
							key: 'amount',
							$width:"100px"
						}
					],
				rightTableColumns: [{
							title: "排名",
							key: "id",
							$width:"50px",
						},
						{
							title: '销量',
							key: 'amount',
							$width:"80px"
						}
					],	
			};
		},
		onLoad() {
			_self = this;
			this.cWidth=uni.upx2px(750);
			this.cHeight=uni.upx2px(500);
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			this.returnFromDatePicker();
			this.getServerData();
			this.showView();
			this.change(0);
		},
		onShow() {
			this.returnFromDatePicker();
			this.getServerData();
			this.showView();
			this.change(0);
		},
		created() {
			this.returnFromDatePicker();
			this.getServerData();
			this.showView();
			this.change(0);
		},
		methods: {
			refresh(selfParam){
				this.selfParam.token = uni.getStorageSync("token")
				this.returnFromDatePicker();
				this.getServerData();
				this.showView();
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
				this.selfParam.token=getApp().globalData.token
				uni.setStorageSync("selfParam",JSON.stringify(this.selfParam))	
			},
			showView(){
				if(this.btnnum==0){
					this.$refs['arcbar11'].showCharts();
					this.$refs['arcbar1'].showCharts();
					this.$refs['dataContain'].showDataContainer();
				}else if(this.btnnum==1){
					this.$refs['arcbar2'].showCharts();
					this.$refs['arcbar22'].showCharts();
					this.$refs['dataContain1'].showDataContainer();
				} 
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
							 dateFlag:1,
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}else if(dateType=='week'){
					param = {dateTimeStart: this.selfParam.compareDate.weekLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.weekLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.weekRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.weekRight.endDate,
							 dateFlag:2,
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}else if(dateType=='month'){
					param = {dateTimeStart: this.selfParam.compareDate.monthLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.monthLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.monthRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.monthRight.endDate,
							 dateFlag:3,
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}else if(dateType=='year'){
					param = {dateTimeStart: this.selfParam.compareDate.yearLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.monthLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.monthRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.monthRight.endDate,
							 dateFlag:4,
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}
				console.log("createParam end:",param)
				return param
			},
			gotoTableDetail(btnnum){
				
			},
			// 获取最上层的两个tab
			getTopData(){
				var url = '/pentaho/shows/gamesContrast/getComGamesContrastSales';
				var param = this.createParam();
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
					this.$set(this.topDataFB, 'left', leftFB);
					this.$set(this.topDataFB, 'right', rightFB);
					this.$refs['dataContain'].showDataContainer();
					console.log('request topData', this.topDataFB);
					
					
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
					this.$set(this.topDataBK, 'left', leftBK);
					this.$set(this.topDataBK, 'right', rightBK);
					this.$refs['dataContain1'].showDataContainer();
					console.log('request topData', this.topDataBK);
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
					var leftFB = {'title1':'销量（元）', 'amount1':0, 'title2':'票数（张）', 'amount2':0};
					var rightFB = {'title1':'销量（元）', 'amount1':0, 'title2':'票数（张）', 'amount2':0};
					this.$set(this.topDataFB, 'left', leftFB);
					this.$set(this.topDataFB, 'right', rightFB);
					this.$refs['dataContain'].showDataContainer();
					var leftBK = {'title1':'销量（元）', 'amount1':0, 'title2':'票数（张）', 'amount2':0};
					var rightBK = {'title1':'销量（元）', 'amount1':0, 'title2':'票数（张）', 'amount2':0};
					this.$set(this.topDataBK, 'left', leftBK);
					this.$set(this.topDataBK, 'right', rightBK);
					this.$refs['dataContain1'].showDataContainer();
				})
			},
			getLinesData(){
				var url = '/pentaho/shows/gamesContrast/getShowGamesSalesPropCom';
				var param = this.createParam();
				param.gameFlag=0;
				var that =this;
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res);
					var data = res.data.data;
					
					var games= data.games;
					var comGanmes =data.comGames;
					var series = [];
					var categories =[];
					for(var i=0;i<games.length;i++){
						categories.push(games[i].gameName);
						var json ={'name':games[i].gameName,'data':games[i].values[0]};
						series.push(json);
					}
					var series2 = [];
					var categories2 =[];
					for(var i=0;i<comGanmes.length;i++){
						categories2.push(comGanmes[i].gameName);
						var json ={'name':comGanmes[i].gameName,'data':comGanmes[i].values[0]};
						series2.push(json);
					}
					this.$set(that.arcbar1, 'series', series);
					this.$set(that.arcbar11, 'series', series2);
					this.$refs['arcbar11'].showCharts();
					this.$refs['arcbar1'].showCharts(); 
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					this.$refs['arcbar11'].showCharts();
					this.$refs['arcbar1'].showCharts(); 
					console.log('request fail', err);
				});
				
				param.gameFlag=1;
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res);
					var data = res.data.data;
					
					var games= data.games;
					var comGanmes =data.comGames;
					
					var series = [];
					var categories =[];
					for(var i=0;i<games.length;i++){
						categories.push(games[i].gameName);
						var json ={'name':games[i].gameName,'data':games[i].values[0]};
						series.push(json);
					}
					var series2 = [];
					var categories2 =[];
					for(var i=0;i<comGanmes.length;i++){
						categories2.push(comGanmes[i].gameName);
						var json ={'name':comGanmes[i].gameName,'data':comGanmes[i].values[0]};
						series2.push(json);
					}
					//this.$set(that.arcbar2, 'categories', categories);
					this.$set(that.arcbar2, 'series', series);
					//this.$set(that.arcbar22, 'categories', categories2);
					this.$set(that.arcbar22, 'series', series2);
					this.$refs['arcbar22'].showCharts();
					this.$refs['arcbar2'].showCharts(); 
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
					this.$set(that.arcbar2, 'series', series);
					//this.$set(that.arcbar22, 'categories', categories2);
					this.$set(that.arcbar22, 'series', series2);
				});
			},
			
			getServerData() {
				this.getTopData();
				this.getLinesData();
			},
			change(e) {
			      this.btnnum = e
			      console.log(this.btnnum)
				  this.refresh();
			},
			changeArcbar(e){
				this.arcbarNum = e
				console.log(this.arcbarNum)
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
			this.showView();
		},
		watch: {
			'$route':'showView'
		},
		created() {
			this.param = this.model;
			//ajax调用
			this.returnFromDatePicker();
			this.getServerData();
			this.showView();
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
	.box-contaniner{
		width: 100%;
	}
	.box-contaniner1{
		width: 100%;
		margin: 10px 10px 10px 10px;
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
</style>
