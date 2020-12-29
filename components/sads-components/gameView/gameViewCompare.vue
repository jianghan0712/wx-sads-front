<template>
	<view>
		<view class="box-contaniner">
			<view class="arcbarChart-tab">
			    <view @tap="changeTop('足球')" :class="arcbarNumTop =='足球'?'btna':'hide'" style="width: 50%;" >足球</view>
			    <view @tap="changeTop('篮球')" :class="arcbarNumTop =='篮球'?'btna':'hide'" style="width: 50%;" >篮球</view>
			</view>
			<view class="end-cont" :class="{dis:arcbarNumTop == '足球'}">
				<dataContainerTwoCol ref="dataContain" :dataAs="footballData"></dataContainerTwoCol>
			</view>
			<view class="end-cont" :class="{dis:arcbarNumTop == '篮球'}">		　
				<dataContainerTwoCol ref="dataContain1" :dataAs="basketballData"></dataContainerTwoCol>
			</view>		
			
		</view>
		
		<!-- 折线图区域-->
		<view class="box-contaniner">
			<view class="clineChart-title">
				<view style="font-size: 30rpx;font-weight: bold;">{{arcbarNumTop}}销量及票数走势对比</view>
				<view class="linechart-tab">
				　　<view @tap="change(0)" :class="btnnum == 0?'btna':'hide'">销量</view>
				  　<view @tap="change(1)" :class="btnnum == 1?'btna':'hide'">票数</view>
				</view>
			</view>		
			<view class="end-cont" :class="{dis:btnnum == 0}">
				<view class="end-cont" :class="{dis:arcbarNumTop =='足球'}">
					<area-chart ref="lineData0" canvasId="index_line_0" :dataAs="lineData0" 
								:xAxisAs="{scrollShow:false}" 
								:yAxisAs="{formatter: {type: 'number', name:'万元',fixed: 0}}"/>
				</view>
				<view class="end-cont" :class="{dis:arcbarNumTop =='篮球'}">
					<area-chart ref="lineData2" canvasId="index_line_2" :dataAs="lineData2" 
								:xAxisAs="{scrollShow:false}" 
								:yAxisAs="{formatter: {type: 'number', name:'万元',fixed: 0}}"/>
				</view>
			</view>
			<view class="end-cont" :class="{dis:btnnum == 1}">		　
				<view class="end-cont" :class="{dis:arcbarNumTop =='足球'}">
					<area-chart ref="lineData1" canvasId="index_line_1" :dataAs="lineData1" 
								:xAxisAs="{scrollShow:false}" 
								:yAxisAs="{formatter: {type: 'number', name:'万张',fixed: 0}}"/>
				</view>
				<view class="end-cont" :class="{dis:arcbarNumTop =='篮球'}">
					<area-chart ref="lineData3" canvasId="index_line_3" :dataAs="lineData3" 
								:xAxisAs="{scrollShow:false}" 
								:yAxisAs="{formatter: {type: 'number', name:'万张',fixed: 0}}"/>
				</view>
			</view>		
		</view>
		<!-- 折线图区域-->
		<view class="box-contaniner">
			<view class="clineChart-title">
				<view style="font-size: 30rpx;font-weight: bold;">{{arcbarNumTop}}销量及占比对比</view>
			</view>		
			<view class="end-cont" :class="{dis:arcbarNumTop =='足球'}">		
				<view>{{selfParam.compareDate.viewLeft}}</view>
				<ring-chart canvasId="arcbar0" ref="arcbar0" :dataAs="arcbar0" />
				<view>{{selfParam.compareDate.viewRight}}</view>
				<ring-chart canvasId="arcbar2" ref="arcbar2" :dataAs="arcbar2" />	
			</view>
			<view class="end-cont" :class="{dis:arcbarNumTop =='篮球'}">	
				<view>{{selfParam.compareDate.viewLeft}}</view>　
				<ring-chart canvasId="arcbar1" ref="arcbar1" :dataAs="arcbar1" />
				<view>{{selfParam.compareDate.viewRight}}</view>
				<ring-chart canvasId="arcbar3" ref="arcbar3" :dataAs="arcbar3" />	
			</view>
			<view style="text-align: center;">
				<button  @click="toRingAll()">查看全部</button>
			</view>
		</view>
		
		<!-- 竞彩足篮球销量及占比对比 -->
		<view class="box-contaniner">
			<view class="container-title">
				<view>各地区{{arcbarNumTop}}销量及占比对比</view>
			</view>
			<view class="end-cont" :class="{dis:arcbarNumTop =='足球'}">
				<view class="sale-row-2">
					<view class="left-row-box">
						<v-table :columns="leftTableColumns" :list="leftTableData"  border-color="#FFFFFF"></v-table>
					</view>
					<view class="right-row-box">
						<v-table :columns="rightTableColumns" :list="rightTableData"  border-color="#FFFFFF"></v-table>
					</view>
				</view>			
			</view>
			<view class="end-cont" :class="{dis:arcbarNumTop =='篮球'}">
				<view class="sale-row-2">
					<view class="left-row-box">
						<v-table :columns="leftTableColumns" :list="leftTableData2"  border-color="#FFFFFF"></v-table>
					</view>
					<view class="right-row-box">
						<v-table :columns="rightTableColumns" :list="rightTableData2"  border-color="#FFFFFF"></v-table>
					</view>
				</view>			
			</view>
			<view style="text-align: center;">
				<button  @click="toAll()">查看全部</button>
			</view>
		</view>		
		
		<!-- 各地区销量排行-->
		<view v-if="selfParam.compareDate.viewLeft!=today&&selfParam.compareDate.viewRight!=today"  class="box-contaniner">
			<view class="container-title">
				<view>各地区{{arcbarNumTop}}返奖情况对比</view>
			</view>
			<!-- v-if="arcbarNumTop =='足球'" -->
			<view class="end-cont" :class="{dis:arcbarNumTop =='足球'}">
				<view class="sale-row-2">
					<view class="left-row-box">
						<v-table :columns="leftTableColumnsReturn" :list="leftTableData1"  border-color="#FFFFFF"></v-table>
					</view>
					<view class="right-row-box">
						<v-table :columns="rightTableColumnsReturn" :list="rightTableData1"  border-color="#FFFFFF"></v-table>
					</view>
				</view>	
			</view>
			<!-- v-if="arcbarNumTop =='篮球'" -->
			<view class="end-cont" :class="{dis:arcbarNumTop =='篮球'}">
				<view class="sale-row-2">
					<view class="left-row-box">
						<v-table :columns="leftTableColumnsReturn" :list="leftTableData3"  border-color="#FFFFFF"></v-table>
					</view>
					<view class="right-row-box">
						<v-table :columns="rightTableColumnsReturn" :list="rightTableData3"  border-color="#FFFFFF"></v-table>
					</view>
				</view>	
			</view>
			<view style="text-align: center;">
				<button  @click="toAll1()">查看全部</button>
			</view>
		</view>
		
		<slot />
	</view>
