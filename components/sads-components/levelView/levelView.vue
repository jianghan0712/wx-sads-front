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
					<button type="default" plain="true" @click="gotoLunBo(btnnum)">查看全部</button>
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
						<button type="default" plain="true" @click="gotoTableDetail(btnnum)">查看全部</button>
					</view>
				</view>
				<view class="end-cont" :class="{dis:btnnum == 1}">	
					<view style="font-size: 30rpx;font-weight: bold;">篮球关次销量及占比</view>　
					<view class="ring_chart">
						<ring-chart :dataAs="pieData1" ref="levelRingChart1" canvasId="index_ring_1"/>
					</view>
					<button type="default" plain="true" @click="gotoLunBo(btnnum)">查看全部</button>
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
						<button type="default" plain="true" @click="gotoTableDetail(btnnum)">查看全部</button>
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
					provinceCenterId:'',
					businessDate:{
						view:'',
						date:{startDate:'', endDate:''},
						week:{startDate:'', endDate:''},
						month:{startDate:'', endDate:''},
						year:{startDate:'', endDate:''},
					},					
					startDate:'',
					endDate:'',
					cityCenterId:'',
					userId:'',
					countyCenterId:'',
					dateType:'',
					compareType:'',
					compareOne:'',
					compareTwo:''
				},
				btnnum: 0,
				index: 0,
				levelList:['单关','2x1','3x1','4x1-8x1','MXN','自有过关'],
				pieData: {					//饼状图数据
					series: [],
					},
				pieData1: {},
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
						$width:"150px"
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
		},
		created() {
			this.selfParam=this.param
			this.getServerData();
			this.showView();
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
						url:"/pages/common/levelRingDetail?btnnum="+ btnnum + "&data=" + JSON.stringify(this.pieData)
					});
				}else{
					uni.navigateTo({
						url:"/pages/common/levelRingDetail?btnnum="+ btnnum + "&data=" + JSON.stringify(this.pieData1)
					});
				}
			},
			createParam(){
				console.log("createParam begin")
				var dateType = this.selfParam.dateType
				var param = {}
				if(dateType=='date'){
					param = {dateTimeStart: this.selfParam.businessDate.date.startDate,
							 dateTimeEnd: this.selfParam.businessDate.date.dateTimeEnd,
							 dateFlag:"1",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='week'){
					param = {dateTimeStart: this.selfParam.businessDate.week.startDate,
							 dateTimeEnd: this.selfParam.businessDate.week.dateTimeEnd,
							 dateFlag:"2",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='month'){
					param = {dateTimeStart: this.selfParam.businessDate.month.startDate,
							 dateTimeEnd: this.selfParam.businessDate.month.dateTimeEnd,
							 dateFlag:"3",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='year'){
					param = {dateTimeStart: this.selfParam.businessDate.year.startDate,
							 dateTimeEnd: this.selfParam.businessDate.year.dateTimeEnd,
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
						this.levelList = data[i].customsName						
						jsonData.name=data[i].customsName;
						jsonData.data=data[i].values[0];
						series[i]=jsonData					
					}
					
					if(type=='足球'){
						this.pieData.series=series
					}else if(type=='篮球'){
						this.pieData1.series=series
					}
					
					console.log('request getTodSalesAmount', this.pieData);				
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			getTableDate(btnnum, passName){
				var url = '/pentaho/sales/checkpointSalesRanking';
				var param = this.createParam()

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
					this.tableData = series
					
					console.log('request checkpointSalesRanking', this.tableData);				
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
			this.selfParam=this.param
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
		background: #ebebeb;
		/* padding:0px 5rpx 0px 5rpx; */
    }
    .dis{
        display: block;
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
	}

</style>
