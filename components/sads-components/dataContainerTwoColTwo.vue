<template>
	<view class="sale-row-2">
		<view class="row-box">
			<view class="left-column_box_2">
				<view class="column-box">
					<text class="big-text">{{dataList.left.football.name}}</text>
					<text class="small-text">{{dataList.left.football.amount}}</text>
					<text class="small-text">{{"占比"+dataList.left.football.zhanbi}}</text>
				</view>
				<view class="column-box">
					<text class="big-text">{{dataList.left.basketball.name}}</text>
					<text class="small-text">{{dataList.left.basketball.amount}}</text>
					<text class="small-text">{{"占比"+dataList.left.basketball.zhanbi}}</text>
				</view>
			</view>			
		</view>
		<view class="row-box">
			<view class="right-column_box_2">
				<view class="column-box">
					<text class="big-text">{{dataList.right.football.name}}</text>
					<text class="small-text">{{dataList.right.football.amount}}</text>
					<text class="small-text">{{"占比"+dataList.right.football.zhanbi}}</text>
				</view>
				<view class="column-box">
					<text class="big-text">{{dataList.right.basketball.name}}</text>
					<text class="small-text">{{dataList.right.basketball.amount}}</text>
					<text class="small-text">{{"占比"+dataList.right.basketball.zhanbi}}</text>
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
				dataList:{
					left:{
						football:{name:"足球",amount:"销量0元",zhanbi:"占比0%"},
						basketball:{name:"篮球",amount:"销量0元",zhanbi:"占比0%"}
					},
					right:{
						football:{name:"足球",amount:"销量0元",zhanbi:"0%"},
						basketball:{name:"篮球",amount:"销量0元",zhanbi:"占比0%"}
					},
				}
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
		text-align: center;
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
		color: #FFFFFF;
		font-size: 36rpx;
	}
	
	.small-text{
		text-align: left;
		margin: 15rpx 5rpx;
		color: #FFFFFF;
		font-size: 30rpx;
	}
	
</style>
