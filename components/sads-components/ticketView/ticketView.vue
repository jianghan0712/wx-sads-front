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
				<view>全部>></view>
			</view>
			<view class="table">
				<v-table :columns="tableColumns" :list="tableData"  border-color="#FFFFFF"></v-table>
			</view>
		</view>
		<slot />
	</view>	
</template>

<script>
	import ticketData from '@/components/sads-components/ticketData.vue';
	import RingChart from "@/components/basic-chart/RingChart.vue";
	import vTable from "@/components/table/table.vue";
	
	export default {
		components: {
			ticketData,RingChart,vTable
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
				model:{
					//数据
					type: Object,
					default: () => ({})
				},
				showModel:{},
				btnnum: 0,
				ticketData:{
					big1:{name:'竞彩（元）',value:'131.8'},
					small1:{name:'足彩（元）',value:'131.80'},
					small2:{name:'篮彩（元）',value:'0.00'},
				},
				pieData: {
					//饼状图数据
					series: [{name: '100',data: 222100},{name: '4-20',data: 70300},{name: '22-48',data: 32100},{name: '100以上',data: 25400},
						{name: '52-98',data: 19700},{name: '2',data: 16000},{name: '50',data: 10500},
					]
				},
				pieData1: {
					//饼状图数据
					series: [{name: '100',data: 422100},{name: '4-20',data: 170300},{name: '22-48',data: 32100},{name: '100以上',data: 25400},
						{name: '52-98',data: 19700},{name: '2',data: 16000},{name: '50',data: 10500},
					]
				},
				pieData2: {
					//饼状图数据
					series: [{name: '100',data: 122100},{name: '4-20',data: 170300},{name: '22-48',data: 32100},{name: '100以上',data: 25400},
						{name: '52-98',data: 19700},{name: '2',data: 16000},{name: '50',data: 10500},
					]
				},
				tableData: [{
							id: "1",
							area: "北京市",
							jingcai: "10233.5",
							football: "146784.00",
							basketball: "29785.00"
						},
						{
							id: "2",
							area: "上海市",
							jingcai: "9965.5",
							football: "100054.00",
							basketball: "3785.00"
						},
						{
							id: "3",
							area: "广东省",
							jingcai: "9754.5",
							football: "9785.00",
							basketball: "6585.00"
						},
						{
							id: "4",
							area: "重庆市",
							jingcai: "6745.6",
							football: "9685.00",
							basketball: "9725.00"
						},
						{
							id: "5",
							area: "河北省",
							jingcai: "6554",
							football: "8785.00",
							basketball: "19785.00"
						}
					],
				tableColumns: [{
							title: "排名",
							key: "id",
							$width:"50px",
						},
						{
							title: '省份',
							key: 'area',
							$width:"80px"
						},
						{
							title: '竞彩（元）',
							key: 'jingcai',
							$width:"80px"
						},
						{
							title: '足球（元）',
							key: 'football',
							$width:"85px"
						},
						{
							title: '篮球（元）',
							key: 'basketball'
						}
					],	
			}
		},
		methods: {
			getServerData() {
				
			},
			change(e) {
			    this.btnnum = e;
			    console.log(this.btnnum);
			},
		},
		created() {
			this.showModel = this.model;
			this.$nextTick(() => {
				this.$refs['ticketData'].showDataContainer();		
				this.$refs['ringChart0'].showCharts();
				this.$refs['ringChart1'].showCharts();
				this.$refs['ringChart2'].showCharts();
			});
			//ajax调用
			this.getServerData();
		}
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
