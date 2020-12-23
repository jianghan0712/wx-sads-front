<template>
	<view class="example">
		<v-table :columns="tableColumns" :list="tableData"  selection="single"  :slot-cols="['area']" on-selection-change="onSelectionChange" border-color="#FFFFFF">
			<template v-slot="{ row }">
				<view style="font-weight: blod;color:blue;"  @click="goDetail(row.areaIdStr)">{{ row.area }}</view>
			</template>
		</v-table>
	</view>
</template>

<script>
	import vTable from "@/components/table/table.vue";
	import urlAPI from '@/common/vmeitime-http/';
	
	export default {
		components: {
			vTable
		},
		data() {
			return{
				amountTableDataWithPro: [],
				amountTableColumnsWithPro: [{
							title: "排名",
							key: "id",
							$width:"50px",
						},
						{
							title: '地市',
							key: 'area',
							$width:"80px"
						},
						{
							title: '门店编号',
							key: 'number',
							$width:"130px"
						},
						{
							title: '销量(万元)',
							key: 'amount'
						}
					],	
				tableData: [],
				tableColumns: [],
				selfParam:{
					token:'',
					provinceCenterId:'',//当前查看的省份，如果之前是全国，这里可能会变动
					cityCenterId:'',
					provinceCenterName:'',
					countyCenterId:'',	
					compareType:'date',
					compareFlag:false,
					businessDate:{
						dateType:'',// date/week/month/year
						view:'',//用于展示日期、年、月等
						date:{startDate:'', endDate:''},
						week:{startDate:'', endDate:''},
						month:{startDate:'', endDate:''},
						year:{startDate:'', endDate:''},
					},
					compareDate:{
						dateType:'date',
						viewLeft:'',//用于展示日期、年、月等
						viewRight:'',
						dateLeft:{startDate:'', endDate:''},
						dateRight:{startDate:'', endDate:''},
						weekLeft:{startDate:'', endDate:''},
						weekRight:{startDate:'', endDate:''},
						monthLeft:{startDate:'', endDate:''},
						monthRight:{startDate:'', endDate:''},
						yearLeft:{startDate:'', endDate:''},
						yearRight:{startDate:'', endDate:''},
					},		
					userId:'',			
					selfProvinceCenterId:''//存登录时候的id
				},
			}
		},
		onLoad() {
			this.returnFromDatePicker();
		},
		created() {
			this.returnFromDatePicker();
		},
		onShow() {
			this.returnFromDatePicker();
		},
		methods: {
			createParam(){
				console.log("createParam begin")
				var dateType = this.selfParam.businessDate.dateType
				var param = {}
				if(dateType=='date'){
					param = {dateTimeStart: this.selfParam.businessDate.date.startDate,
							 dateTimeEnd: this.selfParam.businessDate.date.endDate,
							 dateFlag:"1",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='week'){
					param = {dateTimeStart: this.selfParam.businessDate.week.startDate,
							 dateTimeEnd: this.selfParam.businessDate.week.endDate,
							 dateFlag:"2",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='month'){
					param = {dateTimeStart: this.selfParam.businessDate.month.startDate,
							 dateTimeEnd: this.selfParam.businessDate.month.endDate,
							 dateFlag:"3",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='year'){
					param = {dateTimeStart: this.selfParam.businessDate.year.startDate,
							 dateTimeEnd: this.selfParam.businessDate.year.endDate,
							 dateFlag:"4",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}	
				console.log("createParam end:",param)
				return param
			},
			returnFromDatePicker(){
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				var dateType = uni.getStorageSync("dateType")
				var bussinessDate = JSON.parse(uni.getStorageSync("businessDate"))
				this.selfParam.businessDate = bussinessDate;
				console.log('returnFromDatePicker:dateType=',this.selfParam.businessDate)	
						
			    var area = uni.getStorageSync("area")
				var  areaName = uni.getStorageSync("areaName")
				console.log('returnFromDatePicker:area=',area,', areaName=',areaName)					
				this.selfParam.provinceCenterId=area
				this.selfParam.provinceCenterName=areaName		
				this.selfParam.token=uni.getStorageSync("token")
				uni.setStorageSync("selfParam",JSON.stringify(this.selfParam))	
			},
			goDetail(areaIdStr){
				//跳转到当前地区所有门店
				var url = '/pentaho/channel/getTransfiniteShowsList';
				var param = this.createParam();
				param.provincialId =areaIdStr
				param.token =getApp().globalData.token;
				urlAPI.getRequest(url, param).then((res)=>{
					var data =res.data.data;
					for(var i=0;i<data.length;i++){
						
						var json = {id:i+1, 
									area:data[i][1], 
									number:data[i][2], 
									amount:(data[i][3]/10000).toFixed(2)}	
						this.$set(this.amountTableDataWithPro,i,json);	
					}
				}).catch((err)=>{
					console.log(err)
				});
				console.log(this.amountTableDataWithPro)
				console.log(this.amountTableColumnsWithPro)
				uni.navigateTo({
					url:"/pages/common/tableLimitShopDetail?tableData= " + JSON.stringify(this.amountTableDataWithPro) + '&tableColumns=' + JSON.stringify(this.amountTableColumnsWithPro)
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
