<template>
	<view>
		<view class = "box-container">
			<view style="text-align: center;font-size: 50rpx; width: 100%;padding-bottom: 20rpx;color: blue;">
				<image style="width: 50rpx;height: 40rpx;padding-right: 20rpx;" src="../../../static/left.png" mode="aspectFill">
				 赛事
				<image style="width: 50rpx;height: 40rpx;padding-left: 20rpx;" src="../../../static/right.png" mode="aspectFill">
			</view>
			<view class ="column-box viewborder" style="width: 700rpx; display: flex;" >
				<view style="width: 350rpx;">
					<view class="black-text">足球赛事</view>
					<view class="gray-text">当日完赛场 {{pagedata[1]}}场</view>
				</view>
				<view style="width: 350rpx;">
					<view class="black-text" style="text-align: right;" @click="toFoot()">详情></view>
					<view class="gray-text">当日在售赛场 {{pagedata[0]}}场</view>
				</view>
			</view>
			<view class ="column-box viewborder" style="width: 700rpx; display: flex;" >
				<view style="width: 350rpx;">
					<view class="black-text">篮球赛事</view>
					<view class="gray-text">当日完赛场 {{pagedata[3]}}场</view>
				</view>
				<view style="width: 350rpx;">
					<view class="black-text" style="text-align: right;" @click="toBasket()">详情></view>
					<view class="gray-text">当日在售赛场 {{pagedata[2]}}场</view>
				</view>
			</view>		
			<backTop :src="backTop.src"  :scrollTop="backTop.scrollTop"></backTop>
		</view>
	</view>
</template>

