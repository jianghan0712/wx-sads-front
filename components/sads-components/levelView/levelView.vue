<template>
	<view>
		<view class="box-contaniner">
			<view class="tab-content">
				<view class="end-title">
				　　<view @tap="change(0)" :class="btnnum == 0?'btna':'hide'">足球</view>
				  　<view @tap="change(1)" :class="btnnum == 1?'btna':'hide'">篮球</view>
				</view>	
				<view class="end-cont" :class="{dis:btnnum == 0}">	
					<view style="font-size: 30rpx;font-weight: bold;">足球关次销量及占比</view>				
					<view class="ring_chart">
						<ring-chart :dataAs="pieData" ref="levelRingChart0" canvasId="index_ring_0"/>
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
				tableData: [],
				tableDataDetail: [],
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
			this.selfParam=this.param
			this.getServerData();
			// this.showView();
		},
		methods: {
			showView(){				
				this.$nextTick(() => {	
					this.$refs['levelRingChart0'].showCharts();
					this.$refs['levelRingChart1'].showCharts();
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
				console.log('JSON.stringify(this.pieData)：' + JSON.stringify(this.pieData));				
				if(btnnum==0){
					uni.navigateTo({
						url:"/pages/common/ringDetail?data=" + JSON.stringify(this.pieData)
					});
				}else{
					uni.navigateTo({
						url:"/pages/common/ringDetail?data=" + JSON.stringify(this.pieData1)
					});
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
				
				if(this.btnnum==0){
					param.gameFlag = 1
				}else if(this.btnnum==1){
					param.gameFlag = 2
				}
				
				console.log("createParam end:",param)
				return param
			},
			getPieDate(type){
				var url = '/pentaho/sales/getCheckpointSalesProp';
				var param = this.createParam()
				var that =this;
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
						that.levelList = data[i].customsName						
						jsonData.name=data[i].customsName;
						jsonData.data=data[i].values[0];
						series[i]=jsonData					
					}
					
					if(type=='足球'){
						that.pieData.series=series
						this.$refs['levelRingChart0'].showCharts();
						
					}else if(type=='篮球'){
						that.pieData1.series=series
						this.$refs['levelRingChart1'].showCharts();
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
					if(data==null ||data.length==0){
						return;
					}
					var format0 = numberFun.formatCNumber(data[0][2]); 
					var series = []
					for(var i=0;i<data.length;i++){	
						var jsonData = {}
						jsonData.id=i+1
						jsonData.area=data[i][0];
						jsonData.zhanbi=data[i][1]+'%';
						jsonData.amount=(data[i][2]/format0.value).toFixed(2);
						if (i<=4){
							series[i]=jsonData	
						}
						this.tableDataDetail[i] = jsonData				
					}
					that.tableData = series
					this.tableColumns=[{
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
							title: '销量（' + format0.name + '元）',
							key: 'amount'
						}
					],	
					console.log('request checkpointSalesRanking', that.tableData);				
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			gotoTableDetail(btnnum){
				uni.navigateTo({
					url:"/pages/common/tableDetail?tableData= " + JSON.stringify(this.tableDataDetail) + '&tableColumns=' + JSON.stringify(this.tableColumns)
				});
			},
			refresh(){
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				this.getServerData();
				this.showView();
			},
		},
		mounted(){
			this.selfParam=this.param
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
		color: #000000;
		background:rgba(231, 237, 237  ,0.5);	
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
