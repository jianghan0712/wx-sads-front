<template>
	<view>
		<view class="box-contaniner">
			<dataContainerTwoCol ref="dataContainTwo" :dataAs="topData"></dataContainerTwoCol>
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
				<line-chart ref="lineData2" canvasId="index_line_2" :dataAs="lineData2" :colors="colorList"
							:xAxisAs="{scrollShow:false}" />
			</view>
			<view class="end-cont" :class="{dis:btnnum == 1}">		　
				<line-chart ref="lineData1" canvasId="index_line_1" :dataAs="lineData1"  :colors="colorList"	 
							:xAxisAs="{scrollShow:false}" />
			</view>		
		</view>
		<block v-if="selfParam.compareDate.viewLeft!=today && selfParam.compareDate.viewRight!=today">
			<view class="shop-title">排名对比</view>
			<dataContainerTwoCol ref="rankData" :dataAs="rankData"></dataContainerTwoCol>
			<!-- <dataContainerTwoColFour ref="rankData" :dataAs="rankData"></dataContainerTwoColFour>
			<dataContainerTwoColFour ref="rankData2" :dataAs="rankData2"></dataContainerTwoColFour> -->
		</block>
		<!-- 竞彩足篮球销量及占比对比区域 -->
		<view class="box-contaniner">
			<view class="shop-title">竞彩足篮球销量及占比对比</view>
			<dataContainerTwoColTwo ref="dataContainerTwoColTwo" :dataAs="ballAmount"></dataContainerTwoColTwo>
		</view>		
		
		
<!-- 		门店在售情况-->
<!-- 		<view class="box-contaniner">
			<view class="shop-title">返奖情况对比</view>
			<dataContainerTwoCol ref="shopData" :dataAs="shopData"></dataContainerTwoCol>
		</view> -->
		
		<!-- 各地区销量排行-->
<!-- 		<view class="box-contaniner">
			<view class="rankTable-title">
				<view>各地区销量排行榜对比</view>
				<view class="rankTable-more" @click="goSaleRank(leftTableDataDetail,leftTableColumns,rightTableDataDetail,rightTableColumns)">全部>></view>
			</view>
			<view class="example">
				<view class="sale-row-2">
					<view class="left-row-box">
						<v-table :columns="leftTableColumns" :list="leftTableData"  border-color="rgba(220, 241, 250 ,0.5)"></v-table>
					</view>
					<view class="right-row-box">
						<v-table :columns="rightTableColumns" :list="rightTableData"  border-color="#FFFFFF"></v-table>
					</view>
				</view>			
			</view>
		</view> -->
		
		<block v-if="selfParam.compareDate.viewLeft!=today && selfParam.compareDate.viewRight!=today">
			<view class="shop-title">返奖率情况</view>
			<dataContainerTwoColFour ref="returnData" :dataAs="returnData"></dataContainerTwoColFour>
		</block>
		
		<block v-if="selfParam.compareDate.dateType!='date'">
			<view class="box-contaniner">
				<view class="shop-title">{{selfParam.compareDate.viewLeft}}返奖率走势</view>
				<line-chart ref="lineData3" canvasId="index_line_3" :dataAs="lineData3" :colors="colorList"
							:xAxisAs="{scrollShow:false}" 
							:yAxisAs="{formatter: {type: 'percent', name:'',fixed: 2}}"/>
			</view>	
			<view class="box-contaniner">
				<view class="shop-title">{{selfParam.compareDate.viewRight}}返奖率走势</view>
				<line-chart ref="lineData4" canvasId="index_line_4" :dataAs="lineData4" :colors="colorList"
							:xAxisAs="{scrollShow:false}" 
							:yAxisAs="{formatter: {type: 'percent', name:'',fixed: 2}}"/>
			</view>	
