<template>
	<view >
		<view class = "box-container">
			<view class="arcbarChart-tab">
			    <view @tap="changeTop('足球')" :class="arcbarNumTop =='足球'?'btna':'hide'" style="width: 50%;" >足球</view>
			    <view @tap="changeTop('篮球')" :class="arcbarNumTop =='篮球'?'btna':'hide'" style="width: 50%;" >篮球</view>
			</view>
			
			<dataContainer ref="dataContain" :dataAs="totalData"></dataContainer>

			<view >
				<view class="clineChart-title">
					<view style="font-size: 30rpx;font-weight: bold;">{{arcbarNumTop}}销量及票数走势</view>
					<view class="linechart-tab">
					　　<view @tap="changeMid('销量')" :class="arcbarNumMid =='销量'?'btna':'hide'" >销量</view>
						<view @tap="changeMid('票数')" :class="arcbarNumMid =='票数'?'btna':'hide'" >票数</view>
					</view>
				</view>		
				<line-chart ref="lineData1" canvasId="lineData1" :dataAs="lineData1" />
			</view>	

			<view >
				<view class="clineChart-title">
					<view style="font-size: 30rpx;font-weight: bold;">{{arcbarNumTop}}游戏销量占比</view>
				</view>		
				<ring-chart canvasId="arcbar1" ref="arcbar1" :dataAs="arcbar1" />				
			</view>	
			<view>
				<gamebottom></gamebottom>
			</view>
			
			<view >
				<view class="container-title">
					<view>各地区{{arcbarNumTop}}销量及占比</view>
					<view><button style="width: 200;height: 50upx;text-align: top;font-size: 10rpx;" @click="toAll()">全部>></button></view>
				</view>
				<view class="table">
					<v-table :columns="tableColumns" :list="tableData"  border-color="#FFFFFF"></v-table>
				</view>
			</view>
		</view>		
	</view>
</template>

