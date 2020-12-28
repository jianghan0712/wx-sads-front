<template>
	<view>
		<view class="tab-content">
			<view class="example-body" >
				<view v-for="each in areaList">     <!--:key 保证组件和数据捆绑唯一 -->
					<view class="tag-view">
						<uni-tag  :text="each.name" :inverted="each.inverted" circle="true" type="primary" @click="setArea(each.id)"/>
					</view>
				</view>
			</view>
			<button @click="confirmDate()">确定</button>
		</view>		
	</view>	 
</template>

<script>
	import uniCalendar from '@/components/uni/uni-calendar/uni-calendar.vue';
	import uniTag from "@/components/uni/uni-tag/uni-tag.vue"
	import uniSection from "@/components/uni/uni-section/uni-section.vue"
	
	export default {	
		components: {
		    uniCalendar, uniTag, uniSection
		},
		data() {
		    return {
				areaList:[],
				area:0,
				areaName:'',
				selectTrue:true,
				selectFalse:false,
			}
		},
		onLoad(option) {
			this.area = option.area; // 字符串转对象
			this.areaName = option.areaName;
			var selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			var list = JSON.parse(uni.getStorageSync("areaMap"))
			if(selfParam.selfProvinceCenterId!=0){ 
				list=[]
				var json = {id:this.area, name:this.areaName}
				list[0] = json
			}
			console.log('areaSelect list:',list);
			
			for(var i = 0;i<list.length;i++){    //遍历json对象的每个key/value对,p为key
				console.log(list[i])
				if(list[i].id==this.area){
					list[i].inverted = this.selectFalse
				}else{
					list[i].inverted = this.selectTrue
				}
				this.areaList[i] = list[i]
			}

			console.log('areaSelect:',this.areaList);
		},
		onReady() {

		},
		methods: {
			setArea(index){
				console.log('选择地区：',index)
				for(var i=0;i<this.areaList.length;i++){					
					if(this.areaList[i].id!=index){
						if(!this.areaList[i].inverted){
							this.$set(this.areaList[i], 'inverted', this.selectTrue);
						}
					}else{
						if(!this.areaList[i].inverted){
							this.$set(this.areaList[i], 'inverted', this.selectTrue);
						}else{
							this.$set(this.areaList[i], 'inverted', this.selectFalse);
							this.area=this.areaList[i].id
							this.areaName=this.areaList[i].name
						}						
					}				
				}
			},
			confirmDate(){	
				uni.setStorageSync("area", this.area);
				uni.setStorageSync("areaName", this.areaName);
				
				uni.navigateBack();
			}
		}
	}


</script>

<style>
	.tab-content{
		margin: 20rpx 10rpx 20rpx 10rpx;
		/* padding: 20rpx 10rpx 20rpx 10rpx; */
	}
	
	.tab-title{
		margin: 20rpx 10rpx 20rpx 10rpx;
		padding:0rpx 5rpx 0rpx 5rpx;
		flex-direction: row;
		display: flex;
		text-align: center;
		justify-content:center;
		font-size: 30rpx;
	}
	
	.end-cont{
		display: none;
		background: #FFFFFF;
	}
	.btna{
		color: #000000;
		background: #ebebeb;
		padding:0px 30rpx 0px 30rpx;
	}
	.dis{
		display: block;
	} 
	
	.hide{
		color: #000000;
		background: #FFFFFF;
		padding:0px 30rpx 0px 30rpx;
	}
	
	.content{
		display: flex;
		align-items: center;
		justify-content: center;
		font-size: 32rpx;
		color: #333;
		padding-top: 40rpx;
	}
	
	/* 头条小程序组件内不能引入字体 */
	/* #ifdef MP-TOUTIAO */
	@font-face {
		font-family: uniicons;
		font-weight: normal;
		font-style: normal;
		src: url('~@/static/uni.ttf') format('truetype');
	}
	
	/* #endif */
	
	/* #ifndef APP-NVUE */
	page {
		display: flex;
		flex-direction: column;
		box-sizing: border-box;
		background-color: #efeff4;
		min-height: 100%;
		height: auto;
	}
	
	view {
		font-size: 14px;
		line-height: inherit;
	}
	
	.example {
		padding: 0 15px 15px;
	}
	
	.example-info {
		padding: 15px;
		color: #3b4144;
		background: #ffffff;
	}
	
	.example-body {
		/* #ifndef APP-NVUE */
		display: flex;
		/* #endif */
		flex-direction: row;
		flex-wrap: wrap;
		justify-content: center;
		padding: 0;
		font-size: 14px;
		background-color: #ffffff;
	}
	
	/* #endif */
	.example {
		padding: 0 15px;
	}
	
	.example-info {
		/* #ifndef APP-NVUE */
		display: block;
		/* #endif */
		padding: 15px;
		color: #3b4144;
		background-color: #ffffff;
		font-size: 14px;
		line-height: 20px;
	}
	
	.example-info-text {
		font-size: 14px;
		line-height: 20px;
		color: #3b4144;
	}
	
	
	.example-body {
		flex-direction: column;
		padding: 15px;
		background-color: #ffffff;
	}
	
	.word-btn-white {
		font-size: 18px;
		color: #FFFFFF;
	}
	
	.word-btn {
		/* #ifndef APP-NVUE */
		display: flex;
		/* #endif */
		flex-direction: row;
		align-items: center;
		justify-content: center;
		border-radius: 6px;
		height: 48px;
		margin: 15px;
		background-color: #007AFF;
	}
	
	.word-btn--hover {
		background-color: #4ca2ff;
	}
	
	.example-body {
		/* #ifndef APP-NVUE */
		display: flex;
		/* #endif */
		flex-direction: row;
	}
	
	.calendar-button {
		flex: 1;
		font-weight: bold;
		font-size: 32rpx;
	}
	.tag-view {
		/* #ifndef APP-PLUS-NVUE */
		display: flex;
		/* #endif */
		flex-direction: column;
		margin: 10rpx 15rpx;
		justify-content: center;
	}
</style>
