<template>
	<view>
		<view class='centerView' style="width: 100%;display: flex; padding-top: 20rpx;">
			<view style="text-align: center;width: 100%;padding-bottom: 20rpx;color: blue;">赛事</view>
		</view>
		<view class ="column-box viewborder" style="width: 700rpx; display: flex;" >
			<view style="width: 350rpx;">
				<view class="black-text">足球赛事</view>
				<view class="gray-text">当日完赛场 {{pagedata[0]}}场</view>
			</view>
			<view style="width: 350rpx;">
				<view class="black-text" style="text-align: right;" @click="toFoot()">详情></view>
				<view class="gray-text">当日在售赛场 {{pagedata[1]}}场</view>
			</view>
		</view>
		<view class ="column-box viewborder" style="width: 700rpx; display: flex;" >
			<view style="width: 350rpx;">
				<view class="black-text">篮球赛事</view>
				<view class="gray-text">当日完赛场 {{pagedata[2]}}场</view>
			</view>
			<view style="width: 350rpx;">
				<view class="black-text" style="text-align: right;" @click="toBasket()">详情></view>
				<view class="gray-text">当日在售赛场 {{pagedata[3]}}场</view>
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
								$width:"100px",
							},
							{
								title: '场次',
								key: 'area',
								$width:"50px"
							},],
				//足球
				 tableData:[],
				 //篮球
				 tableData1:[]
				 }
		},
		methods: {
			loadData(){
				var that=this;
				var url = 'pentaho/plugin/cda/api/doQuery11/1/1/2/2';
				urlAPI.getRequest(url, null).then((res)=>{
					this.loading = false;
					var data =res.data.concreteBean;	
					this.$set(that.pagedata,0,data[0]);
					this.$set(that.pagedata,1,data[1]);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				url = 'pentaho/plugin/cda/api/doQuery12/1/1/2/2';
				urlAPI.getRequest(url, null).then((res)=>{
					this.loading = false;
					var data =res.data.concreteBean;	
					this.$set(that.pagedata,2,data[0]);
					this.$set(that.pagedata,3,data[1]);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				
				url = 'pentaho/plugin/cda/api/doQuery12/1/1/2/2';
				urlAPI.getRequest(url, null).then((res)=>{
					this.loading = false;
					var data =res.data.concreteBean;	
					this.$set(that.pagedata,2,data[0]);
					this.$set(that.pagedata,3,data[1]);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				//加载足球所有
				url = 'pentaho/plugin/cda/api/doQuery13/1/1/2/2';
				urlAPI.getRequest(url, null).then((res)=>{
					this.loading = false;
					var data =res.data.concreteBean;	
					that.tableData =data;
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				//加载篮球所有
				
				url = 'pentaho/plugin/cda/api/doQuery14/1/1/2/2';
				urlAPI.getRequest(url, null).then((res)=>{
					this.loading = false;
					var data =res.data.concreteBean;	
					that.tableData1 =data;
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				
			},
			toFoot(){
				var that =this;
				console.log(this.tableData)
				uni.navigateTo({
					url:'/pages/common/tableDetail?col='+JSON.stringify(encodeURIComponent(that.tableColumns))+'&da='+JSON.stringify(encodeURIComponent(that.tableData)),
					success: function(res) {
					    // 通过eventChannel向被打开页面传送数据
					    res.eventChannel.emit('heheh', 
												{ col: JSON.stringify(encodeURIComponent(that.tableColumns))},
												);
					}
				});
			},
			toBasket(){
				var that =this;
				console.log(this.tableData1)
				uni.navigateTo({
					url:'/pages/common/tableDetail?col='+JSON.stringify(encodeURIComponent(that.tableColumns1))+'&da='+JSON.stringify(encodeURIComponent(that.tableData1)),
					success: function(res) {
					    // 通过eventChannel向被打开页面传送数据
					    res.eventChannel.emit('heheh', 
												{ col: JSON.stringify(encodeURIComponent(that.tableColumns))},
												);
					}
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
