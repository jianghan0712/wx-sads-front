<template>
	<!-- 顶部导航 -->
	<view class="order-nav x-f">
		<scroll-view class="scroll-view_H" scroll-x="true" scroll-left="120">
			<view class="nav-item y-f scroll-view-item_H" v-for="nav in navList" :key="nav.id" @tap="onNav(nav)">
				<view class="item-title" :class="{ 'line-active': currentType === nav.text }">{{ nav.text }}</view>
			</view>
		</scroll-view>
	</view>

</template>

<script>
	//导入官方插件之后，使用插件第一步就是引入JS文件。
	import uCharts from '@/components/u-charts/u-charts.js';
	var _self;
	var canvaColumn = null;
	
	export default {
		data() {
			return {
				navList: [],
				timeList: [],
				currentType: '佣金趋势图',
				currentTime: '今日',
				cWidth: '',
				cHeight: '',
				pixelRatio: 1,
				serverData: ''
			}
		},
		onLoad() {
			//获取分销管理 顶部导航
			this.$api('distributionCenter.initTopNav', {}).then(res => {
				this.navList = res.data.items;
			});
			//获取分销管理 时间按钮
			this.$api('distributionCenter.initTimeBtn', {}).then(res => {
				this.timeList = res.data.items;
			});
			
			// 获取canvas
			_self = this;
			// 获取系统信息。如手机的型号，手机品牌，像素比等
			uni.getSystemInfo({
				success: function(res) {
					// pixelRatio 设备像素比
					if (res.pixelRatio > 1) {
						//正常这里给2就行，如果pixelRatio=3性能会降低一点，我的项目中pixelRatio 为2效果不好，固定给了1
						_self.pixelRatio = 1;
					}
				}
			});
			//如果需要修改canvas的宽高，这里也要同步修改。切记切记
			this.cWidth = uni.upx2px(750);
			this.cHeight = uni.upx2px(500);
			this.getServerData();
		},
		// 顶部导航切换
			onNav(nav) {
				this.currentType = nav.text;
				this.getServerData();
			},
			getServerData() {
				let Column = {
					categories: [],
					series: []
				};
				if (_self.currentType == '佣金趋势图') {
					//分销管理 线图数据
					this.$api('distributionCenter.initLineChartData', {}).then(res => {
						switch (this.currentTime) {
							case '今日':
								Column.categories = res.data.items[0].categoriesToday;
								Column.series = res.data.items[0].seriesToday;
								_self.initLineChart("canvasColumn", Column);
								break;
							case '近七天':
								Column.categories = res.data.items[0].categoriesSevenDay;
								Column.series = res.data.items[0].seriesSevenDay;
								_self.initLineChart("canvasColumn", Column);
								break;
							case '半个月':
								Column.categories = res.data.items[0].categoriesHalfMonth;
								Column.series = res.data.items[0].seriesHalfMonth;
								_self.initLineChart("canvasColumn", Column);
								break;
							case '一个月':
								Column.categories = res.data.items[0].categoriesMonth;
								Column.series = res.data.items[0].seriesMonth;
								_self.initAreaChart("canvasColumn", Column);
								break;
							default:
								break;
						}
					});
				} else if (_self.currentType == '佣金占比图') {
					//分销管理 环图数据
					this.$api('distributionCenter.initRingChartData', {}).then(res => {
						Column.series = res.data.items[0].series;
						_self.initRingChart("canvasColumn", Column);
					});
				}
			},
			// 曲线图
			initLineChart(canvasId, chartData) {
				canvaColumn = new uCharts({
					$this: _self,
					canvasId: canvasId,
					type: 'line',
					fontSize: 11,
					// 图例
					legend: {
						show: false
					},
					//数字点标识（数字）
					dataLabel: false,
					//数字点标识（圆点）
					dataPointShape: true,
					background: '#FFFFFF',
					pixelRatio: _self.pixelRatio,
					//x轴数据
					categories: chartData.categories,
					//y周数据
					series: chartData.series,
					animation: true,
					enableScroll: true, //开启图表拖拽功能
					xAxis: {
						//纵向辅助线，关闭
						disableGrid: true,
						itemCount: 5, //x轴单屏显示数据的数量，默认为5个
						scrollShow: false, //新增是否显示滚动条，默认false
						scrollAlign: 'left', //滚动条初始位置
						scrollBackgroundColor: '#F7F7FF', //默认为 #EFEBEF
						scrollColor: '#DEE7F7', //默认为 #A6A6A6
					},
					yAxis: {
						//横向辅助线，默认开启，样式为虚线
						gridType: 'dash'
					},
					width: _self.cWidth * _self.pixelRatio,
					height: _self.cHeight * _self.pixelRatio,
					colors: ['#348BF7'],
					extra: {
						column: {
							width: _self.cWidth * _self.pixelRatio * 0.45 / chartData.categories.length
						},
						line: {
							type: 'curve'
						},
						tooltip: {
							showBox: true, //是否显示半透明黑色的提示区域
							bgColor: '#ffffff', //主体背景颜色
							bgOpacity: 1, //背景颜色透明度
							gridType: 'dash', //辅助线类型（虚线）
							dashLength: 5, //虚线单段长度
							gridColor: '#348BF7', //辅助线颜色
							fontColor: '#000000', //主体文字颜色
							horizentalLine: false, //是否显示横向辅助线
							xAxisLabel: false, //是否显示X轴辅助标签
							yAxisLabel: false, //是否显示Y轴辅助标签
							labelBgColor: '#ffffff', //标签背景颜色
							labelBgOpacity: 1, //背景颜色透明度
							labelFontColor: '#000000' //标签文字颜色
						}
					}
				});
			},
			// 区域图
			initAreaChart(canvasId, chartData) {
				canvaColumn = new uCharts({
					$this:_self,
					canvasId: canvasId,
					type: 'area',
					fontSize:11,
					// 图例
					legend: {
						show: false
					},
					dataLabel: false,
					dataPointShape: false,
					background:'#FFFFFF',
					pixelRatio:_self.pixelRatio,
					categories: chartData.categories,
					series: chartData.series,
					animation: true,
					enableScroll: true, //开启图表拖拽功能
					xAxis: {
						disableGrid: true,
						// type:'grid',
						// gridType:'dash',
						itemCount: 5, //x轴单屏显示数据的数量，默认为5个
						scrollShow: false, //新增是否显示滚动条，默认false
						scrollAlign: 'left', //滚动条初始位置
						scrollBackgroundColor: '#F7F7FF', //默认为 #EFEBEF
						scrollColor: '#DEE7F7', //默认为 #A6A6A6
					},
					yAxis: {
						disabled:true,
						disableGrid:true
					},
					width: _self.cWidth*_self.pixelRatio,
					height: _self.cHeight*_self.pixelRatio,
					colors: ['#348BF7'],
					extra: {
						area:{
							type: 'curve',
							opacity:0.2,
							addLine:true,
							width:2
						},
						tooltip: {
							showBox: true, //是否显示半透明黑色的提示区域
							bgColor: '#ffffff', //主体背景颜色
							bgOpacity: 1, //背景颜色透明度
							gridType: 'dash', //辅助线类型（虚线）
							dashLength: 5, //虚线单段长度
							gridColor: '#348BF7', //辅助线颜色
							fontColor: '#000000', //主体文字颜色
							horizentalLine: false, //是否显示横向辅助线
							xAxisLabel: false, //是否显示X轴辅助标签
							yAxisLabel: false, //是否显示Y轴辅助标签
							labelBgColor: '#ffffff', //标签背景颜色
							labelBgOpacity: 1, //背景颜色透明度
							labelFontColor: '#000000' //标签文字颜色
						}
					}
				});
			},
			// 环形图
			initRingChart(canvasId, chartData) {
				canvaColumn = new uCharts({
					$this: _self,
					canvasId: canvasId,
					type: 'ring',
					fontSize: 11,
					// 图例
					legend: {
						show: true,
						position: 'right',
						fontSize: 12 * _self.pixelRatio,
						lineHeight: 24 * _self.pixelRatio,
						borderWidth: 8
					},

					colors: ['#3C90F7', '#55BFC0', '#5EBE67', '#F4CD49', '#E05667'],
					title: {
						name: '佣金收入（元）',
						color: '#000000',
						fontSize: 12 * _self.pixelRatio,
						offsetY: 0 * _self.pixelRatio,
					},
					subtitle: {
						name: '49136',
						color: '#333333',
						fontSize: 16 * _self.pixelRatio,
						offsetY: 10 * _self.pixelRatio,
					},
					extra: {
						pie: {
							offsetAngle: -45,
							ringWidth: 20 * _self.pixelRatio,
						}
					},
					background: '#FFFFFF',
					pixelRatio: _self.pixelRatio,
					series: chartData.series,
					animation: true,
					width: _self.cWidth * _self.pixelRatio,
					height: _self.cHeight * _self.pixelRatio,
					disablePieStroke: true,
					dataLabel: false,
				});
			},
			touchLine(e) {
				if(this.currentType == '佣金趋势图' && this.currentTime != '一个月'){
					//显示ToolTip调用的方法
					canvaColumn.showToolTip(e, {
						format: function(item) {
							return '  ' +item.name  + '    ' + item.data+ '    '
						}
					});
				}else if(this.currentType == '佣金趋势图' && this.currentTime == '一个月'){
					canvaColumn.showToolTip(e, {
						format: function(item,category) {
							return '  ' +category + '    ' + item.data+ '    '
						}
					});
				}else if(this.currentType == '佣金占比图'){
					canvaColumn.showToolTip(e, {
						format: function(item) {
							return '  ' +item.name + '    ' + item.data+ '    '
						}
					});
				}
				canvaColumn.scrollStart(e);
			},
			// 选择不同的天数，加载不同数据
			chooseTime(time) {
				this.currentTime = time.text;
				this.getServerData();
			},
			moveLineA(e) {
				canvaColumn.scroll(e);
			},
			touchEndLineA(e) {
				canvaColumn.scrollEnd(e);
			}
	}
