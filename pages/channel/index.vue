<template>
	<view>
		<view class="content">
			<view @click="goArea">{{selfParam.provinceCenterName}}</view>
			<uni-section class="section" type="line"></uni-section>
			<view @click="goDatePicker" class="list">{{selfParam.businessDate.view}}</view>
		</view>	 
		<view class="input">
			<input class="uni-input" type="number"  placeholder="请输入门店或终端编号" />
			<view style="color: #007AFF">搜索</view>
		</view>
		
		<view class="box-contaniner">
			<dataContainer ref="dataContain" :dataAs="totalData"></dataContainer>
		</view>
		
		<view class="box-contaniner">
			<view class="container-title">				
				<view>销售top100门店</view>
				<view class="rankTable-more" @click="goShopDetail(amountTableDataDetail,amountTableColumns)">全部>></view>
			</view>
			<view class="table">
				<v-table :columns="amountTableColumns" :list="amountTableData"  selection="single"  :slot-cols="['number']" border-color="#FFFFFF">
					<template v-slot="{ row }">
						<view style="font-weight: blod;color:blue;" @click="goDetail(row.number)">{{ row.number }}</view>
					</template>
				</v-table>
			</view>
		</view>
		
		<view class="box-contaniner">
			<view class="container-title">				
				<view>各地区超限门店</view>
				<view class="rankTable-more" @click="goLimitShopDetail(beyondLimitTableDataDetail,beyondLimitTableColumns)">全部>></view>
			</view>
			<view class="table">
				<v-table :columns="beyondLimitTableColumns" :list="beyondLimitTableData"   :slot-cols="['area']"  border-color="#FFFFFF">
					<template v-slot="{ row }">
						<view style="font-weight: blod;color:blue;" @click="goLimitDetail(row.area)">{{ row.area }}</view>
					</template>
				</v-table>
			</view>
		</view>
	</view>
</template>

