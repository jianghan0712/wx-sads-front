<template>
	<view style="width: 100%;">
		<view class="sale-row-2">
			<view class="left-row-box">
				<v-table :columns="leftTableColumns" :list="leftTableData"  border-color="#FFFFFF"></v-table>
			</view>
			<view class="right-row-box">
				<v-table :columns="rightTableColumns" :list="rightTableData"  border-color="#FFFFFF"></v-table>
			</view>
		</view>	
	</view>
</template>

<script>
	import vTable from "@/components/table/table.vue";
	
	export default {
		components: {
			vTable
		},
		data() {
			return{
				leftTableColumns: [],
				rightTableColumns: [],
				leftTableData: [],
				rightTableData: [],	
			}
		},
		methods: {
		
		},
		onLoad(option){//opthin为object类型，会序列化上页面传递的参数
			this.leftTableData = JSON.parse(option.leftTableData); // 字符串转对象
			this.leftTableColumns = JSON.parse(option.leftTableColumns); // 字符串转对象
			this.rightTableData = JSON.parse(option.rightTableData); // 字符串转对象
			this.rightTableColumns = JSON.parse(option.rightTableColumns); // 字符串转对象
		}
	}
</script>

<style>
	.example {
		/* line-height: 40px; */
		font-weight: bold;
		border-color:#FFFFFF;
		width: 100%;
	}
	.left-row-box {
		display: flex;
		width: 65%;
		margin: 0rpx 5rpx;
		/* padding: 0 10rpx; */
		/* background-color: #ebebeb; */
		flex-direction: column;
	}
	.right-row-box {
		display: flex;
		width: 35%;
		margin: 0rpx 5rpx;
		/* padding: 0 10rpx; */
		/* background-color: #ebebeb; */
		flex-direction: column;
	}
	.sale-row-2{
		display: flex;
		flex-direction: row;	
		margin: 20rpx 10rpx;
		/* padding: 20rpx 10rpx 20rpx 10rpx;	 */
	}
</style>
