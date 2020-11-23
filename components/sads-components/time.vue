<template>
	<view class="times" v-if="isTimeShow">
		<view class="timezhe" @click="closeTime"></view>
		<view class="timecontent">
			<view class="timetile">
				<text class="timeClose" @click="closeTime">取消</text>
				<text class="timeSelese">选择时间</text>
				<text class="timeSuccess" @click="oktime">确认</text>
			</view>
			<view class="timeCon">
				<view class="timeCons" @click="clickTimeTitle" data-id='0' :class="[timeIds===0?'activeTime':'']">年</view>
				<view class="timeCons" @click="clickTimeTitle" data-id='1' :class="[timeIds===1?'activeTime':'']">月</view>
				<view class="timeCons daytime" @click="clickTimeTitle" data-id='2' :class="[timeIds===2?'activeTime':'']">日</view>
			</view>
			<!--时间逻辑-->
			<view class="timeScroll">
				<picker-view indicator-style="height: 45px;" :style="{width:'100%',height:'100%'}" :value="value" @change="bindChange">
					<picker-view-column>
						<view v-for="(item,i) in years" :key="i" class="columns">{{item}}</view>
					</picker-view-column>
					<picker-view-column v-if="timeIds===1 || timeIds===2">
						<view v-for="(item,i) in months" :key="i" class="columns">{{item}}</view>
					</picker-view-column>
					<picker-view-column v-if="timeIds===2">
						<view v-for="(item,i) in days" :key="i"  class="columns">{{item}}</view>
					</picker-view-column>
				</picker-view>
			</view>
			<!--时间逻辑-->
		</view>
	</view>
</template>

<script>
	export default{
		props:{
			isTimeShow:{
				type:Boolean,
				default:false
			}
		},

		data(){
			return{
			    timeIds:2,
				years: [],//选择器年份范围
				year: '',//当前年份
				months: [],//选择器月份范围
				month: '',//当前月份（置于为什么+1，自行百度看原理）
				days:[],//选择器的天数范围
				day:[],//当前天数
				value: [],//选择器弹出的被动选项
				newmonth: '',
				newyear: '',
				newday:'',
			}
		},
		mounted(){
			this.huoTime();			
		},
		methods:{
			huoTime(){
				// 获取当前的年月
				const date = new Date();
				//滚动选择器的范围
				const years = []
				const months = []
				for (let i = 1990; i <= date.getFullYear(); i++) {
				  years.push(i)
				}
				for (let i = 1; i <= 12; i++) {
				  months.push(i)
				}
				/*计算这个月有多少天*/
                this.dayfull(date.getFullYear(),date.getMonth()+1,date.getDate())
				/*计算这个月有多少天*/
				this.year = date.getFullYear()
				this.month = date.getMonth()+1
				this.value = [9999, date.getMonth(),date.getDate()-1]
				this.newmonth = date.getMonth()+1
				this.years = years
				this.newyear = date.getFullYear()
				this.months = months
				/*默认将年月日传回给父组件*/
				this.$emit("monthTime",{
					year:date.getFullYear(),
					month:date.getMonth()+1,
					day:date.getDate()
				})
				/*默认将年月日传回给父组件*/
			},
			/*计算这个月有多少天*/
			dayfull(year,month,day){
				const days = []
				let dayAllThisMonth = 31;
				if (month != 12) {
				  let currentMonthStartDate = new Date(year + "/" + (month) + "/01"); // 本月1号的日期
				  let nextMonthStartDate = new Date(year + "/" + (month + 1) + "/01"); // 下个月1号的日期
				  dayAllThisMonth = (nextMonthStartDate - currentMonthStartDate) / (24 * 3600 * 1000);
				}
				for (let i = 1; i <= dayAllThisMonth; i++) {
				  days.push(i)
				}
				this.day = day
				this.days = days
			},
			/*计算这个月有多少天*/
			clickTimeTitle(e){
				let id = parseInt(e.currentTarget.dataset.id);
				switch (id){
					case 0:
					this.timeIds = 0;
					break;
					case 1:
					this.timeIds = 1;
					break;
					case 2:
					this.timeIds = 2;
					break;
					default:
					this.timeIds = 0;
					break;
				}
			},
			/*选择的时候*/
			bindChange(e){
				const val = e.detail.value
				this.newyear=this.years[val[0]]
				this.newmonth= this.months[val[1]]
				this.newday= this.days[val[2]]
				this.dayfull(this.years[val[0]],this.months[val[1]],this.days[val[2]])
			},
			/*选择的时候*/
			/*点击确定*/
			oktime(e){
				let that = this;
                let year = this.newyear;//选中的年
				let month = this.newmonth;//选中的月
				let day = this.newday;
				switch (this.timeIds){
					case 0:
					this.$emit("monthTime",{
						year:year,
						month:'',
						day:''
					})
					break;
					case 1:
					this.$emit("monthTime",{
						year:year,
						month:month,
						day:''
					})
					break;
					default:
					this.$emit("monthTime",{
						year:year,
						month:month,
						day:day
					})
					break;
				}
				this.$emit("isTimeHide")
			},
			/*点击确定*/
			closeTime(){
				this.$emit("isTimeHide")
			},
		}
	}
</script>

<style>
	.columns{

		display: flex;
		align-items: center;
		justify-content: center;
		font-size: 333rpx;
		font-size: 32rpx;
		font-weight: bold;
	}
	.timeScroll{
		width: 100%;
		height: 260rpx;
		margin-bottom:70rpx;
	}
	.activeTime{
		background: #B1CB30;
		color: #fff!important;
		border: 1px solid #B1CB30!important;
	}
	.daytime{
		border-left: none!important;
	}
	.timeCons:nth-child(1){
		border-top-left-radius: 10rpx;
		border-bottom-left-radius: 10rpx;
		border-right: none!important;
	}
	.timeCons:last-child{
		border-top-right-radius: 10rpx;
		border-bottom-right-radius: 10rpx;
	}
	.timeCons{
		width: 148rpx;
		height: 66rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		color: #333;
		font-size: 28rpx;
		font-weight: bold;
				border:1px solid #aaa;
	}
	.timeCon{
		width: 100%;
		height: 146rpx;
		display: flex;
		align-items: center;
		justify-content: center;
	}
	.timeSuccess{
		color: #B1CB30;
		font-size: 32rpx;
		margin-left: auto;
	}
	.timeSelese{
		color: #333333;
		font-size: 36rpx;
		font-weight: bold;
		display: block;
		margin: 0 auto;
		margin-left: 201rpx;
	}
	.timeClose{
		font-size: 32rpx;
		color: #666666;
	}
	.timetile{
		width: 690rpx;
		height: 98rpx;
		margin: 0 auto;
		border-bottom:1px solid #ececec;
		display: flex;
		align-items: center;
	}
	.timecontent{
		width: 100%;
		background: #fff;
		z-index: 99;
		position: absolute;
		left: 0;
		bottom: 0;
		min-height: 200rpx;
	}
	.timezhe{
		width: 100%;
		height: 100%;
		background: #000;
		opacity: 0.6;
		position: absolute;
		left: 0;
		top: 0;
		z-index: 9;
	}
	.times{
		width: 100%;
		height: 100vh;
		position: fixed;
		left: 0;
		top: 0;
		z-index: 999999999999;
	}
</style>
