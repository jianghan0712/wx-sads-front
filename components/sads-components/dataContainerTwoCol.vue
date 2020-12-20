<template>
	<view class="sale-row-2">
		<view class="row-box">
			<view class="left-column_box_2">
				<view class="column-box">
					<text class="big-text">{{dataList.left.title1}}</text>
					<text class="big-text">{{dataList.left.amount1}}</text>
				</view>
				<view class="column-box">
					<text class="big-text">{{dataList.left.title2}}</text>
					<text class="big-text">{{dataList.left.amount2}}</text>
				</view>
			</view>			
		</view>
		<view class="row-box">
			<view class="right-column_box_2">
				<view class="column-box">
					<text class="big-text">{{dataList.right.title1}}</text>
					<text class="big-text">{{dataList.right.amount1}}</text>
				</view>
				<view class="column-box">
					<text class="big-text">{{dataList.right.title2}}</text>
					<text class="big-text">{{dataList.right.amount2}}</text>
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
				console.log("col showDataContainer data:", this.dataAs);
				console.log("col showDataContainer dataList:", this.dataList);
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
		color: #FFFFFF;
		font-size: 36rpx;
	}
	
	.small-text{
		text-align: left;
		background-color: #ebebeb;
		color: #FFFFFF;
		font-size: 30rpx;
	}
	
</style>
