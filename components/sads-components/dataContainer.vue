<template>
	<view class="sale-row-2">
		<view class="row-box">
			<view class="column_box_2">
				<view class="column-box">
					<text class="big-text">{{dataList.big1.name}}</text>
					<text class="big-text">{{dataList.big1.value}}</text>
				</view>
				<view class="column-box">
					<view class="row_box_2">
						<view class="row-box">
							<text class="small-text">{{dataList.big1.left.name}}</text>
							<text class="small-text">{{dataList.big1.left.value}}</text>
						</view>
						<view class="row-box">
							<text class="small-text">{{dataList.big1.right.name}}</text>
							<text class="small-text">{{dataList.big1.right.value}}</text>
						</view>
					</view>
				</view>
			</view>			
		</view>
		<view class="row-box">
			<view class="column_box_2">
				<view class="column-box">
					<text class="big-text">{{dataList.big2.name}}</text>
					<text class="big-text">{{dataList.big2.value}}</text>
				</view>
				<view class="column-box">
					<view class="row_box_2">
						<view class="row-box">
							<text class="small-text">{{dataList.big2.left.name}}</text>
							<text class="small-text">{{dataList.big2.left.value}}</text>
						</view>
						<view class="row-box">
							<text class="small-text">{{dataList.big2.right.name}}</text>
							<text class="small-text">{{dataList.big2.right.value}}</text>
						</view>
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
		display: flex;
		flex-direction: column;
	}
	
	.row-box {
		display: flex;
		width: 50%;
		margin: 0rpx 5rpx;
		padding: 0 10rpx;
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
		font-size: 36rpx;
	}
	
	.small-text{
		text-align: left;
		background-color: #ebebeb;
		color: #777;
		font-size: 30rpx;
	}
	
</style>
