<template>
	<view style="width: 100%;">
		<view class="linechart-tab">
		　　<view @tap="change(0)" :class="btnnum == 0?'btna':'hide'" style="width: 25%;">销量</view>
		  　<view @tap="change(1)" :class="btnnum == 1?'btna':'hide'" style="width: 25%;">占比</view>
		</view>
		<view class="end-cont" :class="{dis:btnnum == 0}">
			<view class="sale-row-2">
				<view class="left-row-box">
					<v-table :columns="leftTableColumns" :list="leftTableData"  border-color="#FFFFFF"></v-table>
				</view>
				<view class="right-row-box">
					<v-table :columns="rightTableColumns" :list="rightTableData"  border-color="#FFFFFF"></v-table>
				</view>
			</view>	
		</view>
		<view class="end-cont" :class="{dis:btnnum == 1}">
			<view class="sale-row-2">
				<view class="left-row-box">
					<v-table :columns="leftTableColumns1" :list="leftTableData1"  border-color="#FFFFFF"></v-table>
				</view>
				<view class="right-row-box">
					<v-table :columns="rightTableColumns1" :list="rightTableData1"  border-color="#FFFFFF"></v-table>
				</view>
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
				leftTableColumns1: [],
				rightTableColumns1: [],
				leftTableData1: [],
				rightTableData1: [],
				btnnum:0
			}
		},
		methods: {
			change(e) {
				  this.btnnum = e
				  console.log(this.btnnum)
			},
		},
		onLoad(option){//opthin为object类型，会序列化上页面传递的参数
			this.leftTableData = JSON.parse(option.leftTableData); // 字符串转对象
			this.leftTableColumns = JSON.parse(option.leftTableColumns); // 字符串转对象
			this.rightTableData = JSON.parse(option.rightTableData); // 字符串转对象
			this.rightTableColumns = JSON.parse(option.rightTableColumns); // 字符串转对象
			
			
			this.leftTableData1 = JSON.parse(option.leftTableData1); // 字符串转对象
			this.leftTableColumns1 = JSON.parse(option.leftTableColumns1); // 字符串转对象
			this.rightTableData1 = JSON.parse(option.rightTableData1); // 字符串转对象
			this.rightTableColumns1 = JSON.parse(option.rightTableColumns1); // 字符串转对象
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
	
	.end-cont{
		display: none;
		background: #FFFFFF;
	}
	.sale-row-2{
		display: flex;
		flex-direction: row;	
		margin: 20rpx 10rpx;
		/* padding: 20rpx 10rpx 20rpx 10rpx;	 */
	}
	.linechart-tab{
		padding:0rpx 5rpx 0rpx 5rpx;
		flex-direction: row;
		display: flex;
		text-align: right;
		justify-content:flex-end;
		font-size: 30rpx;
	}
	.btna{
		color: #000000;
		background: #ebebeb;
		padding:0px 30rpx 0px 30rpx;
	}
	.dis{
		display: block;
	} 
	.hide{
		color: #000000;
		background: #FFFFFF;
		padding:0px 30rpx 0px 30rpx;
	}
	.linechart-tab{
		padding:0rpx 5rpx 0rpx 5rpx;
		flex-direction: row;
		display: flex;
		text-align: right;
		justify-content:flex-end;
		font-size: 30rpx;
	}
	.example {
		/* line-height: 40px; */
		width: 100%;
		display: flex;
		font-weight: bold;
		border-color:#FFFFFF;
	}
</style>
