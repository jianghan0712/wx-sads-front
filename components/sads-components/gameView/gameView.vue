<template>
	<view >
		<view >
			<gametop></gametop>
		</view>
		<view class = "box-container">
			<view class="arcbarChart-tab">
			    <view @tap="changeTop('足球')" :class="arcbarNumTop =='足球'?'btna':'hide'" style="width: 50%;" >足球</view>
			    <view @tap="changeTop('篮球')" :class="arcbarNumTop =='篮球'?'btna':'hide'" style="width: 50%;" >篮球</view>
			</view>
			
			<dataContainer ref="gameData" :dataAs="totalData"></dataContainer>

			<view >
				<view class="clineChart-title">
					<view style="font-size: 30rpx;font-weight: bold;">{{arcbarNumTop}}销量及票数走势</view>
					<view class="linechart-tab">
					　　<view @tap="changeMid('销量')" :class="arcbarNumMid =='销量'?'btna':'hide'" >销量</view>
						<view @tap="changeMid('票数')" :class="arcbarNumMid =='票数'?'btna':'hide'" >票数</view>
					</view>
				</view>		
				<line-chart ref="lineData1" canvasId="lineData1" :dataAs="lineData1" />
			</view>	

			<view >
				<view class="clineChart-title">
					<view style="font-size: 30rpx;font-weight: bold;">{{arcbarNumTop}}游戏销量占比</view>
				</view>		
				<ring-chart canvasId="arcbar1" ref="arcbar1" :dataAs="arcbar1" />				
			</view>	
			<view>
				<gamebottom></gamebottom>
			</view>
			
			<view v-if="model.area=='all'">
				<view class="container-title">
					<view>各地区{{arcbarNumTop}}销量及占比</view>
					<view>全部>></view>
				</view>
				<view class="table">
					<v-table :columns="tableColumns" :list="tableData"  border-color="#FFFFFF"></v-table>
				</view>
			</view>
		</view>		
	</view>
</template>

