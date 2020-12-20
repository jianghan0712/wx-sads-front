<template>
	<view>
		<view class="box-contaniner1">
			<view class="tab-content">
				<view class="end-title">
				　　<view @tap="change(0)" :class="btnnum == 0?'btna':'hide'">足球</view>
				  　<view @tap="change(1)" :class="btnnum == 1?'btna':'hide'">篮球</view>
				</view>	
				<view class="end-cont" :class="{dis:btnnum == 0}">	
					<view style="font-size: 30rpx;font-weight: bold;">足球关次销量及占比</view>				
					<view class="ring_chart">
						<ring-chart :dataAs="arcbar1" ref="levelRingChart1" canvasId="index_ring_1"/>
					</view>
					<view class="ring_chart">
						<ring-chart :dataAs="arcbar11" ref="levelRingChart11" canvasId="index_ring_11"/>
					</view>
				</view>
				<view class="end-cont" :class="{dis:btnnum == 1}">
					<view style="font-size: 30rpx;font-weight: bold;">足球关次销量及占比</view>				
					<view class="ring_chart">
						<ring-chart :dataAs="arcbar2" ref="levelRingChart2" canvasId="index_ring_2"/>
					</view>
					<view class="ring_chart">
						<ring-chart :dataAs="arcbar22" ref="levelRingChart22" canvasId="index_ring_22"/>
					</view>
				</view>
				<button type="default" plain="true" @click="gotoALL(btnnum)">查看全部</button>
			</view>
			<view class="tab-content">
					<!-- 列表 -->
			</view>
		</view>
	</view>
</template>

