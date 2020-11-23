<template>
	<view>
		<view class ='centerView' style="width: 100%; padding-top: 30rpx;">
			<view style="text-align: center;width: 100%;padding-bottom: 20rpx; color: blue;">区域</view>
			
		</view>
		<view class ="column-box viewborder" style="width: 700rpx; display: flex;" >
			<view style="width: 700rpx;">
				<view class="black-text" style="padding-left: 10rpx;">地区日销量及周同比变化</view>
			</view>
			<view style="width: 350rpx;">
				<view class="gray-text" style="text-align: right;padding-right: 0rpx;" @click="toAll()">全部></view>
			</view>
		</view>
		<view class="table" style="width: 700rpx;margin-left: 30rpx;" >
			<v-table :columns="tableColumns" :list="tableData"  border-color="#FFFFFF"></v-table>
		</view>
		<view class ="column-box viewborder" style="width: 700rpx; display: flex;" >
			<view style="width: 700rpx;">
				<view class="black-text" style="padding-left: 10rpx;">地区日票数及周同比变化</view>
			</view>
			<view style="width: 350rpx;">
				<view class="gray-text" style="text-align: right;padding-right: 0rpx;" @click="toAll1()">全部></view>
			</view>
		</view>
		<view class="table" style="width: 700rpx;margin-left: 30rpx;" >
			<v-table :columns="tableColumns1" :list="tableData1"  border-color="#FFFFFF"></v-table>
		</view>
		<view class ="column-box viewborder" style="width: 700rpx; display: flex;" >
			<view style="width: 350rpx;">
				<view class="black-text" style="padding-left: 10rpx;">地区门店情况</view>
			</view>
			<view style="width: 350rpx;">
				<view class="gray-text" style="text-align: right;padding-right: 0rpx;" @click="toAll2()">全部></view>
			</view>
		</view>
		<view class="table" style="width: 700rpx;margin-left: 30rpx;" >
			<v-table :columns="tableColumns2" :list="tableData2"  border-color="#FFFFFF"></v-table>
		</view>
		<view class ="column-box viewborder" style="width: 700rpx; display: flex;" >
			<view style="width: 350rpx;">
				<view class="black-text" style="padding-left: 10rpx;">地区返奖情况</view>
			</view>
			<view style="width: 350rpx;">
				<view class="gray-text" style="text-align: right;padding-right: 0rpx;" @click="toAll3()">全部></view>
			</view>
		</view>
		<view class="table" style="width: 700rpx;margin-left: 30rpx;" >
			<v-table :columns="tableColumns3" :list="tableData3"  border-color="#FFFFFF"></v-table>
		</view>
		<backTop :src="backTop.src"  :scrollTop="backTop.scrollTop"></backTop>
	</view>
