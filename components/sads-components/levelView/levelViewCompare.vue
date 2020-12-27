<template>
	<view>
		<view class="box-contaniner">
			<view class="tab-content">
				<view class="end-title">
				　　<view @tap="change(0)" :class="btnnum == 0?'btna':'hide'">足球</view>
				  　<view @tap="change(1)" :class="btnnum == 1?'btna':'hide'">篮球</view>
				</view>	
				<view class="end-cont" :class="{dis:btnnum == 0}">	
					<view style="font-size: 30rpx;font-weight: bold;">足球关次销量及占比对比</view>				
					<view class="ring_chart">
						<ring-chart :dataAs="pieData" ref="levelRingChart0" canvasId="index_ring_0"/>
					</view>
					<view class="ring_chart">
						<ring-chart :dataAs="pieData2" ref="levelRingChart2" canvasId="index_ring_2"/>
					</view>
					<button  @click="gotoLunBo(btnnum)">查看全部</button>
					<!-- 各地区销量排行-->
					<view class="rankTable">
						<view class="rankTable-title">
							<view  style="font-weight: bold;">各地区足球关次销量及占比</view>
							<view class="rankTable-more">
								<picker @change="bindPickerChange" :value="index" :range="array" range-key="name">
									当前选择：{{array[index].name}}
								</picker>
							</view>
						</view>
						<view class="example">
							<v-table :columns="tableColumns" :list="tableData"  border-color="#FFFFFF"></v-table>
						</view>
						<button  @click="gotoTableDetail(btnnum)">查看全部</button>
					</view>
				</view>
				<view class="end-cont" :class="{dis:btnnum == 1}">	
					<view style="font-size: 30rpx;font-weight: bold;">篮球关次销量及占比</view>　
					<view class="ring_chart">
						<ring-chart :dataAs="pieData1" ref="levelRingChart1" canvasId="index_ring_1"/>
					</view>
					<view class="ring_chart">
						<ring-chart :dataAs="pieData3" ref="levelRingChart3" canvasId="index_ring_3"/>
					</view>
					<button  @click="gotoLunBo(btnnum)">查看全部</button>
					<!-- 各地区销量排行-->
					<view class="rankTable">
						<view class="rankTable-title">
							<view style="font-weight: bold;">各地区篮球关次销量及占比</view>
							<view class="rankTable-more">
								<picker @change="bindPickerChange" :value="index" :range="array" range-key="name">
									当前选择：{{array[index].name}}
								</picker>
							</view>
						</view>
						<view class="example">
							<v-table :columns="tableColumns" :list="tableData"  border-color="#FFFFFF"></v-table>
						</view>
						<button  @click="gotoTableDetail(btnnum)">查看全部</button>
					</view>
				</view>		
			</view>
		<slot />
		</view>
	</view>
</template>

