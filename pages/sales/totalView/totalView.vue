<template>
	<view>
		<view class="row_box_2">
			<view class="row-box">
				<view class="column_box_2">
					<view class="column-box">
						<text class="big-text">销量（万元）</text>
						<text class="big-text">110.00</text>
					</view>
					<view class="column-box">
						<view class="row_box_2">
							<view class="row-box">
								<text class="small-text">同比</text>
								<text class="small-text">+12.00%</text>
							</view>
							<view class="row-box">
								<text class="small-text">环比</text>
								<text class="small-text">+1.30%</text>
							</view>
						</view>
					</view>
				</view>			
			</view>
			<view class="row-box">
				<view class="column_box_2">
					<view class="column-box">
						<text class="big-text">票数（万元）</text>
						<text class="big-text">65.30</text>
					</view>
					<view class="column-box">
						<view class="row_box_2">
							<view class="row-box">
								<text class="small-text">同比</text>
								<text class="small-text">+12.00%</text>
							</view>
							<view class="row-box">
								<text class="small-text">环比</text>
								<text class="small-text">+1.30%</text>
							</view>
						</view>
					</view>
				</view>			
			</view>
		</view>
		<!-- 折线Line纯数字-->
		<view class="lineChart-box">
			<view class="clineChart-title">
				<view style="font-size: 30rpx;font-weight: bold;">竞彩销量及票数走势</view>
				<view class="linechart-tab">
				　　<view @tap="change(0)" :class="{btna:btnnum == 0}">销量</view>
				  　<view @tap="change(1)" :class="{btna:btnnum == 1}">票数</view>
				</view>
			</view>		
			<view class="end-cont" :class="{dis:btnnum == 0}">		
			 　 <view class="line">
					<line-chart ref="lineData2" canvasId="index_line_2" :dataAs="lineData2" />
			</view>
			</view>
			<view class="end-cont" :class="{dis:btnnum == 1}">		　
			 　 <view class="line">
					<line-chart ref="lineData1" canvasId="index_line_2" :dataAs="lineData1" />
			</view>
		</view>		

		<!-- 圆环arcbar -->
		<view class="lineChart-box">
				<view class="clineChart-title">
					<view style="font-size: 30rpx;font-weight: bold;">竞彩足篮球销量及占比</view>
					<view class="linechart-tab">
					　　<view @tap="changeArcbar(0)" :class="{btna:arcbarNum == 0}">足球</view>
					  　<view @tap="changeArcbar(1)" :class="{btna:arcbarNum == 1}">篮球</view>
					</view>
				</view>	
				<view class="end-cont" :class="{dis:arcbarNum == 0}">
				 　 <view class="arcbar">
						<arcbar-chart :canvasId="`index_arcbar_0`" :ref="`arcbar0`" :dataAs="arcbar0" :basicAs="{colors: ['#ff7600']}"/>
					</view>
				</view>
				<view class="end-cont" :class="{dis:arcbarNum == 1}">		　
					<view class="arcbar">
						 <arcbar-chart :canvasId="`index_arcbar_1`" :ref="`arcbar1`" :dataAs="arcbar1" :basicAs="{colors: ['#ff7600']}"/>
				</view>				
			</view>
		</view>	
		
		<!-- 门店在售情况-->
		<view class="shop-box">
			<view class="shop-title">门店在售情况</view>
			<view class="shop-item-title">
				<view style="width: 400rpx;">在售门店数</view>				
				<view style="width: 200rpx;">同比</view>
				<view style="-webkit-flex: 1;flex: 1;">环比</view>
			</view>
			<view class="shop-item-content">
				<view style="width: 400rpx;">365,041</view>				
				<view style="width: 200rpx;">+12.9%</view>
				<view style="-webkit-flex: 1;flex: 1;">+1.23%</view>
			</view>
			<view>  </view>
			<view class="shop-item-title">
				<view style="width: 400rpx;">门店在售率</view>				
				<view style="width: 200rpx;">同比</view>
				<view style="-webkit-flex: 1;flex: 1;">环比</view>
			</view>
			<view class="shop-item-content">
				<view style="width: 400rpx;">90.54%</view>				
				<view style="width: 200rpx;">+12.9%</view>
				<view style="-webkit-flex: 1;flex: 1;">+1.23%</view>
			</view>
		</view>
		
		<!-- 各地区销量排行-->
		<view class="rankTable">
			<view class="rankTable-title">
				<view>各地区销量排行</view>
				<view class="rankTable-more">全部>></view>
			</view>
			<view class="example">
				<v-table :columns="tableColumns" :list="tableData" :height="250" border-color="#FFFFFF"></v-table>
			</view>
		</view>
		
		<slot />
	</view>
