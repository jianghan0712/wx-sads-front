<template>
	<view>
		<view class="box-contaniner">
			<view class="container-title">单票金额对比</view>
			<dataContainerTwoColThree ref="compareAmount" ></dataContainerTwoColThree>
		</view>
		
		<block v-if="selfParam.compareDate.dateType!='date'">
			<view class="box-contaniner">
				<view class="container-title">单票金额走势对比</view>
				<view class="shop-title">{{selfParam.compareDate.viewLeft}}竞彩单票金额走势</view>
				<line-chart ref="lineData1" canvasId="index_line_1" :dataAs="lineData1" 
							:xAxisAs="{scrollShow:false}" />
			</view>	
			<view class="box-contaniner">
				<view class="shop-title">{{selfParam.compareDate.viewRight}}竞彩单票金额走势</view>
				<line-chart ref="lineData2" canvasId="index_line_2" :dataAs="lineData2" 
							:xAxisAs="{scrollShow:false}" />
			</view>	
		</block>
		
		<view class="box-contaniner">
			<view class="container-title">各票面区间的票数及占比对比</view>
			<view class="tab-content">
				<view class="tab-title">
					<view @tap="change(0)" :class="btnnum == 0?'btna':'hide'">竞彩</view>
				　　<view @tap="change(1)" :class="btnnum == 1?'btna':'hide'">足球</view>
				  　<view @tap="change(2)" :class="btnnum == 2?'btna':'hide'">篮球</view>
				</view>	
				<view class="end-cont" :class="{dis:btnnum == 0}">	
					<view class="ring_chart">
						<ring-chart  ref="pieData" :dataAs="pieData" canvasId="index_ring_0"/>
					</view>
					<view class="ring_chart">
						<ring-chart ref="pieData3" :dataAs="pieData3"  canvasId="index_ring_3"/>
					</view>
				</view>
				<view class="end-cont" :class="{dis:btnnum == 1}">
					<view class="ring_chart">
						<ring-chart  ref="pieData1" :dataAs="pieData1" canvasId="index_ring_1"/>
					</view>
					<view class="ring_chart">
						<ring-chart ref="pieData4"  :dataAs="pieData4" canvasId="index_ring_4"/>
					</view>
				</view>
				<view class="end-cont" :class="{dis:btnnum == 2}">
					<view class="ring_chart">
						<ring-chart  ref="pieData2" :dataAs="pieData2" canvasId="index_ring_2"/>
					</view>		
					<view class="ring_chart">
						<ring-chart ref="pieData5" :dataAs="pieData5" canvasId="index_ring_5"/>
					</view>	
				</view>
				<button type="default" plain="true" @click="gotoLunBo(btnnum)">查看全部</button>
			</view>
		</view>
		
		<view class="box-contaniner">
			<view class="container-title">
				<view>各地区单票金额</view>
				<view @click="gotoRankAll()">全部>></view>
			</view>
			<view class="tab-content">
				<view class="tab-title">
					<view @tap="changeTable(0)" :class="tableIndex == 0?'btna':'hide'">竞彩</view>
				　　<view @tap="changeTable(1)" :class="tableIndex == 1?'btna':'hide'">足球</view>
				  　<view @tap="changeTable(2)" :class="tableIndex == 2?'btna':'hide'">篮球</view>
				</view>	

				<view class="end-cont" :class="{dis:tableIndex == 0}">
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
					<!-- <view class="table">
						<v-table :columns="tableColumns" :list="tableData"  border-color="#FFFFFF"></v-table>
					</view> -->
				</view>
				<view class="end-cont" :class="{dis:tableIndex == 1}">
					<view class="example">
						<view class="sale-row-2">
							<view class="left-row-box">
								<v-table :columns="leftTableColumnsFB" :list="leftTableDataFB"  border-color="rgba(220, 241, 250 ,0.5)"></v-table>
							</view>
							<view class="right-row-box">
								<v-table :columns="rightTableColumnsFB" :list="rightTableDataFB"  border-color="#FFFFFF"></v-table>
							</view>
						</view>			
					</view>
					<!-- <view class="table">
						<v-table :columns="tableColumnsFB" :list="tableDataFB"  border-color="#FFFFFF"></v-table>
					</view> -->
				</view>
				<view class="end-cont" :class="{dis:tableIndex == 2}">
					<view class="example">
						<view class="sale-row-2">
							<view class="left-row-box">
								<v-table :columns="leftTableColumnsBK" :list="leftTableDataBK"  border-color="rgba(220, 241, 250 ,0.5)"></v-table>
							</view>
							<view class="right-row-box">
								<v-table :columns="rightTableColumnsBK" :list="rightTableDataBK"  border-color="#FFFFFF"></v-table>
							</view>
						</view>			
					</view>
					<!-- <view class="table">
						<v-table :columns="tableColumnsBK" :list="tableDataBK"  border-color="#FFFFFF"></v-table>
					</view> -->
				</view>
			</view>
		</view>

		<slot />
	</view>	
