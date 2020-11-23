<template>
	<view class="example">
		<v-table :columns="tableColumns" :list="tableData" border-color="#FFFFFF"></v-table>
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
			}
		},
		methods: {
		
		},
		onLoad(option){//opthin为object类型，会序列化上页面传递的参数
			this.tableData = JSON.parse(option.tableData); // 字符串转对象
			this.tableColumns = JSON.parse(option.tableColumns); // 字符串转对象
			console.log("tableDetail-tableData=",this.tableData)
			console.log("tableDetail-tableColumns=",this.tableColumns)
		}
	}
</script>

<style>
	.example {
		/* line-height: 40px; */
		font-weight: bold;
		border-color:#FFFFFF;
	}
</style>
