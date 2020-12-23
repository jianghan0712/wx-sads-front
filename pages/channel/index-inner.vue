<template>
	<view class="box-contaniner">
	<view class="tab">
		<scroll-view id="tab-bar" class="scroll-h" :scroll-x="true" :show-scrollbar="false" :scroll-into-view="scrollInto">
			<view v-for="(tab,index) in tabBars" :key="tab.id" class="uni-tab-item" :id="tab.id" :data-current="index" @click="ontabtap">
				<text class="uni-tab-item-title" :class="tabIndex==index ? 'uni-tab-item-title-active' : ''">{{tab.name}}</text>
			</view>
		</scroll-view>
		<view class="content">
			<view class="blackClass">
				<view @click="goDatePicker" class="list">{{selfParam.businessDate.view}}</view>
			</view>
			<!-- <view class="blackClass">
				<view @click="goCompare">对比</view>
			</view> -->
		</view>	
		<view style="text-align: center;font-size: 50rpx; width: 100%;padding-bottom: 20rpx;color: blue;">
			<image style="width: 50rpx;height: 40rpx;padding-right: 20rpx;" src="../../static/left.png" mode="aspectFill">
			{{selfParam.shopNo}}
			<image style="width: 50rpx;height: 40rpx;padding-left: 20rpx;" src="../../static/right.png" mode="aspectFill">
		</view>	
		<view style="text-align: center;font-size: 50rpx; width: 100%;padding-bottom: 20rpx;color:#6D6D72;">
			{{showPro}}
		</view>	
		<block v-if="tabIndex==0">
			<channelTotalView ref="channelTotalView" :param="selfParam"></channelTotalView>
		</block>
		<block v-if="tabIndex==1">
			<channelGameView ref="channelGameView" :param="selfParam"></channelGameView>
		</block>
		<block v-if="tabIndex==2">
			<channelLevelView ref="channelLevelView" :param="selfParam"></channelLevelView>
		</block>
		<block v-if="tabIndex==3">
			<channelTicketView ref="channelTicketView" :param="selfParam"></channelTicketView>
		</block>
		<block v-if="tabIndex==4">
			<channelMatchView ref="channelMatchView" :param="selfParam"></channelMatchView>
		</block>
	</view>
	</view>
</template>

