<template>
    <view class="tabs">
		<view v-if="selfParam.provinceCenterId==0">
		   <scroll-view  id="tab-bar" class="scroll-h" :scroll-x="true" :show-scrollbar="false" :scroll-into-view="scrollInto">
				<view v-for="(tab,index) in tabBars" :key="tab.id" class="uni-tab-item" :id="tab.id" :data-current="index" @click="ontabtap">
					<text class="uni-tab-item-title" :class="tabIndex==index ? 'uni-tab-item-title-active' : ''">{{tab.name}}</text>
				</view>
			</scroll-view>
		</view>
		<view v-if="selfParam.provinceCenterId!=0">
		   <scroll-view  id="tab-bar" class="scroll-h" :scroll-x="true" :show-scrollbar="false" :scroll-into-view="scrollInto">
				<view v-for="(tab,index) in tabBars1" :key="tab.id" class="uni-tab-item1" :id="tab.id" :data-current="index" @click="ontabtap">
					<text class="uni-tab-item-title" :class="tabIndex==index ? 'uni-tab-item-title-active' : ''">{{tab.name}}</text>
				</view>
			</scroll-view>
		</view>
		 <view class="content">
			<view class="blackClass">
				<view @click="goArea">{{selfParam.provinceCenterName}}</view>
			</view>
			<view class="blackClass">
				<view @click="goDatePicker" class="list">{{selfParam.businessDate.view}}</view>
			</view>
		 </view>		
		<block v-if="tabIndex==0">
			<allView ref="allView"  :param="selfParam"></allView>
		</block>
		<block v-if="tabIndex==1">
			<matchView  ref="matchView" :param="selfParam"></matchView>
		</block>
		<block v-if="tabIndex==2">
			<salesView ref="salesView"  :param="selfParam"></salesView>
		</block>
		<block v-if="tabIndex==3">
			<channelView ref="channelView" :param="selfParam"></channelView>
		</block>
		<block v-if="tabIndex==4">
			<areaView  ref="areaView" :param="selfParam"></areaView>
		</block>
		<block v-if="tabIndex==5">
			<pondView ref="pondView" :param="selfParam"></pondView>
		</block>
    </view>