<script>
	import LineChart from '@/components/basic-chart/LineChart.vue';
	import PieChart from '@/components/basic-chart/PieChart.vue';
	import RingChart from '@/components/basic-chart/RingChart.vue';
	import gamebottom from './gameViewBottom.vue';
	import dataContainer from '@/components/sads-components/dataContainer.vue';
	import vTable from "@/components/table/table.vue";
	import urlAPI from '@/common/vmeitime-http/';
	
	export default {
			components:{
				LineChart,
				PieChart,
				RingChart,
				gamebottom,dataContainer,vTable
			},
			props: {
				param:{
					//数据
					type: Object,
					default: () => ({})
				}
			},
			created() {
				// this.showModel = this.model;
				this.showModel = JSON.parse(uni.getStorageSync("selfParam"))
				console.log(this.showModel)
				if(this.arcbarNumTop=='足球'){
					this.totalData = this.footballData;
				}else{
					this.totalData = this.basketballData;
				}
				this.returnFromDatePicker();
				this.$nextTick(()=>{
					this.loadData();
				});
				setTimeout(() => {
					this.loadData();
					this.changeTop("足球")
				}, 1);
			},
			onShow() {
				this.returnFromDatePicker();
				this.loadData();
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
					totalData:{
						big1:{},
						big2:{}
					},
					dataCompare:{},
					dataCount:{},
					footballData:{
						big1:{name:'足球销量（百万元）',value:37.82, left:{name:'周同比',value:-0.6209},right:{name:'环比',value:0.0145}},
						big2:{name:'足球票数（万张）',value:45.64, left:{name:'周同比',value:-0.0132},right:{name:'环比',value:0.1069}},
					},	
					basketballData:{
						big1:{name:'篮球销量（万元）',value:36.94, left:{name:'周同比',value:-0.5275},right:{name:'环比',value:-0.61}},
						big2:{name:'篮球票数（张）',value:4818.00, left:{name:'周同比',value:0.2306},right:{name:'环比',value:-0.9523}},
					},
					arcbarNumTop: '足球',
					arcbarNumMid: '销量',
					btnnumTop:'足球',
					province:'',
					city:'',
					rowList: [
						{
							name: '刘晓晓',
							mobile: '18666666666',
							addressName: '贵族皇仕牛排(东城店)',
							address: '北京市东城区',
							area: 'B区',
							default: true
						},
						{
							name: '刘大大',
							mobile: '18667766666',
							addressName: '龙回1区12号楼',
							address: '山东省济南市历城区',
							area: '西单元302',
							default: false
						}
					],
					showTips: false,
					navigateFlag: false,
					pulling: false,
					refreshIcon: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAB5QTFRFcHBw3Nzct7e39vb2ycnJioqK7e3tpqam29vb////D8oK7wAAAAp0Uk5T////////////ALLMLM8AAABxSURBVHja7JVBDoAgDASrjqj//7CJBi90iyYeOHTPMwmFZrHjYyyFYYUy1bwUZqtJIYVxhf1a6u0R7iUvWsCcrEtwJHp8MwMdvh2amHduiZD3rpWId9+BgPd7Cc2LIkPyqvlQvKxKBJ//Qwq/CacAAwDUv0a0YuKhzgAAAABJRU5ErkJggg==",
					showPicker: false,
					date: '2019/01/01',
					time: '15:00:12',
					datetime: '2019/01/01 15:00:12',
					range: ['2019/01/01','2019/01/06'],
					rangetime: ['2019/01/08 14:00','2019/01/16 13:59'],
					type: 'rangetime',
					value: '',
					lineData1: {
						//数字的图--折线图数据
						categories: ['2012', '2013', '2014', '2015', '2016', '2017'],
						series: [
							{ name: '成交量A', data: [35, 8, 25, 37, 4, 20] },
							{ name: '成交量B', data: [70, 40, 65, 100, 44, 68] }
						]
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
					tableData: [/* {
								id: "1",
								area: "北京市",
								jingcai: "10233.5",
								football: "146784.00",
								basketball: "29785.00"
							},
							{
								id: "2",
								area: "上海市",
								jingcai: "9965.5",
								football: "100054.00",
								basketball: "3785.00"
							},
							{
								id: "3",
								area: "广东省",
								jingcai: "9754.5",
								football: "9785.00",
								basketball: "6585.00"
							},
							{
								id: "4",
								area: "重庆市",
								jingcai: "6745.6",
								football: "9685.00",
								basketball: "9725.00"
							},
							{
								id: "5",
								area: "河北省",
								jingcai: "6554",
								football: "8785.00",
								basketball: "19785.00"
							} */
						],
					tableColumns: [{
								title: "排名",
								key: "id",
								$width:"90px",
							},
							{
								title: '省份',
								key: 'area',
								$width:"90px"
							},
							{
								title: '占比',
								key: 'zhanbi',
								$width:"100px"
							},
							{
								title: '销量（元）',
								key: 'count',
								$width:"80px"
							}
						],	
				};
			},
			onShow() {
				this.returnFromDatePicker();
				this.loadData();
			},
			methods: {
				refresh() {
					this.returnFromDatePicker();
					this.loadData();
				},
				createParam(){
					console.log("createParam begin")
					var dateType = this.selfParam.businessDate.dateType
					var param = {}
					if(dateType=='date'){
						param = {dateTimeStart: this.selfParam.businessDate.date.startDate,
								 dateTimeEnd: this.selfParam.businessDate.date.endDate,
								 dateFlag:"1",
								 regionId:this.selfParam.provinceCenterId,
								 token:this.selfParam.token }
					}else if(dateType=='week'){
						param = {dateTimeStart: this.selfParam.businessDate.week.startDate,
								 dateTimeEnd: this.selfParam.businessDate.week.endDate,
								 dateFlag:"2",
								 regionId:this.selfParam.provinceCenterId,
								 token:this.selfParam.token }
					}else if(dateType=='month'){
						param = {dateTimeStart: this.selfParam.businessDate.month.startDate,
								 dateTimeEnd: this.selfParam.businessDate.month.endDate,
								 dateFlag:"3",
								 regionId:this.selfParam.provinceCenterId,
								 token:this.selfParam.token }
					}else if(dateType=='year'){
						param = {dateTimeStart: this.selfParam.businessDate.year.startDate,
								 dateTimeEnd: this.selfParam.businessDate.year.endDate,
								 dateFlag:"4",
								 regionId:this.selfParam.provinceCenterId,
								 token:this.selfParam.token }
					}
					console.log("createParam end:",param)
					return param
				},
				changeTop(e){
					this.arcbarNumTop = e;;
					getApp().globalData.ballType=e; 
					
					this.loadData();
					
				},
				changeMid(e){
					this.arcbarNumMid = e;
					this.loadData();
				},
				loadTopData(ballType){
					var url = '/pentaho/sales/getGameSalesAndVotes';
					var that=this;
					var param =this.createParam();
					urlAPI.getRequest(url, param).then((res)=>{
						var alldata=res.data.data;
						var bk=alldata.bk;
						var fb= alldata.fb;
						if(ballType=='足球'){
							let index0={
								name:ballType+'销量（万元）',
								value:fb[0],
								left:{
									name:'周同比',
									value:fb[1]
								},
								right:{
									name:'环比',
									value:fb[2]
								}}
							this.$set(that.totalData,'big1',index0);
							let index1={
								name:ballType+'票数（万张）',
								value:fb[3],
								left:{
									name:'周同比',
									value:fb[4]
								},
								right:{
									name:'环比',
									value:fb[5]
								}}
							this.$set(that.totalData,'big2',index1);
						}else{
							let index0={
								name:ballType+'销量（百万元）',
								value:bk[0],
								left:{
									name:'周同比',
									value:bk[1]
								},
								right:{
									name:'环比',
									value:bk[2]
								}}
							this.$set(that.totalData,'big1',index0);
							let index1={
								name:ballType+'票数（万张）',
								value:bk[3],
								left:{
									name:'周同比',
									value:bk[4]
								},
								right:{
									name:'环比',
									value:bk[5]
								}}
							this.$set(that.totalData,'big2',index1);
						}
						this.$refs['dataContain'].showDataContainer();
						
					}).catch((err)=>{
						//this.loading = false;
						this.totalData=this.footballData;
						console.log('request fail', err);
					});
					
				},
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
				loadMidData(ballType){
					var url = '/pentaho/sales/getGameTrendChart';
					var param  =this.createParam();
					var that2 =this;
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var dates;
						var sales;
						var votes;
						if(ballType=='足球'){
							dates=res.data.data.fb.dates;
							sales =res.data.data.fb.sales;
							votes = res.data.data.fb.votes;
						}else {
							dates=res.data.data.bk.dates;
							sales =res.data.data.bk.sales;
							votes = res.data.data.bk.votes;
						}
						
						if(that2.arcbarNumMid=='销量'){
							var series=[{
								name: '销量（万元）', 
								data: sales
							}];
							that2.$set(that2.lineData1,'series',series);
							
						}else {
							 var series=[{name: '票数(万张)',
							 data: votes
							 }];
							 that2.$set(that2.lineData1,'series',series);
						}
						that2.$set(that2.lineData1,'categories',dates);
						
						that2.$refs['lineData1'].showCharts();
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					
					url = '/pentaho/sales/getGameSalesProp';
					var gameFlag;
					if(ballType=='足球'){
						gameFlag='1';
					}else {
						gameFlag='2';
					}
					param =this.createParam();
					this.$set(param,'gameFlag',gameFlag);
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var datas =res.data.data;
						var series =[];
						for(var i=0;i<datas.length;i++){
							var obj={name:datas[i].gameName,data: parseInt(datas[i].values[0])};
							series.push(obj);
							
						}
						that2.$set(that2.arcbar1,'series',series);
						that2.$refs['arcbar1'].showCharts();
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					
				},
				loadData(){
					var ballType = getApp().globalData.ballType;
					this.loadTopData(ballType);
					this.loadMidData(ballType);
					this.loadLastData();
					
				},
				loadLastData(){
					var url = '/pentaho/sales/getGameSalesRankingList';
					var that =this;
					var ballType =getApp().globalData.ballType;
					var gameFlag;
					if(ballType=='足球'){
						gameFlag='1';
					}else {
						gameFlag='2';
					}
					var param =this.createParam();
					this.$set(param,'gameFlag',gameFlag);
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						var data =res.data.data;	
						
						for(var i=0;i<data.length;i++){
							var obj={id:i+1,area:data[i][0],zhanbi:data[i][1],count:data[i][2]};
							that.tableData.push(obj);
						}
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					}); 
				},
				toAll(){
					var that =this;
					uni.navigateTo({
						url:'/pages/common/tableDetail?tableColumns='+JSON.stringify(that.tableColumns)+'&tableData='+JSON.stringify(that.tableData),
						
						
					});
				}
			}
		}
