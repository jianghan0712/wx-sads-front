<template>
	<view>
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
			<view class="end-cont" :class="{dis:btnnum == 0}">		
				<line-chart ref="lineData2" canvasId="index_line_2" :dataAs="lineData2" 
							:xAxisAs="{scrollShow:false}" 
							:yAxisAs="{formatter: {type: 'number', name:'百万元',fixed: 0}}"/>
			</view>
			<view class="end-cont" :class="{dis:btnnum == 1}">		　
				<line-chart ref="lineData1" canvasId="index_line_1" :dataAs="lineData1" 	
							:xAxisAs="{scrollShow:false}" 
							:yAxisAs="{formatter: {type: 'number', name:'万张',fixed: 0}}"/>
			</view>		
		</view>
		
		<!-- 圆环图区域 -->
		<view class="box-contaniner">
			<view class="clineChart-title">
				<view style="font-size: 30rpx;font-weight: bold;">竞彩足篮球销量及占比</view>
				<view class="arcbarChart-tab">
					<view @tap="changeArcbar(0)" :class="arcbarNum == 0?'btna':'hide'" >足球</view>
					<view @tap="changeArcbar(1)" :class="arcbarNum == 1?'btna':'hide'" >篮球</view>
				</view>
			</view>	
			<view class="end-cont" :class="{dis:arcbarNum == 0}" >
				<view class="arcbarChart-content">
					<view class="arcbar" style="width: 50%;">
						<arcbar-chart :canvasId="`index_arcbar_0`" :ref="`arcbar0`" :dataAs="arcbar0" :basicAs="{colors: ['#ff7600']}"/>
					</view>
					<view class="arcbar-text" style="width: 50%;">
						<dataContainerTwo  ref="dataContain2" :dataAs="footballData"></dataContainerTwo>
					</view>
				</view>
			</view>
			<view class="end-cont" :class="{dis:arcbarNum == 1}">		　						 
				<view class="arcbarChart-content">
					<view class="arcbar" style="width: 50%;">
						<arcbar-chart :canvasId="`index_arcbar_1`" :ref="`arcbar1`" :dataAs="arcbar1" :basicAs="{colors: ['#ff7600']}"/>
					</view>
					<view class="arcbar-text" style="width: 50%;">
						<dataContainerTwo  ref="dataContain3" :dataAs="basketballData"></dataContainerTwo>
					</view>
				</view>
			</view>				
		</view>		
		
		<!-- 门店在售情况-->
		<view class="box-contaniner">
			<view class="shop-title">门店在售情况</view>
			<view class="shop-item-title">
				<view style="width: 400rpx;">在售门店数</view>				
				<view style="width: 200rpx;">同比</view>
				<view style="-webkit-flex: 1;flex: 1;">环比</view>
			</view>
			<view class="shop-item-content">
				<view style="width: 400rpx;">365,041</view>				
				<view style="width: 200rpx;">+12.9%</view>
				<view style="-webkit-flex: 1;flex: 1;">+1.23%</view>
			</view>
			<view class="shop-item-title">
				<view style="width: 400rpx;">门店在售率</view>				
				<view style="width: 200rpx;">同比</view>
				<view style="-webkit-flex: 1;flex: 1;">环比</view>
			</view>
			<view class="shop-item-content">
				<view style="width: 400rpx;">90.54%</view>				
				<view style="width: 200rpx;">+12.9%</view>
				<view style="-webkit-flex: 1;flex: 1;">+1.23%</view>
			</view>
		</view>
		
		<!-- 各地区销量排行-->
		<view class="box-contaniner">
			<view class="rankTable-title">
				<view>各地区销量排行</view>
				<view class="rankTable-more" @click="goSaleRank(showModel.area)">全部>></view>
			</view>
			<view class="example">
				<v-table :columns="tableColumns" :list="tableData" :height="250" border-color="#FFFFFF"></v-table>
			</view>
		</view>
		
		<slot />
	</view>
</template>

