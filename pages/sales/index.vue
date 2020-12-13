<template>

    <view class="tabs">
       <scroll-view id="tab-bar" class="scroll-h" :scroll-x="true" :show-scrollbar="false" :scroll-into-view="scrollInto">
            <view v-for="(tab,index) in tabBars" :key="tab.id" class="uni-tab-item" :id="tab.id" :data-current="index" @click="ontabtap">
                <text class="uni-tab-item-title" :class="tabIndex==index ? 'uni-tab-item-title-active' : ''">{{tab.name}}</text>
            </view>
        </scroll-view>
		<view class="content">
			<view @click="goArea">{{selfParam.provinceCenterName}}</view>
			<uni-section class="section" type="line"></uni-section>
			<view @click="goDatePicker" class="list">{{selfParam.businessDate.view}}</view>
			<uni-section class="section" type="line"></uni-section>
			<view @click="goCompare">对比</view>
		</view>	 
		<block v-if="tabIndex==0">
			<totalView class="page-css" ref="totalView" :param="selfParam"></totalView>
		</block>
		<block v-if="tabIndex==1">
			<gameView ref="gameView" :param="selfParam"></gameView>
		</block>
		<block v-if="tabIndex==2">
			<levelView ref="levelView" :param="selfParam"></levelView>
		</block>
		<block v-if="tabIndex==3">
			<ticketView ref="ticketView" :param="selfParam"></ticketView>
		</block>
		<block v-if="tabIndex==4">
			<matchView ref="matchView" :param="selfParam"></matchView>
		</block>
    </view>
</template>
<script>
    import mediaItem from './news-item.nvue';
	import MxDatePicker from "@/components/mx-datepicker/mx-datepicker.vue";
	import totalView from "@/components/sads-components/totalView/totalView.vue";
	import levelView from "@/components/sads-components/levelView/levelView.vue";
	import ticketView from "@/components/sads-components/ticketView/ticketView.vue";
	import gameView from "@/components/sads-components/gameView/gameView.vue";
	import matchView from "@/components/sads-components/matchView/matchView.vue";
	import dateSelector from "@/components/sads-components/dateSelector.vue";
	import dateUtils from '@/common/tools/dateUtils.js';
	import multiSeTime from '@/components/sads-components/time.vue'	
	import uniSection from "@/components/uni/uni-section/uni-section.vue"

    // 缓存每页最多
    const MAX_CACHE_DATA = 100;
    // 缓存页签数量
    const MAX_CACHE_PAGE = 3;

    export default {
        components: {
            mediaItem, MxDatePicker,
			totalView, levelView,
			ticketView, gameView,dateSelector,matchView,multiSeTime,uniSection
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
				areaMap:{},
				isFirstLoad:true,
                newsList: [],
                cacheTab: [],
                tabIndex: 0,
                tabBars: [{name: '总览',id: 'totalView'
                }, {name: '游戏',id: 'game'
                }, {name: '关次',id: 'gameLevel'
                }, {name: '票面',id: 'ticket'
                }, {name: '赛事',id: 'match'}],
                scrollInto: "",
                showTips: false,
                navigateFlag: false,
                pulling: false,
                refreshIcon: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAB5QTFRFcHBw3Nzct7e39vb2ycnJioqK7e3tpqam29vb////D8oK7wAAAAp0Uk5T////////////ALLMLM8AAABxSURBVHja7JVBDoAgDASrjqj//7CJBi90iyYeOHTPMwmFZrHjYyyFYYUy1bwUZqtJIYVxhf1a6u0R7iUvWsCcrEtwJHp8MwMdvh2amHduiZD3rpWId9+BgPd7Cc2LIkPyqvlQvKxKBJ//Qwq/CacAAwDUv0a0YuKhzgAAAABJRU5ErkJggg==",
				value: ''			
            }
        },
        onLoad() {
			this.returnFromDatePicker()	
			console.log("sales-self-onLoad:",this.selfParam)
			// commonFun.sleep(2000)
        },
		created(){
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			this.areaMap = JSON.parse(uni.getStorageSync("areaMap"))
			console.log('index-create this.areaMap:', this.areaMap)
			console.log("sales-self-created:", this.selfParam)
		},
		onShow() {//此处接受来自日期选择页面的参数
			this.returnFromDatePicker()
			console.log("sales-self-onShow:",this.selfParam)
			if(!this.isFirstLoad){
				console.log("重新加载")
				this.$refs['totalView'].refresh(JSON.stringify(this.selfParam));
			}
			this.isFirstLoad=false
		},
		onUnload() {
			//页面销毁删除缓存日期数据
			// uni.removeStorageSync("dateObj");
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
			},
			goCompare(){
				uni.navigateTo({
					url:"/pages/sales/indexCompare?tabIndex="+this.tabIndex + '&selfParam=' + JSON.stringify(this.selfParam)
				});			
			},
			goArea(){
				uni.navigateTo({
					url:"/pages/common/areaSelector?area="+this.selfParam.provinceCenterId
				});
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
			goDatePicker() {
				uni.navigateTo({
					url:"/pages/common/dateSelector?type=common&date=" + this.selfParam.businessDate.date.startDate
				});
			},
        }
    }
</script>

<style>
    /* #ifndef APP-PLUS */
  /*  page {
        width: 100%;
        min-height: 100%;
        display: flex;
    } */

    /* #endif */
	.page-css{
		width: 100%;
	}
	
    .tabs {
        /* flex: 1; */
		/* width: 100%; */
        flex-direction: column;
        overflow: hidden;
        background-color: #ffffff;
    }

    .scroll-h {
        width: 100%;
        height: 60rpx;
        flex-direction: row;
        /* #ifndef APP-PLUS */
        white-space: nowrap;
        /* #endif */
        /* flex-wrap: nowrap; */
        /* border-color: #cccccc;
		border-bottom-style: solid;
		border-bottom-width: 1px; */
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

    .loading-more-text {
        font-size: 28rpx;
        color: #999;
    }
	
 	.datePick{
		text-align: center;
		padding: 10px 0;
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
