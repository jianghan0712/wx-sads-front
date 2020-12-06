<template>
	<view>
		<view class='centerView' style="width: 100%;display: flex; padding-top: 20rpx;">
			<view style="text-align: center;width: 100%;padding-bottom: 20rpx;color: blue;">赛事</view>
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
								$width:"185rpx",
							},
							{
								title: '场次',
								key: 'area',
								$width:"185rpx"
							},],
				//完赛
				tableData:[],
				 //在售
				tableData1:[]
				}
		},
		methods: {
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
				this.selfParam.token=uni.getStorageSync("token");		
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
				var param=this.createParam();
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					var data =res.data.data;
					if(data.length=0){
						this.$set(that.pagedata,0,0);
						this.$set(that.pagedata,1,0);
						this.$set(that.pagedata,2,0);
						this.$set(that.pagedata,3,0);
					}else {
						this.$set(that.pagedata,0,0);
						this.$set(that.pagedata,1,0);
						this.$set(that.pagedata,2,0);
						this.$set(that.pagedata,3,0);
					}
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				//加载
				
			},
			toFoot(){
				var that =this;
				this.loadDetail('1');
				uni.navigateTo({
					title:'足球赛事详情',
					url:'/pages/common/tableDetail2?tableColumns='+JSON.stringify(that.tableColumns)+'&tableData='+JSON.stringify(that.tableData)+
					'&tableColumns1='+JSON.stringify(that.tableColumns)+'&tableData1='+JSON.stringify(that.tableData1),
					
				});
			},
			toBasket(){
				var that =this;
				this.loadDetail('2');
				uni.navigateTo({
					title:'篮球赛事详情',
					url:'/pages/common/tableDetail2?tableColumns='+JSON.stringify(that.tableColumns)+'&tableData='+JSON.stringify(that.tableData)+
					'&tableColumns1='+JSON.stringify(that.tableColumns)+'&tableData1='+JSON.stringify(that.tableData1),
					
				});
			},
			loadDetail(ballType){
				var token =getApp().globalData.token;
				//加载足球
				var url = '/pentaho/dailyPaper/getDetailMatchSceneCount';
				var param=param=this.createParam();
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = true;
					var data =res.data.data;	
					var finish =data.finish;
					var onSale = data.onsale;
					if(finish.length==0){
						finish =[{'id':'无','area':0}];
					}
					if(onSale.length==0){
						onSale =[{'id':'无','area':0}];
					}
					that.tableData=finish;
					that.tableData1=onSale;
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			}
			
		},
		created() {
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
</style>
