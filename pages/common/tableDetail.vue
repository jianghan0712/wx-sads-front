<template>
	<view class="example">
		<v-table :columns="tableColumns" :list="tableData" :height="250" border-color="#FFFFFF"></v-table>
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
				tableData: [{
							id: "1",
							area: "北京市",
							amount: "10233.5",
							tongbi: "+12.6%",
							huanbi: "+45.21%"
						},
						{
							id: "2",
							area: "上海市",
							amount: "9965.5",
							tongbi: "+12.6%",
							huanbi: "+45.21%"
						},
						{
							id: "3",
							area: "广东省",
							amount: "9754.5",
							tongbi: "+12.6%",
							huanbi: "+45.21%"
						},
						{
							id: "4",
							area: "重庆市",
							amount: "6745.6",
							tongbi: "+12.6%",
							huanbi: "+45.21%"
						},
						{
							id: "5",
							area: "河北省",
							amount: "6554",
							tongbi: "+12.6%",
							huanbi: "+45.21%"
						}
					],
				tableColumns: [{
							title: "排名",
							key: "id",
							$width:"50px",
						},
						{
							title: '省份',
							key: 'area',
							$width:"100px"
						},
						{
							title: '销量',
							key: 'amount',
							$width:"80px"
						},
						{
							title: '同比',
							key: 'tongbi',
							$width:"80px"
						},
						{
							title: '环比',
							key: 'huanbi'
						}
					],			
			}
		},
		methods: {
		
		},
		onLoad(option){//opthin为object类型，会序列化上页面传递的参数
			this.type = option.area
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