<script>
	import channelGameView from "@/components/sads-components/gameView/channelGameView.vue";	
	import channelTotalView from "@/components/sads-components/totalView/channelTotalView.vue";
	import channelLevelView from "@/components/sads-components/levelView/channelLevelView.vue";
	import channelTicketView from "@/components/sads-components/ticketView/channelTicketView.vue";
	import channelMatchView from "@/components/sads-components/matchView/channelMatchView.vue";
	import uniSection from "@/components/uni/uni-section/uni-section.vue"
	import urlAPI from '@/common/vmeitime-http/';
	
	// 缓存每页最多
    const MAX_CACHE_DATA = 100;
    // 缓存页签数量
    const MAX_CACHE_PAGE = 3;

	export default {
		components: {
			channelGameView,channelTotalView,channelLevelView,channelTicketView,channelMatchView,uniSection 
		},
		onLoad(option){//opthin为object类型，会序列化上页面传递的参数
			this.selfParam.shopNo = uni.getStorageSync("shopNo")
			this.returnFromDatePicker();
			this.loadMainData();
		},
		onShow() {//此处接受来自日期选择页面的参数
			this.returnFromDatePicker();
			console.log("sales-self-onShow:",this.selfParam)
			this.selfParam.shopNo = uni.getStorageSync("shopNo")
			this.loadMainData();
			if(!this.isFirstLoad){
				console.log("重新加载")
				if(this.tabIndex==0){
					this.$refs['channelTotalView'].refresh(JSON.stringify(this.selfParam));
				}else if(this.tabIndex==1){
					this.$refs['channelGameView'].refresh(JSON.stringify(this.selfParam));
				}else if(this.tabIndex==2){
					this.$refs['channelLevelView'].refresh(JSON.stringify(this.selfParam));
				}else if(this.tabIndex==3){
					this.$refs['channelTicketView'].refresh(JSON.stringify(this.selfParam));
				}else if(this.tabIndex==4){
					this.$refs['channelMatchView'].refresh(JSON.stringify(this.selfParam));
				}
				
			}
			this.isFirstLoad=false
		},
		created() {
			this.selfParam.shopNo = uni.getStorageSync("shopNo")
			this.returnFromDatePicker();
			this.loadMainData();
		},
		data() {
			return {
				selfParam:{
					token:'',
					provinceCenterId:'0',//当前查看的省份，如果之前是全国，这里可能会变动
					cityCenterId:'',
					provinceCenterName:'全国',
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
					selfProvinceCenterId:'',//存登录时候的id
					shopNo:''
				},
				gateInfo:{},
				areaMap:{},
				isFirstLoad:true,
				modelSet:{
					area:'hubei', page:'gameView',gateNo:'12545'
				},
				newsList: [],
				cacheTab: [],
				tabIndex: 0,
				scrollInto: "",
				showPro:"",//展示省市
				tabBars: [{
					name: '总览',
					id: 'totalView'
				}, {
					name: '游戏',
					id: 'gameView'
				}, {
					name: '关次',
					id: 'gameLevel'
				}, {
					name: '票面',
					id: 'ticket'
				}, {
					name: '赛制',
					id: 'match'
				}],
				navigateFlag: false,
				pulling: false,
				refreshIcon: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAB5QTFRFcHBw3Nzct7e39vb2ycnJioqK7e3tpqam29vb////D8oK7wAAAAp0Uk5T////////////ALLMLM8AAABxSURBVHja7JVBDoAgDASrjqj//7CJBi90iyYeOHTPMwmFZrHjYyyFYYUy1bwUZqtJIYVxhf1a6u0R7iUvWsCcrEtwJHp8MwMdvh2amHduiZD3rpWId9+BgPd7Cc2LIkPyqvlQvKxKBJ//Qwq/CacAAwDUv0a0YuKhzgAAAABJRU5ErkJggg==",
				showPicker: false,
				date: '2019/01/01',
				time: '15:00:12',
				datetime: '2019/01/01 15:00:12',
				range: ['2019/01/01','2019/01/06'],
				rangetime: ['2019/01/08 14:00','2019/01/16 13:59'],
				type: 'rangetime',
				value: ''
				
			}
		},
		methods: {
			returnFromDatePicker(){
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				const dateType = uni.getStorageSync("dateType")
				const bussinessDate = JSON.parse(uni.getStorageSync("businessDate"))
				this.selfParam.businessDate = bussinessDate;
				console.log('returnFromDatePicker:dateType=',this.selfParam.businessDate)	
						
				const area = uni.getStorageSync("area")
				const areaName = uni.getStorageSync("areaName")
				console.log('returnFromDatePicker:area=',area,', areaName=',areaName)					
				this.selfParam.provinceCenterId=area
				this.selfParam.provinceCenterName=areaName		
				this.selfParam.shopNo = uni.getStorageSync("shopNo")
				uni.setStorageSync("selfParam",JSON.stringify(this.selfParam))
			},
			getList(index) {
				let activeTab = this.newsList[index];
				let list = [];
				for (let i = 1; i <= 10; i++) {
					let item = Object.assign({}, newsData['data' + Math.floor(Math.random() * 5)]);
					item.id = this.newGuid();
					list.push(item);
				}
				activeTab.data = activeTab.data.concat(list);
			},
			loadMainData(){
				var url = '/pentaho/shows/getProvincialCityName';
				var param = {}
				param.showNumber =uni.getStorageSync("shopNo");
				param.token=this.selfParam.token
				//修改为0
				urlAPI.getRequest(url, param).then((res)=>{
					var data = res.data.data;
					this.showPro=data.provincial+data.city
					this.gateInfo = {
						showName:data.showName,provincial:data.provincial,city:data.city,provincialId:data.provincialId,cityId:data.cityId
					}
					uni.setStorageSync("gateInfo",JSON.stringify(this.gateInfo))
				}).catch((err)=>{
					
				});
				
			},
			loadMore(e) {
				setTimeout(() => {
					this.getList(this.tabIndex);
				}, 500)
			},
			ontabtap(e) {
				let index = e.target.dataset.current || e.currentTarget.dataset.current;
				this.switchTab(index);
			},
			ontabchange(e) {
				let index = e.target.current || e.detail.current;
				this.switchTab(index);
			},
			switchTab(index) {
				if (this.tabIndex === index) {
					return;
				}

				this.tabIndex = index;
				this.scrollInto = this.tabBars[index].id;

				// 释放 tabId
				if (this.cacheTab.length > MAX_CACHE_PAGE) {
					let cacheIndex = this.cacheTab[0];
					this.clearTabData(cacheIndex);
					this.cacheTab.splice(0, 1);
				}
			},
			clearTabData(e) {
				this.newsList[e].data.length = 0;
				this.newsList[e].loadingText = "加载更多...";
			},
			refreshData() {},
			onrefresh(e) {
				var tab = this.newsList[this.tabIndex];
				if (!tab.refreshFlag) {
					return;
				}
				tab.refreshing = true;
				tab.refreshText = "正在刷新...";

				setTimeout(() => {
					this.refreshData();
					this.pulling = true;
					tab.refreshing = false;
					tab.refreshFlag = false;
					tab.refreshText = "已刷新";
					setTimeout(() => { // TODO fix ios和Android 动画时间相反问题
						this.pulling = false;
					}, 500);
				}, 2000);
			},
			onpullingdown(e) {
				var tab = this.newsList[this.tabIndex];
				if (tab.refreshing || this.pulling) {
					return;
				}
				if (Math.abs(e.pullingDistance) > Math.abs(e.viewHeight)) {
					tab.refreshFlag = true;
					tab.refreshText = "释放立即刷新";
				} else {
					tab.refreshFlag = false;
					tab.refreshText = "下拉可以刷新";
				}
			},
			newGuid() {
				let s4 = function() {
					return (65536 * (1 + Math.random()) | 0).toString(16).substring(1);
				}
				return (s4() + s4() + "-" + s4() + "-4" + s4().substr(0, 3) + "-" + s4() + "-" + s4() + s4() + s4()).toUpperCase();
			},
			toAll(){
				uni.navigateTo({
				    url: './gameView/gameViewAllcccc'
				});
			},
			onShowDatePicker(type) { //显示
				this.type = type;
				this.showPicker = true;
				this.value = this[type];
			},
			onSelected(e) {//选择
				this.showPicker = false;
				if(e) {
					this[this.type] = e.value; 
					this.date=e.value;
				}
			},
			toCompare(){
				uni.navigateTo({
				    url: './gameView/gameViewCompare?id='+1
				}); 
			},
			goCompare(){
				uni.navigateTo({
					url:"/pages/channel/indexCompare?tabIndex="+this.tabIndex
				});
			},
			goArea(){
				uni.navigateTo({
					url:"/pages/common/areaSelector?area="+this.selfParam.provinceCenterId
				});
			},
			goDatePicker() {
				uni.navigateTo({
					url:"/pages/common/dateSelector?type=common&date=" + this.selfParam.businessDate.date.startDate
				});
			}
			
		}
	}