<script>
	import LineChart from '@/components/basic-chart/LineChart.vue';
	import ArcbarChart from '@/components/basic-chart/ArcbarChart.vue';
	import vTable from "@/components/table/table.vue";
	import {globalRequest} from "@/common/request.js";
	import dataContainer from '@/components/sads-components/dataContainer.vue';
	import dataContainerTwo from '@/components/sads-components/dataContainerTwo.vue';
	import urlAPI from '@/common/vmeitime-http/';
	import numberFun from '@/common/tools/number.js';
	
	export default {
		name: 'Index',
		components: {
			LineChart,
			ArcbarChart,
			vTable,
			dataContainer,
			dataContainerTwo
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
				showModel:{},
				totalData:{},	
				footballData:{
					// big1:{name:'销量',value:'1.26亿元', left:{name:'周同比',value:-0.6209},right:{name:'环比',value:0.0145}},
					// big2:{name:'占比',value:0.63, left:{name:'周同比',value:-0.0132},right:{name:'环比',value:0.1069}},
				},	
				basketballData:{
					big1:{name:'销量',value:'9.01百万元', left:{name:'周同比',value:-0.5275},right:{name:'环比',value:-0.61}},
					big2:{name:'占比',value:0.27, left:{name:'周同比',value:0.2306},right:{name:'环比',value:0.5746}},
				},	
				btnnum: 0,
				arcbarNum: 0,
				lineData2: {},
				lineData1: {},
				arcbar0: {					
						series: [{name: '足球',data: 0.6921}]
				},
				arcbar1: {
						series: [{name: '篮球',data: 0.3079}]
				},
				tableData: [{
							id: "1",
							area: "北京市",
							amount: "10233.5",
							tongbi: "+12.6%",
							huanbi: "+45.21%"
						},
						{
							id: "2",
							area: "上海市",
							amount: "9965.5",
							tongbi: "+12.6%",
							huanbi: "+45.21%"
						},
						{
							id: "3",
							area: "广东省",
							amount: "9754.5",
							tongbi: "+12.6%",
							huanbi: "+45.21%"
						},
						{
							id: "4",
							area: "重庆市",
							amount: "6745.6",
							tongbi: "+12.6%",
							huanbi: "+45.21%"
						},
						{
							id: "5",
							area: "河北省",
							amount: "6554",
							tongbi: "+12.6%",
							huanbi: "+45.21%"
						}
					],
				tableColumns: [{
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
							$width:"80px"
						},
						{
							title: '同比',
							key: 'tongbi',
							$width:"80px"
						},
						{
							title: '环比',
							key: 'huanbi'
						}
					],					
			};
		},
		onLoad() {
			_self = this;
			this.cWidth=uni.upx2px(750);
			this.cHeight=uni.upx2px(500);
			this.getServerData();
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
					console.log("init dataContain:" ,this.totalData);
				});
			},
			// 获取最上层的两个tab
			getDataSet(){
				var url = 'mobile/sales/getSalesToday/1/2020-10-11';
				
				urlAPI.getRequest(url, null).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					uni.showToast({
						title: '请求成功',
						icon: 'success',
						mask: true
					});
					var data = res.data.concreteBean;
					var format0 = numberFun.formatCNumber(data[0]);
					var format1 = numberFun.formatCNumber(data[1]);
					
					var left1 = {'name':'周同比','value':'-71.98%'};
					var right1 = {'name':'环比','value':'-31.11%'};
					var big1 = {'name':'销量（'+format0.name +'元）', 'value':data[0]/format0.value, 'left': left1,'right':right1};
					var big2 = {'name':'票数（'+format1.name +'张）','value':data[1]/format1.value, 'left':{'name':'周同比','value':'-70.56%'},'right':{'name':'环比','value':'-28.88%'}};
				
					this.$set(this.totalData, 'big1', big1);
					this.$set(this.totalData, 'big2', big2);
					console.log('request totalData', this.totalData);
					
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			getLinesData(){
				var url = 'mobile/sales/getSalesTodayByHour/1/2020-10-11';
				urlAPI.getRequest(url, null).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					uni.showToast({
						title: '请求成功',
						icon: 'success',
						mask: true
					});
					var data = res.data.concreteBean;					
					var categories=[];
					var series=[];
					var amountData = [];
					var volData = [];
					var j=0,k = 0,tempAmount=0,tempVol=0;
					
					for(var i=0;i<data.length;i++){	
						if(j==3){
							categories[k] = data[i][0];
							amountData[k] = data[i][1]/1000000;
							volData[k] = data[i][2]/10000;
							k++;
							j=0;
						}else{
							tempAmount = tempAmount+data[i][1]/1000000;
							tempVol = tempVol+data[i][2]/10000;
							j=j+1;
						}
					}
					console.log('categories:', categories);
					console.log('amountData:', amountData);
					console.log('volData:', volData);
					
					var json = {'name':'销量','data':amountData};
					var series = [];
					series[0] = json;				
					this.$set(this.lineData2, 'categories', categories);
					this.$set(this.lineData2, 'series', series);
					
					var json2 = {'name':'销量','data':volData};
					var series2 = [];
					series2[0] = json2;
					this.$set(this.lineData1, 'categories', categories);
					this.$set(this.lineData1, 'series', series2);
					
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			},
			getFootballGame(){
				var url = '/exhibition/gameSales/queryGameSalesOfFb/2020-10-11/1/1';
				urlAPI.getRequest(url, null).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					uni.showToast({
						title: '请求成功',
						icon: 'success',
						mask: true
					});
					var data = res.data.concreteBean;
					var format0 = numberFun.formatCNumber(data[0]);
					var format1 = numberFun.formatCNumber(data[1]);
					
					var amount = data[0]/format0.value + format0.name +'元';
					
					var left1 = {'name':'周同比','value':(data[0]/data[1]-1).toFixed(4)};
					var right1 = {'name':'环比','value':-0.3111};
					var big1 = {'name':'销量', 'value':amount, 'left': left1,'right':right1};
					var big2 = {'name':'占比','value':0.63, 'left':{'name':'周同比','value':-0.0132},'right':{'name':'环比','value':0.1069}};
					this.$set(this.footballData, 'big1', big1);
					this.$set(this.footballData, 'big2', big2);
					console.log('request footballData', this.footballData);
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			},
			getServerData() {
				this.getDataSet();
				this.getLinesData();
				this.getFootballGame();
			},
			change(e) {
			      this.btnnum = e
			      console.log(this.btnnum)
			},
			changeArcbar(e){
				this.arcbarNum = e
				console.log(this.arcbarNum)
			},
			goSaleRank(area){
				console.log(area)
				uni.navigateTo({
					url:"/pages/common/tableDetail?area="+area
				});
			}
		},
		created() {
			this.showModel = this.model;
			//ajax调用
			this.getServerData();
			
			// this.$nextTick(() => {
				
			// 	//柱状图
			// 	// this.$refs['histogramData0'].showCharts();
			// 	// this.$refs['histogramData1'].showCharts();
			// 	// this.$refs['histogramData2'].showCharts();
			// 	// //圆环(注意循环可能会导致出现下面情况,请更具实际情况作出判断// console.log(this.$refs);)
			// 	this.$refs['arcbar0'].showCharts();
			// 	this.$refs['arcbar1'].showCharts();
			// 	// this.$refs['arcbar2'][0].showCharts();
			// 	// // 饼状图
			// 	// this.$refs['pieChart0'].showCharts();
			// 	// // 环状图
			// 	// this.$refs['ringChart0'].showCharts();
			// 	//折线图
			// 	this.$refs['lineData2'].showCharts();
			// 	this.$refs['lineData1'].showCharts();
			// 	this.$refs['dataContain'].showDataContainer();
			// 	this.$refs['dataContain2'].showDataContainer();
			// 	this.$refs['dataContain3'].showDataContainer();
			// 	console.log("init dataContain:" ,this.totalData);
			// });
			
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
		margin: 0rpx 5rpx 0rpx 5rpx;
		/* padding: 0 10rpx 0 10rpx; */
		flex-direction: row;
		background-color: #ebebeb;
	}
	.shop-item-content{
		width: 100%;
		display: flex;
		margin: 0rpx 5rpx 0rpx 5rpx;
		/* padding: 0 10rpx 20rpx 10rpx; */
		flex-direction: row;
		background-color: #ebebeb;
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
		margin: 20rpx 10rpx 40rpx 10rpx;
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
</style>
