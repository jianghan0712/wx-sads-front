<template>
	<view class="sale-row-2">
		<view class="row-box-left">
			<view class="column_box_2">
		<!-- 		<view class="column-box"> -->
					<text class="big-text">{{dataList.big1.name}}</text>
					<text class="big-text">{{dataList.big1.value}}</text>
			<!-- 	</view> -->
			</view>			
		</view>
		<view class="row-box-right">
			<view class="column_box_2">
					<!-- <view class="row-box"> -->
						<text class="big-text">{{dataList.small1.name}} {{dataList.small1.value}}</text>
					<!-- </view> -->
					<!-- <view class="row-box"> -->
						<text class="big-text">{{dataList.small2.name}} {{dataList.small2.value}}</text>
					<!-- </view> -->
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
				console.log("kkkk:"+this.dataList.name);
			},
		},
	}
</script>

<style>
	.sale-row-2{
		display: flex;
		flex-direction: row;	
		margin: 20rpx 10rpx 20rpx 10rpx;
		/* padding: 20rpx 10rpx 20rpx 10rpx;	 */
	}
	.row_box_2{
		display: flex;
		flex-direction: row;	
	}
	
	.column_box_2{	
		margin: 20rpx 10rpx 20rpx 10rpx;
		display: flex;
		flex-direction: column;
	}
	
	.row-box-left {
		display: flex;
		width: 35%;
		margin: 0rpx 0rpx 0rpx 10rpx;
		padding: 0rpx 0rpx 30rpx 0rpx;
		background-color: #ebebeb;
		flex-direction: column;
	}
	
	.row-box-right {
		display: flex;
		width: 65%;
		margin: 0rpx 10rpx 0rpx 0rpx;
		padding: 0rpx 0rpx 30rpx 0rpx;
		background-color: #ebebeb;
		flex-direction: column;
	}
	
	.column-box{
		display: flex;
		height: 50%;
		margin: 0rpx 5rpx;
		padding: 0 5rpx;
		background-color: #ebebeb;
		flex-direction: column;
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
	
</style>
