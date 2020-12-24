<template>
	<view>
		<view class="tab-content">
			<view class="tab-title">
				<view @tap="change2(0)" :class="btnnum == 0?'btna':'hide'">日</view>
			</view>	
			
			<view class="end-cont" :class="{dis:btnnum == 0}">	
				<view class ="content">
					<uni-calendar class="uni-calendar--hook" :date="date" :selected="info.selected" :showMonth="true" @change="setDate" @monthSwitch="monthSwitch" />
				</view>
			</view>
<!-- 			<view class="end-cont" :class="{dis:btnnum == 1}">
				<view class ="content">
					<uni-calendar class="uni-calendar--hook" :range="true" :selected="info.selected" :showMonth="true" @change="change" @monthSwitch="monthSwitch" />
				</view>
			</view> -->
			<view class="end-cont" :class="{dis:btnnum == 2}">
				<view v-for="eachYear in months">     <!--:key 保证组件和数据捆绑唯一 -->
					<uni-section :title="eachYear.year" type="line"></uni-section>
					<view class="example-body" >
						<view v-for="eachMonth in eachYear.value">
							<view class="tag-view">
								<uni-tag  :text="eachMonth.name" :inverted="eachMonth.inverted" circle="true" type="primary" @click="setMonth(eachMonth.year, eachMonth.index)"/>
							</view>
						</view>
					</view>
				</view>			
			</view>
			<view class="end-cont" :class="{dis:btnnum == 3}">
				<view class="example-body" >
					<view v-for="each in years">     <!--:key 保证组件和数据捆绑唯一 -->
						<view class="tag-view">
							<uni-tag  :text="each.name" :inverted="each.inverted" circle="true" type="primary" @click="setYear(each.index)"/>
						</view>
					</view>
				</view>
			</view>
			<button class="button" @click="confirmDate()">确定</button>
		</view>
		
	</view>	 
</template>