<!-- 			<view class="box-contaniner">
				<view class="rankTable-title">
					<view>各地区返奖情况对比</view>
					<view class="rankTable-more" @click="goSaleRank(leftReturnTableDataDetail,leftReturnTableColumns,rightReturnTableDataDetail,rightReturnTableColumns)">全部>></view>
				</view>
				<view class="example">
					<view class="sale-row-2">
						<view class="left-row-box">
							<v-table :columns="leftReturnTableColumns" :list="leftReturnTableData"  border-color="rgba(220, 241, 250 ,0.5)"></v-table>
						</view>
						<view class="right-row-box">
							<v-table :columns="rightReturnTableColumns" :list="rightReturnTableData"  border-color="#FFFFFF"></v-table>
						</view>
					</view>			
				</view>
			</view> -->
		</block>
		
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
	import dataContainerTwoColFour from '@/components/sads-components/dataContainerTwoColFour.vue';
	import urlAPI from '@/common/vmeitime-http/';
	import numberFun from '@/common/tools/number.js';
	import dateUtils from '@/common/tools/dateUtils.js';
	import AreaChart from '@/components/basic-chart/AreaChart.vue';
	import util from '@/common/tools/util.js'
	
	export default {
		name: 'Index',
		components: {
			LineChart,
			ArcbarChart,
			vTable,
			dataContainer,
			dataContainerTwo,
			dataContainerTwoCol,dataContainerTwoColTwo,dataContainerTwoColFour,AreaChart
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
					selfProvinceCenterId:'',//存登录时候的id
					shopNo:''
				},
				gateInfo:{},
				topData:{	left:{title1:'销量（万）',amount1:0,title2:'票数（张）',amount2:0},
							right:{title1:'销量（万）',amount1:0,title2:'票数（张）',amount2:0}},
				shopData:{	left:{title1:'在售门店数',amount1:0,title2:'在售门店率',amount2:0},
							right:{title1:'在售门店数',amount1:0,title2:'在售门店率',amount2:0}},
				returnData:{left:{title1:'返奖率',amount1:0},
							right:{title1:'返奖率',amount1:0}},
				rankData:{
					left:{title1:'排名',amount1:0,title2:'排名',amount2:0},
					right:{title1:'排名',amount1:0,title2:'排名',amount2:0}
				},
				// rankData:{left:{title1:'排名',amount1:0},
				// 		  right:{title1:'排名',amount1:0}},
			    rankData2:{left:{title1:'排名',amount1:0},
					      right:{title1:'排名',amount1:0}},
				ballAmount:{
					left:{
						football:{name:"足球",amount:"销量0元",zhanbi:"0%"},
						basketball:{name:"篮球",amount:"销量0元",zhanbi:"0%"}
					},
					right:{
						football:{name:"足球",amount:"销量0元",zhanbi:"0%"},
						basketball:{name:"篮球",amount:"销量0元",zhanbi:"0%"}
					},
				},						
				footballData:{},	
				basketballData:{},	
				btnnum: 0,
				lineData2: {},
				lineData1: {},
				lineData3: {},
				lineData4: {},
				
				leftTableData: [],
				rightTableData: [],
				leftTableDataDetail: [],
				rightTableDataDetail: [],
				leftTableColumns: [{
							title: '省份',
							key: 'area',
							$width:"100px"
						},{
							title: "排名",
							key: "id",
							$width:"50px",
						},{
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
				leftTableData: [],

				leftReturnTableData: [],
				rightReturnTableData: [],
				leftReturnTableDataDetail: [],
				rightReturnTableDataDetail: [],
				leftReturnTableColumns: [{
							title: '省份',
							key: 'area',
							$width:"100px"
						},{
							title: "排名",
							key: "id",
							$width:"50px",
						},{
							title: '返奖率',
							key: 'amount',
							$width:"100px"
						}
					],
				rightReturnTableColumns: [{
							title: "排名",
							key: "id",
							$width:"50px",
						},
						{
							title: '返奖率',
							key: 'amount',
							$width:"80px"
						}
					],
					
				colorList: ['#1890ff','#facc14']
			};
		},
		created() {
			// this.returnFromDatePicker()
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			// this.selfParam.shopNo=
			this.getServerData();
			// this.showView();
		},
		onLoad() {
			_self = this;
			this.cWidth=uni.upx2px(750);
			this.cHeight=uni.upx2px(500);
			this.showView();
		},
		methods: {
			getServerData() {
				this.getDataSet();
				this.getLinesData();
				this.getBallAmount();
				this.getShopData();
				this.getRankTable();
				this.getComReturnRateState()
				this.getComProSalesRanking()
				// this.getComProSalesRanking2()
				// if(this.selfParam.compareDate.viewLeft!=today && this.selfParam.compareDate.viewRight!=today && this.selfParam.provinceCenterId!=0){
				// 	this.getComReturnRateState()
				// }
				if(this.selfParam.compareDate.dateType!='date'){
					this.getReturnRateTrendChartCom(1)
					this.getReturnRateTrendChartCom(2)
					this.getComReturnRatesRanking()
				}
			},
			showView(){
				this.$nextTick(() => {				
					this.$refs['lineData2'].showCharts();
					this.$refs['lineData1'].showCharts();
					this.$refs['dataContainTwo'].showDataContainer();
					this.$refs['dataContain2'].showDataContainer();
					this.$refs['dataContain3'].showDataContainer();
				});
			},
			returnFromDatePicker(){
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				const dateType = uni.getStorageSync("dateType")
				const bussinessDate = JSON.parse(uni.getStorageSync("businessDate"))
				this.selfParam.businessDate = bussinessDate;
				// this.gateInfo = JSON.parse(uni.getStorageSync("gateInfo"))
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
				var dateType = this.selfParam.compareDate.dateType
				var param = {}

				if(dateType=='date'){
					param = {dateTimeStart: this.selfParam.compareDate.dateLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.dateLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.dateRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.dateRight.endDate,
							 dateFlag:"1",
							 regionId:this.selfParam.provinceCenterId,
							 showNumber: this.selfParam.shopNo,
							 token:this.selfParam.token }
				}else if(dateType=='week'){
					param = {dateTimeStart: this.selfParam.compareDate.weekLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.weekLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.weekRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.weekRight.endDate,
							 dateFlag:"2",
							 regionId:this.selfParam.provinceCenterId,
							  showNumber: this.selfParam.shopNo,
							 token:this.selfParam.token }
				}else if(dateType=='month'){
					param = {dateTimeStart: this.selfParam.compareDate.monthLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.monthLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.monthRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.monthRight.endDate,
							 dateFlag:"3",
							 regionId:this.selfParam.provinceCenterId,
							 showNumber: this.selfParam.shopNo,
							 token:this.selfParam.token }
				}else if(dateType=='year'){
					param = {dateTimeStart: this.selfParam.compareDate.yearLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.monthLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.monthRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.monthRight.endDate,
							 dateFlag:"4",
							 regionId:this.selfParam.provinceCenterId,
							 showNumber: this.selfParam.shopNo,
							 token:this.selfParam.token }
				}	
				console.log("createParam end:",param)
				return param
			},
			// 获取最上层的两个tab
			getDataSet(){
				var url = '/pentaho/showsContrast/getShowSalesAndVotesCom';
				var param = this.createParam()
				
				urlAPI.getRequest(url, param).then((res)=>{
					// setTimeout(() => { 
						this.loading = false;
							console.log('request success', res)
							uni.showToast({
								title: '请求成功',
								icon: 'success',
								mask: true
							});
							var data = res.data.data;
							var amount1 = data[0][0]
							var saleNumber1 = data[0][1]
							var amount2 = data[1][0]
							var saleNumber2 = data[1][1]
							
							var format00 = numberFun.formatCNumber(amount1);
							var format01 = numberFun.formatCNumber(saleNumber1);
							var format10 = numberFun.formatCNumber(amount2);
							var format11 = numberFun.formatCNumber(saleNumber2);
							
							var left = {'title1':'销量（'+format00.name +'元）', 'amount1':(amount1/format00.value).toFixed(2), 'title2':'票数（'+format01.name +'张）', 'amount2':(saleNumber1/format01.value).toFixed(2)};
							var right = {'title1':'销量（'+format10.name +'元）', 'amount1':(amount2/format10.value).toFixed(2), 'title2':'票数（'+format11.name +'张）', 'amount2':(saleNumber2/format11.value).toFixed(2)};
						
							this.$set(this.topData, 'left', left);
							this.$set(this.topData, 'right', right);
							console.log('request topData', this.topData);
							this.$refs['dataContainTwo'].showDataContainer();
							this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			getShopData(){
				var url = '/pentaho/salesContrast/getComStoreSituation';
				var param = this.createParam()
				
				urlAPI.getRequest(url, param).then((res)=>{
					// setTimeout(() => { 
						this.loading = false;
							console.log('request success', res)
							var data = res.data.data;
							if(data==null){
								return;
							}
								
							var amount1 = data[0]
							var saleNumber1 = data[1]
							
							var left = {'title1':'在售门店数', 'amount1':amount1, 'title2':'在售门店率',amount2:0};
							var right = {'title1':'在售门店数', 'amount1':saleNumber1, 'title2':'在售门店率',amount2:0};							
							this.getShopRatio(left,right);		
					
							this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})			
			},
			getShopRatio(left,right){
				var url = '/pentaho/salesContrast/getComStoreSalesrate';
				var param = this.createParam()
				urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						console.log('request success', res)
						var data = res.data.data;
						
						if(data==null){
							left.amount2=0+'%'
							right.amount2=0+'%'
							this.shopData.left=left
							this.shopData.right=right
							this.$refs['shopData'].showDataContainer();
							// var ret = {left:left,right:right}
							return;
						}
						var amount1 = data[0] +"%"
						var saleNumber1 = data[1] +"%"
						left.amount2=amount1;
						right.amount2=saleNumber1;
						
						this.shopData.left=left
						this.shopData.right=right
							
						console.log('request shopData', this.shopData);
						this.$refs['shopData'].showDataContainer();
						this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
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
					var j=0,k = 0,tempAmount=0,tempVol=0,tempAmountComp=0,tempVolComp=0;
					var maxAmount=0,maxVote=0
					for(var i=0;i<dates.length;i++){
						if(maxAmount<sales[i]){
							maxAmount = sales[i]
						}
						if(maxAmount<comSales[i]){
							maxAmount = comSales[i]
						}
						if(maxVote<votes[i]){
							maxVote = votes[i]
						}
						if(maxVote<votes[i]){
							maxVote = comVotes[i]
						}
					}
					
					var amountFormat = numberFun.formatCNumber(maxAmount);
					var voteFormat= numberFun.formatCNumber(maxVote);
					
					for(var i=0;i<dates.length;i++){	
						categories[i] = dates[i];
						amountData[i] = (sales[i]/amountFormat.value).toFixed(2);
						volData[i] = (votes[i]/voteFormat.value).toFixed(2);
					}
					
					for(var i=0;i<comDates.length;i++){
						categoriesComp[i] = comDates[i];
						amountDataComp[i] = (comSales[i]/amountFormat.value).toFixed(2);
						volDataComp[i] = (comVotes[i]/voteFormat.value).toFixed(2);
					}
					
					if(comDates.length>data.length){
						for(var i=data.length;i<comDates.length;i++){
							data[i]=comDates[i]
							amountData[i]=0
							volData[i] = 0
						}						
					}else if(comDates.length<data.length){
						for(var i=comDates.length;i<data.length;i++){
							comDates[i]=date[i]
							amountData[i]=0
							volData[i] = 0
						}
					}
					
					// var json1 = {'name':'销量','data':amountData};
					// var json2 = {'name':'销量','data':amountDataComp};
					var series = [ {'name':this.selfParam.compareDate.viewLeft +'销量('+amountFormat.name + '元)','data':amountData},
								   {'name':this.selfParam.compareDate.viewRight +'销量('+amountFormat.name + '元)','data':amountDataComp}];	
					
					this.$set(this.lineData2, 'categories', categories);
					this.$set(this.lineData2, 'series', series);
					
					// var json3 = {'name':'销量','data':volData};
					var series2 = [{'name':this.selfParam.compareDate.viewLeft +'票数('+voteFormat.name + '张)','data':volData},
							       {'name':this.selfParam.compareDate.viewRight +'票数('+voteFormat.name + '张)','data':volDataComp}];
					// series2[0] = json2;
					this.$set(this.lineData1, 'categories', categoriesComp);
					this.$set(this.lineData1, 'series', series2);
					this.$refs['lineData2'].showCharts();
					this.$refs['lineData1'].showCharts();
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			getBallAmount(){
				var url="/pentaho/showsContrast/getShowsGameSalesCom"
				var param = this.createParam()		
				urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
							console.log('request success', res)
							var data = res.data.data;
							if(data==null || data.length==0){
								return;
							}
							var FB = data.FB
							var BK = data.BK
							var format00 = numberFun.formatCNumber(FB[0]);
							var format01 = numberFun.formatCNumber(BK[0]);
							var format10 = numberFun.formatCNumber(FB[2]);
							var format11 = numberFun.formatCNumber(BK[2]);
							
							var ballAmount={
								left:{
									football:{name:"足球",amount:"销量" +(FB[0]/format00.value).toFixed(2) + format00.name +"元",zhanbi:parseFloat(FB[1]).toFixed(2) +"%"},
									basketball:{name:"篮球",amount:"销量" +(BK[0]/format01.value).toFixed(2) + format01.name +"元",zhanbi:parseFloat(BK[1]).toFixed(2) +"%"}
								},
								right:{
									football:{name:"足球",amount:"销量" +(FB[2]/format10.value).toFixed(2) + format10.name +"元",zhanbi:parseFloat(FB[3]).toFixed(2) +"%"},
									basketball:{name:"篮球",amount:"销量" +(BK[2]/format11.value).toFixed(2) + format11.name +"元",zhanbi:parseFloat(BK[3]).toFixed(2) +"%"}
								}
							}
							this.ballAmount = ballAmount;

							console.log('request ballAmount', this.ballAmount);
							this.$refs['dataContainerTwoColTwo'].showDataContainer();
							
							this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			getRankTable(){			
				var url="/pentaho/salesContrast/getComSalesRankingList"
				var param = this.createParam()		
				urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
							console.log('request success', res)
							var data = res.data.data;
							if(data==null || data.length==0){
								return;
							}
							var format0 = numberFun.formatCNumber(data[0][2]);	
							var format1 = numberFun.formatCNumber(data[0][4]);	
							this.leftTableColumns=[									{
										title: '省份',
										key: 'area',
										$width:"100px"
									},{
										title: "排名",
										key: "id",
										$width:"50px",
									},{
										title: '销量(' +format0.name +'元)',
										key: 'amount',
										$width:"95px"
									}
								];
							this.rightTableColumns=[{
										title: "排名",
										key: "id",
										$width:"50px",
									},
									{
										title:  '销量(' +format1.name +'元)',
										key: 'amount',
										$width:"95px"
									}
								];
							for(var i=0;i<data.length;i++){
								var jsonleft = {id:data[i][1], area:util.formatToolongName(data[i][0]), amount:(data[i][2]/format0.value).toFixed(2)}	
								var jsonright = {id:data[i][3],amount:(data[i][4]/format1.value).toFixed(2)}								
								if(i<=4){
									this.leftTableData[i] = jsonleft
									this.rightTableData[i] = jsonright
								}
								this.leftTableDataDetail[i] = jsonleft
								this.rightTableDataDetail[i] = jsonright
							}
							
							this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})		
			},
			getComReturnRatesRanking(){
				var url="/pentaho/salesContrast/getComReturnRatesRanking"
				var param = this.createParam()		
				urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
							console.log('request success', res)
							var data = res.data.data;
							if(data==null || data.length==0){
								return;
							}
							this.leftReturnTableColumns=[									{
										title: '省份',
										key: 'area',
										$width:"100px"
									},{
										title: "排名",
										key: "id",
										$width:"50px",
									},{
										title: '返奖率',
										key: 'amount',
										$width:"100px"
									}
								];
							this.rightReturnTableColumns=[{
										title: "排名",
										key: "id",
										$width:"50px",
									},
									{
										title:  '返奖率',
										key: 'amount',
										$width:"80px"
									}
								];
							for(var i=0;i<data.length;i++){
								var jsonleft = {id:data[i][1], area:util.formatToolongName(data[i][0]), amount:data[i][2] +'%'}	
								var jsonright = {id:data[i][3],amount:data[i][4] +'%'}								
								if(i<=4){
									this.leftReturnTableData[i] = jsonleft
									this.rightReturnTableData[i] = jsonright
								}
								this.leftReturnTableDataDetail[i] = jsonleft
								this.rightReturnTableDataDetail[i] = jsonright
							}
							
							this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})		
			},
			getComReturnRateState(){
				var url="/pentaho/showsContrast/getShowReturnRateCom"
				var param = this.createParam()		
				urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						console.log('request success', res)
						var data = res.data.data;
						if(data==null || data.length==0){
							return;
						}

						var leftReturn = data[0] +'%'
						var rightReturn = data[1]+'%'
						
						var left = {'title1':'返奖率', 'amount1':leftReturn };
						var right = {'title1':'返奖率', 'amount1':rightReturn};	
						this.returnData.left = left 
						this.returnData.right= right
						this.$refs['returnData'].showDataContainer();
						this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			getComProSalesRanking(){
				var url=''
				var param = this.createParam()	
				param.regionId=this.gateInfo.provinceCenterId
				var title = ''
				if(this.selfParam.provinceCenterId==0){
					url="/pentaho/showsContrast/getShowRankingCountryCom"
					title='全国排名'
				}else{
					url="/pentaho/showsContrast/getShowRankingProCom"
					title='全省排名'
				}
				urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						console.log('request success', res)
						var data = res.data.data;
						if(data==null || data.length==0){
							this.$refs['rankData'].showDataContainer();
							return;
						}
			
						var leftRank = data[0]
						var rightRank = data[1]
						var left = {'title1':title, 'amount1':leftRank};
						var right = {'title1':title, 'amount1':rightRank};	
						this.getComProSalesRanking2(left,right)
						// this.rankData.left = left 
						// this.rankData.right= right
						// this.$refs['rankData'].showDataContainer();
						this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			getComProSalesRanking2(left,right){			
				var url=''
				var param = this.createParam()	
				param.cityId=this.gateInfo.cityId
				param.regionId=this.gateInfo.provincialId
				console.log('totalViewCompare this.gateInfo = ',this.gateInfo)
				console.log('totalViewCompare this.param = ',param)
				var title = ''
				if(this.selfParam.provinceCenterId==0){
					url="/pentaho/showsContrast/getShowRankingProCom"
					title='全省排名'
				}else{
					url="/pentaho/showsContrast/getShowRankingCityCom"
					title='全市排名'
				}
				urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						console.log('request success', res)
						var data = res.data.data;
						if(data==null || data.length==0){
							this.$refs['rankData2'].showDataContainer();
							return;
						}
			
						var leftRank = data[0]
						var rightRank = data[1]
						left.title2=title
						left.amount2=leftRank
						right.title2=title
						right.amount2=rightRank
						// var left = {'title1':title, 'amount1':leftRank };
						// var right = {'title1':title, 'amount1':rightRank};	
						this.rankData.left = left
						this.rankData.right= right
						// this.rankData2.left = left 
						// this.rankData2.right= right
						this.$refs['rankData'].showDataContainer();
						this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			getReturnRateTrendChartCom(type){
				var url = '/pentaho/shows/getShowReturnRateTrendChart'
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
					
					var dates = data.dates
					var ALL = data.ALL
					var FB = data.FB
					var BK = data.BK
					// var comDates = data.comDates
					// var comALL = data.comALL
					// var comFB = data.comFB
					// var comBK = data.comBK
					
					for(var i=0;i<dates.length;i++){
						ALL[i] = (ALL[i]/100).toFixed(2)
						FB[i] = (FB[i]/100).toFixed(2)
						BK[i] = (BK[i]/100).toFixed(2)
					}
					// for(var i=0;i<comDates.length;i++){
					// 	comALL[i] = (comALL[i]/100).toFixed(2)
					// 	comFB[i] = (comFB[i]/100).toFixed(2)
					// 	comBK[i] = (comBK[i]/100).toFixed(2)
					// }
					var series = [ {'name':'竞彩返奖率','data':ALL},
								   {'name':'足球返奖率','data':FB},
								   {'name':'篮球返奖率','data':BK}];	
					if(type==1){
						this.$set(this.lineData3, 'categories', dates);
						this.$set(this.lineData3, 'series', series);
						this.$refs['lineData3'].showCharts();
					}else{
						this.$set(this.lineData4, 'categories', dates);
						this.$set(this.lineData4, 'series', series);
						this.$refs['lineData4'].showCharts();
					}
					
					
					// var json3 = {'name':'销量','data':volData};
					// var series2 = [ {'name':'竞彩返奖率','data':comALL},
					// 			   {'name':'足球返奖率','data':comFB},
					// 			   {'name':'篮球返奖率','data':comBK}];	
					// series2[0] = json2;
					// this.$set(this.lineData4, 'categories', dates);
					// this.$set(this.lineData4, 'series', series2);
					// this.$refs['lineData3'].showCharts();
					// this.$refs['lineData4'].showCharts();
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			
			refresh(){
				// this.returnFromDatePicker()
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				console.log("totalViewCompare selfParam=",this.selfParam)
				this.getServerData();
				this.showView();
				this.getServerData();
				this.showView();
				this.getServerData();
				this.showView();
				this.getServerData();
				this.showView();
			},
			change(e) {
			      this.btnnum = e
			      console.log(this.btnnum)
			},
			changeArcbar(e){
				this.arcbarNum = e
				console.log(this.arcbarNum)
			},
			goSaleRank(tableData, tableColumns,righttableData, righttableColumns){
				uni.navigateTo({
					url:"/pages/common/tableDetail3?leftTableData= " + JSON.stringify(tableData) + '&leftTableColumns=' + JSON.stringify(tableColumns) 
													+"&rightTableData= " + JSON.stringify(righttableData) + '&rightTableColumns=' + JSON.stringify(righttableColumns)
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
		color: #FFFFFF;
		background: #92AAAA;
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
		color: ##1FCE58;
		/* font-size: 30rpx; */
	}
	
	.small-text-red{
		color: #E83838;
		/* font-size: 30rpx; */
	}
	.left-row-box {
		display: flex;
		width: 65%;
		margin: 0rpx 5rpx;
		/* padding: 0 10rpx; */
		background-color: rgba(220, 241, 250 ,0.5);
		flex-direction: column;
	}
	.right-row-box {
		display: flex;
		width: 35%;
		margin: 0rpx 5rpx;
		/* padding: 0 10rpx; */
		background-color: rgba(250, 225, 220 ,0.5);
		flex-direction: column;
	}
	.sale-row-2{
		display: flex;
		flex-direction: row;	
		margin: 20rpx 10rpx;
		/* padding: 20rpx 10rpx 20rpx 10rpx;	 */
	}
</style>
