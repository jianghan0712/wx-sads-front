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
		<slot />
	</view>	
</template>

<script>
	import ticketData from '@/components/sads-components/ticketData.vue';
	import RingChart from "@/components/basic-chart/RingChart.vue";
	import vTable from "@/components/table/table.vue";
	import progress from "@/components/sads-components/progress.vue";
	
	export default {
		components: {
			ticketData,RingChart,vTable,progress
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
				}
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
				
				this.$refs['progress_0'].showProgress();
				this.$refs['progress_1'].showProgress();
				this.$refs['progress_2'].showProgress();
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