<script>
	import urlAPI from '@/common/vmeitime-http/';
	import backTop from '@/components/sads-components/back-top.vue';
	
	export default {
		components: {
			backTop
		},
		props: {
			model:{
				type: Object,
				default: () => ({})
			}
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
						view:'',//用于展示日期、年、月等
						date:{startDate:'', endDate:''},
						week:{startDate:'', endDate:''},
						month:{startDate:'', endDate:''},
						year:{startDate:'', endDate:''},
					},	
					userId:'',			
					selfProvinceCenterId:''//存登录时候的id
				},
				backTop: {
					src: '../../static/top.png',
					scrollTop: 0
				},
				scrollTop: 0,
				showModel:{},
				pagedata:[1,2,3,4],
				tableColumns:[{
								title: "赛制",
								key: "id",
								$width:"155rpx",
							},
							{
								title: '场次',
								key: 'area',
								$width:"155rpx"
							},],
				//完赛
				tableData1:[],
				 //在售
				tableData11:[],
				tableColumns:[{
								title: "赛制",
								key: "id",
								$width:"155rpx",
							},
							{
								title: '场次',
								key: 'area',
								$width:"155rpx"
							},],
				//完赛
				tableData2:[],
				 //在售
				tableData22:[]
				}
		},
		methods: {
			returnFromDatePicker(){
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				const dateType = uni.getStorageSync("dateType")
				const bussinessDate = JSON.parse(uni.getStorageSync("businessDate"))
				this.selfParam.businessDate = bussinessDate;
				console.log('returnFromDatePicker:dateType=',this.selfParam.businessDate)	
						
				var area = uni.getStorageSync("area")
				const areaName = uni.getStorageSync("areaName")
				console.log('returnFromDatePicker:area=',area,', areaName=',areaName)
				if(-1==area){
					area=0;
				}
				this.selfParam.provinceCenterId=area
				this.selfParam.provinceCenterName=areaName		
				this.selfParam.token=getApp().globalData.token
				uni.setStorageSync("selfParam",JSON.stringify(this.selfParam))		
			},
			createParam(){
				console.log("createParam begin")
				var dateType = this.selfParam.businessDate.dateType
				var param = {}
				if(dateType=='date'){
					param = {dateTime: this.selfParam.businessDate.date.startDate,
							 dateFlag:"1",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='week'){
					param = {dateTime: this.selfParam.businessDate.week.startDate,
							 dateFlag:"2",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='month'){
					param = {dateTime: this.selfParam.businessDate.month.startDate,
							 dateFlag:"3",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='year'){
					param = {dateTime: this.selfParam.businessDate.year.startDate,
							 dateFlag:"4",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}	
				console.log("createParam end:",param)
				return param
			},
			loadData(){
				var token =getApp().globalData.token;
				var that=this;
				var url = '/pentaho/dailyPaper/getMatchSceneCount';
				var param={dateTime: this.selfParam.businessDate.date.startDate,
						 regionId:this.selfParam.provinceCenterId,
						 token:this.selfParam.token}
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					var data =res.data.data;
					if(data.length==0||data.length==4){
						this.$set(that.pagedata,0,0);
						this.$set(that.pagedata,1,0);
						this.$set(that.pagedata,2,0);
						this.$set(that.pagedata,3,0);
					}else {
						this.$set(that.pagedata,0,data[16]);
						this.$set(that.pagedata,1,data[17]);
						this.$set(that.pagedata,2,data[19]);
						this.$set(that.pagedata,3,data[18]);
					}
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				//加载
				this.loadDetail('1');
				this.loadDetail('2');
			},
			toFoot(){
				var that =this;
				uni.navigateTo({
					title:'足球赛事详情',
					url:'/pages/common/tableDetail2?tableColumns='+JSON.stringify(that.tableColumns)+'&tableData='+JSON.stringify(that.tableData1)+
					'&tableColumns1='+JSON.stringify(that.tableColumns)+'&tableData1='+JSON.stringify(that.tableData11),
					
				});
			},
			toBasket(){
				var that =this;
				uni.navigateTo({ 
					title:'篮球赛事详情',
					url:'/pages/common/tableDetail2?tableColumns='+JSON.stringify(that.tableColumns)+'&tableData='+JSON.stringify(that.tableData2)+
					'&tableColumns1='+JSON.stringify(that.tableColumns)+'&tableData1='+JSON.stringify(that.tableData22)
					
				});
			},
			loadDetail(ballType){
				var token =getApp().globalData.token;
				//加载足球
				var url = '/pentaho/dailyPaper/getDetailMatchSceneCount';
				var param=this.createParam();
				if(ballType=='1'){
					param.gameFlag = 1
				}else if(ballType=='2'){
					param.gameFlag = 2
				}
				var that =this;
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = true;
					var data1 =res.data.data;	
					var finish =data1.finish;
					var onSale = data1.onSale;
					this.tableData1=[];
					this.tableData2=[];
					if(finish.length==0){
						finish =[{'id':'无','area':0}];
					}else {
						for(var i=0;i<finish.length;i++){
							var obj={'id':finish[i][0],'area':finish[i][1]};
							if(ballType=='1'){
								that.tableData1.push(obj);
							}else if(ballType=='2'){
								that.tableData2.push(obj);
							
							}
						};
					}
					this.tableData11=[];
					this.tableData22=[];
					if(onSale.length==0){
						onSale =[{'id':'无','area':0}];
					}else{
						for(var j=0;j<onSale.length;j++){
							var obj={'id':onSale[j][0],'area':onSale[j][1]};
							if(ballType=='1'){
								that.tableData11.push(obj);
							}else if(ballType=='2'){
								that.tableData22.push(obj);
							
							}
						};
					}
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			},
			refresh(){
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				this.returnFromDatePicker();
				this.loadData();
			},
			
		},
		created() {
			this.returnFromDatePicker();
			this.loadData();
		},
		onShow() {
			this.returnFromDatePicker();
			this.loadData();
		},
		onLoad() {
			this.returnFromDatePicker();
			this.loadData();
		},
		onPageScroll(e) {
			this.backTop.scrollTop = e.scrollTop;
		}
	}
</script>

<style>
	.row-box {
		display: flex;
		margin: 0rpx 10rpx;
		padding: 0 10rpx;
	}
	
	.column-box{
		margin: 25rpx 20rpx;
		background-color: #ebebeb;
	}
	
	.black-text{
		text-align: left;
		color: #777;
		font-weight:bold;
		font-size: 30rpx;
		margin: 20rpx 30rpx;
	}
	
	.gray-text{
		text-align: left;
		color: #777;
		font-size: 30rpx;
		margin: 20rpx 30rpx;
	}
	.viewborder{
		border-radius: 20rpx;
		padding: 0rpx 0rpx 0rpx 0rpx;
	}
	.box-contaniner{
		width: 100%;
		margin: 20rpx 10rpx 40rpx 10rpx;
	}
</style>
