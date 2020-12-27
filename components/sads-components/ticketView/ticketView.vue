<template>
	<view>
		<view class="box-contaniner">
			<view class="box-contaniner">
				<view class="container-title">单票金额</view>
				<ticketData ref="ticketData2" :dataAs="ticketData"></ticketData>
			</view>
			
			<block v-if="selfParam.businessDate.dateType!='date'">
				<view class="box-contaniner">
					<view class="container-title">单票金额走势</view>
					<area-chart ref="lineData5" canvasId="index_line" :dataAs="lineData"
								:xAxisAs="{scrollShow:false, gridEval:(lineData.categories.length / 4).toFixed(0)}" 
								:yAxisAs="{formatter: {type: 'number', name:'元',fixed: 0}}"/>
				</view>
			</block>
			
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
					</view>
					<view class="end-cont" :class="{dis:btnnum == 1}">
						<view class="ring_chart">
							<ring-chart :dataAs="pieData1" ref="ringChart1" canvasId="index_ring_1"/>
						</view>
					</view>
					<view class="end-cont" :class="{dis:btnnum == 2}">
						<view class="ring_chart">
							<ring-chart :dataAs="pieData2" ref="ringChart2" canvasId="index_ring_2"/>
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
				<view class="table">
					<v-table :columns="tableColumns" :list="tableData"  border-color="#FFFFFF"></v-table>
				</view>
			</view>
			<slot />
		</view>
	</view>	
</template>

