<template>
	<view>
		<view class="box-contaniner">
			<view class="tab-content">
				<view class="end-title">
				　　<view @tap="change(0)" :class="btnnum == 0?'btna':'hide'">足球</view>
				  　<view @tap="change(1)" :class="btnnum == 1?'btna':'hide'">篮球</view>
				</view>	
				<view class="end-cont" :class="{dis:btnnum == 0}">
					<view class="box-contaniner">
						<view style="font-size: 30rpx;font-weight: bold;">top5 赛制销量</view>
						<view class="example">
							<v-table :columns="matchTypeTableColumns" :list="matchTypeTableData"  border-color="#FFFFFF"></v-table>
						</view>
					</view>
				</view>
				<view class="end-cont" :class="{dis:btnnum == 1}">	
					<view class="box-contaniner">
						<view style="font-size: 30rpx;font-weight: bold;">top5 赛制销量</view>
						<view class="example">
							<v-table :columns="matchTypeTableColumns" :list="matchTypeTableData"  border-color="#FFFFFF"></v-table>
						</view>
					</view>
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
				index: 0,
				matchTypeTableData: [{
								id: "1",
								matchType: "欧洲国家联赛",
								amount: "10233.5",
							},
							{
								id: "2",
								matchType: "美国职业大联盟",
								amount: "9965.5"
							},
							{
								id: "3",
								matchType: "巴西甲级联赛",
								amount: "9754.5"
							}
						],
				matchTypeTableColumns: [{
						title: "排名",
						key: "id",
						$width:"50px",
					},{
						title: '赛制',
						key: 'matchType',
						$width:"200px"
					},{
						title: '销量（百万元）',
						key: 'amount'
					}
				],	
				matchEventTableData: [{
								id: "1",
								matchName: "德国vs西班牙",
								amount: "10233.5",
							},
							{
								id: "2",
								matchName: "俄罗斯vs塞尔维亚",
								amount: "9965.5"
							},
							{
								id: "3",
								matchName: "乌克兰vs瑞士",
								amount: "9754.5"
							}
						],
				matchEventTableColumns: [{
						title: "排名",
						key: "id",
						$width:"50px",
					},{
						title: '赛事',
						key: 'matchName',
						$width:"200px"
					},{
						title: '销量（百万元）',
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
					url:"/pages/common/levelRingDetail?btnnum="+btnnum
				});
			}
		},
		created() {
			this.param = this.model;
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
