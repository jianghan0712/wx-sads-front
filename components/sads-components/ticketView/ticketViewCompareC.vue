<template>
	<view>
		<view class="box-contaniner">
			<view class="container-title">单票金额对比</view>
			<dataContainerTwoColThree ref="compareAmount" ></dataContainerTwoColThree>
		</view>
		
<!-- 		<block v-if="selfParam.compareDate.dateType!='date'">
			<view class="box-contaniner">
				<view class="shop-title">{{selfParam.compareDate.viewLeft}}竞彩单票金额走势</view>
				<line-chart ref="lineData1" canvasId="index_line_1" :dataAs="lineData1" 
							:xAxisAs="{scrollShow:false}" />
			</view>	
			<view class="box-contaniner">
				<view class="shop-title">{{selfParam.compareDate.viewRight}}竞彩单票金额走势</view>
				<line-chart ref="lineData2" canvasId="index_line_2" :dataAs="lineData2" 
							:xAxisAs="{scrollShow:false}" />
			</view>	
		</block> -->
		
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
		
	<!-- 	<view class="box-contaniner">
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
					<view class="table">
						<v-table :columns="tableColumns" :list="tableData"  border-color="#FFFFFF"></v-table>
					</view>
				</view>
				<view class="end-cont" :class="{dis:tableIndex == 1}">
					<view class="table">
						<v-table :columns="tableColumnsFB" :list="tableDataFB"  border-color="#FFFFFF"></v-table>
					</view>
				</view>
				<view class="end-cont" :class="{dis:tableIndex == 2}">
					<view class="table">
						<v-table :columns="tableColumnsBK" :list="tableDataBK"  border-color="#FFFFFF"></v-table>
					</view>
				</view>
			</view>
		</view> -->

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
	
	export default {
		components: {
			RingChart,vTable,dataContainerTwoColThree
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
				tableData: [],
				tableDataAll: [],
				tableColumns: [{
							title: "排名",
							key: "leftRank",
							$width:"50px",
						},{
							title: '省份',
							key: 'area',
							$width:"100px"
						},{
							title: '竞彩（元）',
							key: 'leftAmount',
							$width:"120px"
						},{
							title: '竞彩（元）',
							key: 'rightAmount',
							$width:"120px"
						}],	
				
				tableDataFB: [],
				tableDataAllFB: [],
				tableColumnsFB: [{
							title: "排名",
							key: "leftRank",
							$width:"50px",
						},{
							title: '省份',
							key: 'area',
							$width:"100px"
						},{
							title: '足球（元）',
							key: 'leftAmount',
							$width:"120px"
						},{
							title: '足球（元）',
							key: 'rightAmount',
							$width:"120px"
						}],	
				
				tableDataBK: [],
				tableDataAllBK: [],
				tableColumnsBK: [{
							title: "排名",
							key: "leftRank",
							$width:"50px",
						},{
							title: '省份',
							key: 'area',
							$width:"100px"
						},{
							title: '篮彩（元）',
							key: 'leftAmount',
							$width:"120px"
						},{
							title: '篮彩（元）',
							key: 'rightAmount',
							$width:"120px"
						}],	
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
			this.returnFromDatePicker()
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			this.selfParam.token = uni.getStorageSync("token")
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
				// this.getRankTable('竞彩');
				// this.getRankTable('足球');
				// this.getRankTable('篮彩');
				this.getAmountCompare(true)
				this.getAmountCompare(false)
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
							 showNumber: this.selfParam.shopNo,
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='week'){
					param = {dateTimeStart: this.selfParam.compareDate.weekLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.weekLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.weekRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.weekRight.endDate,
							 dateFlag:"2",
							 showNumber: this.selfParam.shopNo,
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='month'){
					param = {dateTimeStart: this.selfParam.compareDate.monthLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.monthLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.monthRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.monthRight.endDate,
							 dateFlag:"3",
							 showNumber: this.selfParam.shopNo,
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='year'){
					param = {dateTimeStart: this.selfParam.compareDate.yearLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.yearLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.yearRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.yearRight.endDate,
							 dateFlag:"4",
							 showNumber: this.selfParam.shopNo,
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}	
				console.log("createParam end:",param)
				return param
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
			getAmountCompare(isLeft){
				var url = '/pentaho/showProValue/getShowSingleVoteMoney';				
				var param = this.createParam2(isLeft);
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					var data = res.data.data;
					if(data==null){
						return 
					}
					var format0 = numberFun.formatCNumber(data[0]);
					
					var title = {'nameOne':'竞彩（'+format0.name +'元）', 'nameTwo':'足球单票金额（元）','nameThree':'篮球单票金额（元）'}
					if(isLeft){
						var left = {'valueOne':(data[0]/format0.value).toFixed(2) , 'valueTwo':(data[1]/format0.value).toFixed(2) ,'valueThree':(data[2]/format0.value).toFixed(2) }
						this.compareAmount.title = title
						this.compareAmount.left = left
					}else{
						var right = {'valueOne':(data[0]/format0.value).toFixed(2) , 'valueTwo':(data[1]/format0.value).toFixed(2) ,'valueThree':(data[2]/format0.value).toFixed(2) }
						this.compareAmount.title = title
						this.compareAmount.right = right
					}
			
					this.$refs['compareAmount'].showDataContainer(this.compareAmount);		
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
				})
			},
			// getAmountCompare(){
			// 	var url = '/pentaho/showProValue/getShowProValueVotesProp';
			// 	var param = this.createParam();
			// 	param.gameFlag=1
			// 	urlAPI.getRequest(url, param).then((res)=>{
			// 		this.loading = false;
			// 		console.log('request success', res)

			// 		var data = res.data.data;
			// 		if(data==null){
			// 			this.$refs['compareAmount'].showDataContainer(this.compareAmount);
			// 			return
			// 		}
			// 		// var format0 = numberFun.formatCNumber(data[0]);
			// 		// var format1 = numberFun.formatCNumber(data[1]);
			// 		// var format2 = numberFun.formatCNumber(data[2]);
			// 		var title = {'nameOne':'竞彩单票金额（元）', 'nameTwo':'足球单票金额（元）','nameThree':'篮球单票金额（元）'}
			// 		var left = {'valueOne':data[0] , 'valueTwo':data[1] ,'valueThree':data[2] }
			// 		var right = {'valueOne':data[3] , 'valueTwo':data[4] ,'valueThree':data[5] }
			// 		this.compareAmount.title = title
			// 		this.compareAmount.left = left
			// 		this.compareAmount.right = right
			// 		// this.$set(this.compareAmount, 'title', title);
			// 		// this.$set(this.compareAmount, 'left', left);
			// 		// this.$set(this.compareAmount, 'right', right);
			// 		this.$refs['compareAmount'].showDataContainer(this.compareAmount);

			// 		console.log('request ticketData', this.compareAmount);				
			// 		this.res = '请求结果 : ' + JSON.stringify(res);
			// 	}).catch((err)=>{
			// 		this.loading = false;
			// 		console.log('request fail', err);
			// 	})
			// },
			getPieData(type){
				var url = '/pentaho/showProValue/getShowProValueVotesPropCom';
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
				var table = []
				var tableAll = []
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
					if(data!=null && data.length>0){
						format0 = numberFun.formatCNumber(data[0][2]);							
					}else{
						return;
					}			
					
					for(var i=0;i<data.length;i++){
						var jsonData = {leftRank:data[i][1], 
									    area:data[i][0], 
										leftAmount:(data[i][2]/format0.value).toFixed(2), 
										rightAmount:(data[i][4]/format0.value).toFixed(2)}
						tableAll[i]=jsonData;						
						if(i>4){
							continue;
						}
						table[i]=jsonData;
					}
					if(type=='竞彩'){
						this.tableData=table
						this.tableDataAll=tableAll
					}else if (type=='足球'){
						this.tableDataFB=table
						this.tableDataAllFB=tableAll
					}else if (type=='篮彩'){
						this.tableDataBK=table
						this.tableDataAllBK=tableAll
					}
			
					console.log('request tableData', this.tableData);				
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
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
			// getLinetData(){				
			// 	var url = '/pentaho/proValue/getSingleVoteTrendChart'
			// 	var param = this.createParam()
				
			// 	urlAPI.getRequest(url, param).then((res)=>{
			// 		this.loading = false;
			// 		console.log('request success', res)
			// 		uni.showToast({
			// 			title: '请求成功',
			// 			icon: 'success',
			// 			mask: true
			// 		});
			// 		var data = res.data.data;	
					
			// 		var dates = data.dates
			// 		var ALL = data.ALL
			// 		var FB = data.FB
			// 		var BK = data.BK
			// 		var comDates = data.comDates
			// 		var comALL = data.comALL
			// 		var comFB = data.comFB
			// 		var comBK = data.comBK
					
			// 		for(var i=0;i<dates.length;i++){
			// 			ALL[i] = (ALL[i]/100).toFixed(2)
			// 			FB[i] = (FB[i]/100).toFixed(2)
			// 			BK[i] = (BK[i]/100).toFixed(2)
			// 		}
			// 		for(var i=0;i<comDates.length;i++){
			// 			comALL[i] = (comALL[i]/100).toFixed(2)
			// 			comFB[i] = (comFB[i]/100).toFixed(2)
			// 			comBK[i] = (comBK[i]/100).toFixed(2)
			// 		}
			// 		var series = [ {'name':'竞彩返奖率','data':ALL},
			// 					   {'name':'足球返奖率','data':FB},
			// 					   {'name':'篮球返奖率','data':BK}];	
					
			// 		this.$set(this.lineData3, 'categories', dates);
			// 		this.$set(this.lineData3, 'series', series);
					
			// 		// var json3 = {'name':'销量','data':volData};
			// 		var series2 = [ {'name':'竞彩返奖率','data':comALL},
			// 					   {'name':'足球返奖率','data':comFB},
			// 					   {'name':'篮球返奖率','data':comBK}];	
			// 		// series2[0] = json2;
			// 		this.$set(this.lineData4, 'categories', dates);
			// 		this.$set(this.lineData4, 'series', series2);
			// 		this.$refs['lineData3'].showCharts();
			// 		this.$refs['lineData4'].showCharts();
			// 		this.res = '请求结果 : ' + JSON.stringify(res);
			// 	}).catch((err)=>{
			// 		this.loading = false;
			// 		console.log('request fail', err);
			// 	})
			// },
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
				this.returnFromDatePicker()
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
	
	.table {
		/* line-height: 40px; */
		display: flex;
		width: 95%;
		font-weight: bold;
		border-color:#FFFFFF;
	}
	
	button {
		width: 75%;
	    margin-top: 30rpx;
	    margin-bottom: 30rpx;
		font-size: 30rpx;
	}
</style>