<script>
	import uniCalendar from '@/components/uni/uni-calendar/uni-calendar.vue';
	import uniTag from "@/components/uni/uni-tag/uni-tag.vue"
	import uniSection from "@/components/uni/uni-section/uni-section.vue"
	import dateUtils from '@/common/tools/dateUtils.js';
	/**
	 * 获取任意时间
	 */
	function getDate(date, AddDayCount = 0) {
		if (!date) {
			date = new Date()
		}
		if (typeof date !== 'object') {
			date = date.replace(/-/g, '/')
		}
		const dd = new Date(date)
	
		dd.setDate(dd.getDate() + AddDayCount) // 获取AddDayCount天后的日期
	
		const y = dd.getFullYear()
		const m = dd.getMonth() + 1 < 10 ? '0' + (dd.getMonth() + 1) : dd.getMonth() + 1 // 获取当前月份的日期，不足10补0
		const d = dd.getDate() < 10 ? '0' + dd.getDate() : dd.getDate() // 获取当前几号，不足10补0
		return {
			fullDate: y + '-' + m + '-' + d,
			year: y,
			month: m,
			date: d,
			day: dd.getDay()
		}
	}
	
	function getDaysInOneMonth(year, month){
	    month = parseInt(month, 10);
	    var day= new Date(year, month, 0);  
	    return day.getDate();  
	}
		
	
	export default {	
		components: {
		    uniCalendar, uniTag, uniSection
		},
		data() {
		    return {							
				date:dateUtils.getToday(),
				type:'common',//common或者compare
				position:'',
				month:{year:'',month:''},
				week:{start:'',end:''},
				year:'',			
				dateInfo:{
					view:'',
					dateType:'date',
					date:{startDate:'', endDate:''},
					week:{startDate:'', endDate:''},
					month:{startDate:'', endDate:''},
					year:{startDate:'', endDate:''},
				},
				btnnum:0,
				dateOption: {},
				isShow: false,
				showCalendar: false,
				info: {
					lunar: true,
					range: true,
					insert: false,
					selected: []
				},
				selectTrue:true,
				selectFalse:false,
				monthList:['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'],
				years:[],
				months:[],
			}
		},
		onLoad(option) {
			this.date = option.date
			this.type = option.type
			this.position = option.position
			var date = getDate(new Date())
			var years = []
			var j = 0
			
			for(var i =2016;i<date.year+2;i++){
				var json = {index:j, name:i+"年", year:i, inverted:this.selectTrue}
				this.years[j++]=json
			}				
			
			for(var i =0;i<this.years.length;i++){
				j=0;
				var monthsValue= []	
				var json = {};
				for(var monthIndex=0; monthIndex<this.monthList.length; monthIndex++){
					json = {index:monthIndex, name:this.monthList[monthIndex], year:this.years[i].year, inverted:this.selectTrue, month:monthIndex+1}	
					monthsValue[j++] = json;
				}
				var key = {year:this.years[i].year, value:monthsValue}
				this.months[i]=key				
			}	
					
		},
		onReady() {
			this.$nextTick(() => {
				this.showCalendar = true
			})
			// TODO 模拟请求异步同步数据
			setTimeout(() => {
				this.info.date = getDate(new Date(), -30).fullDate
				this.info.startDate = getDate(new Date(), -60).fullDate
				this.info.endDate = getDate(new Date(), 30).fullDate
				this.info.selected = []
			}, 2000)
		},
		methods: {
			PrefixInteger(num, m) {
			      return (Array(m).join(0) + num).slice(-m);
			},
			setYear(index){		
				for(var i=0;i<this.years.length;i++){
					if(i!=index){
						if(!this.years[i].inverted){
							this.$set(this.years[i], 'inverted', this.selectTrue);
						}
					}else{
						if(!this.years[i].inverted){
							this.$set(this.years[i], 'inverted', this.selectTrue);
							this.year=''
						}else{
							this.$set(this.years[i], 'inverted', this.selectFalse);
							this.year=this.years[i].year
						}					
					}				
				}
				this.dateInfo.dateType='year'
				this.dateInfo.view = this.year
				this.dateInfo.year.startDate = this.year + '-01-01'
				this.dateInfo.year.endDate = this.year + '-12-31'
			},
			setMonth(yearIndex, monthIndex){
				console.log("yearIndex=",yearIndex, " monthIndex=",monthIndex)
				for(var i=0;i<this.months.length;i++){
					console.log("this.months[i].year=",this.months[i].year," yearIndex=",yearIndex,"flag=",this.months[i].year==yearIndex)
					
					if(this.months[i].year==yearIndex){
						for(var j=0;j<this.monthList.length;j++){
							console.log("i=",i," j=",j)
							if(j!=monthIndex){
								if(!this.months[i].value[j].inverted){
									this.$set(this.months[i].value[j], 'inverted', this.selectTrue);
								}
							}else{
								if(!this.months[i].value[j].inverted){
									this.$set(this.months[i].value[j], 'inverted', this.selectTrue);
									this.month.year=''
									this.month.month=''
								}else{
									this.$set(this.months[i].value[j], 'inverted', this.selectFalse);
									this.month.year=this.months[i].value[j].year
									this.month.month=this.months[i].value[j].month
								}							
							}		
						}
					}else{
						for(var j=0;j<this.monthList.length;j++){
							this.$set(this.months[i].value[j], 'inverted', this.selectTrue);	
						}
					}
				}
				
				
				var month =''
				if(this.month.month<10){
					month = '0'+this.month.month
				}else{
					month = this.month.month
				}
				this.dateInfo.dateType='month'
				this.dateInfo.view = this.month.year + '-' + month 
				this.dateInfo.month.startDate = this.month.year + '-' +  month + '-01'
				this.dateInfo.month.endDate = this.month.year + '-' +  month + '-' + getDaysInOneMonth(this.month.year,this.month.month)
				
				// console.log("this.month=",this.businessDate.view)
			},
			change2(e) {
			    this.btnnum = e;
			    console.log(this.btnnum);
			},
			open() {
				this.$refs.calendar.open()
			},
			close() {
				console.log('弹窗关闭');
			},
			changeRange(e){
				var start = e.range.before;
				var end = e.range.after;
				if(start!="" && end!=""){
					console.log('changeRange 返回:', e)
					this.date.date = start + "~~" + end;
				}

			},
			setDate(e){
				var fulldate = e.fulldate;
				var tDay = e.lunar.nWeek;
				
				this.dateInfo.dateType='date'
				this.dateInfo.view = fulldate 
				this.dateInfo.date.startDate = fulldate
				this.dateInfo.date.endDate = fulldate
			},
			change(e) {
				console.log('change 返回:', e)
				this.date.date = e.fulldate;
			},
			getNextDate(date, day) {  
				// console.log('date:', date,'day:',day);
				var dd = new Date(date);
				dd.setDate(dd.getDate() + day);
				var y = dd.getFullYear();
				var m = dd.getMonth() + 1 < 10 ? "0" + (dd.getMonth() + 1) : dd.getMonth() + 1;
				var d = dd.getDate() < 10 ? "0" + dd.getDate() : dd.getDate();
				return y + "-" + m + "-" + d;
			},
			monthSwitch(e) {
				console.log('monthSwitchs 返回:', e)
			},
			confirmDate(){	
				if(this.dateInfo==null || this.dateInfo.view==''){
					uni.navigateBack();
					return 
				}
				if(this.type=='common'){
					if(this.btnnum==0){
						uni.setStorageSync("dateType", "date");
					}else if(this.btnnum==1){
						uni.setStorageSync("dateType", "week");
					}else if(this.btnnum==2){
						uni.setStorageSync("dateType", "month");
					}else if(this.btnnum==3){
						uni.setStorageSync("dateType", "year");
					}
					uni.setStorageSync("businessDate", JSON.stringify(this.dateInfo));
				}else if(this.type=='compare'){
					if(this.btnnum==0){
						uni.setStorageSync("compareDateType", "date");
					}else if(this.btnnum==1){
						uni.setStorageSync("compareDateType", "week");
					}else if(this.btnnum==2){
						uni.setStorageSync("compareDateType", "month");
					}else if(this.btnnum==3){
						uni.setStorageSync("compareDateType", "year");
					}			
					if(this.position=='left'){
						uni.setStorageSync("leftBusinessDate", JSON.stringify(this.dateInfo));
					}else if(this.position=='right'){
						uni.setStorageSync("rightBusinessDate", JSON.stringify(this.dateInfo));
					}				
				}

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
	.button{
		margin-top: 150rpx;
		justify-content: center;
		background-color: #007AFF;
		color: #FFFFFF;
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