</template>
<script>
	
	import vTable from "@/components/table/table.vue";
	import urlAPI from '@/common/vmeitime-http/';
	import backTop from '@/components/sads-components/back-top.vue';
	
	export default {
		components: {
			vTable,
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
				showModel:{},
				 btnnum: 0,
				 index: 0,
				 arcbarNumTop:'周同比',
				 tableData: [],
				 tableDataAll: [],
				 backTop: {
						src: '../../static/top.png',
						scrollTop: 0
				 },
				 scrollTop: 0,
				 tableColumns: [{
				 			title: "排名",
				 			key: "id",
				 			$width:"50px",
				 		},
				 		{
				 			title: '省份',
				 			key: 'area',
				 			$width:"80px"
				 		},
				 		{
				 			title: '销量(百万元)',
				 			key: 'xiaoliang',
				 			$width:"90px"
				 		},
				 		{
				 			title: '周同比变化(百万元)',
				 			key: 'rateChange',
				 			$width:"150px"
				 		}
				 	],
					tableData1: [],
					tableDataAll1: [],
					tableColumns1: [{
								title: "排名",
								key: "id",
								$width:"50px",
							},
							{
								title: '省份',
								key: 'area',
								$width:"80px"
							},
							{
								title: '票数(张)',
								key: 'piaoshu',
								$width:"90px"
							},
							{
								title: '周同比变化(张)',
								key: 'rateChange',
								$width:"150px"
							}
						],
					tableData2: [],
					tableDataAll2: [],
					tableColumns2: [{
								title: "排名",
								key: "id",
								$width:"50px",
							},
							{
								title: '省份',
								key: 'area',
								$width:"80px"
							},
							{
								title: '有销量门店数',
								key: 'notnonecount',
								$width:"90px"
							},
							{
								title: '"0"销量门店数',
								key: 'nonecount',
								$width:"150px"
							}
						],
					tableData3: [],
					tableDataAll3: [],
					tableColumns3: [{
								title: "排名",
								key: "id",
								$width:"50px",
							},
							{
								title: '省份',
								key: 'area',
								$width:"80px"
							},
							{
								title: '竞彩',
								key: 'jingcai',
								$width:"90px"
							},
							{
								title: '足球',
								key: 'football',
								$width:"50px"
							},
							{
								title: '篮球',
								key: 'basketball',
								$width:"90px"
							},
						],
				 }
		},
		methods: {
			changeTop(e){
				this.arcbarNumTop = e;;
				this.loadData();
				
			},
			loadData(){
				var that=this;
				
				//加载地区门店情况
				var url = 'pentaho/plugin/cda/api/doQuery17/1/1/1/1/1';
				urlAPI.getRequest(url, null).then((res)=>{
					this.loading = false;
					var data =res.data.concreteBean;	
					/* {"北京",15,46,0,5},
						{"河北",1,59,8,3},
						{"山西",12,25,3,3},
						{"山东",35,98,7,0},
						{"福建",16,59,9,1},
						{"江苏",58,68,1,3},
						{"新疆",99,75,0,1} 
					省份 有销量 有销量对比 0销量 0销量对比	
						*/
					for(var i=0;i<data[i].length;i++){
						var arr={
								id: i+1,
								area: data[i][0],
								notnonecount: data[i][1],
								nonecount: data[i][3]
							};
						that.tableDataAll2.push(arr);
						if(i<5){
							that.tableData2.push(arr);
						}
					}
					var arr1={id:1,
							area:'北京',
							jingcai:"竞彩",
							football:111,
							basketball:222
							};
					that.tableData3.push(arr1);
					var arr2={id:1,
							area:'北京',
							xiaoliang:599,
							rateChange:111,
							};
					that.tableData.push(arr2);
					var arr3={id:1,
							area:'北京',
							piaoshu:599,
							rateChange:111,
							};
					that.tableData1.push(arr3);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				
			},
			toAll(){
				var that =this;
				console.log(this.tableDataAll)
				uni.navigateTo({
					url:'/pages/common/tableDetail?col='+JSON.stringify(encodeURIComponent(that.tableColumns))+'&da='+JSON.stringify(encodeURIComponent(that.tableDataAll)),
					success: function(res) {
					    // 通过eventChannel向被打开页面传送数据
					    res.eventChannel.emit('heheh', 
												{ col: JSON.stringify(encodeURIComponent(that.tableColumns))},
												);
					}
				});
			},
			toAll1(){
				var that =this;
				console.log(this.tableDataAll1)
				uni.navigateTo({
					url:'/pages/common/tableDetail?col='+JSON.stringify(encodeURIComponent(that.tableColumns1))+'&da='+JSON.stringify(encodeURIComponent(that.tableDataAll1)),
					success: function(res) {
					    // 通过eventChannel向被打开页面传送数据
					    res.eventChannel.emit('heheh', 
												{ col: JSON.stringify(encodeURIComponent(that.tableColumns1))},
												);
					}
				});
				
			},
			toAll2(){
				var that =this;
				console.log(this.tableDataAll2)
				uni.navigateTo({
					url:'/pages/common/tableDetail?col='+JSON.stringify(encodeURIComponent(that.tableColumns2))+'&da='+JSON.stringify(encodeURIComponent(that.tableDataAll2)),
					success: function(res) {
					    // 通过eventChannel向被打开页面传送数据
					    res.eventChannel.emit('heheh', 
												{ col: JSON.stringify(encodeURIComponent(that.tableColumns2))},
												);
					}
				});
				
			},
			toAll3(){
				
				var that =this;
				console.log(this.tableDataAll3)
				uni.navigateTo({
					url:'/pages/common/tableDetail?col='+JSON.stringify(encodeURIComponent(that.tableColumns3))+'&da='+JSON.stringify(encodeURIComponent(that.tableDataAll3)),
					success: function(res) {
					    // 通过eventChannel向被打开页面传送数据
					    res.eventChannel.emit('heheh', 
												{ col: JSON.stringify(encodeURIComponent(that.tableColumns3))},
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
</style>
