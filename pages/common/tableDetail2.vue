<template>
	<view style="width: 100%;">
	<view>
		当日完赛
	</view>
	<view class="example">
		<v-table :columns="tableColumns" :list="tableData" border-color="#FFFFFF"></v-table>
	</view>
	<view>
		当日在售
	</view>
	<view class="example">
		<v-table :columns="tableColumns1" :list="tableData1" border-color="#FFFFFF"></v-table>
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
				tableData: [],
				tableColumns: [],
				tableData1: [],
				tableColumns1: [],	
			}
		},
		methods: {
		
		},
		onLoad(option){//opthin为object类型，会序列化上页面传递的参数
			this.tableData = JSON.parse(option.tableData); // 字符串转对象
			this.tableColumns = JSON.parse(option.tableColumns); // 字符串转对象
			this.tableData1 = JSON.parse(option.tableData1); // 字符串转对象
			this.tableColumns1 = JSON.parse(option.tableColumns1); // 字符串转对象
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
</style>
