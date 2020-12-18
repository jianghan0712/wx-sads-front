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
		/* margin: 20rpx 10rpx 20rpx 10rpx; */
		/* padding: 20rpx 10rpx 20rpx 10rpx;	 */
	}
	.row_box_2{
		display: flex;
		flex-direction: row;	
	}
	
	.column_box_2{	
		margin: 10rpx 10rpx;
		display: flex;
		flex-direction: column;
		background:rgba(220, 241, 250 ,0.5);
		background-image: url(../../static/card.png);
		border-radius: 15px;
	}
	
	.row-box {
		display: flex;
		width: 50%;
		margin: 10rpx 10rpx;
		background-image: url(../../static/card.png);
		/* padding: 0 10rpx; */
		flex-direction: column;
	}
	
	.column-box{
		display: flex;
		height: 50%;
		margin: 10rpx 10rpx;
		/* padding: 0 5rpx; */
		flex-direction: column;
	}
	
	.big-text{
		text-align: left;
		color: #777;
		font-size: 36rpx;
	}
	
	.small-text{
		text-align: left;
		color: #777;
		font-size: 30rpx;
	}
	
</style>
