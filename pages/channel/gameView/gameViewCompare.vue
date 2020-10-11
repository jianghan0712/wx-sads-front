<template>
	<view>
		<view >
			<v-table :columns="tableColumns" :list="tableData" border-color="#FFFFFF"></v-table>
		</view>
	</view>
</template>

<script>
	import vTable  from  '@/components/table/table.vue';
	
	export default{
		components:{
			vTable
		},
		data(){
			return {
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
							key: 'huanbi',
							$width:"80px"
						}
					]
			}
		},
		methods:{
			loadData(){
				let url='https://111.203.194.163:8024/pentaho/plugin/cda/api/doQuery?path=/public/api/shopAnalysis/gamesAndAup.cda&dataAccessId=FbGameSalesRateByShopNo'
				uni.request({
				    url: url,
				    data: {
						paramstartDate: "20200912",
						paramendDate: "20200915",
						paramshopNo : 1
				    },
					method: 'GET',
					success: (res) => {
				        console.log(res);
				    },
					fail:(res)=>{
						console.log(res);
					}
				});
			}
		},
		onLoad(option){
			uni.setNavigationBarTitle({
				title :option.title
			});
			/* console.log(JSON.parse(decodeURIComponent(option.title))) */
			const eventChannel = this.getOpenerEventChannel();
			eventChannel.on('hahahah', function(data) {
			    console.log(data)
			});
			this.loadData()
		}
		
	}
</script>

<style>
</style>