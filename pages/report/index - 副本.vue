<template>
	<view class="tabs">
		<scroll-view id="tab-bar" class="scroll-h" :scroll-Y="true" :show-scrollbar="false" :scroll-into-view="scrollInto" >
			<view v-for="(tab,index) in tabBars" :key="tab.id" class="uni-tab-item" :id="tab.id" :data-current="index" @click="ontabtap">
				<text class="uni-tab-item-title" :class="tabIndex==index ? 'uni-tab-item-title-active' : ''">{{tab.name}}</text>
			</view>
			
		</scroll-view>
		<block v-if="tabIndex==0">
			<view class="content">
					<scroll-view scroll-y="true" :scroll-into-view="intoindex" style="height: 300px;">
						<view v-for="(item,index) in content" :key='index' :id='"text"+index'>{{item+index}}</view>
					</scroll-view>
					<button type="primary" @tap="scroll">跳</button>
			</view>
			<text>{{tabIndex}}</text>
		</block>
		<block v-if="tabIndex==1">
			<text>{{tabIndex}}</text>
		</block>
		<block v-if="tabIndex==2">
			<text>{{tabIndex}}</text>
		</block>
		<block v-if="tabIndex==3">
			<text>{{tabIndex}}</text>
		</block>		
		<block v-if="tabIndex==4">
			<text>{{tabIndex}}</text>
		</block>
		<block v-if="tabIndex==5">
			<text>{{tabIndex}}</text>
		</block> 
	</view>
</template>

<script>
	import MxDatePicker from '@/components/mx-datepicker/mx-datepicker.vue';
	
	
	// 缓存每页最多
    const MAX_CACHE_DATA = 100;
    // 缓存页签数量
    const MAX_CACHE_PAGE = 3;

	export default {
		components: {
			
		},
		data() {
			return {
				newsList: [],
				cacheTab: [],
				tabIndex: 0,
				scrollInto: "",
				tabBars: [{
					name: '总览',
					id: 'totalView'
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
				value: '',
				content: ["珍珠奶茶", "鲜百香双响炮", "奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮", "奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮", "奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮",
					"奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮", "奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮", "奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮", "奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮",
					"奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮", "奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮", "奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮", "奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮",
					"奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮", "奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮", "奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮", "奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮",
					"奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮", "奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮", "奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮", "奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮",
					"奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮", "奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮", "奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮", "奶茶三兄弟", "珍珠奶茶", "鲜百香双响炮",
					"奶茶三兄弟"
				],
				intoindex: '',
				num:10 //动态模拟需要跳到的位置
			}
		},
		methods: {
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
			scroll() {
				this.num+=3
				this.$nextTick(()=> {
					this.intoindex = "text" + this.num
					console.log(this.intoindex)
				});
				this.intoindex=''  //不清空再次跳到锚点位置会不起作用
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
        font-size: 30rpx;
        height: 60rpx;
        line-height: 50rpx;
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
	
	.scroll-view-item {
		height: 300rpx;
		line-height: 300rpx;
		text-align: center;
		font-size: 36rpx;
	}
</style>