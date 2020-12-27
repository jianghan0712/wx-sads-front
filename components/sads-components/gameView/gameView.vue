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
				<area-chart ref="lineData1" canvasId="lineData1" :dataAs="lineData1" />
			</view>	

			<view >
				<view class="clineChart-title">
					<view style="font-size: 30rpx;font-weight: bold;">{{arcbarNumTop}}游戏销量占比</view>
				</view>		
				<ring-chart canvasId="arcbar1" ref="arcbar1" :dataAs="arcbar1" />				
			</view>	
			<view style="text-align: center;">
				<button  @click="toRingAll()">查看全部</button>
			</view>
			
			<view >
				<view class="container-title">
					<view>各地区{{arcbarNumTop}}销量及占比</view>
					<view style="width: 200;height: 50upx;text-align: top;font-size: 30rpx;" @click="toAll()">全部>></view>
				</view>
				<view class="table">
					<v-table :columns="tableColumns" :list="tableData"  border-color="#FFFFFF"></v-table>
				</view>
			</view>
			
			<block v-if="selfParam.businessDate.view!=today">
				<view >
					<view class="container-title">
						<view>各地区{{arcbarNumTop}}返奖情况</view>
						<view style="width: 200;height: 50upx;text-align: top;font-size: 30rpx;" @click="toAll1()">全部>></view>
					</view>
					<view class="table">
						<v-table :columns="tableColumns1" :list="tableData1"  border-color="#FFFFFF"></v-table>
					</view>
				</view>
			</block>
		</view>		
	</view>
</template>

