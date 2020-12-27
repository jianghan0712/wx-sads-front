<template>
	<view >
		<view v-for="(item,index) in dataList"  class="uni-tab-item" >
			<view class="column-box">
				<text class="big-text">{{item.name}}</text>
			</view>
			<view class="row-box">
				<view class="left-column_box_2">
						<view class="column-box">
							<text class="big-text">{{item.left.title1}}</text>
							<text class="big-text">{{item.left.amount1}}</text>
						</view>
						<view class="column-box">
							<text class="big-text">{{item.left.title2}}</text>
							<text class="big-text">{{item.left.amount2}}</text>
						</view>
					</view>			
				</view>
				<view class="row-box">
					<view class="right-column_box_2">
						<view class="column-box">
							<text class="big-text">{{item.right.title1}}</text>
							<text class="big-text">{{item.right.amount1}}</text>
						</view>
						<view class="column-box">
							<text class="big-text">{{item.right.title2}}</text>
							<text class="big-text">{{item.right.amount2}}</text>
						</view>
					</view>			
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	export default {
		components: {
			
		},
		data() {
			return{
				dataList:{}
			}
		},
		methods: {
			
		},
		onLoad(option){//opthin为object类型，会序列化上页面传递的参数
			debugger
			this.dataList = JSON.parse(option.dataList); // 字符串转对象
		},
		created(option){//opthin为object类型，会序列化上页面传递的参数
			debugger
			this.dataList = JSON.parse(option.dataList); // 字符串转对象
		}
	}
</script>

<style>
	.small-text-green{
		color: #00FF00;
	}
	.uni-tab-item {
	    /* #ifndef APP-PLUS */
	    display: inline-block;
	    /* #endif */
	    flex-wrap: nowrap;
	    padding-left: 34rpx;
	    padding-right: 34rpx;
	}
	.small-text-red{
		color: #FF0000;
	}
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