<script>
	import dataContainer from '@/components/sads-components/dataContainer.vue';
	import vTable from "@/components/table/table.vue";
	import uniSection from "@/components/uni/uni-section/uni-section.vue"	
	import dateSelector from "@/components/sads-components/dateSelector.vue";
	import urlAPI from '@/common/vmeitime-http/';
	import commonFun from '@/common/tools/watcher.js';
	
	export default {
			components:{
				dateSelector,dataContainer, vTable
			},
			data() {
				return {
					selfParam:{
						token:'',
						provinceCenterId:'',
						provinceCenterName:'',
						businessDate:{
							view:'',
							date:{startDate:'', endDate:''},
							week:{startDate:'', endDate:''},
							month:{startDate:'', endDate:''},
							year:{startDate:'', endDate:''},
						},					
						startDate:'',
						endDate:'',
						cityCenterId:'',
						userId:'',
						countyCenterId:'',
						dateType:'date',
						compareType:'date',
						compareOne:'',
						compareTwo:'',
						selfProvinceCenterId:''
					},
					areaMap:{},
					isFirstLoad:true,
					totalData:{},	
					areaIdList:{},
					amountTableData: [],
					amountTableDataDetail:[],
					amountTableColumns: [{
								title: "排名",
								key: "id",
								$width:"50px",
							},
							{
								title: '省份/地市',
								key: 'area',
								$width:"100px"
							},
							{
								title: '门店编号',
								key: 'number',
								$width:"150px"
							},
							{
								title: '销量',
								key: 'amount'
							}
						],	
					beyondLimitTableData: [],
					beyondLimitTableDataDetail:[],
					beyondLimitTableColumns: [{
								title: "排名",
								key: "id",
								$width:"50px",
							},
							{
								title: '省份/地市',
								key: 'area',
								$width:"100px"
							},
							{
								title: '门店数量',
								key: 'count',
								$width:"150px"
							},
							{
								title: '环比变化值',
								key: 'change'
							}
						],
				}				
			},
			onLoad() {
				this.returnFromDatePicker()	
				console.log("sales-self-onLoad:totalData=",this.totalData)
			},
			created(){
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				this.areaMap = JSON.parse(uni.getStorageSync("areaMap"))
				this.getServerData();
				this.showView()
				console.log('index-create this.areaMap:', this.areaMap)
				console.log("sales-self-created:", this.selfParam)
			},
			onShow() {//此处接受来自日期选择页面的参数
				this.returnFromDatePicker()
				console.log("sales-self-onShow:",this.selfParam)
			},
			methods:{
				getServerData() {
					this.getStoreSituation();	
					this.getTopHundredShows();
					this.getTransfiniteShows();
				},
				getStoreSituation(){	
					var url = '/pentaho/sales/getStoreSituation';
					var param = this.createParam()
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						console.log('request success', res)
						uni.showToast({
							title: '请求成功',
							icon: 'success',
							mask: true
						});
						var data = res.data.data;	
						var left1 = {'name':'周同比','value':data[1] + '%'};
						var right1 = {'name':'环比','value':data[2] + '%'};
						var big1 = {name:'在售门店数',value:data[0], left:left1, right:right1}
						this.$set(this.totalData, 'big1', big1);
						this.res = '请求结果 : ' + JSON.stringify(res);
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					
					var url = '/pentaho/sales/getStoreSalesrate';
					var param = this.createParam()
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						console.log('request success', res)
						uni.showToast({
							title: '请求成功',
							icon: 'success',
							mask: true
						});
						var data = res.data.data;	
						var left2 = {'name':'周同比','value':data[1] + '%'};
						var right2 = {'name':'环比','value':data[2] + '%'};
						var big2 = {name:'在售率',value:data[0], left:left2, right:right2}
						
						this.$set(this.totalData, 'big2', big2);
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					this.res = 'channel请求结果 : ' + JSON.stringify(this.totalData);
				},
				getTopHundredShows(){
					var url = '/pentaho/channel/getTopHundredShows';
					var param = this.createParam()
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						console.log('request success', res)
						uni.showToast({
							title: '请求成功',
							icon: 'success',
							mask: true
						});
						var data = res.data.data;	
						for(var i=0;i<data.length;i++){
							var json = {id:i+1, 
										area:data[i][1], 
										number:data[i][2], 
										amount:data[i][3]}						
							if(i<=4){
								this.amountTableData[i] = json
							}
							this.amountTableDataDetail[i] = json
						}
								
						this.res = '请求结果 : ' + JSON.stringify(res);
						console.log(this.amountTableData)
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
				},
				getTransfiniteShows(){
					var url = '/pentaho/channel/getTransfiniteShows';
					var param = this.createParam()
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						console.log('request success', res)
						uni.showToast({
							title: '请求成功',
							icon: 'success',
							mask: true
						});
						var data = res.data.data;	
						for(var i=0;i<data.length;i++){
							var json = {id:i+1, 
										area:data[i][1], 
										count:data[i][2], 
										change:data[i][3]}	
							var areaId={id:data[i][0],name:data[i][1]}
							if(i<=4){
								this.beyondLimitTableData[i] = json
							}
							this.beyondLimitTableDataDetail[i] = json
							this.areaIdList[i]=areaId
						}
								
						this.res = '请求结果 : ' + JSON.stringify(res);
						console.log(this.beyondLimitTableData)
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
				},
				returnFromDatePicker(){
					const dateType = uni.getStorageSync("dateType")
					const bussinessDate = JSON.parse(uni.getStorageSync("businessDate"))
					this.selfParam.businessDate = bussinessDate;
					console.log('returnFromDatePicker:dateType=',this.selfParam.businessDate)	
							
					const area = uni.getStorageSync("area")
					const areaName = uni.getStorageSync("areaName")
					console.log('returnFromDatePicker:area=',area,', areaName=',areaName)					
					this.selfParam.provinceCenterId=area
					this.selfParam.provinceCenterName=areaName			
				},
				goArea(){
					uni.navigateTo({
						url:"/pages/common/areaSelector?area="+this.selfParam.provinceCenterId
					});
				},
				goDetail(number){
					console.log(number)
					uni.navigateTo({
						url:"/pages/channel/index-inner?number="+number
					});
				},
				goDatePicker() {
					uni.navigateTo({
						url:"/pages/common/dateSelector"
					});
				},
				createParam(){
					console.log("createParam begin")
					var dateType = this.selfParam.dateType
					var param = {}
					if(dateType=='date'){
						param = {dateTimeStart: this.selfParam.businessDate.date.startDate,
								 dateTimeEnd: this.selfParam.businessDate.date.dateTimeEnd,
								 dateFlag:"1",
								 regionId:this.selfParam.provinceCenterId,
								 token:this.selfParam.token }
					}else if(dateType=='week'){
						param = {dateTimeStart: this.selfParam.businessDate.week.startDate,
								 dateTimeEnd: this.selfParam.businessDate.week.dateTimeEnd,
								 dateFlag:"2",
								 regionId:this.selfParam.provinceCenterId,
								 token:this.selfParam.token }
					}else if(dateType=='month'){
						param = {dateTimeStart: this.selfParam.businessDate.month.startDate,
								 dateTimeEnd: this.selfParam.businessDate.month.dateTimeEnd,
								 dateFlag:"3",
								 regionId:this.selfParam.provinceCenterId,
								 token:this.selfParam.token }
					}else if(dateType=='year'){
						param = {dateTimeStart: this.selfParam.businessDate.year.startDate,
								 dateTimeEnd: this.selfParam.businessDate.year.dateTimeEnd,
								 dateFlag:"4",
								 regionId:this.selfParam.provinceCenterId,
								 token:this.selfParam.token }
					}	
					console.log("createParam end:",param)
					return param
				},
				showView(){
					// commonFun.sleep(2000)
					this.$nextTick(() => {				
						this.$refs['dataContain'].showDataContainer();
					});
				},
				goLimitShopDetail(tableData, tableColumns){
					uni.navigateTo({
						url:"/pages/common/tableLimitShopDetail?tableData= " + JSON.stringify(tableData) + '&tableColumns=' + JSON.stringify(tableColumns)
					});
				},
				goShopDetail(tableData, tableColumns){
					uni.navigateTo({
						url:"/pages/common/tableShopDetail?tableData= " + JSON.stringify(tableData) + '&tableColumns=' + JSON.stringify(tableColumns)
					});
				},
				onSelectionChange(obj){
					console.log("对比前后，选中的变化")
					console.log(obj)
				},
				goLimitDetail(){
					var areaId = 
					this.areaMap  
				}
			},
			mounted(){
				// this.selfParam=this.model
				this.showView();
			},
			watch: {
				'$route':'showView'
			},

		}
</script>

<style>
	.box-contaniner{
		width: 100%;
		margin: 20rpx 10rpx 40rpx 10rpx;
		text-align: center;
	}
	.datePick{
		text-align: center;
		padding: 0upx 5upx;
	}
	.datetext{
		font-size: 35rpx;
		background-color:  #ebebeb;
		text-align: center;
	}
	.input{
		/*  */
		justify-content: center;
		display: flex;
		flex-direction: row;
		margin: 20rpx 10rpx 40rpx 10rpx;		
	}
	.container-title{
		display: flex;
		width: 100%;
		margin: 0rpx 5rpx;
		padding: 0 10rpx;
		font-size: 30rpx;
		font-weight: bold;
		justify-content: space-between;
		background-color: #FFFFFF;
	}
	
	.table {
		/* line-height: 40px; */
		font-weight: bold;
		border-color:#FFFFFF;
	}
	.content {
		display: flex;
		align-items: center;
		justify-content: center;
		font-size: 32rpx;
		color: #333;
		padding-top: 40rpx;
	}
	.section{
		background-color: #FFFFFF;
	}
</style>