</template>

<script>
	import LineChart from '@/components/basic-chart/LineChart.vue';
	import ArcbarChart from '@/components/basic-chart/ArcbarChart.vue';
	import vTable from "@/components/table/table.vue"
	
	export default {
		name: 'Index',
		components: {
			LineChart,
			ArcbarChart,
			vTable
		},
		data() {
			return {
				btnnum: 0,
				arcbarNum: 0,
				lineData2: {
					//数字的图--折线图数据
					categories: ['2012', '2013', '2014', '2015', '2016', '2017'],
					series: [
						{ name: '成交量A', data: [35, 8, 25, 37, 4, 20] },
						{ name: '成交量B', data: [70, 40, 65, 100, 44, 68] },
						{ name: '成交量C', data: [100, 80, 95, 150, 112, 132] }
					]
				},
				lineData1: {
					//数字的图--折线图数据
					categories: ['2012', '2013', '2014', '2015', '2016', '2017'],
					series: [
						{ name: '成交量A', data: [35, 8, 25, 37, 4, 20] },
						{ name: '成交量B', data: [70, 40, 65, 100, 44, 68] }
					]
				},
				arcbar0: {					
						series: [{name: '足球',data: 0.6921}]
				},
				arcbar1: {
						series: [{name: '篮球',data: 0.3079}]
				},
				tableData: [{
							id: "1",
							area: "北京市",
							amount: "10233.5",
							tongbi: "+12.6%",
							huanbi: "+45.21%"
						},
						{
							id: "2",
							area: "上海市",
							amount: "9965.5",
							tongbi: "+12.6%",
							huanbi: "+45.21%"
						},
						{
							id: "3",
							area: "广东省",
							amount: "9754.5",
							tongbi: "+12.6%",
							huanbi: "+45.21%"
						},
						{
							id: "4",
							area: "重庆市",
							amount: "6745.6",
							tongbi: "+12.6%",
							huanbi: "+45.21%"
						},
						{
							id: "5",
							area: "河北省",
							amount: "6554",
							tongbi: "+12.6%",
							huanbi: "+45.21%"
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
							$width:"100px"
						},
						{
							title: '销量',
							key: 'amount',
							$width:"80px"
						},
						{
							title: '同比',
							key: 'tongbi',
							$width:"80px"
						},
						{
							title: '环比',
							key: 'huanbi',
							$width:"80px"
						}
					],					
			};
		},
		onLoad() {
			_self = this;
			this.cWidth=uni.upx2px(750);
			this.cHeight=uni.upx2px(500);
			this.getServerData();
		},
		methods: {
			getServerData() {
				//模拟ajax调用
				// uni.request({
				// 	url: 'https://www.easy-mock.com/mock/5cc586b64fc5576cba3d647b/uni-wx-charts/chartsdata2',
				// 	data: {},
				// 	success: function(res) {
				// 		console.log(res.data.data);
				// 		let serverData = res.data.data;
				// 		this.$set(this.lineData, 'categories', serverData.Column.categories);
				// 		this.$set(this.lineData, 'series', serverData.Column.series);
				// 		this.$refs['lineData1'].showCharts();
				// 	},
				// 	fail: () => {
				// 		console.log('网络错误');
				// 	}
				// });
				setTimeout(() => {
					//延迟模拟ajax嗲用后台数据
					let categories = ['20111', '2013', '2014', '2015', '2016', '2017'];
					let series = [{ name: '成交量A', data: [0.8511, 0.233, 0.125, 0.437, 0.48, 0.1234] }];
					this.$set(this.lineData, 'categories', categories);
					this.$set(this.lineData, 'series', series);
					this.$refs['lineData1'].showCharts();
				}, 1000);
			},
			change(e) {
			      this.btnnum = e
			      console.log(this.btnnum)
			},
			changeArcbar(e){
				this.arcbarNum = e
				console.log(this.arcbarNum)
			}
		},
		created() {
			this.$nextTick(() => {
				//柱状图
				// this.$refs['histogramData0'].showCharts();
				// this.$refs['histogramData1'].showCharts();
				// this.$refs['histogramData2'].showCharts();
				// //圆环(注意循环可能会导致出现下面情况,请更具实际情况作出判断// console.log(this.$refs);)
				this.$refs['arcbar0'].showCharts();
				this.$refs['arcbar1'].showCharts();
				// this.$refs['arcbar2'][0].showCharts();
				// // 饼状图
				// this.$refs['pieChart0'].showCharts();
				// // 环状图
				// this.$refs['ringChart0'].showCharts();
				//折线图
				this.$refs['lineData2'].showCharts();
				this.$refs['lineData1'].showCharts();
			});
			//ajax调用
			this.getServerData();
		}
	}