</script>

<style>
	page {
	    width: 100%;
	    min-height: 100%;
	    display: flex;
		background-color: #FFFFFF;
	}
	
	.tabs {
	    flex: 1;
		width: 100%;
	    flex-direction: column;
	    overflow: hidden;
	    background-color: #ffffff;
	    height: 100vh;
	}
	.clineChart-title{
		display: flex;
		justify-content:space-between;
	}
	.linechart-tab{
		padding:0rpx 5rpx 0rpx 5rpx;
		flex-direction: row;
		display: flex;
		text-align: right;
		justify-content:flex-end;
		font-size: 30rpx;
	}
	.scroll-h {
	    width: 100%;
	    height: 100rpx;
	    flex-direction: row;
	    white-space: nowrap;
	    flex-wrap: nowrap;
	    border-color: #cccccc;
		border-bottom-style: solid;
		border-bottom-width: 1px;
	}
	
	.line-h {
	    height: 1rpx;
	    background-color: #cccccc;
	}
	
	.uni-tab-item {
	    display: inline-block;
	    flex-wrap: nowrap;
		width: 50%;
	}
	
	.uni-tab-item-title {
	    color: #555;
	    font-size: 40rpx;
		width: 100%;
	    height: 100rpx;
	    line-height: 80rpx;
		padding-left: 130rpx;
	    flex-wrap: nowrap;
	    white-space: nowrap;
	}
	
	.uni-tab-item-title-active {
	    color: #007AFF;
	}
	
	.swiper-box {
	    flex: 1;
	}
	
	.swiper-item {
	    flex: 1;
	    flex-direction: row;
	}
	
	.scroll-v {
	    flex: 1;
	    flex-direction: column;
	    width: 750rpx;
	}
	
	.update-tips {
	    position: absolute;
	    left: 0;
	    top: 41px;
	    right: 0;
	    padding-top: 5px;
	    padding-bottom: 5px;
	    background-color: #FDDD9B;
	    align-items: center;
	    justify-content: center;
	    text-align: center;
	}
	
	.update-tips-text {
	    font-size: 14px;
	    color: #ffffff;
	}
	
	.refresh {
	    width: 750rpx;
	    height: 64px;
	    justify-content: center;
	}
	
	.refresh-view {
	    flex-direction: row;
	    flex-wrap: nowrap;
	    align-items: center;
	    justify-content: center;
	}
	
	.refresh-icon {
		width: 30px;
		height: 30px;
		transition-duration: .5s;
		transition-property: transform;
		transform: rotate(0deg);
		transform-origin: 15px 15px;
	}
	
	.refresh-icon-active {
		transform: rotate(180deg);
	}
	
	.loading-icon {
		width: 20px;
		height: 20px;
		margin-right: 5px;
		color: #999999;
	}
	
	.loading-text {
	    margin-left: 2px;
	    font-size: 16px;
	    color: #999999;
	}
	
	.loading-more {
	    align-items: center;
	    justify-content: center;
	    padding-top: 10px;
	    padding-bottom: 10px;
	    text-align: center;
	}
	
	.loading-more-text {
	    font-size: 28rpx;
	    color: #999;
	}
	
	.btna{
		color: #000000;
		background: #ebebeb;
		padding:0px 30rpx 0px 30rpx;
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
	},
	/* 将三个内容view的display设置为none(隐藏) */
	.arcbarChart-tab{
		/* padding:0rpx 5rpx 0rpx 5rpx; */
		flex-direction: row;
		display: flex;
		justify-content:center;
		font-size: 45rpx;
		font-family: 'Courier New', Courier, monospace;
	},
	.end-cont{
		/* text-align: left; */
		display: none;
		/* padding:0rpx 15rpx 0rpx 15rpx; */
		background: #FFFFFF;
	},
	.row_box_2{
		display: flex;
		flex-direction: row;		
	}
	
	.column_box_2{	
		display: flex;
		flex-direction: column;
	}
	
	.row-box {
		width: 50%;
		margin: 0rpx 5rpx;
		padding: 0 10rpx;
		background-color: #ebebeb;
	}
	
	.column-box{
		height: 50%;
		margin: 0rpx 5rpx;
		padding: 0 5rpx;
		background-color: #ebebeb;
	}
	
	.big-text{
		text-align: left;
		background-color: #ebebeb;
		color: #777;
		font-size: 40rpx;
	}
	
	.small-text{
		text-align: left;
		background-color: #ebebeb;
		color: #777;
		font-size: 30rpx;
		margin-left: 0rpx;
	}
	
	.qiun-charts {
		width: 750upx;
		height: 500upx;
		background-color: #FFFFFF;
	}
	
	.charts {
		width: 750upx;
		height: 500upx;
		background-color: #FFFFFF;
	}
	
	.box-contaniner{
		width: 100%;
		margin: 20rpx 10rpx 40rpx 10rpx;
	}
	
	.container-title{
		display: flex;
		width: 100%;
		margin: 0rpx 5rpx;
		padding: 0 10rpx;
		font-size: 30rpx;
		font-weight: bold;
		justify-content: space-between;
		background-color: #FFFFFF;
	}
	
	
</style>