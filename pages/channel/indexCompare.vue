<template>

    <view class="tabs">
       <scroll-view id="tab-bar" class="scroll-h" :scroll-x="true" :show-scrollbar="false" :scroll-into-view="scrollInto">
            <view v-for="(tab,index) in tabBars" :key="tab.id" class="uni-tab-item" :id="tab.id" :data-current="index" @click="ontabtap">
                <text class="uni-tab-item-title" :class="tabIndex==index ? 'uni-tab-item-title-active' : ''">{{tab.name}}</text>
            </view>
        </scroll-view>
	
		<view class="content">
				<view @click="goDatePicker" style="width: 400rpx;">{{selfParam.businessDate}}</view>
				<view @click="goDatePicker" style="width: 280rpx;">{{selfParam.businessDate}}</view>
				<view style="-webkit-flex: 1;flex: 1;" @click="returnBack()">取消</view>		
		</view>	 
		<block v-if="tabIndex==0">
			<totalViewCompareC ref="totalViewCompareC" :model="selfParam"></totalViewCompareC>
		</block>
		<block v-if="tabIndex==1">
			<gameViewCompareC ref="gameViewCompareC" :model="selfParam"></gameViewCompareC>
		</block>
		<block v-if="tabIndex==2">
			<levelViewCompareC ref="levelViewCompareC" :model="selfParam"></levelViewCompareC>
		</block>
		<block v-if="tabIndex==3">
			<ticketViewCompareC ref="ticketViewCompareC" :model="selfParam"></ticketViewCompareC>
		</block>
		<block v-if="tabIndex==4">
			<matchViewCompareC ref="matchViewCompareC" :model="selfParam"></matchViewCompareC>
		</block>
    </view>
</template>
<script>
	import MxDatePicker from "@/components/mx-datepicker/mx-datepicker.vue";
	import totalViewCompareC from "@/components/sads-components/totalView/totalViewCompareC.vue";
	import levelViewCompareC from "@/components/sads-components/levelView/levelViewCompareC.vue";
	import ticketViewCompareC from "@/components/sads-components/ticketView/ticketViewCompareC.vue";
	import gameViewCompareC from "@/components/sads-components/gameView/gameViewCompareC.vue";
	import matchViewCompareC from "@/components/sads-components/matchView/matchViewCompareC.vue";
	import dateSelector from "@/components/sads-components/dateSelector.vue";
	import dateUtils from '@/common/tools/dateUtils.js';
	import multiSeTime from '@/components/sads-components/time.vue'
	

    // 缓存每页最多
    const MAX_CACHE_DATA = 100;
    // 缓存页签数量
    const MAX_CACHE_PAGE = 3;

    export default {
        components: {
            MxDatePicker,
			totalViewCompareC, levelViewCompareC,
			ticketViewCompareC, gameViewCompareC,dateSelector,matchViewCompareC,multiSeTime
        },
        data() {
            return {
				selfParam:{ provinceCenterId:0,
							businessDate:dateUtils.getToday(),
							startDate:'',
							endDate:'',
							cityCenterId:1,
							userId:1141,
							countyCenterId:1
				},
				goodDatePickerOption3:'compare',
                newsList: [],
                cacheTab: [],
                tabIndex: 0,
                tabBars: [{name: '总览',id: 'totalViewCompareC'
                }, {name: '游戏',id: 'gameViewCompareC'
                }, {name: '关次',id: 'levelViewCompareC'
                }, {name: '票面',id: 'ticketViewCompareC'
                }, {name: '赛事',id: 'matchViewCompareC'}],
                scrollInto: "",
                showTips: false,
                navigateFlag: false,
                pulling: false,
                refreshIcon: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAB5QTFRFcHBw3Nzct7e39vb2ycnJioqK7e3tpqam29vb////D8oK7wAAAAp0Uk5T////////////ALLMLM8AAABxSURBVHja7JVBDoAgDASrjqj//7CJBi90iyYeOHTPMwmFZrHjYyyFYYUy1bwUZqtJIYVxhf1a6u0R7iUvWsCcrEtwJHp8MwMdvh2amHduiZD3rpWId9+BgPd7Cc2LIkPyqvlQvKxKBJ//Qwq/CacAAwDUv0a0YuKhzgAAAABJRU5ErkJggg==",
				value: ''			
            }
        },
        onLoad(option) {
			// const _dateObj=uni.getStorageSync("dateObj")
			this.tabIndex = option.tabIndex
			this.selfParam.businessDate = dateUtils.getToday();
			
			/* this.$refs['totalViewCompareC'].showView();
			this.$refs['gameViewCompareC'].showView();
			this.$refs['matchViewCompareC'].showView();
			this.$refs['levelViewCompareC'].showView();
			this.$refs['ticketViewCompareC'].showView(); */
        },
		onShow() {//此处接受来自日期选择页面的参数
		   this.returnFromDatePicker();
			const _dateObj=uni.getStorageSync("dateObj");			
			if(_dateObj){
				this.selfParam.businessDate = _dateObj.date; 
			}
			if(this.$refs['totalViewCompareC']!=null){
				this.$refs['totalViewCompareC'].refresh();
			}else if(this.$refs['gameViewCompareC']!=null){
				this.$refs['gameViewCompareC'].refresh();
			}else if(this.$refs['matchViewCompareC']!=null){
				this.$refs['matchViewCompareC'].refresh();
			}else if(this.$refs['levelViewCompareC']!=null){
				this.$refs['levelViewCompareC'].refresh();
			}else if(this.$refs['ticketViewCompareC']!=null){
				this.$refs['ticketViewCompareC'].refresh();
			}
		},
		onUnload() {
			//页面销毁删除缓存日期数据
			uni.removeStorageSync("dateObj");
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
				this.selfParam.token =getApp().globalData.token;
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
			onShowDatePicker(type){//显示
				// uni.navigateTo({
				// 	url:"/pages/common/dateSelector"
				// });
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
			returnBack(){
				uni.navigateBack({
					delta:1
				})
			},
			goDatePicker() {
				//跳转日期选择页面,同时传递日期初始化参数
				// 单选就传递单选参数，复选就传递复选参数
			    uni.setStorageSync("dateOption", this.goodDatePickerOption3);
				uni.navigateTo({
					url:"/pages/common/dateSelector"
				});
			},
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
		padding: 10px 0;
	}
	
	.popup-content {
		background-color: #fff;
		padding: 15px;
		height: 500px;
	}
	.content {
		width: 100%;
		display: flex;
		margin: 0rpx 10rpx 0rpx 10rpx;
		padding: 0 10rpx 0 10rpx;
		flex-direction: row;
		font-size: 30rpx;
		
/* 		display: flex;
		align-items: center;
		justify-content: center; 
		justify-content: space-between;
		font-size: 32rpx;
		color: #333;
		padding-top: 40rpx; */
	}
	</style>
