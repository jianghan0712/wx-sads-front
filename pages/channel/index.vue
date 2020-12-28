<template>
	<view class="box-contaniner">
		<view class="content">
			<view class="blackClass">
				<view @click="goArea">{{selfParam.provinceCenterName}}</view>
			</view>
			<view class="blackClass">
				<view @click="goDatePicker" class="list">{{selfParam.businessDate.view}}</view>
			</view>
		</view>	 
		<view class="input">
			<input id='num'  style="background-color: rgba(128,139,150,0.1);border:1px solid gray;width: 60%;" @input="onKeyInput" placeholder="请输入门店或终端编号" />
			<view style="color: #007AFF;padding-left: 5rpx;" @click="resetData()">搜索</view>
		</view>
		
		<view class="box-contaniner">
			<dataContainer ref="dataContain" :dataAs="totalData"></dataContainer>
		</view>
		
		<view class="box-contaniner" style="margin: 20rpx;">
			<view class="container-title">				
				<view>销售top100门店</view>
				<view class="rankTable-more" style="padding-right: 30rpx;" @click="goShopDetail(amountTableDataDetail,amountTableColumns)">全部>></view>
			</view>
			<view class="example">
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
				<view class="rankTable-more" style="padding-right: 30rpx;" @click="goLimitShopDetail(beyondLimitTableDataDetail,beyondLimitTableColumns)">全部>></view>
			</view>
			<view v-if="update2">
				<view class="example">
					<v-table :columns="beyondLimitTableColumns" :list="beyondLimitTableData"   :slot-cols="['area']"  border-color="#FFFFFF">
						<template v-slot="{ row }">
							<view style="font-weight: blod;color:blue;" @click="goLimitDetail(row.area)">{{ row.area }}</view>
						</template>
					</v-table>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	import dataContainer from '@/components/sads-components/dataContainer.vue';
	import vTable from "@/components/table/table.vue";
	import uniSection from "@/components/uni/uni-section/uni-section.vue"	
	import urlAPI from '@/common/vmeitime-http/';
	import commonFun from '@/common/tools/watcher.js';
	import numberFun from '@/common/tools/number.js';
	
	export default {
			components:{
				dataContainer, vTable,uniSection
			},
			data() {
				return {
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
				update2:false,
				areaMap:{},
				isFirstLoad:true,
				totalData:{},
				num:'',
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
							$width:"130px"
						},
						{
							title: '销量(万元)',
							key: 'amount'
						}
					],
				amountTableDataWithPro: [],
				amountTableColumnsWithPro: [{
							title: "排名",
							key: "id",
							$width:"50px",
						},
						{
							title: '地市',
							key: 'area',
							$width:"100px"
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
							$width:"130px"
						},
						{
							title: '环比变化值',
							key: 'change'
						}
					],
				}				
			},
			onLoad() {
				this.returnFromDatePicker();
				this.getServerData();
				this.showView();
			},
			created(){
				/* this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				console.log(this.selfParam) */
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				this.areaMap = JSON.parse(uni.getStorageSync("areaMap"))
				this.getServerData();
				this.showView()
				console.log('index-create this.areaMap:', this.areaMap)
				console.log("sales-self-created:", this.selfParam)
			},
			onShow() {//此处接受来自日期选择页面的参数
				this.returnFromDatePicker();
				this.getServerData();
				this.showView();
				this.showView();
				console.log("sales-self-onShow:",this.selfParam)
			},
			methods:{
				getServerData() {
					this.getStoreSituation();	
					this.getTopHundredShows();
					this.getTransfiniteShows();
				},
				onKeyInput(event){
					this.num=event.target.value;
				},
				getStoreSituation(){	
					var url = '/pentaho/sales/getStoreSituation';
					var param = this.createParam()
					var that = this;
					urlAPI.getRequest(url, param).then((res)=>{
						that.loading = false;
						console.log('request success', res)
						var data = res.data.data;	
						var left1 = {'name':'周同比','value':data[1] + '%'};
						var right1 = {'name':'环比','value':data[2] + '%'};
						var big1 = {name:'在售门店数',value:data[0], left:left1, right:right1}
						this.$set(this.totalData, 'big1', big1);
						this.$refs['dataContain'].showDataContainer();
						
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
						var data = res.data.data;	
						var left2 = {'name':'周同比','value':data[1] + '%'};
						var right2 = {'name':'环比','value':data[2] + '%'};
						var big2 = {name:'在售率',value:data[0]+"%", left:left2, right:right2}
						
						this.$set(this.totalData, 'big2', big2);
						this.$refs['dataContain'].showDataContainer();
						
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					this.res = 'channel请求结果 : ' + JSON.stringify(this.totalData);
				},
				getTopHundredShows(){
					var url = '/pentaho/channel/getTopHundredShows';
					var param = this.createParam()
					var that =this;
					
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						console.log('request success', res)
						var data = res.data.data;	
						if(data==null || data.length==0){
							return;
						}
						var format0 = numberFun.formatCNumber(data[0][3]);		
						for(var i=0;i<data.length;i++){
							var json = {id:i+1, 
										area:data[i][1], 
										number:data[i][2], 
										// amount:data[i][3]}
										amount:(data[i][3]/format0.value).toFixed(2)}
							//不变红																		
							if(i<=9){
								this.amountTableData[i] = json
							}
							this.amountTableDataDetail[i] = json
						}
						var t = '省份'
						if(this.selfParam.provinceCenterId!=0){
							t='地市'
						}
						this.amountTableColumns=[{
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
									title: '门店编号',
									key: 'number',
									$width:"130px"
								},
								{
									title: '销量(' + format0.name + '元)',
									key: 'amount'
								}
							],
								
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
					var that =this ;
					this.update2=false;
					
					if(this.selfParam.provinceCenterId==0){
						this.beyondLimitTableColumns=[{
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
									title: '门店数量',
									key: 'count',
									$width:"130px"
								},
								{
									title: '环比变化值',
									key: 'change'
								}
							]
								
					}else {
						this.beyondLimitTableColumns=[{
									title: "排名",
									key: "id",
									$width:"50px",
								},
								{
									title: '地市',
									key: 'area',
									$width:"100px"
								},
								{
									title: '门店数量',
									key: 'count',
									$width:"130px"
								},
								{
									title: '环比变化值',
									key: 'change'
								}
							]
					}
					
					urlAPI.getRequest(url, param).then((res)=>{
						this.loading = false;
						console.log('request success', res)
						var data = res.data.data;	
						for(var i=0;i<data.length;i++){
							var json = {id:i+1,
										area:data[i][1], 
										count:data[i][2], 
										change:(data[i][3]>0?("+"+data[i][3]):data[i][3])
										}	
							var cellClassName ={};
							if(data[i][3]<0){
								cellClassName.change='small-text-green'
							}else{
								cellClassName.change='small-text-red'
							}	
							json.cellClassName=cellClassName;			
							var areaId={id:data[i][0],name:data[i][1]}
							if(i<=4){
								this.beyondLimitTableData[i]=json;	
							}
							this.$set(this.beyondLimitTableDataDetail,i,json);	
							this.areaIdList[i]=areaId
							this.$set(this.areaIdList,i,areaId);
							
						}
							
						this.res = '请求结果 : ' + JSON.stringify(res);
						console.log(this.beyondLimitTableData)
					}).catch((err)=>{
						this.loading = false;
						console.log('request fail', err);
					});
					this.update2=true;
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
					this.selfParam.token=getApp().globalData.token
					uni.setStorageSync("selfParam",JSON.stringify(this.selfParam))	
				},
				goArea(){
					uni.navigateTo({
						url:"/pages/common/areaSelector?area="+this.selfParam.provinceCenterId +'&areaName=' + this.selfParam.provinceCenterName
					});
				},
				goDetail(number){
					console.log(number)
					uni.setStorageSync("shopNo", number)
					uni.navigateTo({
						url:"/pages/channel/index-inner?number="+number
					});
				},
				goDatePicker() {
					uni.navigateTo({
						url:"/pages/common/dateSelector?type=common&date=" + this.selfParam.businessDate.date.startDate
					});
				},
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
				showView(){
					// commonFun.sleep(2000)
					this.$refs['dataContain'].showDataContainer();
				},
				goLimitShopDetail(tableData, tableColumns){
					uni.navigateTo({
						url:"/pages/common/tableLimitShopDetail2?tableData= " + JSON.stringify(tableData) + '&tableColumns=' + JSON.stringify(tableColumns)
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
				goLimitDetail(area){
					//跳转到当前地区所有门店
					var url = '/pentaho/channel/getTransfiniteShowsList';
					var param = this.createParam();
					var list = JSON.parse(uni.getStorageSync("areaMap"))
					console.log(list)
					var areaIdStr="";
					for(var i = 0;i<list.length;i++){    //遍历json对象的每个key/value对,p为key
						if(list[i].name==area){
							areaIdStr=list[i].id;
						}
					}
					console.log(areaIdStr)
					param.provincialId =areaIdStr
					urlAPI.getRequest(url, param).then((res)=>{
						var data =res.data.data;
						for(var i=0;i<data.length;i++){
							
							var json = {id:i+1, 
										area:data[i][1], 
										number:data[i][2], 
										amount:data[i][3]>0?"+"+(data[i][3]/10000).toFixed(2):(data[i][3]/10000).toFixed(2)}
							var cellClassName ={};				
							if(data[i][3]<0){
								cellClassName.amount='small-text-green'
							}else{
								cellClassName.amount='small-text-red'
							}	
							json.cellClassName=cellClassName
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
				resetData(){
					//根据门店编号跳转
					//校验门店是否存在
					var url = '/pentaho/shows/searchShowByShowNumber';
					var param = {
						showNumber:this.num,
						provincial:this.selfParam.provinceCenterId,
						 token:this.selfParam.token
					}
					//修改为0
					var flag=0;
					urlAPI.getRequest(url, param).then((res)=>{
						var data = res.data.data;
						if(data.flag){
							flag==1;
						}
					}).catch((err)=>{
						
					});
					if(flag==0){
						uni.showToast({
							title: '门店不存在',
							icon: 'loading',
						});
						console.log(11111)
					}else {
						this.goDetail(this.num)
						console.log(2222)
					}
					
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
		/* margin: 20rpx 10rpx 40rpx 10rpx; */
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
		width: 100%;
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
	.blackClass{
		padding: 10px 10px;
	}
	.example {
		/* line-height: 40px; */
		width: 100%;
		display: flex;
		font-weight: bold;
		border-color:#FFFFFF;
	}
</style>