<script>
	import RingChart from "@/components/basic-chart/RingChart.vue";
	import vTable from "@/components/table/table.vue";
	import urlAPI from '@/common/vmeitime-http/';
	import numberFun from '@/common/tools/number.js';
	import PieChart from '@/components/basic-chart/PieChart.vue';
	
	export default {
		components: {
			RingChart,
			vTable,
			PieChart
		},
		props: {
			model:{
				//数据
				type: Object,
				default: () => ({})
			}
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
				btnnum: 0,
				index: 0,
				levelList:['单关','2x1','3x1','4x1-8x1','MXN','自有过关'],
				arcbar2: {
						type: 'radar',
						series:[
								{name: '胜平负',data: 100},
								 {name: '半全场胜平负',data: 30},
								 {name: '让球胜平负',data: 50},
						],
						extra: {
							pie: {
								lableWidth: 15,
								ringWidth: 10, //圆环的宽度
								offsetAngle: 0 //圆环的角度
							}
						}
				},
				arcbar22: {
						type: 'radar',
						series:[
								{name: '胜平负',data: 100},
								 {name: '半全场胜平负',data: 30},
								 {name: '让球胜平负',data: 50},
						],
						extra: {
							pie: {
								lableWidth: 15,
								ringWidth: 10, //圆环的宽度
								offsetAngle: 0 //圆环的角度
							}
						}
				},
				arcbar1: {
						type: 'radar',
						series:[
								{name: '胜平负',data: 100},
								 {name: '半全场胜平负',data: 30},
								 {name: '让球胜平负',data: 50},
						],
						extra: {
							pie: {
								lableWidth: 15,
								ringWidth: 10, //圆环的宽度
								offsetAngle: 0 //圆环的角度
							}
						}
				},
				arcbar11: {
							type: 'radar',
							series:[
									{name: '胜平负',data: 100},
									 {name: '半全场胜平负',data: 30},
									 {name: '让球胜平负',data: 50},
							],
							extra: {
								pie: {
									lableWidth: 15,
									ringWidth: 10, //圆环的宽度
									offsetAngle: 0 //圆环的角度
								}
							}
				},
				leftTableData: [{
							id: "1",
							area: "北京市",						
							amount: "10233.5"
						},
						{
							id: "2",
							area: "上海市",
							amount: "9965.5"
						},
						{
							id: "3",
							area: "广东省",
							amount: "9754.5"
						},
						{
							id: "4",
							area: "重庆市",
							amount: "6745.6"
						},
						{
							id: "5",
							area: "河北省",
							amount: "6554"
						}
					],
				rightTableData: [{
							id: "1",
							amount: "10233.5"
						},
						{
							id: "2",
							amount: "9965.5"
						},
						{
							id: "3",
							amount: "9754.5"
						},
						{
							id: "4",
							amount: "6745.6"
						},
						{
							id: "5",
							amount: "6554"
						}
					],
				leftTableColumns: [
					{
						title: '省份',
						key: 'area',
						$width:"100px"
					},{
						title: "排名",
						key: "id",
						$width:"50px",
					},{
						title: '销量',
						key: 'amount',
						$width:"100px"
					}],
				rightTableColumns: [{
							title: "排名",
							key: "id",
							$width:"50px",
						},
						{
							title: '销量',
							key: 'amount',
							$width:"80px"
						}
					],	
				array: [{name:'单关'},{name: '2X1'}, {name:'3X1'}, {name:'4X1-8X1'}, {name:'MXN'}, {name:'自由过关'}],
			};
		},
		onLoad() {
			_self = this;
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			this.returnFromDatePicker();
			this.getServerData();
			this.showView();
			this.refresh()
		},
		onShow() {
			_self = this;
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			this.returnFromDatePicker();
			this.getServerData();
			this.showView()
			this.refresh()
		},
		created() {
			_self = this;
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			this.returnFromDatePicker();
			this.getServerData();
			this.showView()
			this.refresh()
		},
		methods: {
			refresh(selfParam){
				this.selfParam.token = uni.getStorageSync("token")
				this.returnFromDatePicker();
				this.getServerData();
				this.showView();
			},
			createParam(){
				console.log("createParam begin")
				var dateType = this.selfParam.compareDate.dateType
				var param = {}
				if(dateType=='date'){
					param = {dateTimeStart: this.selfParam.compareDate.dateLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.dateLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.dateRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.dateRight.endDate,
							 dateFlag:1,
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}else if(dateType=='week'){
					param = {dateTimeStart: this.selfParam.compareDate.weekLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.weekLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.weekRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.weekRight.endDate,
							 dateFlag:2,
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}else if(dateType=='month'){
					param = {dateTimeStart: this.selfParam.compareDate.monthLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.monthLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.monthRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.monthRight.endDate,
							 dateFlag:3,
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}else if(dateType=='year'){
					param = {dateTimeStart: this.selfParam.compareDate.yearLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.monthLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.monthRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.monthRight.endDate,
							 dateFlag:4,
							 showNumber:this.selfParam.shopNo,
							 token:this.selfParam.token }
				}
				param.token=getApp().globalData.token;
				console.log("createParam end:",param)
				return param
			},
			returnFromDatePicker(){
				const dateType = uni.getStorageSync("compareDateType")
				const leftDate = JSON.parse(uni.getStorageSync("leftBusinessDate"))
				const rightDate = JSON.parse(uni.getStorageSync("rightBusinessDate"))
				console.log("dateType:",dateType)
				console.log("leftDate:",leftDate)
				console.log("rightDate:",rightDate)
				
				if(leftDate==null || rightDate==null){
					return
				}
				
				if(leftDate.dateType!=dateType || rightDate.dateType!=dateType){
					console.log("dateType不匹配:")
					const compareDate={
							dateType:dateType,
							viewLeft:leftDate.view,//用于展示日期、年、月等
							viewRight:rightDate.view,
							dateLeft:{startDate:leftDate.date.startDate, endDate:leftDate.date.endDate},
							dateRight:{startDate:rightDate.date.startDate, endDate:rightDate.date.endDate},
							weekLeft:{startDate:leftDate.week.startDate, endDate:leftDate.week.endDate},
							weekRight:{startDate:rightDate.week.startDate, endDate:rightDate.week.endDate},
							monthLeft:{startDate:leftDate.month.startDate, endDate:leftDate.month.endDate},
							monthRight:{startDate:rightDate.month.startDate, endDate:rightDate.month.endDate},
							yearLeft:{startDate:leftDate.year.startDate, endDate:leftDate.year.endDate},
							yearRight:{startDate:rightDate.year.startDate, endDate:rightDate.year.endDate},
						}
					this.selfParam.compareDate=compareDate
					return
				}
				console.log("leftDate:",leftDate)
				const compareDate={
						dateType:dateType,
						viewLeft:leftDate.view,//用于展示日期、年、月等
						viewRight:rightDate.view,
						dateLeft:{startDate:leftDate.date.startDate, endDate:leftDate.date.endDate},
						dateRight:{startDate:rightDate.date.startDate, endDate:rightDate.date.endDate},
						weekLeft:{startDate:leftDate.week.startDate, endDate:leftDate.week.endDate},
						weekRight:{startDate:rightDate.week.startDate, endDate:rightDate.week.endDate},
						monthLeft:{startDate:leftDate.month.startDate, endDate:leftDate.month.endDate},
						monthRight:{startDate:rightDate.month.startDate, endDate:rightDate.month.endDate},
						yearLeft:{startDate:leftDate.year.startDate, endDate:leftDate.year.endDate},
						yearRight:{startDate:rightDate.year.startDate, endDate:rightDate.year.endDate},
					}
				this.selfParam.compareDate=compareDate
				console.log("compareDate:",compareDate)
				const bussinessDate = JSON.parse(uni.getStorageSync("businessDate"))
				this.selfParam.businessDate = bussinessDate;
				console.log('returnFromDatePicker:dateType=',this.selfParam.businessDate)	
						
				const area = uni.getStorageSync("area")
				const areaName = uni.getStorageSync("areaName")
				console.log('returnFromDatePicker:area=',area,', areaName=',areaName)					
				this.selfParam.provinceCenterId=area
				this.selfParam.provinceCenterName=areaName
				this.selfParam.token=uni.getStorageSync("token")
				this.selfParam.shopNo = uni.getStorageSync("shopNo");
				uni.setStorageSync("selfParam",JSON.stringify(this.selfParam))
			},
			showView(){
				this.$refs['levelRingChart1'].showCharts();
				this.$refs['levelRingChart11'].showCharts();
				this.$refs['levelRingChart2'].showCharts();
				this.$refs['levelRingChart22'].showCharts(); 
			},
			getServerData() {
				this.getPieData();
			},
		    change(e) {
			    this.btnnum = e;
			    console.log(this.btnnum);
				this.refresh()
		    },
			bindPickerChange: function(e) {
				console.log('picker发送选择改变，携带值为：' + e.detail.value)
				this.index = e.detail.value
			},
			gotoALL(btnnum){
				console.log('JSON.stringify(this.pieData)：' + JSON.stringify(this.pieData));
				if(btnnum==0){
					uni.navigateTo({
						url:"/pages/common/levelRingDetail?btnnum="+ btnnum + "&data=" + JSON.stringify(this.pieData)
					});
				}else{
					uni.navigateTo({
						url:"/pages/common/levelRingDetail?btnnum="+ btnnum + "&data=" + JSON.stringify(this.pieData1)
					});
				}
			},
			getPieData(){
				var url = '/pentaho/shows/gamesContrast/getShowPassSalesPropCom';
				var param = this.createParam();
				param.gameFlag=0;
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res);
					var data = res.data.data;
					
					var games= data.pass;
					var comGanmes =data.comPass;
					
					var series = [];
					var categories =[];
					for(var i=0;i<games.length;i++){
						categories.push(games[i].customsName);
						var json ={'name':games[i].customsName,'data':games[i].values[0]};
						series.push(json);
					}
					var series2 = [];
					var categories2 =[];
					for(var i=0;i<comGanmes.length;i++){
						categories2.push(comGanmes[i].customsName);
						var json ={'name':comGanmes[i].customsName,'data':comGanmes[i].values[0]};
						series2.push(json);
					}
					//this.$set(this.arcbar1, 'categories', categories);
					this.$set(this.arcbar1, 'series', series);
					//this.$set(this.arcbar111, 'categories', categories2);
					this.$set(this.arcbar11, 'series', series2);
					this.$refs['levelRingChart1'].showCharts();
					this.$refs['levelRingChart11'].showCharts();
					
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				
				param.gameFlag=1;
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res);
					var data = res.data.data;
					
					var games= data.pass;
					var comGanmes =data.comPass;
					
					var series = [];
					var categories =[];
					for(var i=0;i<games.length;i++){
						categories.push(games[i].customsName);
						var json ={'name':games[i].customsName,'data':games[i].values[0]};
						series.push(json);
					}
					var series2 = [];
					var categories2 =[]; 
					for(var i=0;i<comGanmes.length;i++){
						categories2.push(comGanmes[i].customsName);
						var json ={'name':comGanmes[i].customsName,'data':comGanmes[i].values[0]};
						series2.push(json);
					}
					//this.$set(this.arcbar2, 'categories', categories);
					this.$set(this.arcbar2, 'series', series);
					//this.$set(this.arcbar222, 'categories', categories2);
					this.$set(this.arcbar22, 'series', series2);
					this.$refs['levelRingChart2'].showCharts();
					this.$refs['levelRingChart22'].showCharts();
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
			},
		},
		mounted(){
			this.showView();
		},
		watch: {
			'$route':'showView'
		},
		created() {
			this.param = this.model;
			this.getServerData();
			// this.showView();
		},
	}