<script>
	import LineChart from '@/components/basic-chart/LineChart.vue';
	import PieChart from '@/components/basic-chart/PieChart.vue';
	import RingChart from '@/components/basic-chart/RingChart.vue';
	import AreaChart from '@/components/basic-chart/AreaChart.vue';
	import dataContainer from '@/components/sads-components/dataContainer.vue';
	import vTable from "@/components/table/table.vue";
	import urlAPI from '@/common/vmeitime-http/';
	import dateUtils from '@/common/tools/dateUtils.js';
	import numberFun from '@/common/tools/number.js';
	
	export default {
			components:{
				LineChart,
				PieChart,
				RingChart,
				dataContainer,vTable,AreaChart
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
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				this.returnFromDatePicker();
				this.loadData();
				this.refresh();
			},
			onShow() {
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				this.returnFromDatePicker();
				this.loadData();
				this.refresh();
			},
			data() {
				return {
					today:dateUtils.getToday(),
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
						big1:{name:'足球销量（百万元）',value:0, left:{name:'周同比',value:0.00},right:{name:'环比',value:0.00}},
						big2:{name:'足球票数（万张）',value:0, left:{name:'周同比',value:0.00},right:{name:'环比',value:0.00}},
					},	
					basketballData:{
						big1:{name:'篮球销量（万元）',value:0, left:{name:'周同比',value:0.00},right:{name:'环比',value:0.00}},
						big2:{name:'篮球票数（张）',value:0, left:{name:'周同比',value:0.00},right:{name:'环比',value:0.00}},
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
					lineData1: {
						//数字的图--折线图数据
						categories: [],
						series: []
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
					tableData: [],
					tableDataAll:[],
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
								$width:"80px"
							},
							{
								title: '销量（元）',
								key: 'count',
							}
						],	
						tableData1: [],
						tableDataAll1:[],
						tableColumns1: [{
									title: "排名",
									key: "id",
									$width:"50px",
								},
								{
									title: '省份',
									key: 'area',
									$width:"80px"
								},
								{
									title: '返奖率',
									key: 'returnRate',
									$width:"100px"
								},
								{
									title: '周同比',
									key: 'tongbi',
									$width:"80px"
								},
								{
									title: '环比',
									key: 'huanbi',
									$width:"80px"
								}
							],	
				};
			},
			methods: {
				refresh() {
					this.returnFromDatePicker();
					this.loadData(this.ballType);
					this.loadData(this.ballType);
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
					this.refresh();
					
				},
				changeMid(e){
					this.arcbarNumMid = e;
					this.refresh();
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
							var format0 = numberFun.formatCNumber(fb[0]); 
							let index0={
								name:'销量（' + format0.name + '元）',
								value:(fb[0]/format0.value).toFixed(2),
								left:{
									name:'周同比',
									value:fb[1]+"%"
								},
								right:{
									name:'环比',
									value:fb[2]+"%"
								}}
							this.$set(that.totalData,'big1',index0);
							var format1 = numberFun.formatCNumber(fb[3]); 
							let index1={
								name:'票数（ ' + format1.name + '张）',
								value:(fb[3]/format1.value).toFixed(2),
								left:{
									name:'周同比',
									value:fb[4]+"%"
								},
								right:{
									name:'环比',
									value:fb[5]+"%"
								}}
							this.$set(that.totalData,'big2',index1);
						}else{
							var format0 = numberFun.formatCNumber(bk[0]);
							let index0={
								name:'销量（'+format0.name + '元）',
								value:(bk[0]/format0.value).toFixed(2),
								left:{
									name:'周同比',
									value:bk[1]+"%"
								},
								right:{
									name:'环比',
									value:bk[2]+"%"
								}}
							this.$set(that.totalData,'big1',index0);
							var format1 = numberFun.formatCNumber(bk[3]);
							let index1={
								name:'票数（'+format1.name + ' 张）',
								value:(bk[3]/format1.value).toFixed(2),
								left:{
									name:'周同比',
									value:bk[4]+"%"
								},
								right:{
									name:'环比',
									value:bk[5]+"%"
								}}
							this.$set(that.totalData,'big2',index1);
						}
						this.$refs['dataContain'].showDataContainer();
						
					}).catch((err)=>{
						//this.loading = false;
						this.totalData=this.footballData;
						console.log('request fail', err);
						let index0={
								name:'销量（百万元）',
								value:0,
								left:{
									name:'周同比',
									value:0
								},
								right:{
									name:'环比',
									value:0
								}}
						this.$set(that.totalData,'big1',index0);
						let index1={
							name:'票数（万张）',
							value:0,
							left:{
								name:'周同比',
								value:0
							},
							right:{
								name:'环比',
								value:0
							}}
						this.$set(that.totalData,'big2',index1);
						this.$refs['dataContain'].showDataContainer()
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
					this.selfParam.token=getApp().globalData.token
					uni.setStorageSync("selfParam",JSON.stringify(this.selfParam))	
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
						  
						  for(var i=0;i<sales.length;i++){
						   sales[i] =(sales[i]/amountFormat.value).toFixed(2);;
						   votes[i] = (votes[i]/voteFormat.value).toFixed(2);
						  }
						
						if(that2.arcbarNumMid=='销量'){
							var series=[{
								name: '销量（'+amountFormat.name+'元）', 
								data: sales
							}];
							 that2.$set(that2.lineData1,'series',series);
						}else {
							var series=[{name: '票数('+voteFormat.name+'张)',
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
						if(data==null || data.length==0){
							return 
						}
						that.tableData=[]
						that.tableDataAll=[]
						var format0 = numberFun.formatCNumber(data[0][2]); 
						for(var i=0;i<data.length;i++){
							var obj={id:i+1,area:data[i][0],zhanbi:data[i][1]+"%",count:(data[i][2]/format0.value).toFixed(2)};
							if(i<5){
								that.tableData[i] = obj;
							}
							that.tableDataAll[i] = obj;		
						}
						this.tableColumns=[{
									title: "排名",
									key: "id",
									$width:"90px",
								},
								{
									title: '省份',
									key: 'area',
									$width:"100px"
								},
								{
									title: '占比',
									key: 'zhanbi',
									$width:"100px"
								},
								{
									title: '销量（' + format0.name + '元）',
									key: 'count',
								}
							]
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					}); 
					console.log("today=",this.today,"selfparam=",this.selfParam)
					if(that.selfParam.businessDate.view!=this.today){
						var url = '/pentaho/sales/gamesReturnRateRankingList';
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
							if(data==null){
								return
							}
							that.tableData1=[]
							that.tableDataAll1=[]
							for(var i=0;i<data.length;i++){
								var cellClassName={};
								if(data[i][2]<0){
									cellClassName.tongbi='small-text-green'
								}else{
									cellClassName.tongbi='small-text-red'
								}
								if(data[i][3]<0){
									cellClassName.huanbi='small-text-green'
								}else{
									cellClassName.huanbi='small-text-red'
								}
								var obj={id:i+1,
										area:data[i][0],
										returnRate:data[i][1]+"%",
										tongbi:data[i][2]>0?"+"+data[i][2]+"%":data[i][2]+"%",
										huanbi:data[i][3]>0?"+"+data[i][3]+"%":data[i][3]+"%"};								
								obj.cellClassName=cellClassName;	
								if(i<5){
									that.tableData1[i] = obj;
								}
								that.tableDataAll1[i] = obj;							
							}
							
						}).catch((err)=>{
							this.loading = false;
							console.log('request fail', err);
						}); 
					}

				},
				toRingAll() {
					uni.navigateTo({
						url:"/pages/common/ringDetail?data=" + JSON.stringify(this.arcbar1)
					});
				},
				toAll(){
					var that =this;
					uni.navigateTo({
						url:'/pages/common/tableDetail?tableColumns='+JSON.stringify(that.tableColumns)+'&tableData='+JSON.stringify(that.tableDataAll),
						
						
					});
				},
				toAll1(){
					var that =this;
					uni.navigateTo({
						url:'/pages/common/tableDetail?tableColumns='+JSON.stringify(that.tableColumns1)+'&tableData='+JSON.stringify(that.tableDataAll1),
						
						
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
	.table {
		/* line-height: 40px; */
		/* font-weight: bold; */
		display: flex;
		border-color:#FFFFFF;
	}
	
	button {
		width: 75%;
	    margin-top: 30rpx;
	    margin-bottom: 30rpx;
		font-size: 30rpx;
		background-color: rgba(220, 241, 250,0.5);
		color: #007AFF;
	}
	
	
</style>