</script>

<style>
 /* #ifndef APP-PLUS */
    page {
        width: 100%;
        min-height: 100%;
        display: flex;
    }

    /* #endif */

    .tabs {
        flex: 1;
		width: 100%;
        flex-direction: column;
        overflow: hidden;
        background-color: #ffffff;
        /* #ifdef MP-ALIPAY || MP-BAIDU */
        height: 100vh;
        /* #endif */
    }

    .scroll-h {
        width: 100%;
        height: 100rpx;
        flex-direction: row;
        /* #ifndef APP-PLUS */
        white-space: nowrap;
        /* #endif */
        /* flex-wrap: nowrap; */
        /* border-color: #cccccc;
		border-bottom-style: solid;
		border-bottom-width: 1px; */
    }

    .line-h {
        height: 1rpx;
        background-color: #cccccc;
    }

    .uni-tab-item {
        /* #ifndef APP-PLUS */
        display: inline-block;
        /* #endif */
        flex-wrap: nowrap;
        padding-left: 34rpx;
        padding-right: 34rpx;
    }

    .uni-tab-item-title {
        color: #555;
        font-size: 40rpx;
        height: 100rpx;
        line-height: 60rpx;
        flex-wrap: nowrap;
        /* #ifndef APP-PLUS */
        white-space: nowrap;
        /* #endif */
    }

    .uni-tab-item-title-active {
        color: #007AFF;
    }

    .swiper-box {
        flex: 1;
    }

    .swiper-item {
        flex: 1;
        flex-direction: row;
    }

    .scroll-v {
        flex: 1;
        /* #ifndef MP-ALIPAY */
        flex-direction: column;
        /* #endif */
        width: 750rpx;
    }

    .update-tips {
        position: absolute;
        left: 0;
        top: 41px;
        right: 0;
        padding-top: 5px;
        padding-bottom: 5px;
        background-color: #FDDD9B;
        align-items: center;
        justify-content: center;
        text-align: center;
    }

    .update-tips-text {
        font-size: 14px;
        color: #ffffff;
    }

    .refresh {
        width: 750rpx;
        height: 64px;
        justify-content: center;
    }

    .refresh-view {
        flex-direction: row;
        flex-wrap: nowrap;
        align-items: center;
        justify-content: center;
    }

	.refresh-icon {
		width: 30px;
		height: 30px;
		transition-duration: .5s;
		transition-property: transform;
		transform: rotate(0deg);
		transform-origin: 15px 15px;
	}

	.refresh-icon-active {
		transform: rotate(180deg);
	}

	.loading-icon {
		width: 20px;
		height: 20px;
		margin-right: 5px;
		color: #999999;
	}

    .loading-text {
        margin-left: 2px;
        font-size: 16px;
        color: #999999;
    }

    .loading-more {
        align-items: center;
        justify-content: center;
        padding-top: 10px;
        padding-bottom: 10px;
        text-align: center;
    }

    .loading-more-text {
        font-size: 28rpx;
        color: #999;
    }
	
 	.datePick{
		text-align: center;
		padding: 0upx 5upx;
	}
	
	.confirm-btn{
		display: inline;
		padding: 30 38upx;
		margin-left: 20rpx;
		border-radius: 100px;
		height: 60upx;
		line-height: 60upx;
		font-size: $font-base + 2upx;
		background: $uni-color-primary;
		box-shadow: 1px 2px 5px rgba(217, 60, 93, 0.72)
	}
	.content {
		display: flex;
		align-items: center;
		justify-content: center;
		font-size: 32rpx;
		color: #333;
		/* padding-top: 40rpx; */
	}
	.section{
		background-color: #FFFFFF;
	}
	.box-contaniner{
		width: 100%;
		margin: 20rpx 10rpx 40rpx 10rpx;
	}
	.blackClass{
		padding: 10px 10px;
	}
	
</style>