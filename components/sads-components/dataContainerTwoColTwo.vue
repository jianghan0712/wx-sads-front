<template>
	<view class="sale-row-2">
		<view class="row-box">
			<view class="left-column_box_2">
				<view class="column-box">
					<text class="big-text">足球</text>
					<text class="small-text">销量24.44万元</text>
					<text class="small-text">占比100%</text>
				</view>
				<view class="column-box">
					<text class="big-text">篮球</text>
					<text class="small-text">销量0.00万元</text>
					<text class="small-text">占比0.0%</text>
				</view>
			</view>			
		</view>
		<view class="row-box">
			<view class="right-column_box_2">
				<view class="column-box">
					<text class="big-text">足球</text>
					<text class="small-text">销量250万元</text>
					<text class="small-text">占比98.59%</text>
				</view>
				<view class="column-box">
					<text class="big-text">篮球</text>
					<text class="small-text">销量3.58万元</text>
					<text class="small-text">占比1.41%</text>
				</view>
			</view>	
			</view>			
		</view>
	</view>
</template>

<script>
	export default {
		props: {
			dataAs: {
				//数据
				type: Object,
				default: () => ({})
			},
		},
		data() {
			return {
				dataList:{}
			}
		},
		methods: {
			showDataContainer() {			
				this.dataList = this.dataAs;
				// var str = JSON.stringify(this.dataAs);
				console.log("showDataContainer:", this.dataAs);
			},
		},
	}
</script>

<style>
	.sale-row-2{
		display: flex;
		flex-direction: row;	
		margin: 20rpx 10rpx;
	}
	.row_box_2{
		display: flex;
		flex-direction: row;	
	}
	
	.column_box_2{	
		display: flex;
		flex-direction: column;
	}
	
	.right-column_box_2{
		display: flex;
		flex-direction: column;
		background:rgba(250, 225, 220 ,0.5);
		border-radius: 15px;
	}
	
	.left-column_box_2{
		display: flex;
		flex-direction: column;
		background:rgba(220, 241, 250 ,0.5);
		border-radius: 15px;
	}
	
	.row-box {
		display: flex;
		width: 50%;
		margin: 0rpx 5rpx;
		padding: 0 10rpx;
		flex-direction: column;
	}
	
	.column-box{
		display: flex;
		height: 50%;
		margin: 20rpx 5rpx;
		padding: 0 5rpx;
		flex-direction: column;
	}
	
	.big-text{
		text-align: left;
		margin: 15rpx 5rpx;
		color: #777;
		font-size: 36rpx;
	}
	
	.small-text{
		text-align: left;
		margin: 15rpx 5rpx;
		color: #777;
		font-size: 30rpx;
	}
	
</style>