<script>
	import RingChart from "@/components/basic-chart/RingChart.vue";
	import vTable from "@/components/table/table.vue";
	import urlAPI from '@/common/vmeitime-http/';
	import numberFun from '@/common/tools/number.js';

	
	export default {
		components: {
			RingChart,
			vTable
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
				btnnum: 0,
				index: 0,
				levelList:['单关','2x1','3x1','4x1-8x1','MXN','自有过关'],
				pieData: {					//饼状图数据
					series: [],
					},
				pieData1: {
					series: [],
				},
				pieData2: {					//饼状图数据
					series: [],
					},
				pieData3: {
					series: [],
				},
				tableData: [],
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
						title: '占比',
						key: 'zhanbi',
						$width:"130px"
					},
					{
						title: '销量（元）',
						key: 'amount'
					}
				],	
				array: [{name:'单关'},{name: '2X1'}, {name:'3X1'}, {name:'4X1-8X1'}, {name:'MXN'}, {name:'自由过关'}],
			};
		},
		onLoad() {
			_self = this;
			this.showView();
		},
		created() {
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			this.getServerData();
			this.showView();
		},
		methods: {
			refresh(){
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				this.getServerData();
				this.showView();
				this.getServerData();
				this.showView();
			},
			showView(){				
				this.$nextTick(() => {	
					this.$refs['levelRingChart0'].showCharts();
					this.$refs['levelRingChart1'].showCharts();
					this.$refs['levelRingChart2'].showCharts();
					this.$refs['levelRingChart3'].showCharts();
					console.log("init ringChart0:" ,this.pieData);
				});
			},
			getServerData() {
				this.getPieDate('足球')
				this.getPieDate('篮球')
				this.getTableDate(this.btnnum, '单关')
			},
		    change(e) {
			    this.btnnum = e;
			    console.log(this.btnnum);
				this.getServerData();
				this.showView();
		    },
			bindPickerChange(e) {
				console.log('picker发送选择改变，携带值为：' + this.array[e.detail.value].name)
				console.log(this.selfParam)
				this.index = e.detail.value
				this.getTableDate(this.btnnum, this.array[e.detail.value].name)
			},
			gotoLunBo(btnnum){			
				if(btnnum==0){
					uni.navigateTo({
						url:"/pages/common/ringDetailTwo?type=level&leftPie=" + JSON.stringify(this.pieData) + "&rightPie="+ JSON.stringify(this.pieData2)
					});
				}else{
					uni.navigateTo({
							url:"/pages/common/ringDetailTwo?type=level&leftPie=" + JSON.stringify(this.pieData1) + "&rightPie="+ JSON.stringify(this.pieData3)
					});
				}
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
			getPieDate(type){
				var url = '/pentaho/gamesContrast/getComPassSalesProp';
				var param = this.createParam()
				param.token=getApp().globalData.token
				if(type=='足球'){
					param.gameFlag=1
				}else{
					param.gameFlag=2
				}
				var that =this;
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					var data = res.data.data;
				    if(data==null){
						return;
					}
					var pass = data.pass
					var comPass = data.comPass
					
					var series = []
					for(var i=0;i<pass.length;i++){	
						var jsonData = {}
						that.levelList = pass[i].customsName						
						jsonData.name=pass[i].customsName;
						jsonData.data=pass[i].values[0];
						series[i]=jsonData					
					}
					
					var series2 = []
					for(var i=0;i<comPass.length;i++){
						var jsonData = {}				
						jsonData.name=comPass[i].customsName;
						jsonData.data=comPass[i].values[0];
						series2[i]=jsonData					
					}
					
					if(type=='足球'){
						that.pieData.series=series
						that.pieData2.series=series2
						this.$refs['levelRingChart0'].showCharts();
						this.$refs['levelRingChart2'].showCharts();
					}else if(type=='篮球'){
						that.pieData1.series=series
						that.pieData3.series=series2
						this.$refs['levelRingChart1'].showCharts();
						this.$refs['levelRingChart3'].showCharts();
					}
					
					console.log('request getTodSalesAmount', that.pieData);				
					that.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			getTableDate(btnnum, passName){
				var url = '/pentaho/sales/checkpointSalesRanking';
				var param = this.createParam()
				param.token=getApp().globalData.token
				var that =this;
				param.passName=passName;
				urlAPI.getRequest(url, param).then((res)=>{	
					this.loading = false;
					console.log('request success', res)
					uni.showToast({
						title: '请求成功',
						icon: 'success',
						mask: true
					});
					var data = res.data.data;

					var series = []
					for(var i=0;i<data.length;i++){	
						var jsonData = {}
						jsonData.id=i+1
						jsonData.area=data[i][0];
						jsonData.zhanbi=data[i][1]+'%';
						jsonData.amount=data[i][2];
						series[i]=jsonData					
					}
					that.tableData = series
					
					console.log('request checkpointSalesRanking', that.tableData);				
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			gotoTableDetail(btnnum){
				uni.navigateTo({
					url:"/pages/common/tableDetail?tableData= " + JSON.stringify(this.tableData) + '&tableColumns=' + JSON.stringify(this.tableColumns)
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
	.box-contaniner{
		width: 100%;
		margin: 20rpx 10rpx 40rpx 10rpx;
	}
	
    /* 将三个内容view的display设置为none(隐藏) */
	.tab-content{
		margin: 20rpx 10rpx 20rpx 10rpx;
		/* padding: 20rpx 10rpx 20rpx 10rpx; */
	}
    .end-title{
        display: flex;
    }
    .end-title view{
        flex-grow: 1;
        text-align: center;
    }
   .end-cont{
		display: none;
		background: #FFFFFF;
    }
   .btna{
		color: #FFFFFF;
		background:rgba(47, 98, 248 ,0.5);	
    }
    .dis{
        display: block;
		color: #000000;
		background:#FFFFFF;
    } 
	
	
	.rankTable{
		width: 100%;
		height: 500upx;
		margin: 0rpx 0rpx;
		padding: 0 0rpx;
		font-size: 30rpx;		
		background-color: #FFFFFF;
	}
	
	.rankTable-title{
		width: 100%;
		margin: 0rpx 0rpx;
/* 		padding: 0 10rpx; */
		display: flex;
		/* font-weight: bold; */
		justify-content: space-between;
	}
	
	.rankTable-more{
/* 		margin: 0rpx 10rpx;
		padding: 0 10rpx; */
		text-align: right;
	}
		
	
	.example {
		/* line-height: 40px; */
		/* font-weight: bold; */
		border-color:#FFFFFF;
	}
	
	button {
		width: 75%;
	    margin-top: 30rpx;
	    margin-bottom: 30rpx;
		font-size: 30rpx;
		background-color: rgba(220, 241, 250,0.5);
		color: #007AFF;
	}

</style>
