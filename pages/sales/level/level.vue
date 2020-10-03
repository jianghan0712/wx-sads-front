<template>
	<view>
		<view class="tab-content">
			<view class="end-title">
			　　<view @tap="change(0)" :class="btnnum == 0?'btna':'hide'">足球</view>
			  　<view @tap="change(1)" :class="btnnum == 1?'btna':'hide'">篮球</view>
			</view>	
			<view class="end-cont" :class="{dis:btnnum == 0}">	
				<view style="font-size: 30rpx;font-weight: bold;">足球关次销量及占比</view>				
				<view class="ring_chart">
					<ring-chart :dataAs="pieData" ref="ringChart0" canvasId="index_ring_0"/>
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
					<button type="default" plain="true" @click="gotoLunBo(btnnum)">查看全部</button>
				</view>
			</view>
			<view class="end-cont" :class="{dis:btnnum == 1}">	
				<view style="font-size: 30rpx;font-weight: bold;">篮球关次销量及占比</view>　
				<view class="ring_chart">
					<ring-chart :dataAs="pieData1" ref="ringChart1" canvasId="index_ring_1"/>
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
					<button type="default" plain="true" @click="gotoLunBo(btnnum)">查看全部</button>
				</view>
			</view>		
		</view>
	<slot />
	</view>
</template>

<script>
	import RingChart from "@/components/basic-chart/RingChart.vue";
	import vTable from "@/components/table/table.vue";
	
	export default {
		components: {
			RingChart,
			vTable
		},
		data() {
			return {
				 btnnum: 0,
				 index: 0,
				 pieData: {
				 	//饼状图数据
				 	series: [{name: '单关',data: 400},
				 		{name: '2X1',data: 350},
				 		{name: '3X1',data: 330}
				 	]
				 },
				 pieData1: {
				 	//饼状图数据
				 	series: [{name: '单关',data: 300},
				 		{name: '2X1',data: 200},
				 		{name: '3X1',data: 700}
				 	]
				 },
				tableData: [{
								id: "1",
								area: "北京市",
								amount: "10233.5",
								zhanbi: "+12.6%"
							},
							{
								id: "2",
								area: "上海市",
								amount: "9965.5",
								zhanbi: "+12.6%"
							},
							{
								id: "3",
								area: "广东省",
								amount: "9754.5",
								zhanbi: "+12.6%"
							},
							{
								id: "4",
								area: "重庆市",
								amount: "6745.6",
								zhanbi: "+12.6%"
							},
							{
								id: "5",
								area: "河北省",
								amount: "6554",
								zhanbi: "+12.6%"
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
		methods: {
			getServerData() {
			},
		    change(e) {
			    this.btnnum = e;
			    console.log(this.btnnum);
		    },
			bindPickerChange: function(e) {
				console.log('picker发送选择改变，携带值为：' + e.detail.value)
				this.index = e.detail.value
			},
			gotoLunBo(btnnum){
				uni.navigateTo({	
					url:"/pages/sales/level/levle_ring_detail?btnnum="+btnnum
				});
			}
		},
		created() {
			this.$nextTick(() => {
				// 环状图
				this.$refs['ringChart0'].showCharts();
				this.$refs['ringChart1'].showCharts();
			});
			//ajax调用
			this.getServerData();
		}
	}
</script>

<style>
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
