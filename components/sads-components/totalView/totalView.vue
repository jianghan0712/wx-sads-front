<template>
	<view>
		<view class="box-contaniner">
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
								:xAxisAs="{scrollShow:false, gridEval:(lineData2.categories.length / 4).toFixed(0)}"/>
				</view>
				<view class="end-cont" :class="{dis:btnnum == 1}">		　
					<line-chart ref="lineData1" canvasId="index_line_1" :dataAs="lineData1" 	
								:xAxisAs="{scrollShow:false, gridEval:(lineData1.categories.length / 4).toFixed(0)}" />
				</view>		
			</view>
			
			<block v-if="selfParam.provinceCenterId!=0">
				<view class="box-contaniner">
					<view class="shop-title">全国排名</view>
					<view class="line">	
						<view class="shop-item-title">
							<view style="width: 50%;">排名</view>				
							<view style="width: 25%;">周同比</view>
							<view style="-webkit-flex: 1;flex: 1;">环比</view>
						</view> 
						<view class="shop-item-content">
							<view style="width: 50%;">{{rankData.sum}} 名</view>
							<view :class="rankData.tongbi>= 0?'small-text-red':'small-text-green'" style="width: 25%;"> {{rankData.tongbi}}</view>
							<view :class="rankData.huanbi>= 0?'small-text-red':'small-text-green'" style="-webkit-flex: 1;flex: 1;">{{rankData.huanbi}}</view>
						</view>
					</view>
				</view>
			</block>
			
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
				<view class="line">			
					<view class="shop-item-title">
						<view style="width: 40%;">在售门店数</view>				
						<view style="width: 30%;">同比</view>
						<view style="width: 25%;">环比</view>
					</view>
					<view class="shop-item-content">
						<view style="width: 40%;">{{shopData.shop.sum}}</view>
						<view :class="shopData.shop.tongbi>= 0?'small-text-red':'small-text-green'" style="width: 30%;">{{shopData.shop.tongbi +"%"}}</view>
						<view :class="shopData.shop.huanbi>= 0?'small-text-red':'small-text-green'" style="width: 25%;">{{shopData.shop.huanbi +"%"}}</view>
					</view>
				</view>
			</view>
			<view class="box-contaniner">
				<view class="line">
					<view class="shop-item-title">
						<view style="width: 40%;">门店在售率</view>				
						<view style="width: 30%;">同比</view>
						<view style="width: 25%;">环比</view>
					</view>
					
					<view class="shop-item-content">
						<view style="width: 40%;">{{shopData.rate.sum +"%"}}</view>				
						<view :class="shopData.rate.tongbi>= 0?'small-text-red':'small-text-green'" style="width: 30%;">{{shopData.rate.tongbi +"%"}}</view>
						<view :class="shopData.rate.huanbi>= 0?'small-text-red':'small-text-green'" style="width: 25%;">{{shopData.rate.huanbi +"%"}}</view>
					</view>
				</view>
			</view>
			
			<!-- 各地区销量排行-->
			<view class="box-contaniner">
				<view class="rankTable-title">
					<view>各地区销量排行</view>
					<view class="rankTable-more" @click="goSaleRank(tableDataDetail,tableColumns)">全部>></view>
				</view>
				<block v-if="tableData.length==0">
					<noData :message="nodataMessage"></noData>
				</block>
				<block v-if="tableData.length>0">
					<view class="example">
						<v-table :columns="tableColumns" :list="tableData"  border-color="#FFFFFF"></v-table>
					</view>
				</block>
			</view>
			
			<block v-if="today!= selfParam.businessDate.view">
				<!-- 全国返奖情况-->
				<view class="box-contaniner">
					<view class="shop-title">{{selfParam.provinceCenterName}}返奖情况</view>
					<view class="line">
						<view class="shop-item-title">
							<view style="width: 40%; ">返奖率</view>				
							<view style="width: 30%;">同比</view>
							<view style="width: 25%;">环比</view>
						</view>
						<view class="shop-item-content">
							<view style="width: 40%;">{{returnData.rate.sum +"%"}}</view>
							<view :class="returnData.rate.tongbi>= 0?'small-text-red':'small-text-green'" style="width: 30%;">{{returnData.rate.tongbi+"%"}}</view>
							<view :class="returnData.rate.huanbi>= 0?'small-text-red':'small-text-green'" style="width: 25%;">{{returnData.rate.huanbi+"%"}}</view>
						</view>
					</view>
				</view>
				
				<!-- 各地区返奖情况-->
				<view class="box-contaniner">
					<view class="rankTable-title">
						<view>各地区返奖情况</view>
						<view class="rankTable-more" @click="goSaleRank(tableDataDetail2,tableColumns2)">全部>></view>
					</view>
					<block v-if="tableData2.length==0">
						<noData :message="nodataMessage"></noData>
					</block>
					<block v-if="tableData2.length>0">
						<view class="example">
							<v-table :columns="tableColumns2" :list="tableData2"  border-color="#FFFFFF"></v-table>
						</view>
					</block>
				</view>
			</block>
			
			
			<slot />
		</view>
	</view>
