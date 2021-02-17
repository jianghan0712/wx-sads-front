<template>
	<view class="column-2">
		<view class="column_box_2">
			<view class="big-text">{{dataList.big1.name}} {{dataList.big1.value}}</view>
			<view class="sale-row-2">
				<view class="row-box">
					<text class="small-text">{{dataList.big1.left.name}}</text>
					<text :class="dataList.big1.left.value >= 0?'small-text-red':'small-text-green'">{{valueToPercent(dataList.big1.left.value)}}</text>
				</view>
				<view class="row-box">
					<text class="small-text">{{dataList.big1.right.name}}</text>
					<text :class="dataList.big1.right.value >= 0?'small-text-red':'small-text-green'">{{valueToPercent(dataList.big1.right.value)}}</text>
				</view>
			</view>
		</view>
		<view class="column_box_2">
			<view class="big-text">{{dataList.big2.name}} {{dataList.big2.value+"%"}}</view>
			<view class="sale-row-2">
				<view class="row-box">
					<view class="small-text">{{dataList.big2.left.name}}</view>
					<view :class="dataList.big2.left.value >= 0?'small-text-red':'small-text-green'">{{valueToPercent(dataList.big2.left.value)}}</view>
				</view>
				<view class="row-box">
					<view class="small-text">{{dataList.big2.right.name}}</view>
					<view :class="dataList.big2.right.value >= 0?'small-text-red':'small-text-green'">{{valueToPercent(dataList.big2.right.value)}}</view>
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
				dataList:{big1:{'name':'销量',value:'--',left:{'name':'周同比',value:'--'},right:{'name':'环比',value:'--'}},
						  big2:{'name':'占比',value:'--',left:{'name':'周同比',value:'--'},right:{'name':'环比',value:'--'}}}
			}
		},
		methods: {
			showDataContainer() {
				this.dataList = this.dataAs;
			},
			valueToPercent(value) {
				// let temp = value;
				// value = value + '';
				// const pointIndex = value.indexOf('.');
				// if (pointIndex === -1) return (value - 0) * 100;
				// const powIndex = value.length - pointIndex - 1;
				// let result = (value.replace('.', '') - 0) * Math.pow(10, 2 - powIndex);
				if(""==value){
					return value;
				}
				if(value>=0){
					value = "+" + value + "%";
				}else{
					value = value + "%";
				}
				return value;
			}
		},
	}
</script>

<style>
	.column-2{
		display: flex;
		flex-direction: column;	
		margin: 0rpx 0rpx 0rpx 5rpx;
		background: #FFFFFF;
	}	
	
	.sale-row-2{
		width: 100%;
		display: flex;
		flex-direction: row;	
		margin: 0rpx 0rpx 0rpx 0rpx;
	}
	.row_box_2{
		display: flex;
		flex-direction: row;	
	}
	
	.column_box_2{	
		display: flex;
		flex-direction: column;
		/* background:rgba(241, 250, 250 ,0.5); */
		/* background-image: url(../../static/card.png); */
		margin: 0rpx 0rpx 20rpx 0rpx;
	}
	
	.row-box {
		display: flex;
		width: 50%;
		margin: 0rpx 0rpx 0rpx 0rpx;
		padding: 0 0rpx;
		flex-direction: column;
	}
	
	.column-box{
		display: flex;
		height: 50%;
		margin: 0rpx 0rpx 0rpx 0rpx;
		padding: 0 0rpx;
		flex-direction: column;
	}
	
	.big-text{
		text-align: left;
		display: flex;
		font-size: 35rpx;
	}
	
	.small-text{
		text-align: left;
		display: flex;
		font-size: 30rpx;
	}
	
	.small-text-green{
		text-align: left;
		color: #1FCE58;
		font-size: 30rpx;
	}
	
	.small-text-red{
		text-align: left;
		color: #E83838;
		font-size: 30rpx;
	}
	
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
		/* background:rgba(220, 241, 250 ,0.5); */
		border-radius: 15px;
	}
	
	.row-box {
		display: flex;
		width: 50%;
		margin: 10rpx 10rpx;
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
		color: #000000;
		font-size: 36rpx;
	}
	
	.small-text{
		text-align: left;
		color: #000000;
		font-size: 30rpx;
	}
	
</style>
