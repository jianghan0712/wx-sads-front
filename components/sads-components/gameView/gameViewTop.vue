<template>
	<view>
		<view class="datePick">
			<text @click="onShowDatePicker('dateTime')" class="datetext" >{{date}}</text>
			<mx-date-picker :show="showPicker" :type="type" :value="value" :show-tips="true" :begin-text="'起始日期'" :end-text="'终止日期'" :show-seconds="true" @confirm="onSelected" @cancel="onSelected" />
			<button class="confirm-btn" @click="toCompare()" >对比</button>
		</view>
		<view style="text-align: center; font-size: 14rpx;">
			<text>1234567890</text>
			<br>
			<text>河北省石家庄市</text>
			<br>
		</view>
	</view>
	
</template>

<script>
	import MxDatePicker from '@/components/mx-datepicker/mx-datepicker.vue';
	
	export default {
		components: {
			MxDatePicker
		},
		data() {
			return {
				scrollInto: "",
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
				    url: './gameView/gameViewCompare?title='+JSON.stringify(encodeURIComponent('对比')),
					success: function(res) {
					    // 通过eventChannel向被打开页面传送数据
					    res.eventChannel.emit('hahahah', 
												{ type: 'compare' },
												);
					}
				}); 
			}
			
		}
	}
</script>

<style>
	page {
	    width: 100%;
	    min-height: 100%;
	    display: flex;
		background-color: #FFFFFF;
	}
	.datePick{
		text-align: center;
		padding: 0upx 5upx;
	}
	.datetext{
		font-size: 35rpx;
		background-color:  #ebebeb;
	}
	.confirm-btn{
		display: inline;
		background: #ebebeb;
		padding: 0 30upx;
		margin: 0;
		border-radius: 100px;
		height: 76upx;
		line-height: 76upx;
		font-size: $font-base + 2upx;
		background: $uni-color-primary;
		box-shadow: 1px 2px 5px rgba(217, 60, 93, 0.72)
	}
</style>