<script>
	import ticketData from '@/components/sads-components/ticketData.vue';
	import RingChart from "@/components/basic-chart/RingChart.vue";
	import vTable from "@/components/table/table.vue";
	import urlAPI from '@/common/vmeitime-http/';
	import numberFun from '@/common/tools/number.js';
	import commonFun from '@/common/tools/watcher.js';
	import LineChart from '@/components/basic-chart/LineChart.vue';
	import AreaChart from '@/components/basic-chart/AreaChart.vue';
	
	export default {
		components: {
			ticketData,RingChart,vTable,LineChart,AreaChart
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
						view:'',//用于展示日期、年、月等
						date:{startDate:'', endDate:''},
						week:{startDate:'', endDate:''},
						month:{startDate:'', endDate:''},
						year:{startDate:'', endDate:''},
					},	
					userId:'',			
					selfProvinceCenterId:''//存登录时候的id
				},
				btnnum: 0,
				dateType: 'date',
				lineData:{},
				ticketData:{big1:{name:"",value:""},big2:{name:"",value:""}},
				pieData: {series: []},
				pieData1: {series: []},
				pieData2: {series: []},
				tableData: [],
				tableDataAll: [],
				tableColumns: [{
							title: "排名",
							key: "id",
							$width:"50px",
						},{
							title: '省份',
							key: 'area',
							$width:"80px"
						},{
							title: '竞彩（元）',
							key: 'jingcai',
							$width:"80px"
						},{
							title: '足球（元）',
							key: 'football',
							$width:"85px"
						},{
							title: '篮球（元）',
							key: 'basketball'
						}],	
			}
		},
		onLoad() {		
			// _self = this;	
			// this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			// this.returnFromDatePicker();
			// this.getServerData();
			// this.showView()
			// this.refresh();
		},
		onShow() {
			// _self = this;	
			// this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			// this.returnFromDatePicker();
			// this.getServerData();
			// this.showView()
			// this.refresh();
		},
		created() {
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			// this.returnFromDatePicker();
			this.getServerData();
			this.showView()
			// this.refresh();
		},
		methods: {
			showView(){
				console.log("ticket showView" ,this.pieData);
				// commonFun.sleep(3000) 
				this.$nextTick(() => {	
					this.$refs['ticketData2'].showDataContainer();		
					this.$refs['ringChart0'].showCharts();
					this.$refs['ringChart1'].showCharts();
					this.$refs['ringChart2'].showCharts();
				});	
			},
			getServerData() {
				if(this.selfParam.businessDate.dateType!='date'){
					this.getLineData();
				}
				this.getDataSet(this.selfParam.provinceCenterId,this.selfParam.businessDate,this.selfParam.cityCenterId);
				this.getPieData('竞彩');
				this.getPieData('足球');
				this.getPieData('篮球');
				this.getRankTable(this.selfParam.provinceCenterId,this.selfParam.businessDate);
			},
			change(e) {
			    this.btnnum = e;
				if(0==e){ 
					this.getPieData('竞彩');
				}else if(1==e){
					this.getPieData('足球');
				}else if(2==e){
					this.getPieData('篮球');
				}
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
			getTicketData(){		
				var url = "/pentaho/proValue/getSingleVoteMoney";
				var param = this.createParam();
				
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					var data = res.data.data;
					var format0 = numberFun.formatCNumber(data[0]);
					var big1 = {'name':'竞彩（'+format0.name +'元）', 'value':(data[0]/format0.value).toFixed(2)}
					var small1 = {'name':'足球（'+format0.name +'元）', 'value':(data[1]/format0.value).toFixed(2)}
					var small2 = {'name':'篮球（'+format0.name +'元）', 'value':(data[2]/format0.value).toFixed(2)}
					this.ticketData = {big1:big1,small1:small1,small2:small2}
					// this.$set(this.ticketData, 'big1', big1);
					// this.$set(this.ticketData, 'small1', small1);
					// this.$set(this.ticketData, 'small2', small2);
					this.$refs['ticketData2'].showDataContainer();

					console.log('request ticketData', this.ticketData);				
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			// 获取最上层的两个tab
			getDataSet(provinceCenterId, currentDate){
				this.getTicketData();
			},
			getPieData(type){
				var url = '/pentaho/proValue/getProValueVotesProp';
				var param = this.createParam();
				
				if(type=='竞彩'){
					param.gameFlag = 0
				}else if(type=='足球'){
					param.gameFlag = 1
				}else if(type=='篮球'){
					param.gameFlag = 2
				}
				var that =this;
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					
					var data = res.data.data;
					var list=[];	
					for(var i=0; i<data.length; i++){
						list[i]={name:data[i].proValueName,data:data[i].values[0]};					
					}
					if(type=='竞彩'){
						this.pieData.series=list
						// that.$set(that.pieData, 'series', list);
						this.$refs['ringChart0'].showCharts();
						
					}else if(type=='足球'){
						// that.$set(that.pieData1, 'series', list);
						this.pieData1.series=list
						this.$refs['ringChart1'].showCharts();
						
					}else if(type=='篮球'){
						// that.$set(that.pieData2, 'series', list);
						this.pieData2.series=list
						this.$refs['ringChart2'].showCharts();						
					}
					that.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			getRankTable(provinceCenterId, currentDate){
				var url ='/pentaho/proValue/getSingleVoteMoneyRanking';	
				var param = this.createParam();
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					var data = res.data.data;
					var format0 = null;
					if(data!=null && data.length>0){
						format0 = numberFun.formatCNumber(data[0][1]);							
					}else{
						return;
					}	
					
					this.tableColumns= [{
							title: "排名",
							key: "id",
							$width:"50px",
						},{
							title: '省份',
							key: 'area',
							$width:"80px"
						},{
							title: '竞彩（元）',
							key: 'jingcai',
							$width:"80px"
						},{
							title: '足球（元）',
							key: 'football',
							$width:"85px"
						},{
							title: '篮球（元）',
							key: 'basketball'
						}
					
					]
					
					for(var i=0;i<data.length;i++){
						var jsonData = {id:i+1, 
									    area:data[i][0], 
										jingcai:data[i][1], 
										football:data[i][2],
										basketball:data[i][3],
									   }
						this.tableDataAll[i]=jsonData;						
						if(i>4){
							continue;
						}
						this.tableData[i]=jsonData;
					}
			
					console.log('request tableData', this.tableData);				
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			gotoLunBo(btnnum){
				if(btnnum==0){
					uni.navigateTo({
						url:"/pages/common/ringDetail?data=" + JSON.stringify(this.pieData)
					});
				}else if(btnnum==1){
					uni.navigateTo({
						url:"/pages/common/ringDetail?data=" + JSON.stringify(this.pieData1)
					});
				}else if(btnnum==2){
					uni.navigateTo({
						url:"/pages/common/ringDetail?data=" + JSON.stringify(this.pieData2)
					});
				}
			},
			gotoRankAll(){				
				uni.navigateTo({
					url:"/pages/common/tableDetail?tableData= " + JSON.stringify(this.tableDataAll) + '&tableColumns=' + JSON.stringify(this.tableColumns)
				});
			},
			getLineData(){
				var url = '/pentaho/proValue/getSingleVoteTrendChart';
				var param = this.createParam();

				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;

					var data = res.data.data;	
					
					var dates = data.dates
					var FB = data.FB
					var ALL = data.ALL
					var BK = data.BK						
			
					var series = [];
					series[0] =  {'name':'竞彩','data':ALL};
					series[1] =  {'name':'足球','data':FB};
					series[2] =  {'name':'篮球','data':BK};
									
					this.$set(this.lineData, 'categories', dates);
					this.$set(this.lineData, 'series', series);
					
					this.$refs['lineData5'].showCharts();
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			},
			refresh(){
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				this.getServerData();
				this.showView();
				this.getServerData();
				this.showView();
			},
			returnFromDatePicker(){
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				this.dateType = uni.getStorageSync("dateType")
				const bussinessDate = JSON.parse(uni.getStorageSync("businessDate"))
				this.selfParam.businessDate = bussinessDate;
				console.log('returnFromDatePicker:dateType=',this.selfParam.businessDate)	
						
				const area = uni.getStorageSync("area")
				const areaName = uni.getStorageSync("areaName")
				console.log('returnFromDatePicker:area=',area,', areaName=',areaName)					
				this.selfParam.provinceCenterId=area
				this.selfParam.provinceCenterName=areaName		
				uni.setStorageSync("selfParam",JSON.stringify(this.selfParam))
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
		padding: 5px 5px 5px 5px;
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
	
	.table {
		/* line-height: 40px; */
		display: flex;
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
