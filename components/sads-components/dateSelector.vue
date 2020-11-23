<template>
	<view>
		<view class="datePick">		
			<text @click="onShowDatePicker('date')">{{date}}</text>
<!-- 			<view>日期选择 - 示例</view>
			{{date}}
			<button type="primary" @click="onShowDatePicker('date')">选择日期</button>
			{{range[0]}} - {{range[1]}}
			<button type="primary" @click="onShowDatePicker('range')">选择日期范围</button> -->
			<!-- <mx-date-picker :show="showPicker" :type="type" :value="value" :show-tips="true" :begin-text="'入住'" :end-text="'离店'" @confirm="onSelected" @cancel="onSelected" /> -->
		</view>
		<view class="tab-content">
			<view class="tab-title">
				<view @tap="change(0)" :class="btnnum == 0?'btna':'hide'">日</view>
			　　<view @tap="change(1)" :class="btnnum == 1?'btna':'hide'">周</view>
			  　<view @tap="change(2)" :class="btnnum == 2?'btna':'hide'">月</view>
			    <view @tap="change(2)" :class="btnnum == 3?'btna':'hide'">年</view>
			</view>	
			
			<view class="end-cont" :class="{dis:btnnum == 0}">	
				<!-- <mx-date-picker :show="showPicker" :type="type" :value="value" :show-tips="true" :begin-text="'入住'" :end-text="'离店'" @confirm="onSelected" @cancel="onSelected" /> -->
			</view>
			<view class="end-cont" :class="{dis:btnnum == 1}">

			</view>
			<view class="end-cont" :class="{dis:btnnum == 2}">
				
			</view>
			<view class="end-cont" :class="{dis:btnnum == 3}">
				
			</view>
		</view>
		
	</view>	 
</template>

<script>
	import MxDatePicker from "@/components/mx-datepicker/mx-datepicker.vue";

	export default {	
		components: {
		    MxDatePicker
		},
		data() {
		    return {
				btnnum:0,
				showPicker: false,
				date: '2019/01',
				time: '15:00:12',
				datetime: '2019/01/01 15:00:12',
				range: ['2019/01/01','2019/01/06'],
				rangetime: ['2019/01/08 14:00','2019/01/16 13:59'],
				type: 'rangetime',
				dateOption: {},
				isShow: false,
			}
		},
		onLoad() {
			this.isShow = false;
			this.dateOption = uni.getStorageSync('dateOption');
			this.isShow = true;
		},
		
		methods: {
			changeDate(e) {
				//选择日期回调，选择完日期返回上一页面
				// 页面传值方式很多,vuex,storge等都可以实现
				console.log(e);
				uni.setStorageSync('dateObj', e); //在前一个页面onShow接受
				uni.navigateBack();
			}
			// change(e) {
			//     this.btnnum = e;
			//     console.log(this.btnnum);
			// },
			// onShowDatePicker(type){//显示
			// 	this.type = type;
			// 	this.showPicker = true;
			// 	this.value = this[type];
			// },
			// onSelected(e) {//选择
			// 	this.showPicker = false;
			// 	if(e) {
			// 		this[this.type] = e.value; 
			// 		//选择的值
			// 		console.log('value => '+ e.value);
			// 		//原始的Date对象
			// 		console.log('date => ' + e.date);
			// 	}
			// }			
		},
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
</style>