</template>

<script>
	import LineChart from '@/components/basic-chart/LineChart.vue';
	import ArcbarChart from '@/components/basic-chart/ArcbarChart.vue';
	import vTable from "@/components/table/table.vue";
	import dataContainer from '@/components/sads-components/dataContainer.vue';
	import dataContainerTwo from '@/components/sads-components/dataContainerTwo.vue';
	import urlAPI from '@/common/vmeitime-http/';
	import numberFun from '@/common/tools/number.js';
	import {globalRequest} from '@/common/request.js'
	import commonFun from '@/common/tools/watcher.js';
	import dateUtils from '@/common/tools/dateUtils.js';
	import noData from '@/components/sads-components/noData.vue';
	
	
	export default {
		name: 'Index',
		components: {
			LineChart,
			ArcbarChart,
			vTable,
			dataContainer,
			dataContainerTwo,noData
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
				today:dateUtils.getToday(),
				nodataMessage:'没有找到相关数据',
				totalData:{},	
				footballData:{},	
				basketballData:{},	
				amountFormat:{"name":"","value":1},
				voteFormat:{"name":"","value":1},
				btnnum: 0,
				arcbarNum: 0,
				lineData2: {},
				lineData1: {},
				arcbar0: {},
				arcbar1: {},
				shopData: {shop:{sum:0,tongbi:0,huanbi:0},
						   rate:{sum:0,tongbi:0,huanbi:0}},
				returnData: {rate:{sum:0,tongbi:0,huanbi:0}},
				rankData:{sum:0,tongbi:0,huanbi:0},
				tableData: [],
				tableDataDetail:[],
				tableData2: [],
				tableDataDetail2:[],
				tableColumns: [{
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
							title: '销量',
							key: 'amount',
							$width:"100px"
						},
						{
							title: '同比',
							key: 'tongbi',
							$width:"80px"
						},
						{
							title: '环比',
							key: 'huanbi',
							$width:"80px"
						}
					],
				tableColumns2: [{
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
							key: 'return',
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
			console.log("totalView onLoad:",this.selfParam)
			this.cWidth=uni.upx2px(750);
			this.cHeight=uni.upx2px(550);
			 
			try{
				this.getServerData();
				this.showView();
				this.refresh();
			} catch (e) {
				console.log('request fail', err);
				try{
					this.showView();
				} catch (e) {
					console.log('request fail', err);
					this.showView();
				};
				
			};
			
		},
		created() {
			// this.selfParam = this.param
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			console.log("totalView created:",this.selfParam)
			
			try{
				this.getServerData();
				this.showView();
				this.refresh();
			} catch (e) {
				console.log('request fail', err);
				try{
					this.showView();
				} catch (e) {
					console.log('request fail', err);
					this.showView();
				};
				
			};
		},
		onShow(){
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			
			try{
				this.getServerData();
				this.showView();
				this.refresh();
			} catch (e) {
				console.log('request fail', err);
				try{
					this.showView();
				} catch (e) {
					console.log('request fail', err);
					this.showView();
				};
				
			};
		},
		methods: {
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
			refresh(){			
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				console.log("刷新页面，日期为",this.selfParam)
				this.getServerData();
				this.showView();
				this.getServerData();
				this.showView();
			},
			showView(){
				// commonFun.sleep(2000)
				this.$nextTick(() => {	
					this.$refs['arcbar0'].showCharts();
					this.$refs['arcbar1'].showCharts();
					this.$refs['lineData2'].showCharts();
					this.$refs['lineData1'].showCharts();
					this.$refs['dataContain'].showDataContainer();
					this.$refs['dataContain2'].showDataContainer();
					this.$refs['dataContain3'].showDataContainer();
				});
			},
			// 获取最上层的两个tab
			getDataSet(provinceCenterId, businessDate){
				console.log("getDataSet provinceCenterId=",provinceCenterId," businessDate=",businessDate)
				var url = '/pentaho/sales/getSalesOverview';
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
						this.totalData={}
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
						var big2 = {'name':'票数（'+format1.name +'张）','value':(saleNumber[0]/format1.value).toFixed(2), 'left':left2,'right':right2};
												
						this.$set(this.totalData, 'big1', big1);
						this.$set(this.totalData, 'big2', big2);
						console.log('request totalData', this.totalData);
						this.$refs['dataContain'].showDataContainer();						
						this.res = '请求结果 : ' + JSON.stringify(res);
											
					}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			},
			getLinesData(provinceCenterId, businessDate){
				var url = '/pentaho/sales/getOverviewTrendChart';
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
					this.amountFormat = numberFun.formatCNumber(maxAmount);
					this.voteFormat= numberFun.formatCNumber(maxVote);
					for(var i=0;i<dates.length;i++){
						categories[i] = dates[i];
						amountData[i] = (sales[i]/this.amountFormat.value).toFixed(2);
						volData[i] = (votes[i]/this.voteFormat.value).toFixed(2);
					}
					
					var json = {'name':'销量('+this.amountFormat.name +'元）' ,'data':amountData};
					var series = [];
					series[0] = json;				
					this.$set(this.lineData2, 'categories', categories);
					this.$set(this.lineData2, 'series', series);
					
					var json2 = {'name':'票数('+this.voteFormat.name +'张）','data':volData};
					var series2 = [];
					series2[0] = json2;
					this.$set(this.lineData1, 'categories', categories);
					this.$set(this.lineData1, 'series', series2);
					
					this.$refs['lineData2'].showCharts();
					this.$refs['lineData1'].showCharts();
					console.log("lineData1: ",this.lineData1)
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			},
			getDataContainerTwo(type, provinceCenterId, businessDate, cityCenterId){
				var url='/pentaho/sales/getGameSales'
				var param = this.createParam()
				
				var big1 = {'name':'销量'};
				var left1 = {'name':'周同比'};
				var right1 = {'name':'环比'};				
				
				var big2 = {'name':'占比'};
				var left2 = {'name':'周同比'};
				var right2 = {'name':'环比'};
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					uni.showToast({
						title: '请求成功',
						icon: 'success',
						mask: true
					});
					var data = res.data.data;	
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
						this.$set(this.footballData, 'big1', big1);
						this.$set(this.footballData, 'big2', big2);
						var json = [{name: '足球',data: (tempObj[3]/100).toFixed(2)}]
						this.$set(this.arcbar0, 'series', json);
						this.$refs['arcbar0'].showCharts();
						this.$refs['dataContain2'].showDataContainer();
						console.log('request basketballData', this.footballData);
					}else{
						this.$set(this.basketballData, 'big1', big1);
						this.$set(this.basketballData, 'big2', big2);
						var json = [{name: '篮球',data: (tempObj[3]/100).toFixed(2)}]
						this.$set(this.arcbar1, 'series', json);
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
			getShopData(provinceCenterId, cityCenterId, businessDate){
				var url = '/pentaho/sales/getStoreSituation';
				var param = this.createParam()
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					var data = res.data.data;	
					if(data==null || data.length==0){
						return;
					}		
					this.shopData.shop.sum=data[0];
					this.shopData.shop.tongbi=data[1]>0?"+"+data[1]:data[1];
					this.shopData.shop.huanbi=data[2]>0?"+"+data[2]:data[2]

					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				
				var url = '/pentaho/sales/getStoreSalesrate';
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
					this.shopData.rate.sum=data[0];
					this.shopData.rate.tongbi=data[1]>0?"+"+data[1]:data[1];
					this.shopData.rate.huanbi=data[2]>0?"+"+data[2]:data[2];
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			},
			getSalesRankingList(provinceCenterId, cityCenterId, businessDate){
				var url = '/pentaho/sales/salesRankingList';
				var param = this.createParam()
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;

					var data = res.data.data;	
					if(data==null || data.length==0){
						return;
					}
					var format0 = numberFun.formatCNumber(data[0][1]);		
					for(var i=0;i<data.length;i++){
						var json = {id:i+1, 
									area:data[i][0], 
									amount:(data[i][1]/format0.value).toFixed(2), 
									tongbi:data[i][2]>0?"+"+data[i][2]+"%":data[i][2]+"%",
									huanbi:data[i][3]>0?"+"+data[i][3]+"%":data[i][3]+"%"}
						var cellClassName={}
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
						json.cellClassName=cellClassName;								
						if(i<=4){
							this.tableData[i] = json
						}
						this.tableDataDetail[i] = json
					}
					console.log("this.tableData=",this.tableData)
					this.tableColumns=[{
								title: "排名",
								key: "id",
								$width:"50px",
							},
							{
								title: '省份',
								key: 'area',
								$width:"70px"
							},
							{
								title: '销量（' + format0.name + '元）',
								key: 'amount',
								$width:"100px"
							},
							{
								title: '同比',
								key: 'tongbi',
								$width:"80px"
							},
							{
								title: '环比',
								key: 'huanbi',
								$width:"80px"
							}
						],
			
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			},
			getProSalesRanking(provinceCenterId, cityCenterId, businessDate){
				var url = '/pentaho/sales/getProSalesRanking';
				var param = this.createParam()
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;

					var data = res.data.data;
					if(data==null){
						return
					}
					this.rankData.sum = data[0]
					this.rankData.tongbi = data[1]
					this.rankData.huanbi = data[2]
							
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			},
			getReturnRateState(){
				var url = '/pentaho/sales/getReturnRateState';
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
									
					this.returnData.rate.sum=data[0];
					this.returnData.rate.tongbi=data[1]>0?"+"+data[1]:data[1];
					this.returnData.rate.huanbi=data[2]>0?"+"+data[2]:data[2]
				
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			},
			getReturnRateRankingList(){
				var url = '/pentaho/sales/returnRateRankingList';
				var param = this.createParam()
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					var data = res.data.data;	
					if(data==null || data.length==0){
						return;
					}
					for(var i=0;i<data.length;i++){
						var json = {id:i+1, 
									area:data[i][0], 
									return:data[i][1]+'%', 
									tongbi:data[i][2]>0?"+"+data[i][2]+'%':data[i][2]+'%',
									huanbi:data[i][3]>0?"+"+data[i][2]+'%':data[i][2]+'%'}	
						var cellClassName={}
							
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
						json.cellClassName=cellClassName;
						
						if(i<=4){
							this.tableData2[i] = json
						}
						this.tableDataDetail2[i] = json
					}
			
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			},
			getServerData() {				
				console.log("getServerData data=",this.param.provinceCenterId)
				this.getDataSet(this.param.provinceCenterId, this.param.businessDate);
				this.getLinesData(this.param.provinceCenterId, this.param.businessDate);
				this.getDataContainerTwo('足球',this.param.provinceCenterId, this.param.businessDate, this.param.cityCenterId);
				this.getDataContainerTwo('篮球',this.param.provinceCenterId, this.param.businessDate, this.param.cityCenterId);
				this.getShopData(this.param.provinceCenterId, this.param.businessDate, this.param.cityCenterId);
				this.getSalesRankingList(this.param.provinceCenterId, this.param.cityCenterId, this.param.businessDate);
				this.getProSalesRanking(this.param.provinceCenterId, this.param.cityCenterId, this.param.businessDate);
				this.getReturnRateState();
				this.getReturnRateRankingList();				
			},
			change(e) {
			      this.btnnum = e
			      console.log(this.btnnum)
				  // this.getServerData();
				  // this.showView();
			},
			changeArcbar(e){
				this.arcbarNum = e
				console.log(this.arcbarNum)
				// this.getServerData();
				// this.showView();
			},
			goSaleRank(tableData, tableColumns){
				uni.navigateTo({
					url:"/pages/common/tableDetail?tableData= " + JSON.stringify(tableData) + '&tableColumns=' + JSON.stringify(tableColumns)
				});
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
			valueToPercent3(value) {
				if(value==null){
					return "0%"
				}
				return value+ "%"
			},
			valueToPercent2(value) {
				let temp = value;
				value = value + '';
				const pointIndex = value.indexOf('.');
				if (pointIndex === -1) return (value - 0) * 100;
				const powIndex = value.length - pointIndex - 1;
				let result = (value.replace('.', '') - 0) * Math.pow(10, 2 - powIndex);

				return result + "%";
			},

		},
		mounted(){
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			this.getServerData();
			this.showView();
		},
		watch: {
			'$route':'showView'
			// '$route':'refresh'
		},
	}
</script>

<style>	
	
	.shop-title{
		width: 100%;
		margin: 0rpx 5rpx;
		padding: 10px 0px;
		font-size: 30rpx;
		font-weight: bold;
	}
	
	.shop-item-title{
		display: flex;
		flex-direction: row;
		padding: 10px 0px;
		font-size: 30rpx;
	}
	.shop-item-content{
		padding: 10px 0px;
		display: flex;
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
		width: 100%;
		display: flex;
		font-weight: bold;
		border-color:#FFFFFF;
	}
	
	.title {
		/* line-height: 40px; */
		font-weight: bold;
		border-color:#FFFFFF;
	}
	.box-contaniner{
		width: 95%;
		padding: 5px 5px 5px 5px;
		/* margin: 0px 10px 10px 0px; */
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
		color: #FFFFFF;
		background: #B4C3D4;
		padding:5rpx 30rpx 5rpx 30rpx;
	}
	.dis{
		display: block;
		/* padding:0px 30rpx 0px 30rpx; */
	} 
	.hide{
		color: #000000;
		background: #FFFFFF;
		padding:5rpx 30rpx 5rpx 30rpx;
	}
	.small-text-green{
		color: #1FCE58;
		/* font-size: 30rpx; */
	}
	
	.small-text-red{
		color: #E83838;
		/* font-size: 30rpx; */
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
</style>
