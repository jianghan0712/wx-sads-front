<template>
	<view>
		<view class="box-contaniner">
			<view class="container-title">单票金额对比</view>
			<dataContainerTwoColThree></dataContainerTwoColThree>
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
						<ring-chart :legendAs="legend" :dataAs="pieData" ref="ringChart0" canvasId="index_ring_0"/>
					</view>
					<view class="ring_chart">
						<ring-chart :legendAs="legend" :dataAs="pieData" ref="ringChart3" canvasId="index_ring_3"/>
					</view>
				</view>
				<view class="end-cont" :class="{dis:btnnum == 1}">
					<view class="ring_chart">
						<ring-chart :dataAs="pieData1" ref="ringChart1" canvasId="index_ring_1"/>
					</view>
					<view class="ring_chart">
						<ring-chart :dataAs="pieData1" ref="ringChart4" canvasId="index_ring_4"/>
					</view>
				</view>
				<view class="end-cont" :class="{dis:btnnum == 2}">
					<view class="ring_chart">
						<ring-chart :dataAs="pieData2" ref="ringChart2" canvasId="index_ring_2"/>
					</view>		
					<view class="ring_chart">
						<ring-chart :dataAs="pieData2" ref="ringChart5" canvasId="index_ring_5"/>
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
</template>

<script>
	import RingChart from "@/components/basic-chart/RingChart.vue";
	import dataContainerTwoColThree from '@/components/sads-components/dataContainerTwoColThree.vue';
	import vTable from "@/components/table/table.vue";
	import urlAPI from '@/common/vmeitime-http/';
	import numberFun from '@/common/tools/number.js';
	
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
				param:{},
				btnnum: 0,
				pieData: {
					//饼状图数据
					series: [{name: '100',data: 222100},{name: '4-20',data: 70300},{name: '22-48',data: 32100},{name: '100以上',data: 25400},
						{name: '52-98',data: 19700},{name: '2',data: 16000},{name: '50',data: 10500},
					]
				},
				pieData1: {series: []},
				pieData2: {series: []},
				tableData: [],
				tableDataAll: [],
				tableColumns: [],	
				legend: {
					show: false
				},
			}
		},
		onLoad() {
			_self = this;
			this.getServerData();
			this.showView()
		},
		methods: {
			showView(){
				console.log("ticket showView" ,this.pieData);
				this.$nextTick(() => {		
					this.$refs['ringChart0'].showCharts();
					this.$refs['ringChart1'].showCharts();
					this.$refs['ringChart2'].showCharts();
					this.$refs['ringChart3'].showCharts();
					this.$refs['ringChart4'].showCharts();
					this.$refs['ringChart5'].showCharts();
				});
			},
			getServerData() {
				this.getPieData(this.param.provinceCenterId,this.param.businessDate);
				this.getRankTable(this.param.provinceCenterId,this.param.businessDate);
			},
			change(e) {
			    this.btnnum = e;
			    console.log(this.btnnum);
			},
			getPieData(provinceCenterId, currentDate){
				var url = '/exhibition/ticketAmount/querySalesTickets/' + provinceCenterId + '/' + currentDate;
				urlAPI.getRequest(url, null).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					uni.showToast({
						title: '请求成功',
						icon: 'success',
						mask: true
					});
					
					var data = res.data.concreteBean;
					var ftList=[];
					var bkList=[];
					for(var i=0; i<data.length; i++){
						var ftObject = {name:data[i][0],data:data[i][1]};
						var bkObject = {name:data[i][0],data:data[i][2]};
						ftList[i]=ftObject;
						bkList[i]=bkObject;
					}
					
					this.$set(this.pieData1, 'series', ftList);
					this.$set(this.pieData2, 'series', bkList);
					
					console.log('request pieData1', this.pieData1);	
					console.log('request pieData2', this.pieData2);
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			getRankTable(provinceCenterId, currentDate){
				var url = '/exhibition/ticketAmount/queryAvgTicketRegion/' + provinceCenterId+'/'+currentDate;				
				urlAPI.getRequest(url, null).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					uni.showToast({
						title: '请求成功',
						icon: 'success',
						mask: true
					});
					var data = res.data.concreteBean;
					var format0 = null;
					if(data.length>0){
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
										jingcai:data[i][1].toFixed(2)/format0.value, 
										football:data[i][2].toFixed(2)/format0.value,
										basketball:data[i][3].toFixed(2)/format0.value,
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
			}
		},
		mounted(){
			this.showView();
		},
		watch: {
			'$route':'showView'
		},
		created() {
			this.param = this.model;
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