</script>

<style>
	.box-contaniner1{
		width: 100%;
		margin: 10px 10px 10px 10px;
	}
	.box-contaniner{
		width: 100%;
	}
	
    /* 将三个内容view的display设置为none(隐藏) */
	.tab-content{
		margin: 20rpx 10rpx 20rpx 10rpx;
		/* padding: 20rpx 10rpx 20rpx 10rpx; */
	}
    .end-title{
        display: flex;
    }
    .end-title view{
        flex-grow: 1;
        text-align: center;
    }
    .end-cont{
		display: none;
		background: #FFFFFF;
    }
    .btna{
		color: #000000;
		background: #ebebeb;
		/* padding:0px 5rpx 0px 5rpx; */
    }
    .dis{
        display: block;
    } 
	
	
	.rankTable{
		width: 100%;
		height: 500upx;
		margin: 0rpx 0rpx;
		padding: 0 0rpx;
		font-size: 30rpx;		
		background-color: #FFFFFF;
	}
	
	.rankTable-title{
		width: 100%;
		margin: 0rpx 0rpx;
/* 		padding: 0 10rpx; */
		display: flex;
		/* font-weight: bold; */
		justify-content: space-between;
	}
	
	.rankTable-more{
/* 		margin: 0rpx 10rpx;
		padding: 0 10rpx; */
		text-align: right;
	}
		
	
	.example {
		/* line-height: 40px; */
		/* font-weight: bold; */
		border-color:#FFFFFF;
	}
	
	button {
		width: 75%;
	    margin-top: 30rpx;
	    margin-bottom: 30rpx;
		font-size: 30rpx;
	}
	
	.left-row-box {
		display: flex;
		width: 65%;
		margin: 0rpx 5rpx;
		/* padding: 0 10rpx; */
		/* background-color: #ebebeb; */
		flex-direction: column;
	}
	.right-row-box {
		display: flex;
		width: 35%;
		margin: 0rpx 5rpx;
		/* padding: 0 10rpx; */
		/* background-color: #ebebeb; */
		flex-direction: column;
	}
	.sale-row-2{
		display: flex;
		flex-direction: row;	
		margin: 20rpx 10rpx;
		/* padding: 20rpx 10rpx 20rpx 10rpx;	 */
	}

</style>