<script>
	import MxDatePicker from '@/components/mx-datepicker/mx-datepicker.vue';
	import LineChart from '@/components/basic-chart/LineChart.vue';
	import PieChart from '@/components/basic-chart/PieChart.vue';
	import RingChart from '@/components/basic-chart/RingChart.vue';
	import gametop  from './gameViewTop.vue';
	import gamebottom from './gameViewBottom.vue';
	import dataContainer from '@/components/sads-components/dataContainer.vue';
	import vTable from "@/components/table/table.vue";
	
	export default {
			components:{
				MxDatePicker,
				LineChart,
				PieChart,
				RingChart,
				gametop,
				gamebottom,dataContainer,vTable
			},
			props: {
				model:{
					//数据
					type: Object,
					default: () => ({})
				}
			},
			created() {
				this.showModel = this.model;
				if(this.arcbarNumTop=='足球'){
					this.totalData = this.footballData;
				}else{
					this.totalData = this.basketballData;
				}
				uni.getLocation({
				    type: 'wgs84',
					geocode: true,
				    success: function (res) {
				        console.log('当前位置的经度：' + res.latitude);
				        console.log('当前位置的纬度：' + res.longitude);
						let locationString = res.latitude + "," + res.longitude;
						uni.request({
						    url: 'https://apis.map.qq.com/ws/geocoder/v1',
						    data: {
								key: "FZIBZ-RXJE6-Q7GSP-E3TUR-HMTKE-SMBBY",
								location: locationString,
								get_poi : 1
						    },
							method: 'GET',
							success: (res) => {
						        console.log(res.data);
						    },
							fail:(res)=>{
								console.log(res);
							}
						});
					
				    },
					complete:function (res) {

				    }
				});
				this.$nextTick(()=>{
					this.loadData();
				})
				
			},
			data() {
				return {
					showModel:{},
					totalData:{},
					footballData:{
						big1:{name:'足球销量（百万元）',value:37.82, left:{name:'周同比',value:-0.6209},right:{name:'环比',value:0.0145}},
						big2:{name:'足球票数（万张）',value:45.64, left:{name:'周同比',value:-0.0132},right:{name:'环比',value:0.1069}},
					},	
					basketballData:{
						big1:{name:'篮球销量（万元）',value:36.94, left:{name:'周同比',value:-0.5275},right:{name:'环比',value:-0.61}},
						big2:{name:'篮球占比（张）',value:4818.00, left:{name:'周同比',value:0.2306},right:{name:'环比',value:-0.9523}},
					},	
					arcbarNumTop: '足球',
					arcbarNumMid: '销量',
					btnnumTop:'足球',
					province:'',
					city:'',
					rowList: [
						{
							name: '刘晓晓',
							mobile: '18666666666',
							addressName: '贵族皇仕牛排(东城店)',
							address: '北京市东城区',
							area: 'B区',
							default: true
						},
						{
							name: '刘大大',
							mobile: '18667766666',
							addressName: '龙回1区12号楼',
							address: '山东省济南市历城区',
							area: '西单元302',
							default: false
						}
					],
					showTips: false,
					navigateFlag: false,
					pulling: false,
					refreshIcon: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAB5QTFRFcHBw3Nzct7e39vb2ycnJioqK7e3tpqam29vb////D8oK7wAAAAp0Uk5T////////////ALLMLM8AAABxSURBVHja7JVBDoAgDASrjqj//7CJBi90iyYeOHTPMwmFZrHjYyyFYYUy1bwUZqtJIYVxhf1a6u0R7iUvWsCcrEtwJHp8MwMdvh2amHduiZD3rpWId9+BgPd7Cc2LIkPyqvlQvKxKBJ//Qwq/CacAAwDUv0a0YuKhzgAAAABJRU5ErkJggg==",
					showPicker: false,
					date: '2019/01/01',
					time: '15:00:12',
					datetime: '2019/01/01 15:00:12',
					range: ['2019/01/01','2019/01/06'],
					rangetime: ['2019/01/08 14:00','2019/01/16 13:59'],
					type: 'rangetime',
					value: '',
					lineData1: {
						//数字的图--折线图数据
						categories: ['2012', '2013', '2014', '2015', '2016', '2017'],
						series: [
							{ name: '成交量A', data: [35, 8, 25, 37, 4, 20] },
							{ name: '成交量B', data: [70, 40, 65, 100, 44, 68] }
						]
					},
					arcbar1: {
							type: 'radar',
							series:[
									{name: '胜平负',data: 100},
									 {name: '半全场胜平负',data: 30},
									 {name: '让球胜平负',data: 50},
							],
							extra: {
								pie: {
									lableWidth: 15,
									ringWidth: 10, //圆环的宽度
									offsetAngle: 0 //圆环的角度
								}
							}
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
				};
			},
			methods: {
				changeTop(e){
					this.arcbarNumTop = e;;
					getApp().globalData.ballType=e; 
					console.log(getApp().globalData.ballType);
					// 根据e去请求对应的销量数据  默认值为销量
					this.lineData1 ={
						categories: ['2012', '2013', '2014', '2015', '2016', '2017'],
						series: [
							{ name: '成交量A', data: [35, 8, 25, 37, 4, 20] },
							{ name: '成交量B', data: [70, 40, 65, 100, 44, 68] }
						]
					};
					if(this.arcbarNumTop=='足球'){
						this.totalData = this.basketballData;	
					}else{
						this.totalData = this.footballData;
					}
					this.loadData()
					
				},
				changeMid(e){
					this.arcbarNumMid = e;
					// 根据e去请求对应数据
					this.lineData1 ={
						categories: ['2012', '2013', '2014', '2015', '2016', '2017'],
						series: [
							{ name: '成交量A', data: [35, 8, 25, 37, 4, 20] },
							{ name: '成交量B', data: [70, 40, 65, 100, 44, 68] }
						]
					};
				},
				loadData(){
					/* //请求足球数据
					let categories = ['20111', '2013', '2014', '2015', '2016', '2017'];
					let series = [{ name: '成交量A', data: [0.8511, 0.233, 0.125, 0.437, 0.48, 0.1234] }];
					this.$set(this.lineData1, 'categories', categories);
					this.$set(this.lineData1, 'series', series); */
					this.$refs['lineData1'].showCharts();
					this.$refs['arcbar1'].showCharts();
					this.$refs['gameData'].showDataContainer();
				}
			}
		}
</script>

<style>
	page {
	    width: 100%;
	    min-height: 100%;
	    display: flex;
		background-color: #FFFFFF;
	}
	
	.tabs {
	    flex: 1;
		width: 100%;
	    flex-direction: column;
	    overflow: hidden;
	    background-color: #ffffff;
	    height: 100vh;
	}
	.clineChart-title{
		display: flex;
		justify-content:space-between;
	}
	.linechart-tab{
		padding:0rpx 5rpx 0rpx 5rpx;
		flex-direction: row;
		display: flex;
		text-align: right;
		justify-content:flex-end;
		font-size: 30rpx;
	}
	.scroll-h {
	    width: 100%;
	    height: 100rpx;
	    flex-direction: row;
	    white-space: nowrap;
	    flex-wrap: nowrap;
	    border-color: #cccccc;
		border-bottom-style: solid;
		border-bottom-width: 1px;
	}
	
	.line-h {
	    height: 1rpx;
	    background-color: #cccccc;
	}
	
	.uni-tab-item {
	    display: inline-block;
	    flex-wrap: nowrap;
		width: 50%;
	}
	
	.uni-tab-item-title {
	    color: #555;
	    font-size: 40rpx;
		width: 100%;
	    height: 100rpx;
	    line-height: 80rpx;
		padding-left: 130rpx;
	    flex-wrap: nowrap;
	    white-space: nowrap;
	}
	
	.uni-tab-item-title-active {
	    color: #007AFF;
	}
	
	.swiper-box {
	    flex: 1;
	}
	
	.swiper-item {
	    flex: 1;
	    flex-direction: row;
	}
	
	.scroll-v {
	    flex: 1;
	    flex-direction: column;
	    width: 750rpx;
	}
	
	.update-tips {
	    position: absolute;
	    left: 0;
	    top: 41px;
	    right: 0;
	    padding-top: 5px;
	    padding-bottom: 5px;
	    background-color: #FDDD9B;
	    align-items: center;
	    justify-content: center;
	    text-align: center;
	}
	
	.update-tips-text {
	    font-size: 14px;
	    color: #ffffff;
	}
	
	.refresh {
	    width: 750rpx;
	    height: 64px;
	    justify-content: center;
	}
	
	.refresh-view {
	    flex-direction: row;
	    flex-wrap: nowrap;
	    align-items: center;
	    justify-content: center;
	}
	
	.refresh-icon {
		width: 30px;
		height: 30px;
		transition-duration: .5s;
		transition-property: transform;
		transform: rotate(0deg);
		transform-origin: 15px 15px;
	}
	
	.refresh-icon-active {
		transform: rotate(180deg);
	}
	
	.loading-icon {
		width: 20px;
		height: 20px;
		margin-right: 5px;
		color: #999999;
	}
	
	.loading-text {
	    margin-left: 2px;
	    font-size: 16px;
	    color: #999999;
	}
	
	.loading-more {
	    align-items: center;
	    justify-content: center;
	    padding-top: 10px;
	    padding-bottom: 10px;
	    text-align: center;
	}
	
	.loading-more-text {
	    font-size: 28rpx;
	    color: #999;
	}
	
	.btna{
		color: #000000;
		background: #ebebeb;
		padding:0px 30rpx 0px 30rpx;
	}
	.backWidth{
		width: 50%;
	}
	.dis{
		display: block;
		/* padding:0px 30rpx 0px 30rpx; */
	} 
	.hide{
		color: #000000;
		background: #FFFFFF;
		padding:0px 30rpx 0px 30rpx;
	},
	/* 将三个内容view的display设置为none(隐藏) */
	.arcbarChart-tab{
		/* padding:0rpx 5rpx 0rpx 5rpx; */
		flex-direction: row;
		display: flex;
		justify-content:center;
		font-size: 45rpx;
		font-family: 'Courier New', Courier, monospace;
	},
	.end-cont{
		/* text-align: left; */
		display: none;
		/* padding:0rpx 15rpx 0rpx 15rpx; */
		background: #FFFFFF;
	},
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
		margin-left: 0rpx;
	}
	
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
	
	.box-contaniner{
		width: 100%;
		margin: 20rpx 10rpx 40rpx 10rpx;
	}
	
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
	
</style>