</template>

<script>
	import LineChart from '@/components/basic-chart/LineChart.vue';
	import ArcbarChart from '@/components/basic-chart/ArcbarChart.vue';
	import vTable from "@/components/table/table.vue";
	import AreaChart from '@/components/basic-chart/AreaChart.vue';
	import RingChart from '@/components/basic-chart/RingChart.vue';
	import dataContainer from '@/components/sads-components/dataContainer.vue';
	import dataContainerTwo from '@/components/sads-components/dataContainerTwo.vue';
	import dataContainerTwoCol from '@/components/sads-components/dataContainerTwoCol.vue';
	import dataContainerTwoColTwo from '@/components/sads-components/dataContainerTwoColTwo.vue';
	import urlAPI from '@/common/vmeitime-http/';
	import numberFun from '@/common/tools/number.js';
	import dateUtils from '@/common/tools/dateUtils.js';
	import util from '@/common/tools/util.js'
	
	
	export default {
		name: 'Index',
		components: {
			LineChart,
			ArcbarChart,
			AreaChart,
			RingChart,
			vTable,
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
				today:dateUtils.getToday(),
				footballData:{},	
				basketballData:{},	
				btnnum: 0,
				arcbarNumTop:'足球',
				lineData0: {},
				lineData1: {},
				lineData2: {},
				lineData3: {},
				arcbar0:{type: 'radar',
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
							}},
				arcbar1:{type: 'radar',
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
							}},
				arcbar2:{type: 'radar',
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
							}},
				arcbar3:{type: 'radar',
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
							}},
				//结构和上面不一样 跳转RingAllDetail
				arcbarAll0:{},//足球
				arcbarAll2:{},//篮球
				amountFormat:{"name":"","value":1},
				voteFormat:{"name":"","value":1},
				leftTableDataRateAllbk: [
					],
				rightTableDataRateAllbk: [
					],
				leftTableDataRateAllfb: [
					],
				rightTableDataRateAllfb: [
					],
				leftTableData: [
					],
				rightTableData: [
					],
				leftTableData1: [
					],
				rightTableData1: [
					],
				leftTableData2: [
					],
				rightTableData2: [
					],
				leftTableData3: [
					],
				rightTableData3: [
					],
				leftTableDataAll: [
					],
				rightTableDataAll: [
					],
				leftTableDataAll1: [
					],
				rightTableDataAll1: [
					],
				leftTableDataAll2: [
					],
				rightTableDataAll2: [
					],
				leftTableDataAll3: [
					],
				rightTableDataAll3: [
					],	
				leftTableColumns: [
						{
							title: '省份',
							key: 'area',
							$width:"100px"
						},
						{
							title: "排名",
							key: "id",
							$width:"50px",
						},
						{
							title: '销量（万元）',
							key: 'amount',
							$width:"110px"
						}
					],
				rightTableColumns: [{
							title: "排名",
							key: "id",
							$width:"50px",
						},
						{
							title: '销量（万元）',
							key: 'amount',
							$width:"100px"
						}
					],
				leftTableColumnsRate: [
						{
							title: '省份',
							key: 'area',
							$width:"100px"
						},
						{
							title: "排名",
							key: "id",
							$width:"50px",
						},
						{
							title: '占比',
							key: 'rate',
							$width:"110px"
						}
					],
				rightTableColumnsRate: [{
							title: "排名",
							key: "id",
							$width:"50px",
						},
						{
							title: '占比',
							key: 'rate',
							$width:"80px"
						}
					],			
				leftTableColumnsReturn: [
						{
							title: '省份',
							key: 'area',
							$width:"100px"
						},
						{
							title: "排名",
							key: "id",
							$width:"50px",
						},
						{
							title: '返奖率',
							key: 'rate',
							$width:"110px"
						}
					],
				rightTableColumnsReturn: [{
							title: "排名",
							key: "id",
							$width:"50px",
						},
						{
							title: '返奖率',
							key: 'rate',
							$width:"80px"
						}
					],	
			};
		},
		onLoad() {
			this.cWidth=uni.upx2px(750);
			this.cHeight=uni.upx2px(500);
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			this.returnFromDatePicker()
			this.getServerData();
			this.showView();
		},
		created() {
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			this.returnFromDatePicker()
			this.getServerData();
			this.showView();
			this.refresh();
		},
		methods: {
			refresh(){
				this.returnFromDatePicker()
				this.getServerData();
				this.showView();
				this.getServerData();
				this.showView();
			},
			showView(){
				try{
					this.$refs['lineData0'].showCharts();
				} catch (e) {
					
				};
				try{
					this.$refs['lineData1'].showCharts();
				} catch (e) {
					
				};
				try{
					this.$refs['lineData2'].showCharts();
				} catch (e) {
					
				};
				try{
					this.$refs['lineData3'].showCharts();
				} catch (e) {
					
				};
				try{
					this.$refs['arcbar0'].showCharts();
				} catch (e) {
					
				};
				try{
					this.$refs['arcbar1'].showCharts();
				} catch (e) {
					
				};
				try{
					this.$refs['arcbar2'].showCharts();
				} catch (e) {
					
				};
				try{
					this.$refs['arcbar3'].showCharts();
				} catch (e) {
					
				};
				try{
					this.$refs['dataContain'].showDataContainer();
				} catch (e) {
					
				};
				try{
					this.$refs['dataContain1'].showDataContainer();
				} catch (e) {
					
				};
				
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
				this.selfParam.token=getApp().globalData.token
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
							 token:getApp().globalData.token }
				}else if(dateType=='week'){
					param = {dateTimeStart: this.selfParam.compareDate.weekLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.weekLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.weekRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.weekRight.endDate,
							 dateFlag:"2",
							 regionId:this.selfParam.provinceCenterId,
							 token:getApp().globalData.token }
				}else if(dateType=='month'){
					param = {dateTimeStart: this.selfParam.compareDate.monthLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.monthLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.monthRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.monthRight.endDate,
							 dateFlag:"3",
							 regionId:this.selfParam.provinceCenterId,
							 token:getApp().globalData.token }
				}else if(dateType=='year'){
					param = {dateTimeStart: this.selfParam.compareDate.yearLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.monthLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.monthRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.monthRight.endDate,
							 dateFlag:"4",
							 regionId:this.selfParam.provinceCenterId,
							 token:getApp().globalData.token }
				}	
				console.log("createParam end:",param)
				return param
			},
			// 获取最上层的两个tab
			getDataSet(){
				var url = '/pentaho/gamesContrast/getGamesContrastSales';
				var param = this.createParam();
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					/* “BK”:[11230, 7815, 1245,4247](篮球销量,篮球票数,对比销量,对比票数),
						“FB”:[11012, 7815, 1245,4247](足球销量,足球票数,对比销量,对比票数) */
					var data = res.data.data;
					var fb =data.fb;
					var bk = data.bk;
					
					//销量 票数 对比销量  对比票数
					var formatfb0=numberFun.formatCNumber(fb[0]);
					var formatfb1=numberFun.formatCNumber(fb[1]);
					var formatfb2=numberFun.formatCNumber(fb[2]);
					var formatfb3=numberFun.formatCNumber(fb[3]);
					
					//销量 票数 对比销量  对比票数
					var formatbk0=numberFun.formatCNumber(bk[0]);
					var formatbk1=numberFun.formatCNumber(bk[1]);
					var formatbk2=numberFun.formatCNumber(bk[2]);
					var formatbk3=numberFun.formatCNumber(bk[3]);
					
					
					var leftfb = {title1:'销量（'+formatfb0.name + ' 元）',amount1:(fb[0]/formatfb0.value).toFixed(2),
								  title2:'票数（'+formatfb1.name + ' 张）',amount2:(fb[1]/formatfb1.value).toFixed(2)};
					var rightfb = {title1:'销量（'+formatfb2.name + ' 元）',amount1:(fb[2]/formatfb2.value).toFixed(2),
								   title2:'票数（'+formatfb3.name + ' 张）',amount2:(fb[3]/formatfb3.value).toFixed(2)};
					var leftbk = {title1:'销量（'+formatbk0.name + ' 元）',amount1:(bk[0]/formatbk0.value).toFixed(2),
								  title2:'票数（'+formatbk1.name + ' 张）',amount2:(bk[1]/formatbk1.value).toFixed(2)};
					var rightbk = {title1:'销量（'+formatbk2.name + ' 元）',amount1:(bk[2]/formatbk2.value).toFixed(2),
								  title2:'票数（'+formatbk3.name + ' 张）',amount2:(bk[3]/formatbk3.value).toFixed(2)};
									
					this.$set(this.basketballData, 'left', leftbk);
					this.$set(this.basketballData, 'right', rightbk);
					this.$set(this.footballData, 'left', leftfb);
					this.$set(this.footballData, 'right', rightfb);
					try{
						this.$refs['dataContain'].showDataContainer();
					} catch (e) {
						
					};
					try{
						this.$refs['dataContain1'].showDataContainer();
					} catch (e) {
						
					};
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			getLinesData(){
				var url = '/pentaho/gamesContrast/getComGamesTrendChart';
				var param =this.createParam();
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					
					var data = res.data.data;
					if(data==null || data.length==0){
						return;
					}
					//篮球
					var salesbk = data.BK.sales
					var datesbk = data.BK.dates
					var votesbk = data.BK.votes
					var comSalesbk = data.comBK.sales
					var comDatesbk = data.comBK.dates
					var comVotesbk = data.comBK.votes
					
					var categories=[];
					
					//确定最大值
					var maxAmount = 0;
					var maxVote = 0;
					for(var i=0;i<datesbk.length;i++){	
						if(maxAmount<salesbk[i]){
							maxAmount = salesbk[i]
						}
						if(maxVote<votesbk[i]){
							maxVote = votesbk[i]
						}
					}
					this.amountFormat = numberFun.formatCNumber(maxAmount);
					this.voteFormat= numberFun.formatCNumber(maxVote);
					var amountDatabk=[];
					var volDatabk = [];
					for(var i=0;i<datesbk.length;i++){
						categories[i] = datesbk[i];
						amountDatabk[i] = (salesbk[i]/this.amountFormat.value).toFixed(2);
						volDatabk[i] = (votesbk[i]/this.voteFormat.value).toFixed(2);
					}
					var amountDatabkc=[];
					var volDatabkc = [];
					for(var i=0;i<comDatesbk.length;i++){
						amountDatabkc[i] = (comSalesbk[i]/this.amountFormat.value).toFixed(2);
						volDatabkc[i] = (votesbk[i]/this.voteFormat.value).toFixed(2);
					}
					
					var series = [ {'name':this.selfParam.compareDate.viewLeft +'销量','data':amountDatabk},
								   {'name':this.selfParam.compareDate.viewRight +'销量','data':amountDatabkc}];
					
					this.$set(this.lineData2, 'categories', categories);
					this.$set(this.lineData2, 'series', series);
					
					var series2 = [{'name':this.selfParam.compareDate.viewLeft +'票数','data':volDatabk},
								   {'name':this.selfParam.compareDate.viewRight +'票数','data':volDatabkc}];
					this.$set(this.lineData3, 'categories', categories);
					this.$set(this.lineData3, 'series', series2);
					try{
						this.$refs['lineData2'].showCharts();
					} catch (e) {
						
					};
					try{
						this.$refs['lineData3'].showCharts();
					} catch (e) {
						
					};
					//足球
					var salesfb = data.FB.sales
					var datesfb = data.FB.dates
					var votesfb = data.FB.votes
					var comSalesfb = data.comFB.sales
					var comDatesfb = data.comFB.dates
					var comVotesfb = data.comFB.votes
					
					//确定最大值
					var maxAmount1 = 0;
					var maxVote1 = 0;
					for(var i=0;i<datesfb.length;i++){	
						if(maxAmount1<salesbk[i]){
							maxAmount1 = salesbk[i]
						}
						if(maxVote1<votesbk[i]){
							maxVote1= votesbk[i]
						}
					}
					
					var categories1=[];
					
					this.amountFormat = numberFun.formatCNumber(maxAmount1);
					this.voteFormat= numberFun.formatCNumber(maxVote1);
					var amountDatafb=[];
					var volDatafb = [];
					for(var i=0;i<datesfb.length;i++){
						categories1[i] = datesbk[i];
						amountDatafb[i] = (salesbk[i]/this.amountFormat.value).toFixed(2);
						volDatafb[i] = (votesbk[i]/this.voteFormat.value).toFixed(2);
					}
					var amountDatafbc=[];
					var volDatafbc = [];
					for(var i=0;i<comDatesfb.length;i++){
						amountDatafbc[i] = (comSalesfb[i]/this.amountFormat.value).toFixed(2);
						volDatafbc[i] = (votesfb[i]/this.voteFormat.value).toFixed(2);
					}
					
					var series0 = [ {'name':this.selfParam.compareDate.viewLeft +'销量','data':amountDatafb},
								   {'name':this.selfParam.compareDate.viewRight +'销量','data':amountDatafbc}];
					
					this.$set(this.lineData0, 'categories', categories1);
					this.$set(this.lineData0, 'series',series0);
					
					var series1 = [{'name':this.selfParam.compareDate.viewLeft +'票数','data':volDatafb},
								   {'name':this.selfParam.compareDate.viewRight +'票数','data':volDatafbc}];
					this.$set(this.lineData1, 'categories', categories1);
					this.$set(this.lineData1, 'series', series1);
					try{
						this.$refs['lineData0'].showCharts();
					} catch (e) {
						
					};
					try{
						this.$refs['lineData1'].showCharts();
					} catch (e) {
						
					};
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			},
			getRingData(){
				var url = '/pentaho/gamesContrast/getGamesContrastSalesProp';
				var param =this.createParam();
				param.gameFlag=1;
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					var datas =res.data.data;
					
					var games =datas.games;
					var comGames=datas.comGames
				
					var series =[];
					var series1 =[];
					for(var i=0;i<games.length;i++){
						var obj={name:games[i].gameName,data: games[i].values[0]};
						//返回的顺序不一样
						series.push(obj);
					}
					for(var i=0;i<comGames.length;i++){
						//返回的顺序不一样
						var obj1={name:comGames[i].gameName,data: comGames[i].values[0]};
						series1.push(obj1);
					}
					this.$set(this.arcbar0,'series',series);
					this.$set(this.arcbar2,'series',series1);
					try{
						this.$refs['arcbar0'].showCharts();
					} catch (e) {
						
					};
					try{
						this.$refs['arcbar2'].showCharts();
					} catch (e) {
						
					};
					if(games.length>comGames.length){
						//处理总得
						for(var i=0;i<games.length;i++){
							var num=numberFun.formatCNumber(games[i].values[0]);
							var objAll={name:games[i].gameName,
										left:{
											title1:'占比',
											amount1:this.valueToPercent(games[i].values[1]),
											title2:'销量',
											amount2:(games[i].values[0]/num.value).toFixed(2)+num.name+'元'
										},
										right:{
											title1:'占比',
											amount1: 0,
											title2:'销量',
											amount2:0
										}};
							var right={};
							for(var j=0;j<comGames.length;j++){
								if(comGames[j].gameName==games[i].gameName){
									right={
										title1:'占比',
										amount1: this.valueToPercent(comGames[j].values[1]),
										title2:'销量',
										amount2:(comGames[j].values[0]/num.value).toFixed(2)+num.name+'元'
									}
								}
							}
							objAll.right=right;
							this.arcbarAll0[i]=objAll
							}
						}else {
							//处理总得
							for(var i=0;i<comGames.length;i++){
								var num=numberFun.formatCNumber(comGames[i].values[0]);
								var objAll={name:comGames[i].gameName,
											left:{
												title1:'占比',
												amount1:0,
												title2:'销量',
												amount2:0
											},
											right:{
												title1:'占比',
												amount1: 0,
												title2:'销量',
												amount2:0
											}};
								var left={};
								for(var j=0;j<games.length;j++){
									if(games[j].gameName==comGames[i].gameName){
										right={
											title1:'占比',
											amount1: this.valueToPercent(games[j].values[1]),
											title2:'销量',
											amount2:(games[j].values[0]/num.value).toFixed(2)+num.name+'元'
										}
									}
								}
								objAll.right=right;
								this.arcbarAll0[i]=objAll
							}
						}
				
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail+++++++++++++++++++', err);
				
				});
				param =this.createParam();
				param.gameFlag=2;
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					var datas =res.data.data;
					
					var games =datas.games;
					var comGames=datas.comGames
					
					var series =[];
					var series1 =[];
					for(var i=0;i<games.length;i++){
						var obj={name:games[i].gameName,data: games[i].values[0]};
						series.push(obj);
					}
					
					for(var i=0;i<comGames.length;i++){
						var obj1={name:comGames[i].gameName,data: comGames[i].values[0]};
						series1.push(obj1);
					}
					
					this.$set(this.arcbar1,'series',series);
					this.$set(this.arcbar3,'series',series1);
					try{
						this.$refs['arcbar1'].showCharts();
					} catch (e) {
						
					};
					try{
						this.$refs['arcbar3'].showCharts();
					} catch (e) {
						
					};
					if(games.length>comGames.length){
						//处理总得
						for(var i=0;i<games.length;i++){
							var num=numberFun.formatCNumber(games[i].values[0]);
							var objAll={name:games[i].gameName,
										left:{
											title1:'占比',
											amount1:this.valueToPercent(games[i].values[1]),
											title2:'销量',
											amount2:(games[i].values[0]/num.value).toFixed(2)+num.name+'元'
										},
										right:{
											title1:'占比',
											amount1: 0,
											title2:'销量',
											amount2:0
										}};
							var right={};
							for(var j=0;j<comGames.length;j++){
								if(comGames[j].gameName==games[i].gameName){
									right={
										title1:'占比',
										amount1: this.valueToPercent(comGames[j].values[1]),
										title2:'销量',
										amount2:(comGames[j].values[0]/num.value).toFixed(2)+num.name+'元'
									}
								}
							}
							objAll.right=right;
							this.arcbarAll2[i]=objAll
						}
					}else {
						//处理总得
						for(var i=0;i<comGames.length;i++){
							var num=numberFun.formatCNumber(comGames[i].values[0]);
							var objAll={name:comGames[i].gameName,
										left:{
											title1:'占比',
											amount1:0,
											title2:'销量',
											amount2:0
										},
										right:{
											title1:'占比',
											amount1: 0,
											title2:'销量',
											amount2:0
										}};
							var left={};
							for(var j=0;j<games.length;j++){
								if(games[j].gameName==comGames[i].gameName){
									right={
										title1:'占比',
										amount1: this.valueToPercent(games[j].values[1]),
										title2:'销量',
										amount2:(games[j].values[0]/num.value).toFixed(2)+num.name+'元'
									}
								}
							}
							objAll.right=right;
							this.arcbarAll2[i]=objAll
						}
					}
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail+++++++++++++++++++========', err);
				});
			},
			loadTableData(){
				//各地区足篮球销量及占比对比
				var url = '/pentaho/gamesContrast/getComGameSalesRanking';
				var param =this.createParam();
				param.gameFlag=1;
				urlAPI.getRequest(url, param).then((res)=>{
					var data =res.data.data;
					
					for(var i=0;i<data.length;i++){
						var num=numberFun.formatCNumber(data[i][3]);
						var obj={area:util.formatToolongName(data[i][0]),
								id:data[i][1],
								amount:(data[i][3]/num.value).toFixed(2),
								}
						var objC={
								id:data[i][4],
								amount:(data[i][6]/num.value).toFixed(2),
								}
						var objRate={area:data[i][0],
								id:data[i][1],
								rate:this.valueToPercent(data[i][2]),
								}
						var cellClassName={};
						if(data[i][2]<0){
							cellClassName.rate='small-text-green'
						}else{
							cellClassName.rate='small-text-red'
						}
						objRate.cellClassName=cellClassName;			
						var objRateC={area:util.formatToolongName(data[i][0]),
								id:data[i][1],
								rate:this.valueToPercent(data[i][5]),
								}
						if(data[i][5]<0){
							cellClassName.rate='small-text-green'
						}else{
							cellClassName.rate='small-text-red'
						}
						objRateC.cellClassName=cellClassName;																
						if(i<5){
							this.leftTableData[i] = obj;
							this.rightTableData[i] = objC;
						}
						this.leftTableDataAll[i] = obj;
						this.rightTableDataAll[i] = objC;
						this.leftTableDataRateAllfb[i]=objRate;
						this.rightTableDataRateAllfb[i]=objRateC;
					}
					
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				param =this.createParam();
				param.gameFlag=2;
				urlAPI.getRequest(url, param).then((res)=>{
					var data =res.data.data;
					for(var i=0;i<data.length;i++){
						var num=numberFun.formatCNumber(data[i][3]);
						var obj={area:util.formatToolongName(data[i][0]),
								id:data[i][1],
								amount:(data[i][3]/num.value).toFixed(2),
								}
						var objC={
								id:data[i][4],
								amount:(data[i][6]/num.value).toFixed(2),
								}
						var objRate={area:util.formatToolongName(data[i][0]),
								id:data[i][1],
								rate:this.valueToPercent(data[i][2]),
								}
						var cellClassName={};
						if(data[i][2]<0){
							cellClassName.rate='small-text-green'
						}else{
							cellClassName.rate='small-text-red'
						}
						objRate.cellClassName=cellClassName;			
						var objRateC={area:util.formatToolongName(data[i][0]),
								id:data[i][1],
								rate:this.valueToPercent(data[i][5]),
								}
						if(data[i][5]<0){
							cellClassName.rate='small-text-green'
						}else{
							cellClassName.rate='small-text-red'
						}
						objRateC.cellClassName=cellClassName;															
						if(i<5){
							this.leftTableData2[i] = obj;
							this.rightTableData2[i] = objC;
						}
						this.leftTableDataAll2[i] = obj;
						this.rightTableDataAll2[i] = objC;
						this.leftTableDataRateAllbk[i]=objRate;
						this.rightTableDataRateAllbk[i]=objRateC;
					}
					
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				
				//返奖率
				url = '/pentaho/gamesContrast/getComReturnRateRanking';
				param =this.createParam();
				param.gameFlag=1;
				urlAPI.getRequest(url, param).then((res)=>{
					var data =res.data.data;
					
					for(var i=0;i<data.length;i++){
						var num=numberFun.formatCNumber(data[i][3]);
						var obj={area:util.formatToolongName(data[i][0]),
								id:data[i][1],
								rate:this.valueToPercent(data[i][2]),
								}
						var cellClassName={};		
						if(data[i][2]<0){
							cellClassName.rate='small-text-green'
						}else{
							cellClassName.rate='small-text-red'
						}
						obj.cellClassName=cellClassName;	
						var cellClassName2={};	
						var objC={
								id:data[i][3],
								rate:this.valueToPercent(data[i][4]),
								}
						if(data[i][4]<0){
							cellClassName2.rate='small-text-green'
						}else{
							cellClassName2.rate='small-text-red'
						}
						objC.cellClassName=cellClassName2;	
						if(i<5){
							this.leftTableData1[i] = obj;
							this.rightTableData1[i] = objC;
						}
						this.leftTableDataAll1[i] = obj;
						this.rightTableDataAll1[i] = objC;	
					}
					
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				
				url = '/pentaho/gamesContrast/getComReturnRateRanking';
				param =this.createParam();
				param.gameFlag=2;
				urlAPI.getRequest(url, param).then((res)=>{
					var data =res.data.data;
					
					for(var i=0;i<data.length;i++){
						var num=numberFun.formatCNumber(data[i][3]);
						var obj={area:util.formatToolongName(data[i][0]),
								id:data[i][1],
								rate:this.valueToPercent(data[i][2]),
								}
						var cellClassName={};		
						if(data[i][2]<0){
							cellClassName.rate='small-text-green'
						}else{
							cellClassName.rate='small-text-red'
						}
						obj.cellClassName=cellClassName;	
						var objC={
								id:data[i][3],
								rate:this.valueToPercent(data[i][4]),
								}
						var cellClassName2={};		
						if(data[i][4]<0){
							cellClassName2.rate='small-text-green'
						}else{
							cellClassName2.rate='small-text-red'
						}
						objC.cellClassName=cellClassName2;	
						if(i<5){
							this.leftTableData3[i] = obj;
							this.rightTableData3[i] = objC;
						}
						this.leftTableDataAll3[i] = obj;
						this.rightTableDataAll3[i] = objC;	
					}
					
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail++++++++++++++++', err);
				});
				
				
			},
			getServerData() {
				this.getDataSet();
				this.getLinesData();
				this.getRingData();
				this.loadTableData()
			},
			change(e) {
			      this.btnnum = e
				  this.refresh();
			},
			changeTop(e) {
			     this.arcbarNumTop = e
				  this.refresh();
			},
			toAll1(){
				var dataAllleft={};
				var dataAllright={};
				if(this.arcbarNumTop =='篮球'){
					dataAllleft = this.leftTableDataAll3
					dataAllright =this. rightTableDataAll3
				}else {
					dataAllleft =this.leftTableDataAll1
					dataAllright = this.rightTableDataAll1
				}
				uni.navigateTo({
					url:'/pages/common/tableDetail3?leftTableColumns='+JSON.stringify(this.leftTableColumnsReturn)
					+'&rightTableColumns='+JSON.stringify(this.rightTableColumnsReturn)
					+'&rightTableData='+JSON.stringify(dataAllright)
					+'&leftTableData='+JSON.stringify(dataAllleft),
				});
			},
			toAll(){
				//需要将销量和对比都传过去
				var dataAllleft={};
				var dataAllright={};
				var dataAllleft1={};
				var dataAllright1={};
				if(this.arcbarNumTop =='篮球'){
					dataAllleft = this.leftTableDataAll2
					dataAllright = this.rightTableDataAll2
					dataAllleft1 = this.leftTableDataRateAllbk
					dataAllright1 = this.rightTableDataRateAllbk
				}else {
					dataAllleft =this.leftTableDataAll
					dataAllright = this.rightTableDataAll
					dataAllleft1 = this.leftTableDataRateAllfb
					dataAllright1 = this.rightTableDataRateAllfb
				}
				uni.navigateTo({
					url:'/pages/common/tableDetail4?leftTableColumns='+JSON.stringify(this.leftTableColumns)
					+'&rightTableColumns='+JSON.stringify(this.rightTableColumns)
					+'&rightTableData='+JSON.stringify(dataAllright)
					+'&leftTableData='+JSON.stringify(dataAllleft)
					+'&leftTableColumns1='+JSON.stringify(this.leftTableColumnsRate)
					+'&rightTableColumns1='+JSON.stringify(this.rightTableColumnsRate)
					+'&rightTableData1='+JSON.stringify(dataAllright1)
					+'&leftTableData1='+JSON.stringify(dataAllleft1),
				});
			},
			toRingAll(){
				if(this.arcbarNumTop =='篮球'){
					uni.navigateTo({
						url:"/pages/common/ringDetailTwo?type=game&leftPie=" + JSON.stringify(this.arcbar1) + "&rightPie="+ JSON.stringify(this.arcbar3)
					});
				}else {
					uni.navigateTo({
						url:"/pages/common/ringDetailTwo?type=game&leftPie=" + JSON.stringify(this.arcbar0) + "&rightPie="+ JSON.stringify(this.arcbar2)
					});
				}
			},	
			valueToPercent(value) {
				if(value>=0){
					value = "+" + value + "%";
				}else{
					value = value + "%";
				}
				return value;
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
		line-height: 40px; 
		flex-direction: row;
		font-weight: bold;
		border-color:#FFFFFF;
	}
	
	.title {
		line-height: 40px;
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
		padding: 20rpx 0rpx 20rpx 0rpx;
	}
	
	.arcbarChart-title{
		display: flex;
		justify-content:space-between;
	}

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
	} 
	.hide{
		color: #000000;
		background: #FFFFFF;
		padding:0px 30rpx 0px 30rpx;
	}
	.small-text-green{
		color: #00FF00;
	}
	
	.small-text-red{
		color: #FF0000;
	}
	.left-row-box {
		display: flex;
		width: 65%;
		margin: 0rpx 5rpx;
		flex-direction: column;
	}
	.right-row-box {
		display: flex;
		width: 35%;
		margin: 0rpx;
		flex-direction: column;
	}
	.sale-row-2{
		display: flex;
		flex-direction: row;	
		margin: 20rpx 10rpx;
	}
	.example {
		/* line-height: 40px; */
		width: 100%;
		display: flex;
		font-weight: bold;
		border-color:#FFFFFF;
	}
</style>