</script>

<style>
// 顶部导航栏
.order-nav {
	background: #fff;
	height: 68rpx;
	font-size: 34rpx;
	margin-bottom: 16rpx;

	.scroll-view_H {
		white-space: nowrap;
		width: 100%;

		.scroll-view-item_H {
			display: inline-block;
			width: 50%;
			text-align: center;
		}

		.nav-item {
			position: relative;

			.item-title {
				font-family: PingFang SC;
				font-weight: 400;
				color: rgba(51, 51, 51, 1);
				line-height: 76rpx;
			}

			.line-active::before {
				content: '';
				bottom: 0;
				left: calc(50% - 110rpx);
				width: 220rpx;
				height: 6rpx;
				position: absolute;
				z-index: 1;
				background: rgba(99, 138, 227, 1);
			}
		}
	}
}

.chartArea {
	background-color: white;

	.chartTitle {
		padding: 18rpx 0 0 26rpx;
		letter-spacing: 1px;
		color: rgba(80, 80, 80, 1);
		font-size: 18px;
		font-weight: bold;
	}

	.btn {
		display: flex;
		width: 100%;
		margin: 48rpx 0;
		text-align: center;

		.btnItem {
			flex: 1;
			letter-spacing: 1px;
			color: rgba(80, 80, 80, 1);
			font-size: 16px;
		}

		.activeBtnItem {
			font-weight: bold;
			color: rgba(99, 138, 227, 1)
		}
	}

	.qiun-charts {
		width: 750upx;
		height: 500upx;
		background-color: #FFFFFF;

		.charts {
			width: 750upx;
			height: 500upx;
			background-color: #FFFFFF;
		}
	}
}
</style>
