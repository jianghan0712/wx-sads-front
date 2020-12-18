<template>
	<view>
		<view class="box-contaniner">
			<view class="box-contaniner">
				<view class="container-title">单票金额对比</view>
				<dataContainerTwoColThree ref="threeData" :dataAs="threeData"></dataContainerTwoColThree>
			</view>
			
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
							<ring-chart :dataAs="pieData0" ref="ringChart0" canvasId="index_ring_0"/>
						</view>
						<view class="ring_chart">
							<ring-chart :dataAs="pieData00" ref="ringChart00" canvasId="index_ring_00"/>
						</view>
					</view>
					<view class="end-cont" :class="{dis:btnnum == 1}">
						<view class="ring_chart">
							<ring-chart :dataAs="pieData1" ref="ringChart1" canvasId="index_ring_1"/>
						</view>
						<view class="ring_chart">
							<ring-chart :dataAs="pieData11" ref="ringChart11" canvasId="index_ring_11"/>
						</view>
					</view>
					<view class="end-cont" :class="{dis:btnnum == 2}">
						<view class="ring_chart">
							<ring-chart :dataAs="pieData2" ref="ringChart2" canvasId="index_ring_2"/>
						</view>
						<view class="ring_chart">
							<ring-chart :dataAs="pieData22" ref="ringChart22" canvasId="index_ring_22"/>
						</view>
					</view>
					<button type="default" plain="true" @click="gotoLunBo(btnnum)">查看全部</button>
				</view>
			</view>
			<slot />
		</view>
	</view>	
</template>

