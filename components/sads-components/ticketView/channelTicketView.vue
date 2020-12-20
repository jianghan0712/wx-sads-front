<template>
	<view>
		<view class="box-contaniner">
			<view class="container-title">单票金额</view>
			<ticketData ref="ticketData" :dataAs="ticketData"></ticketData>
		</view>
		
		<view class="box-contaniner">
			<view class="container-title">各票面区间的票数及占比</view>
			<view class="tab-content">
				<view class="tab-title">
					<view @tap="change(0)" :class="btnnum == 0?'btna':'hide'">竞彩</view>
				　　<view @tap="change(1)" :class="btnnum == 1?'btna':'hide'">足球</view>
				  　<view @tap="change(2)" :class="btnnum == 2?'btna':'hide'">篮球</view>
				</view>	
				<view class="end-cont" :class="{dis:btnnum == 0}">	
					<view class="ring_chart">
						<ring-chart :dataAs="pieData" ref="ringChart0" canvasId="index_ring_0"/>
					</view>
					<progress ref="progress_0" :dataAs="pieData"></progress>
				</view>
				<view class="end-cont" :class="{dis:btnnum == 1}">
					<view class="ring_chart">
						<ring-chart :dataAs="pieData1" ref="ringChart1" canvasId="index_ring_1"/>
					</view>
					<progress ref="progress_1" :dataAs="pieData1"></progress>
				</view>
				<view class="end-cont" :class="{dis:btnnum == 2}">
					<view class="ring_chart">
						<ring-chart :dataAs="pieData2" ref="ringChart2" canvasId="index_ring_2"/>
					</view>	
					<progress ref="progress_2" :dataAs="pieData2"></progress>
				</view>
			</view>
		</view>
		
<!-- 		<block v-if="'date'!= selfParam.businessDate.dateType">
			<view class="box-contaniner">
				<view class="container-title">竞彩单票金额走势图</view>
				<line-chart ref="ticketlineData" canvasId="ticket_line_1" :dataAs="lineData1" />
			</view>
		</block> -->
		<slot />
	</view>	
</template>