</template>

<script>
	import RingChart from "@/components/basic-chart/RingChart.vue";
	import dataContainerTwoColThree from '@/components/sads-components/dataContainerTwoColThree.vue';
	import vTable from "@/components/table/table.vue";
	import urlAPI from '@/common/vmeitime-http/';
	import numberFun from '@/common/tools/number.js';
	import dateUtils from '@/common/tools/dateUtils.js';
	import LineChart from '@/components/basic-chart/LineChart.vue';
	import AreaChart from '@/components/basic-chart/AreaChart.vue';
	
	export default {
		components: {
			RingChart,vTable,dataContainerTwoColThree,LineChart,AreaChart
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
					selfProvinceCenterId:''//存登录时候的id
				},
				btnnum: 0,
				tableIndex:0,
				pieData: {},
				pieData1: {},
				pieData2: {},
				pieData3: {},
				pieData4: {},
				pieData5: {},
				lineData1:{},
				lineData2:{},
				
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
							title: '竞彩（元）',
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
							title: '竞彩（元）',
							key: 'amount',
							$width:"80px"
						}
				],

				leftTableDataFB: [],
				rightTableDataFB: [],
				leftTableDataDetailFB: [],
				rightTableDataDetailFB: [],
				leftTableColumnsFB: [{
							title: '省份',
							key: 'area',
							$width:"100px"
						},{
							title: "排名",
							key: "id",
							$width:"50px",
						},{
							title: '足球（元）',
							key: 'amount',
							$width:"100px"
						}
				],
				rightTableColumnsFB: [{
							title: "排名",
							key: "id",
							$width:"50px",
						},
						{
							title: '足球（元）',
							key: 'amount',
							$width:"80px"
						}
				],

				leftTableDataBK: [],
				rightTableDataBK: [],
				leftTableDataDetailBK: [],
				rightTableDataDetailBK: [],
				leftTableColumnsBK: [{
							title: '省份',
							key: 'area',
							$width:"100px"
						},{
							title: "排名",
							key: "id",
							$width:"50px",
						},{
							title: '篮球（元）',
							key: 'amount',
							$width:"100px"
						}
				],
				rightTableColumnsBK: [{
							title: "排名",
							key: "id",
							$width:"50px",
						},
						{
							title: '篮球（元）',
							key: 'amount',
							$width:"80px"
						}
				],

				compareAmount:{
					title:{nameOne:'竞彩单票金额（元）',nameTwo:'足球单票金额（元）',nameThree:'篮球单票金额（元）'},
					left:{valueOne:0,valueTwo:0,valueThree:0},
					right:{valueOne:0,valueTwo:0,valueThree:0},
				},
			}
		},
		onLoad() {
			// _self = this;
			// this.getServerData();
			this.showView()
		},
		created() {
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			this.getServerData();
			this.showView();
		},
		methods: {
			showView(){
				// console.log("ticket showView" ,this.pieData);
				// this.$nextTick(() => {		
				// 	this.$refs['pieData'].showCharts();
				// 	this.$refs['pieData1'].showCharts();
				// 	this.$refs['pieData2'].showCharts();
				// 	this.$refs['pieData3'].showCharts();
				// 	this.$refs['pieData4'].showCharts();
				// 	this.$refs['pieData5'].showCharts();

				// 	this.$refs['compareAmount'].showDataContainer(this.compareAmount);
				// });
			},
			getServerData() {
				this.getPieData('竞彩');
				this.getPieData('足球');
				this.getPieData('篮球');
				this.getRankTable('竞彩');
				this.getRankTable('足球');
				this.getRankTable('篮彩');
				this.getAmountCompare()
				this.getLineData(true)
				this.getLineData(false)
			},
			change(e) {
			    this.btnnum = e;
			    if(0==e){
			    	this.getPieData('竞彩');
					this.$refs['pieData'].showCharts();
					this.$refs['pieData1'].showCharts();
			    }else if(1==e){
			    	this.getPieData('足球');
					this.$refs['pieData2'].showCharts();
					this.$refs['pieData3'].showCharts();
			    }else if(2==e){
			    	this.getPieData('篮球');
					this.$refs['pieData4'].showCharts();
					this.$refs['pieData5'].showCharts();
			    }
				this.showView();
			},
			changeTable(e){
				this.tableIndex = e;
				console.log(this.tableIndex);
			},
			createParam2(isLeft){
				console.log("createParam begin")
				var dateType = this.selfParam.compareDate.dateType
				var param = {}
				if(dateType=='date'){
					param = {dateTimeStart: isLeft ? this.selfParam.compareDate.dateLeft.startDate :this.selfParam.compareDate.dateRight.startDate,
							 dateTimeEnd: isLeft ? this.selfParam.compareDate.dateLeft.endDate :this.selfParam.compareDate.dateRight.endDate,
							 dateFlag:"1",
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}else if(dateType=='week'){
					param = {dateTimeStart: isLeft ? this.selfParam.compareDate.weekLeft.startDate :this.selfParam.compareDate.weekRight.startDate,
							 dateTimeEnd: isLeft ? this.selfParam.compareDate.weekLeft.endDate :this.selfParam.compareDate.weekRight.endDate,
							 dateFlag:"2",
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}else if(dateType=='month'){
					param = {dateTimeStart: isLeft ? this.selfParam.compareDate.monthLeft.startDate :this.selfParam.compareDate.monthRight.startDate,
							 dateTimeEnd: isLeft ? this.selfParam.compareDate.monthLeft.endDate :this.selfParam.compareDate.monthRight.endDate,
							 dateFlag:"3",
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}else if(dateType=='year'){
					param = {dateTimeStart: isLeft ? this.selfParam.compareDate.yearLeft.startDate :this.selfParam.compareDate.yearRight.startDate,
							 dateTimeEnd: isLeft ? this.selfParam.compareDate.yearLeft.endDate :this.selfParam.compareDate.yearRight.endDate,
							 dateFlag:"4",
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}	
				console.log("createParam end:",param)
				return param
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
							 dateTimeEnd: this.selfParam.compareDate.yearLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.yearRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.yearRight.endDate,
							 dateFlag:"4",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}	
				console.log("createParam end:",param)
				return param
			},
			getAmountCompare(){
				var url = '/pentaho/proValue/getSingleVoteMoneyCom';
				var param = this.createParam();
				
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)

					var data = res.data.data;
					if(data==null){
						this.$refs['compareAmount'].showDataContainer(this.compareAmount);
						return
					}
					// var format0 = numberFun.formatCNumber(data[0]);
					// var format1 = numberFun.formatCNumber(data[1]);
					// var format2 = numberFun.formatCNumber(data[2]);
					var title = {'nameOne':'竞彩单票金额（元）', 'nameTwo':'足球单票金额（元）','nameThree':'篮球单票金额（元）'}
					var left = {'valueOne':data[0] , 'valueTwo':data[1] ,'valueThree':data[2] }
					var right = {'valueOne':data[3] , 'valueTwo':data[4] ,'valueThree':data[5] }
					this.compareAmount.title = title
					this.compareAmount.left = left
					this.compareAmount.right = right
					// this.$set(this.compareAmount, 'title', title);
					// this.$set(this.compareAmount, 'left', left);
					// this.$set(this.compareAmount, 'right', right);
					this.$refs['compareAmount'].showDataContainer(this.compareAmount);

					console.log('request ticketData', this.compareAmount);				
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			getPieData(type){
				var url = '/pentaho/proValue/getProValueVotesPropCom';
				var param = this.createParam();
				var that =this;
				if(type=='竞彩'){
					param.gameFlag = 0
				}else if(type=='足球'){
					param.gameFlag = 1
				}else if(type=='篮球'){
					param.gameFlag = 2
				}
				
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					
					var data = res.data.data;
					if(data==null){
						return
					}
					var votes = data.votes
					var comVotes = data.comVotes
					
					var list=[];	
					var compareList=[]
					for(var i=0; i<votes.length; i++){
						list[i]={name:votes[i].proValueName,data:votes[i].values[0]};
						compareList[i]={name:comVotes[i].proValueName,data:comVotes[i].values[0]};
					}
					console.log("ticket compare list:",list)
					console.log("ticket compare compareList:",compareList)
					
					if(type=='竞彩'){
						that.pieData.series = list
						that.pieData3.series = compareList
						this.$refs['pieData'].showCharts();	
						this.$refs['pieData3'].showCharts();	
					}else if(type=='足球'){
						that.pieData1.series = list
						that.pieData4.series = compareList
						this.$refs['pieData1'].showCharts();
						this.$refs['pieData4'].showCharts();
					}else if(type=='篮球'){
						that.pieData2.series = list
						that.pieData5.series = compareList
						this.$refs['pieData2'].showCharts();
						this.$refs['pieData5'].showCharts();
					}
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			getRankTable(type){
				var url ='/pentaho/proValue/getSingleVoteRankingCom';	
				var param = this.createParam();
				var tableLeft = []
				var tableRight = []
				var tableLeftAll = []
				var tableRightAll = []
				if(type=='竞彩'){
					param.gameFlag=0
				}else if (type=='足球'){
					param.gameFlag=1
				}else if (type=='篮彩'){
					param.gameFlag=2
				}
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)

					var data = res.data.data;
					var format0 = null;
					if(data==null){
						return					
					}		
					
					for(var i=0;i<data.length;i++){
						var jsonleft = {id:data[i][1], area:data[i][0], amount:data[i][2].toFixed(2)}	
						var jsonright = {id:data[i][3], amount:data[i][4].toFixed(2)}								
						if(i<=4){
							tableLeft[i] = jsonleft
							tableRight[i] = jsonright
						}
						tableLeftAll[i] = jsonleft
						tableRightAll[i] = jsonright
					}
					
					if(type=='竞彩'){
						this.leftTableData = tableLeft
						this.leftTableDataDetail = tableLeftAll
						this.rightTableData = tableRight
						this.rightTableDataDetail = tableRightAll
					}else if (type=='足球'){
						this.leftTableDataFB = tableLeft
						this.leftTableDataDetailFB = tableLeftAll
						this.rightTableDataFB = tableRight
						this.rightTableDataDetailFB = tableRightAll
					}else if (type=='篮彩'){
						this.leftTableDataBK = tableLeft
						this.leftTableDataDetailBK = tableLeftAll
						this.rightTableDataBK = tableRight
						this.rightTableDataDetailBK = tableRightAll
					}
			
					console.log('request tableData', this.tableData);				
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			getLineData(isLeft){
				var url = '/pentaho/proValue/getSingleVoteTrendChart';
				var param = this.createParam2(isLeft);
			
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					var data = res.data.data;	
					if(data==null){
						return
					}
					var dates = data.dates
					var FB = data.FB
					var ALL = data.ALL
					var BK = data.BK						
			
					var series = [];
					series[0] =  {'name':'竞彩','data':ALL};
					series[1] =  {'name':'足球','data':FB};
					series[2] =  {'name':'篮球','data':BK};
					if(isLeft){
						this.$set(this.lineData1, 'categories', dates);
						this.$set(this.lineData1, 'series', series);
						
						this.$refs['lineData1'].showCharts();
					}else{
						this.$set(this.lineData2, 'categories', dates);
						this.$set(this.lineData2, 'series', series);
						
						this.$refs['lineData2'].showCharts();
					}		
					
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			},
			gotoLunBo(btnnum){
				if(btnnum==0){
					uni.navigateTo({
						url:"/pages/common/ringDetailTwo?type=ticket&leftPie=" + JSON.stringify(this.pieData) + "&rightPie="+ JSON.stringify(this.pieData3)
					});
				}else if(btnnum==1){
					uni.navigateTo({
						url:"/pages/common/ringDetailTwo?type=ticket&leftPie=" + JSON.stringify(this.pieData1) + "&rightPie="+ JSON.stringify(this.pieData4)
					});
				}else if(btnnum==2){
					uni.navigateTo({
						url:"/pages/common/ringDetailTwo?type=ticket&leftPie=" + JSON.stringify(this.pieData2) + "&rightPie="+ JSON.stringify(this.pieData5)
					});
				}
			},
			gotoRankAll(){
				if(this.tableIndex==0){
					uni.navigateTo({
						url:"/pages/common/tableDetail?tableData= " + JSON.stringify(this.tableDataAll) + '&tableColumns=' + JSON.stringify(this.tableColumns)
					});
				}else if(this.tableIndex==1){
					uni.navigateTo({
						url:"/pages/common/tableDetail?tableData= " + JSON.stringify(this.tableDataAllFB) + '&tableColumns=' + JSON.stringify(this.tableColumnsFB)
					});
				}else if(this.tableIndex==2){
					uni.navigateTo({
						url:"/pages/common/tableDetail?tableData= " + JSON.stringify(this.tableDataAllBK) + '&tableColumns=' + JSON.stringify(this.tableColumnsBK)
					});
				}

			},
			refresh(){
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				this.getServerData();
				this.showView();
				this.getServerData();
				this.showView();
			},
		},
		mounted(){			
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			this.getServerData();
			this.showView();
		},
		watch: {
			'$route':'showView'
		},

	}
</script>

<style>
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

	.box-container{
		width: 100%;
		margin: 20rpx 10rpx 40rpx 10rpx;
		/* padding: 20rpx 10rpx 20rpx 10rpx; */
	}
	
	/* 将三个内容view的display设置为none(隐藏) */
	.tab-content{
		margin: 20rpx 10rpx 20rpx 10rpx;
		/* padding: 20rpx 10rpx 20rpx 10rpx; */
	}
	
	/* 将三个内容view的display设置为none(隐藏) */
	.tab-title{
		margin: 20rpx 10rpx 20rpx 10rpx;
		padding:0rpx 5rpx 0rpx 5rpx;
		flex-direction: row;
		display: flex;
		text-align: center;
		justify-content:center;
		font-size: 30rpx;
	}
	.end-cont{
		display: none;
		background: #FFFFFF;
	}
	.btna{
		color: #FFFFFF;
		background:rgba(47, 98, 248 ,0.5);		
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
	
	.example {
		/* line-height: 40px; */
		flex-direction: row;
		font-weight: bold;
		border-color:#FFFFFF;
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
	
	button {
		width: 75%;
	    margin-top: 30rpx;
	    margin-bottom: 30rpx;
		font-size: 30rpx;
	}
</style>
