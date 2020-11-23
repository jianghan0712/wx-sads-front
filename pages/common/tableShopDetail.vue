<template>
	<view class="example">
		<v-table :columns="tableColumns" :list="tableData"  selection="single"  :slot-cols="['number']" on-selection-change="onSelectionChange" border-color="#FFFFFF">
			<template v-slot="{ row }">
				<view style="font-weight: blod;color:blue;" @click="goDetail(row.number)">{{ row.number }}</view>
			</template>
		</v-table>
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
			goDetail(number){
				console.log(number)
				uni.navigateTo({
					url:"/pages/channel/index-inner?number="+number
				});
			},
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