<script>
	import ticketData from '@/components/sads-components/ticketData.vue';
	import RingChart from "@/components/basic-chart/RingChart.vue";
	import vTable from "@/components/table/table.vue";
	import urlAPI from '@/common/vmeitime-http/';
	import numberFun from '@/common/tools/number.js';
	import commonFun from '@/common/tools/watcher.js';
	import progress from "@/components/sads-components/progress.vue";
	import LineChart from '@/components/basic-chart/LineChart.vue';
	
	export default {
		components: {
			ticketData,RingChart,vTable,progress,LineChart
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
					selfProvinceCenterId:'',//存登录时候的id
					shopNo:''
				},
				btnnum: 0,
				ticketData:{big1:{name:"",value:""},big2:{name:"",value:""}},
				pieData: {series: []},
				pieData1: {series: []},
				pieData2: {series: []},
				lineData1:{}
			}
		},
		onLoad() {
			this.returnFromDatePicker();
			this.getServerData();
			this.showView();
		},
		onShow() {
			this.returnFromDatePicker();
			this.getServerData();
			this.showView();
		},
		created() {
			this.returnFromDatePicker();
			this.getServerData();
			this.showView();
		},
		methods: {
			showView(){
				console.log("ticket showView" ,this.pieData);
				// commonFun.sleep(3000)
				this.$nextTick(() => {	
					this.$refs['ticketData'].showDataContainer();
					this.$refs['ringChart0'].showCharts();
					this.$refs['ringChart1'].showCharts();
					this.$refs['ringChart2'].showCharts();
					this.$refs['progress_0'].showProgress(this.pieData);
					this.$refs['progress_1'].showProgress(this.pieData1);
					this.$refs['progress_2'].showProgress(this.pieData2);
					// this.$refs['ticketlineData'].showCharts();
				});	
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
				this.selfParam.shopNo = uni.getStorageSync("shopNo")
				this.selfParam.token=getApp().globalData.token
				uni.setStorageSync("selfParam",JSON.stringify(this.selfParam))
			},
			getServerData() {
				this.getTicketData();
				this.getPieData('竞彩');
				this.getPieData('足彩');
				this.getPieData('篮彩');
				// this.getLineDate();
				// this.$refs['ticketData'].showDataContainer();
			},
			change(e) {
			    this.btnnum = e;
				if(0==e){
					this.getPieData('竞彩');
				}else if(1==e){
					this.getPieData('足彩');
				}else if(2==e){
					this.getPieData('篮彩');
				}
			},
			refresh(selfParam){
				this.selfParam = JSON.parse(selfParam)
				this.selfParam.token = uni.getStorageSync("token")
				this.getServerData();
				this.showView();
			},
			createParam(){
				console.log("createParam begin")
				var dateType = this.selfParam.businessDate.dateType
				var param = {}
				if(dateType=='date'){
					param = {dateTimeStart: this.selfParam.businessDate.date.startDate,
							 dateTimeEnd: this.selfParam.businessDate.date.endDate,
							 dateFlag:"1",
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}else if(dateType=='week'){
					param = {dateTimeStart: this.selfParam.businessDate.week.startDate,
							 dateTimeEnd: this.selfParam.businessDate.week.endDate,
							 dateFlag:"2",
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}else if(dateType=='month'){
					param = {dateTimeStart: this.selfParam.businessDate.month.startDate,
							 dateTimeEnd: this.selfParam.businessDate.month.endDate,
							 dateFlag:"3",
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}else if(dateType=='year'){
					param = {dateTimeStart: this.selfParam.businessDate.year.startDate,
							 dateTimeEnd: this.selfParam.businessDate.year.endDate,
							 dateFlag:"4",
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}	
				console.log("createParam end:",param)
				return param
			},
			getTicketData(){		
				var url = "/pentaho/showProValue/getShowSingleVoteMoney";
				var param = this.createParam();
				
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					var data = res.data.data;
					var format0 = numberFun.formatCNumber(data[0]);
					var big1 = {'name':'竞彩（'+format0.name +'元）', 'value':data[0].toFixed(2)/format0.value}
					var small1 = {'name':'足彩（'+format0.name +'元）', 'value':data[1].toFixed(2)/format0.value}
					var small2 = {'name':'篮彩（'+format0.name +'元）', 'value':data[2].toFixed(2)/format0.value}
					this.$set(this.ticketData, 'big1', big1);
					this.$set(this.ticketData, 'small1', small1);
					this.$set(this.ticketData, 'small2', small2);
					this.$refs['ticketData'].showDataContainer();		
					console.log('request ticketData', this.ticketData);				
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
					var big1 = {'name':'竞彩（百万元）', 'value':0}
					var small1 = {'name':'足彩（百万元）', 'value':0}
					var small2 = {'name':'篮彩（百万元）', 'value':0}
					this.$set(this.ticketData, 'big1', big1);
					this.$set(this.ticketData, 'small1', small1);
					this.$set(this.ticketData, 'small2', small2);
				})
			},
			getPieData(type){
				var url = '/pentaho/showProValue/getShowProValueVotesProp';
				var param = this.createParam();
				
				if(type=='竞彩'){
					param.gameFlag = 0
				}else if(type=='足彩'){
					param.gameFlag = 1
				}else if(type=='篮彩'){
					param.gameFlag = 2
				}
				// var that =this;
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					uni.showToast({
						title: '请求成功',
						icon: 'success',	
						mask: true
					});
					
					var data = res.data.data;
					var list=[];	
					for(var i=0; i<data.length; i++){
						list[i]={name:data[i].proValueName,data:data[i].values[0]};
					}
					if(type=='竞彩'){
						this.$set(this.pieData, 'series', list);
						this.$refs['ringChart0'].showCharts();
						// this.$refs['progress_0'].showProgress(this.pieData);					
					}else if(type=='足彩'){
						this.$set(this.pieData1, 'series', list);
						this.$refs['ringChart1'].showCharts();
						// this.$refs['progress_1'].showProgress(this.pieData1);
					}else if(type=='篮彩'){
						this.$set(this.pieData2, 'series', list);
						this.$refs['ringChart2'].showCharts();
						// this.$refs['progress_2'].showProgress(this.pieData2);
					}
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			getLineDate(){
				var dateType = this.selfParam.businessDate.dateType
				if(dateType=='date'){
					return;
				}
				var url = '/pentaho/showProValue/getShowSingleVoteTrendChart';
				var param = this.createParam()
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					var data = res.data.data;
					var dates = data.dates
					var all = data.ALL
					var fb = data.FB
					var bk = data.BK
					
					var categories=[];
					var series=[];
					var allData = [];
					var fbData = [];
					var bkData = [];
					var j=0,k = 0,tempallAmount=0,tempfbVol=0,tempbkAmount=0;
					
					for(var i=0;i<dates.length;i++){	
						if(j==3){
							categories[k] = dates[i];
							allData[k] = all[i];
							fbData[k] = fb[i];
							bkData[k] = bk[i];
							tempallAmount=0,tempfbVol=0,tempbkAmount=0
							k++;
							j=0;
						}else{
							tempallAmount = tempallAmount+all[i];
							tempfbVol = tempfbVol+fb[i];
							tempbkAmount = tempbkAmount+bk[i]
							j=j+1;
						}
					}
					
					series[0] = json;
					var json = {'name':'竞彩','data':allData};								
					var json2 = {'name':'足彩','data':fbData};
					var json3 = {'name':'篮彩','data':bkData};
					series[0] = json;
					series[1] = json2;
					series[2] = json3;
				
					this.$set(this.lineData1, 'categories', categories);
					this.$set(this.lineData1, 'series', series);
					console.log('categories:', categories);
					console.log('series: ', series);
					console.log('lineData1: ', this.lineData1);
					
					
					this.res = '请求结果 : ' + JSON.stringify(res);
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
			},
			gotoLunBo(btnnum){
				if(btnnum==0){
					uni.navigateTo({
						url:"/pages/common/ticketRingDetail?btnnum="+ btnnum + "&data=" + JSON.stringify(this.pieData)
					});
				}else if(btnnum==1){
					uni.navigateTo({
						url:"/pages/common/ticketRingDetail?btnnum="+ btnnum + "&data=" + JSON.stringify(this.pieData1)
					});
				}else if(btnnum==2){
					uni.navigateTo({
						url:"/pages/common/ticketRingDetail?btnnum="+ btnnum + "&data=" + JSON.stringify(this.pieData2)
					});
				}
			},
			gotoRankAll(){				
				uni.navigateTo({
					url:"/pages/common/tableDetail?tableData= " + JSON.stringify(this.tableDataAll) + '&tableColumns=' + JSON.stringify(this.tableColumns)
				});
			}
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
		width: 90%;
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
	
	.table {
		/* line-height: 40px; */
		font-weight: bold;
		border-color:#FFFFFF;
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
	
	button {
		width: 75%;
	    margin-top: 30rpx;
	    margin-bottom: 30rpx;
		font-size: 30rpx;
	}
</style>
