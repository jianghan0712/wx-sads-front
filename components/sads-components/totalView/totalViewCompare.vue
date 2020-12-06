<template>
	<view>
		<view class="box-contaniner">
			<dataContainerTwoCol ref="dataContain" :dataAs="topData"></dataContainerTwoCol>
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
		
		<!-- 竞彩足篮球销量及占比对比区域 -->
		<view class="box-contaniner">
			<view class="shop-title">竞彩足篮球销量及占比对比</view>
			<dataContainerTwoColTwo></dataContainerTwoColTwo>
		</view>		
		
		<!-- 门店在售情况-->
		<view class="box-contaniner">
			<view class="shop-title">门店在售情况对比</view>
			<dataContainerTwoCol ref="dataContain" ></dataContainerTwoCol>
		</view>
		
		<!-- 各地区销量排行-->
		<view class="box-contaniner">
			<view class="rankTable-title">
				<view>各地区销量排行榜对比</view>
				<view class="rankTable-more" @click="goSaleRank(leftTableData,leftTableColumns)">全部>></view>
			</view>
			<view class="example">
				<view class="sale-row-2">
					<view class="left-row-box">
						<v-table :columns="leftTableColumns" :list="leftTableData"  border-color="#FFFFFF"></v-table>
					</view>
					<view class="right-row-box">
						<v-table :columns="rightTableColumns" :list="rightTableData"  border-color="#FFFFFF"></v-table>
					</view>
				</view>			
			</view>
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
	
	export default {
		name: 'Index',
		components: {
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
				topData:{	left:{title1:'销量（万）',amount1:0,title2:'票数（张）',amount2:0},
							right:{title1:'销量（万）',amount1:0,title2:'票数（张）',amount2:0}},			
				footballData:{},	
				basketballData:{},	
				btnnum: 0,
				lineData2: {},
				lineData1: {},
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
			this.showView();
		},
		created() {		
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam")) 
			//ajax调用
			this.getServerData();	
		},
		methods: {
			getServerData() {
				this.getDataSet();
				// this.getLinesData(this.param.provinceCenterId,this.param.businessDate);
				// this.getDataContainerTwo('足球',this.param.provinceCenterId,this.param.businessDate,this.param.cityCenterId);
				// this.getDataContainerTwo('篮球',this.param.provinceCenterId,this.param.businessDate,this.param.cityCenterId);
			},
			showView(){
				this.$nextTick(() => {				
					// this.$refs['lineData2'].showCharts();
					// this.$refs['lineData1'].showCharts();
					this.$refs['dataContain'].showDataContainer();
					// this.$refs['dataContain2'].showDataContainer();
					// this.$refs['dataContain3'].showDataContainer();
				});
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
							 token:this.selfParam.token }
				}else if(dateType=='week'){
					param = {dateTimeStart: this.selfParam.compareDate.weekLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.weekLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.weekRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.weekRight.endDate,
							 dateFlag:"2",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='month'){
					param = {dateTimeStart: this.selfParam.compareDate.monthLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.monthLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.monthRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.monthRight.endDate,
							 dateFlag:"3",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='year'){
					param = {dateTimeStart: this.selfParam.compareDate.yearLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.monthLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.monthRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.monthRight.endDate,
							 dateFlag:"4",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}	
				console.log("createParam end:",param)
				return param
			},
			// 获取最上层的两个tab
			getDataSet(){
				var url = '/pentaho/salesContrast/getContrastSales';
				var param = this.createParam()
				
				urlAPI.getRequest(url, param).then((res)=>{
					setTimeout(() => { 
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
							
							var left = {'title1':'销量（'+format00.name +'元）', 'amount1':amount1/format00.value, 'title2':'票数（'+format01.name +'张）', 'amount2':saleNumber1/format01.value};
							var right = {'title1':'销量（'+format10.name +'元）', 'amount1':amount1/format10.value, 'title2':'票数（'+format11.name +'张）', 'amount2':saleNumber2/format11.value};
						
							this.$set(this.topData, 'left', left);
							this.$set(this.topData, 'right', right);
							console.log('request topData', this.topData);
							
							this.res = '请求结果 : ' + JSON.stringify(res);
						}).catch((err)=>{
							this.loading = false;
							uni.showToast({
								title: err.errMsg,
								duration: 5000
							});
							console.log('request fail', err);
						})						
					}, 10000);
			},
			getLinesData(provinceCenterId, businessDate){
				var url = 'mobile/sales/getSalesTodayByHour/' + provinceCenterId+'/' + businessDate;
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
			getDataContainerTwo(type, provinceCenterId, businessDate, cityCenterId){
				var url=''
				if(type=='足球'){
					url = '/exhibition/gameSales/queryGameSalesOfFb/' + businessDate + '/' + provinceCenterId + '/' + cityCenterId;
				}else{
					url = '/exhibition/gameSales/queryGameSalesOfBk/' + businessDate + '/' + provinceCenterId + '/' + cityCenterId;
				}
				var big1 = {'name':'销量'};
				var left1 = {'name':'周同比'};
				var right1 = {'name':'环比'};				
				
				var big2 = {'name':'占比'};
				var left2 = {'name':'周同比'};
				var right2 = {'name':'环比'};
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
					left1.value = (data[0]/data[1]-1).toFixed(4);
					right1.value = -0.3111;
					big1.value = amount;
					big1.left = left1;
					big1.right = right1;
					
					big2.value = 0.63;
					left2.value = -0.0132;
					right2.value = 0.1069;
					big2.left = left2;
					big2.right = right2;					
					
					if(type=='足球'){
						this.$set(this.footballData, 'big1', big1);
						this.$set(this.footballData, 'big2', big2);
					}else{
						this.$set(this.basketballData, 'big1', big1);
						this.$set(this.basketballData, 'big2', big2);
					}
					
					// console.log('request basketballData', this.basketballData);
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			},

			change(e) {
			      this.btnnum = e
			      console.log(this.btnnum)
			},
			changeArcbar(e){
				this.arcbarNum = e
				console.log(this.arcbarNum)
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
