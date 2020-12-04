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
			loadData(){
				var token =getApp().globalData.token;
				var that=this;
				var url = '/pentaho/dailyPaper/getMatchSceneCount';
				var param={dateTime:'2020-01-03',
							regionId:'',
							token:token};
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					var data =res.data.data;	
					this.$set(that.pagedata,0,data[0]);
					this.$set(that.pagedata,1,data[1]);
					this.$set(that.pagedata,2,data[2]);
					this.$set(that.pagedata,3,data[3]);
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
				var param={dateTime:'2020-01-03',
							gameFlag:ballType,
							token:token};
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