<script>
	import RingChart from "@/components/basic-chart/RingChart.vue";
	import dataContainerTwoColThree from '@/components/sads-components/dataContainerTwoColThree.vue';
	import vTable from "@/components/table/table.vue";
	import urlAPI from '@/common/vmeitime-http/';
	import numberFun from '@/common/tools/number.js';
	import PieChart from '@/components/basic-chart/PieChart.vue';
	
	export default {
		components: {
			RingChart,vTable,dataContainerTwoColThree,PieChart
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
				btnnum: 0,
				pieData0: {series: []},
				pieData00: {series: []},
				pieData1: {series: []},
				pieData11: {series: []},
				pieData2: {series: []},
				pieData22: {series: []},
				tableData: [],
				tableDataAll: [],
				tableColumns: [],
				threeData:{
					title:{nameOne:'竞彩单票金额（元）',nameTwo:'足球单票金额（元）',nameThree:'篮球单票金额（元）'},
					left:{valueOne:'0元',valueTwo:'0元',valueThree:'0元'},
					right:{valueOne:'0元',valueTwo:'0元',valueThree:'0元'},
				},
				threeDataCompare:{
					title:{nameOne:'竞彩单票金额（元）',nameTwo:'足球单票金额（元）',nameThree:'篮球单票金额（元）'},
					left:{valueOne:'0元',valueTwo:'0元',valueThree:'0元'},
					right:{valueOne:'0元',valueTwo:'0元',valueThree:'0元'},
				},
				legend: {
					show: false
				},
			}
		},
		onLoad() {
			_self = this;
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			this.returnFromDatePicker();
			this.getServerData();
			this.showView()
		},
		onShow() {
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			this.returnFromDatePicker();
			this.getServerData();
			this.showView()
		},
		methods: {
			createParam(){
				console.log("createParam begin")
				var  dateType = uni.getStorageSync("dateType")
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
				}else {
					param = {dateTimeStart: this.selfParam.compareDate.dateLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.dateLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.dateRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.dateRight.endDate,
							 dateFlag:1,
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}
				param.token= getApp().globalData.token;
				param.regionId =this.selfParam.provinceCenterId
				console.log("createParam end:",param)
				return param
			},
			returnFromDatePicker(){
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
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
				this.selfParam.shopNo = uni.getStorageSync("shopNo");
			},
			showView(){
				console.log("ticket showView" ,this.pieData);
				if(this.btnnum==0){
					this.$refs['ringChart0'].showCharts();
					this.$refs['ringChart00'].showCharts();
				} else if(this.btnnum==1){
					this.$refs['ringChart1'].showCharts();
					this.$refs['ringChart11'].showCharts();
					
				} else if(this.btnnum==2){
					this.$refs['ringChart2'].showCharts();
					this.$refs['ringChart22'].showCharts();
				} 
				this.$refs['threeData'].showDataContainer();
			},
			getServerData() {
				this.getTopData();
				this.getPieData();
				this.getLastData();
			},
			change(e) {
			    this.btnnum = e;
			    console.log(this.btnnum);
			},
			getTopData(){
				var url = '/pentaho/proValue/getSingleVoteMoneyCom';
				var param = this.createParam();
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					var data = res.data.data;
					
					var format0 = numberFun.formatCNumber(data[0]);
					var format1 = numberFun.formatCNumber(data[1]);
					var format2 = numberFun.formatCNumber(data[2]);
					var format00 = numberFun.formatCNumber(data[3]);
					var format11 = numberFun.formatCNumber(data[4]);
					var format22 = numberFun.formatCNumber(data[5]);
					
					var title = {'nameOne':'竞彩单票金额（'+format0.name +'元）', 'nameTwo':'足球单票金额（'+format0.name +'元）','nameThree':'篮球单票金额（'+format0.name +'元）'}
					var left = {'valueOne':data[0].toFixed(2)/format0.value , 'valueTwo':data[1].toFixed(2)/format1.value ,'valueThree':data[2].toFixed(2)/format2.value }
					var right = {'valueOne':data[3].toFixed(2)/format00.value , 'valueTwo':data[4].toFixed(2)/format11.value ,'valueThree':data[5].toFixed(2)/format22.value }
					
					this.$set(this.threeData, 'title', title);
					this.$set(this.threeData, 'left', left);
					this.$set(this.threeData, 'right', right);
					this.$refs['threeData'].showDataContainer();

					console.log('request ticketData', this.ticketData);				
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			getPieData(){
				var url = '/pentaho/proValue/getProValueVotesPropCom' ;
				var param = this.createParam();
				param.gameFlag=0;
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res);
					var data = res.data.data;
					
					var games= data.votes;
					var comGanmes =data.comVotes;
					
					var series = [];
					var categories =[];
					for(var i=0;i<games.length;i++){
						categories.push(games[i].proValueName);
						var json ={'name':games[i].proValueName,'data':games[i].values[0]};
						series.push(json);
					}
					var series2 = [];
					var categories2 =[];
					for(var i=0;i<comGanmes.length;i++){
						categories2.push(comGanmes[i].proValueName);
						var json ={'name':comGanmes[i].proValueName,'data':comGanmes[i].values[0]};
						series.push(json);
					}
					//this.$set(this.pieData0, 'categories', categories);
					this.$set(this.pieData0, 'series', series);
					//this.$set(this.pieData00, 'categories', categories2);
					this.$set(this.pieData00, 'series', series2);
					this.$refs['ringChart0'].showCharts();
					this.$refs['ringChart00'].showCharts();
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				
				param.gameFlag=1;
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res);
					var data = res.data.data;
					
					var games= data.votes;
					var comGanmes =data.comVotes;
					
					var series = [];
					var categories =[];
					for(var i=0;i<games.length;i++){
						categories.push(games[i].proValueName);
						var json ={'name':games[i].proValueName,'data':games[i].values[0]};
						series.push(json);
					}
					var series2 = [];
					var categories2 =[];
					for(var i=0;i<comGanmes.length;i++){
						categories2.push(comGanmes[i].proValueName);
						var json ={'name':comGanmes[i].proValueName,'data':comGanmes[i].values[0]};
						series.push(json);
					}
					//this.$set(this.arcbar1, 'categories', categories);
					this.$set(this.arcbar1, 'series', series);
					//this.$set(this.arcbar11, 'categories', categories2);
					this.$set(this.arcbar11, 'series', series2);
					this.$refs['ringChart1'].showCharts();
					this.$refs['ringChart11'].showCharts();
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				
				param.gameFlag=2;
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res);
					var data = res.data.data;
					
					var games= data.votes;
					var comGanmes =data.comVotes;
					
					var series = [];
					var categories =[];
					for(var i=0;i<games.length;i++){
						categories.push(games[i].proValueName);
						var json ={'name':games[i].proValueName,'data':games[i].values[0]};
						series.push(json);
					}
					var series2 = [];
					var categories2 =[];
					for(var i=0;i<comGanmes.length;i++){
						categories2.push(comGanmes[i].proValueName);
						var json ={'name':comGanmes[i].proValueName,'data':comGanmes[i].values[0]};
						series.push(json);
					}
					//this.$set(this.arcbar2, 'categories', categories);
					this.$set(this.arcbar2, 'series', series);
					//this.$set(this.arcbar22, 'categories', categories2);
					this.$set(this.arcbar22, 'series', series2);
					this.$refs['ringChart2'].showCharts();
					this.$refs['ringChart22'].showCharts();
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				
			},
			getLastData(){
				/* var url = '';
				var param = this.createParam();
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				}) */
			},
			gotoLunBo(btnnum){
				if(btnnum==0){
					uni.navigateTo({
						url:"/pages/common/levelRingDetail?btnnum="+ btnnum + "&data=" + JSON.stringify(this.pieData)
					});
				}else if(btnnum==1){
					uni.navigateTo({
						url:"/pages/common/levelRingDetail?btnnum="+ btnnum + "&data=" + JSON.stringify(this.pieData1)
					});
				}else if(btnnum==2){
					uni.navigateTo({
						url:"/pages/common/levelRingDetail?btnnum="+ btnnum + "&data=" + JSON.stringify(this.pieData1)
					});
				}
			},
			gotoRankAll(){				
				uni.navigateTo({
					url:"/pages/common/tableDetail?tableData= " + JSON.stringify(this.tableDataAll) + '&tableColumns=' + JSON.stringify(this.tableColumns)
				});
			},
			refresh(selfParam){
				this.selfParam.token = uni.getStorageSync("token")
				this.getServerData();
				this.showView();
			},
		},
		mounted(){			
			this.showView();
		},
		watch: {
			'$route':'showView'
		},
		created() {
			this.selfParam = this.model;
			this.getServerData();
			// this.showView();
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
	
	.table {
		/* line-height: 40px; */
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