</template>
<script>
	import allView from "@/components/sads-components/reportView/allView.vue";
	import matchView from "@/components/sads-components/reportView/matchView.vue";
	import areaView from "@/components/sads-components/reportView/areaView.vue";
	import channelView from "@/components/sads-components/reportView/channelView.vue";
	import pondView from "@/components/sads-components/reportView/pondView.vue";
	import salesView from "@/components/sads-components/reportView/salesView.vue";
	import ticketView from "@/components/sads-components/ticketView/ticketView.vue";
	import dateUtils from '@/common/tools/dateUtils.js';
	import uniSection from "@/components/uni/uni-section/uni-section.vue"

    // 缓存每页最多
    const MAX_CACHE_DATA = 100;
    // 缓存页签数量
    const MAX_CACHE_PAGE = 3;

    export default {
        components: {
           allView,matchView,areaView,channelView,pondView,salesView,uniSection
        },
        data() {
            return {
				today:dateUtils.getYesterday(),
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
					selfProvinceCenterId:''//存登录时候的id
				},
				areaMap:{},
				isFirstLoad:true,
				modelSet:{
					area:'all', page:'totalView',gateNo:''
				},
                newsList: [],
                cacheTab: [],
                tabIndex: 0,
                tabBars: [{
							name: '总览',
							id: 'allView'
						}, {
							name: '赛事',
							id: 'match'
						}, {
							name: '销售',
							id: 'sales'
						}, {
							name: '渠道',
							id: 'channel'
						}, {
							name: '区域',
							id: 'area'
						}, {
							name: '奖池',
							id: 'reward'
						}],
				tabBars1: [{
							name: '总览',
							id: 'allView'
						}, {
							name: '赛事',
							id: 'match'
						}, {
							name: '销售',
							id: 'sales'
						}, {
							name: '渠道',
							id: 'channel'
						}, {
							name: '区域',
							id: 'area'
						}],
                scrollInto: "",
                showTips: false,
                navigateFlag: false,
                pulling: false,
                refreshIcon: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAB5QTFRFcHBw3Nzct7e39vb2ycnJioqK7e3tpqam29vb////D8oK7wAAAAp0Uk5T////////////ALLMLM8AAABxSURBVHja7JVBDoAgDASrjqj//7CJBi90iyYeOHTPMwmFZrHjYyyFYYUy1bwUZqtJIYVxhf1a6u0R7iUvWsCcrEtwJHp8MwMdvh2amHduiZD3rpWId9+BgPd7Cc2LIkPyqvlQvKxKBJ//Qwq/CacAAwDUv0a0YuKhzgAAAABJRU5ErkJggg==",
				showPicker: true,
				date: '2019/01/01',
				time: '15:00:12',
				datetime: '2019/01/01 15:00:12',
				range: ['2019/01/01','2019/01/06'],
				rangetime: ['2019/01/08 14:00','2019/01/16 13:59'],
				type: 'rangetime',
				value: ''
            }
        },
        onLoad() {
			this.returnFromDatePicker();
			if(this.selfParam.businessDate.date.startDate==dateUtils.getToday()){
				this.selfParam.businessDate.view =dateUtils.getYesterday();
				this.selfParam.businessDate.date.startDate =dateUtils.getYesterday();
			}
			this.refresh()
        },
		onShow() {
			this.returnFromDatePicker();
			if(this.selfParam.businessDate.date.startDate==dateUtils.getToday()){
				this.selfParam.businessDate.view =dateUtils.getYesterday();
				this.selfParam.businessDate.date.startDate =dateUtils.getYesterday();
			}
			this.refresh()
		},
		created() {
			this.returnFromDatePicker();
			if(this.selfParam.businessDate.date.startDate==dateUtils.getToday()){
				this.selfParam.businessDate.view =dateUtils.getYesterday();
				this.selfParam.businessDate.date.startDate =dateUtils.getYesterday();
			}
			this.refresh()
		},
        methods: {
			refresh(){
				if(this.tabIndex==0){
					this.$refs['allView'].refresh(JSON.stringify(this.selfParam));
				}else if(this.tabIndex==1){
					this.$refs['matchView'].refresh(JSON.stringify(this.selfParam));
				}else if(this.tabIndex==2){
					this.$refs['salesView'].refresh(JSON.stringify(this.selfParam));
				}else if(this.tabIndex==3){
					this.$refs['channelView'].refresh(JSON.stringify(this.selfParam));
				}else if(this.tabIndex==4){
					this.$refs['areaView'].refresh(JSON.stringify(this.selfParam));
				}else if(this.tabIndex==5){
					this.$refs['pondView'].refresh(JSON.stringify(this.selfParam));
				}
			},
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
				this.selfParam.token=getApp().globalData.token	
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
            goDetail(e) {
                if (this.navigateFlag) {
                    return;
                }
                this.navigateFlag = true;
                uni.navigateTo({
                    url: './detail/detail?title=' + e.title
                });
                setTimeout(() => {
                    this.navigateFlag = false;
                }, 200)
            },
            close(index1, index2) {
                uni.showModal({
                    content: '是否删除本条信息？',
                    success: (res) => {
                        if (res.confirm) {
                            this.newsList[index1].data.splice(index2, 1);
                        }
                    }
                })
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
                    //console.log("remove cache index:: " + cacheIndex);
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
			onShowDatePicker(type){//显示
				this.type = type;
				this.showPicker = true;
				this.value = this[type];
			},
			onSelected(e) {//选择
				this.showPicker = false;
				if(e) {
					this[this.type] = e.value; 
					//选择的值
					console.log('value => '+ e.value);
					//原始的Date对象
					console.log('date => ' + e.date);
				}
			},
			toggle(type) {
				this.type = type
				this.$refs.popup.open()
			},
			goCompare(){
				uni.navigateTo({
					url:"/pages/report/indexCompare?tabIndex="+this.tabIndex
				});
			},
			goArea(){
				uni.navigateTo({
					url:"/pages/common/areaSelector?area="+this.selfParam.provinceCenterId +'&areaName=' + this.selfParam.provinceCenterName
				});
			},
			goDatePicker() {
				console.log(111111);
				uni.navigateTo({
					url:"/pages/common/dateSelectorReport?type=common&date=" + this.selfParam.businessDate.date.startDate
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
        padding-left: 23rpx;
        padding-right: 23rpx;
    }
	.uni-tab-item1 {
			/* #ifndef APP-PLUS */
			display: inline-block;
			/* #endif */
			flex-wrap: nowrap;
			padding-left: 35rpx;
			padding-right: 35rpx;
		}
    .uni-tab-item-title {
        color: #555;
        font-size: 40rpx;
        height: 100rpx;
        line-height: 80rpx;
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

    .loading-more-text {
        font-size: 28rpx;
        color: #999;
    }
	
 	.datePick{
		text-align: center;
		padding: 10px 0;
	}
	
	.popup-content {
		background-color: #fff;
		padding: 15px;
		height: 500px;
	}
	.content {
		display: flex;
		align-items: center;
		justify-content: center;
		font-size: 32rpx;
		color: #333;
	}
	.section{
		background-color: #FFFFFF;
	}
	.blackClass{
		padding: 10px 10px;
	}

	</style>