</script>

<style>	
	.row_box_2{
		display: flex;
		flex-direction: row;		
	}
	
	.column_box_2{	
		display: flex;
		flex-direction: column;
	}

	.row-box {
		width: 50%;
		margin: 0rpx 5rpx;
		padding: 0 10rpx;
		background-color: #ebebeb;
	}

	.column-box{
		height: 50%;
		margin: 0rpx 5rpx;
		padding: 0 5rpx;
		background-color: #ebebeb;
	}
	
	.big-text{
		text-align: left;
		background-color: #ebebeb;
		color: #777;
		font-size: 40rpx;
	}
	
	.small-text{
		text-align: left;
		background-color: #ebebeb;
		color: #777;
		font-size: 30rpx;
	}
	
	/*样式的width和height一定要与定义的cWidth和cHeight相对应*/
	.qiun-charts {
		width: 750upx;
		height: 500upx;
		background-color: #FFFFFF;
	}
	
	.charts {
		width: 750upx;
		height: 500upx;
		background-color: #FFFFFF;
	}
	
	.shop-box {
		width: 100%;
		height: 500upx;
		margin: 0rpx 5rpx;
		padding: 0 10rpx;
		background-color: #FFFFFF;
	}
	
	.shop-title{
		width: 100%;
		margin: 0rpx 5rpx;
		padding: 0 10rpx;
		font-size: 30rpx;
		font-weight: bold;
		background-color: #FFFFFF;
	}
	
	.shop-item-title{
		width: 100%;
		display: flex;
		margin: 0rpx 5rpx;
		padding: 0 10rpx;
		flex-direction: row;
		background-color: #ebebeb;
	}
	.shop-item-content{
		width: 100%;
		display: flex;
		margin: 0rpx 5rpx;
		padding: 0 10rpx;
		flex-direction: row;
		background-color: #ebebeb;
	}
	
	.rankTable{
		width: 100%;
		height: 500upx;
		margin: 0rpx 5rpx;
		padding: 0 10rpx;
		font-size: 30rpx;
		font-weight: bold;
		background-color: #FFFFFF;
	}
	
	.rankTable-title{
		width: 100%;
		margin: 0rpx 5rpx;
		padding: 0 10rpx; 
		display: flex;
		justify-content: space-between;
	}
	
	.rankTable-more{
		margin: 0rpx 5rpx;
		padding: 0 10rpx;
		text-align: right;
	}
		
	
	.example {
		/* line-height: 40px; */
		font-weight: bold;
		border-color:#FFFFFF;
	}
	
	.title {
		/* line-height: 40px; */
		font-weight: bold;
		border-color:#FFFFFF;
	}
	
	.lineChart-box{
		padding:10px 20px 10px 5px;
	}
	.clineChart-title{
		display: flex;
		justify-content:space-between;
	}
	/* 将三个内容view的display设置为none(隐藏) */
	.linechart-tab{
		padding:0px 20px 0px 5px;
		flex-direction: row;
		display: flex;
		text-align: right;
		justify-content:flex-end;
		font-size: 30rpx;
	}
	
	.end-cont{
		/* text-align: left; */
		display: none;
		padding:10px 20px 0px 5px;
		background: #FFFFFF;
	}
	.btna{
		color: #FFFFFF;
		background: #ebebeb;
	}
	.dis{
		display: block;
	}    
</style>
