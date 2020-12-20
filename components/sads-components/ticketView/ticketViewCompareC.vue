<template>
	<view>
		<view class="box-contaniner1">
			<view class="container-title">单票金额对比</view>
			<dataContainerTwoColThree ref="compareAmount" :dataAs="compareAmount"></dataContainerTwoColThree>
		</view>
		
		<view class="box-contaniner">
			<view class="container-title">各票面区间的票数及占比对比</view>
			<view class="tab-content">
				<view class="tab-title">
					<view @tap="change(0)" :class="btnnum == 0?'btna':'hide'">竞彩</view>
				　　<view @tap="change(1)" :class="btnnum == 1?'btna':'hide'">足球</view>
				  　<view @tap="change(2)" :class="btnnum == 2?'btna':'hide'">篮球</view>
				</view>	
				<view class="end-cont" :class="{dis:btnnum == 0}">	
					<view class="ring_chart">
						<ring-chart :legendAs="legend" :dataAs="pieData" ref="ringChart0" canvasId="index_ring_0"/>
					</view>
					<view class="ring_chart">
						<ring-chart :legendAs="legend" :dataAs="pieData" ref="ringChart3" canvasId="index_ring_3"/>
					</view>
				</view>
				<view class="end-cont" :class="{dis:btnnum == 1}">
					<view class="ring_chart">
						<ring-chart :dataAs="pieData1" ref="ringChart1" canvasId="index_ring_1"/>
					</view>
					<view class="ring_chart">
						<ring-chart :dataAs="pieData1" ref="ringChart4" canvasId="index_ring_4"/>
					</view>
				</view>
				<view class="end-cont" :class="{dis:btnnum == 2}">
					<view class="ring_chart">
						<ring-chart :dataAs="pieData2" ref="ringChart2" canvasId="index_ring_2"/>
					</view>		
					<view class="ring_chart">
						<ring-chart :dataAs="pieData2" ref="ringChart5" canvasId="index_ring_5"/>
					</view>	
				</view>
				<button type="default" plain="true" @click="gotoLunBo(btnnum)">查看全部</button>
			</view>
		</view>
		
		<view class="box-contaniner">
			<view class="container-title">
				<view>各地区单票金额</view>
				<view @click="gotoRankAll()">全部>></view>
			</view>
			<view class="tab-content">
				<view class="tab-title">
					<view @tap="changeTable(0)" :class="tableIndex == 0?'btna':'hide'">竞彩</view>
				　　<view @tap="changeTable(1)" :class="tableIndex == 1?'btna':'hide'">足球</view>
				  　<view @tap="changeTable(2)" :class="tableIndex == 2?'btna':'hide'">篮球</view>
				</view>	

				<view class="end-cont" :class="{dis:tableIndex == 0}">
					<view class="table">
						<v-table :columns="tableColumns" :list="tableData"  border-color="#FFFFFF"></v-table>
					</view>
				</view>
				<view class="end-cont" :class="{dis:tableIndex == 1}">
					<view class="table">
						<v-table :columns="tableColumnsFB" :list="tableDataFB"  border-color="#FFFFFF"></v-table>
					</view>
				</view>
				<view class="end-cont" :class="{dis:tableIndex == 2}">
					<view class="table">
						<v-table :columns="tableColumnsBK" :list="tableDataBK"  border-color="#FFFFFF"></v-table>
					</view>
				</view>
			</view>
		</view>

		<slot />
	</view>	
</template>

<script>
	import RingChart from "@/components/basic-chart/RingChart.vue";
	import dataContainerTwoColThree from '@/components/sads-components/dataContainerTwoColThree.vue';
	import vTable from "@/components/table/table.vue";
	import urlAPI from '@/common/vmeitime-http/';
	import numberFun from '@/common/tools/number.js';
	
	export default {
		components: {
			RingChart,vTable,dataContainerTwoColThree
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
				selfParam:{},
				btnnum: 0,
				tableIndex:0,
				pieData: {
					//饼状图数据
					series: [{name: '100',data: 222100},{name: '4-20',data: 70300},{name: '22-48',data: 32100},{name: '100以上',data: 25400},
						{name: '52-98',data: 19700},{name: '2',data: 16000},{name: '50',data: 10500},
					]
				},
				pieData1: {series: []},
				pieData2: {series: []},
				tableData: [],
				tableDataAll: [],
				tableColumns: [{
							title: "排名",
							key: "leftRank",
							$width:"50px",
						},{
							title: '省份',
							key: 'area',
							$width:"100px"
						},{
							title: '竞彩（元）',
							key: 'leftAmount',
							$width:"80px"
						},{
							title: '排名',
							key: 'rightRank',
							$width:"100px"
						},{
							title: '竞彩（元）',
							key: 'rightAmount',
							$width:"80px"
						}],	
				
				tableDataFB: [],
				tableDataAllFB: [],
				tableColumnsFB: [{
							title: "排名",
							key: "leftRank",
							$width:"50px",
						},{
							title: '省份',
							key: 'area',
							$width:"100px"
						},{
							title: '足彩（元）',
							key: 'leftAmount',
							$width:"80px"
						},{
							title: '排名',
							key: 'rightRank',
							$width:"100px"
						},{
							title: '足彩（元）',
							key: 'rightAmount',
							$width:"80px"
						}],	
				
				tableDataBK: [],
				tableDataAllBK: [],
				tableColumnsBK: [{
							title: "排名",
							key: "leftRank",
							$width:"50px",
						},{
							title: '省份',
							key: 'area',
							$width:"100px"
						},{
							title: '篮彩（元）',
							key: 'leftAmount',
							$width:"80px"
						},{
							title: '排名',
							key: 'rightRank',
							$width:"100px"
						},{
							title: '篮彩（元）',
							key: 'rightAmount',
							$width:"80px"
						}],	
				compareAmount:{
					title:{nameOne:'竞彩单票金额（元）',nameTwo:'足球单票金额（元）',nameThree:'篮球单票金额（元）'},
					left:{valueOne:'0元',valueTwo:'0元',valueThree:'0元'},
					right:{valueOne:'0元',valueTwo:'0元',valueThree:'0元'},
				},
				legend: {
					show: false
				},
			}
		},
		onLoad() {
			_self = this;
			this.returnFromDatePicker();
			this.getServerData();
			this.showView()
			this.refresh();
		},
		created() {
			_self = this;
			this.returnFromDatePicker();
			this.getServerData();
			this.showView()
			this.refresh();
		},
		onShow() {
			_self = this;
			this.returnFromDatePicker();
			this.getServerData();
			this.showView()
			this.refresh();
		},
		methods: {
			showView(){
				console.log("ticket showView" ,this.pieData);
				this.$nextTick(() => {		
					this.$refs['ringChart0'].showCharts();
					this.$refs['ringChart1'].showCharts();
					this.$refs['ringChart2'].showCharts();
					this.$refs['ringChart3'].showCharts();
					this.$refs['ringChart4'].showCharts();
					this.$refs['ringChart5'].showCharts();
					this.$refs['compareAmount'].showDataContainer();
				});
			},
			getServerData() {
				// this.getPieData(this.selfParam.provinceCenterId,this.selfParam.businessDate);
				this.getRankTable('竞彩');
				this.getRankTable('足彩');
				this.getRankTable('篮彩');
				this.getAmountCompare()
			},
			change(e) {
			    this.btnnum = e;
			    console.log(this.btnnum);
			},
			changeTable(e){
				this.tableIndex = e;
				console.log(this.tableIndex);
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
							 dateFlag:"1",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='week'){
					param = {dateTimeStart: this.selfParam.compareDate.weekLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.weekLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.weekRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.weekRight.endDate,
							 dateFlag:"2",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='month'){
					param = {dateTimeStart: this.selfParam.compareDate.monthLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.monthLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.monthRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.monthRight.endDate,
							 dateFlag:"3",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='year'){
					param = {dateTimeStart: this.selfParam.compareDate.yearLeft.startDate,
							 dateTimeEnd: this.selfParam.compareDate.yearLeft.endDate,
							 dateTimeStartCom: this.selfParam.compareDate.yearRight.startDate,
							 dateTimeEndCom: this.selfParam.compareDate.yearRight.endDate,
							 dateFlag:"4",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}	
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
			getAmountCompare(){
				var url = '/pentaho/proValue/getSingleVoteMoneyCom';
				var param = this.createParam();
				
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					uni.showToast({
						title: '请求成功',
						icon: 'success',
						mask: true
					});

					var data = res.data.data;
					var format0 = numberFun.formatCNumber(data[0]);
					var format1 = numberFun.formatCNumber(data[1]);
					var format2 = numberFun.formatCNumber(data[2]);
					var title = {'nameOne':'竞彩单票金额（'+format0.name +'元）', 'nameTwo':'足球单票金额（'+format0.name +'元）','nameThree':'篮球单票金额（'+format0.name +'元）'}
					var left = {'valueOne':data[0].toFixed(2)/format0.value , 'valueTwo':data[1].toFixed(2)/format1.value ,'valueThree':data[2].toFixed(2)/format1.value }
					var right = {'valueOne':data[3].toFixed(2)/format0.value , 'valueTwo':data[1].toFixed(4)/format1.value ,'valueThree':data[5].toFixed(2)/format1.value }
					
					this.$set(this.compareAmount, 'title', title);
					this.$set(this.compareAmount, 'left', left);
					this.$set(this.compareAmount, 'right', right);
					this.$refs['compareAmount'].showDataContainer();

					console.log('request ticketData', this.ticketData);				
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			getPieData(provinceCenterId, currentDate){
				var url = '/pentaho/proValue/getProValueVotesProp';
				var param = this.createParam();
				
				if(type=='竞彩'){
					param.gameFlag = 0
				}else if(type=='足彩'){
					param.gameFlag = 1
				}else if(type=='篮彩'){
					param.gameFlag = 2
				}
				var that =this;
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					uni.showToast({
						title: '请求成功',
						icon: 'success',	
						mask: true
					});
					
					var data = res.data.data;
					var list=[];	
					for(var i=0; i<data.length; i++){
						list[i]={name:data[i].proValueName,data:data[i].values[0]};
					}
					if(type=='竞彩'){
						that.$set(that.pieData, 'series', list);
						this.$refs['ringChart0'].showCharts();
						
					}else if(type=='足彩'){
						that.$set(that.pieData1, 'series', list);
						this.$refs['ringChart1'].showCharts();
						
					}else if(type=='篮彩'){
						that.$set(that.pieData2, 'series', list);
						this.$refs['ringChart2'].showCharts();
						
					}
					that.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			getRankTable(type){
				var url ='/pentaho/proValue/getSingleVoteRankingCom';	
				var param = this.createParam();
				var table = []
				var tableAll = []
				if(type=='竞彩'){
					param.gameFlag=0
				}else if (type=='足彩'){
					param.gameFlag=1
				}else if (type=='篮彩'){
					param.gameFlag=2
				}
				urlAPI.getRequest(url, param).then((res)=>{
					this.loading = false;
					console.log('request success', res)
					uni.showToast({
						title: '请求成功',
						icon: 'success',
						mask: true
					});
					var data = res.data.data;
					var format0 = null;
					if(data.length>0){
						format0 = numberFun.formatCNumber(data[0][2]);							
					}else{
						return;
					}			
					
					for(var i=0;i<data.length;i++){
						var jsonData = {leftRank:data[i][1], 
									    area:data[i][0], 
										leftAmount:(data[i][2]/format0.value).toFixed(2), 
										rightRank:data[i][3], 
										rightAmount:(data[i][4]/format0.value).toFixed(2)}
						tableAll[i]=jsonData;						
						if(i>4){
							continue;
						}
						table[i]=jsonData;
					}
					if(type=='竞彩'){
						this.tableData=table
						this.tableDataAll=tableAll
					}else if (type=='足彩'){
						this.tableDataFB=table
						this.tableDataAllFB=tableAll
					}else if (type=='篮彩'){
						this.tableDataBK=table
						this.tableDataAllBK=tableAll
					}
			
					console.log('request tableData', this.tableData);				
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			gotoLunBo(btnnum){
				if(btnnum==0){
					uni.navigateTo({
						url:"/pages/common/levelRingDetail?btnnum="+ btnnum + "&data=" + JSON.stringify(this.pieData)
					});
				}else if(btnnum==1){
					uni.navigateTo({
						url:"/pages/common/levelRingDetail?btnnum="+ btnnum + "&data=" + JSON.stringify(this.pieData1)
					});
				}else if(btnnum==2){
					uni.navigateTo({
						url:"/pages/common/levelRingDetail?btnnum="+ btnnum + "&data=" + JSON.stringify(this.pieData1)
					});
				}
			},
			gotoRankAll(){
				if(this.tableIndex==0){
					uni.navigateTo({
						url:"/pages/common/tableDetail?tableData= " + JSON.stringify(this.tableDataAll) + '&tableColumns=' + JSON.stringify(this.tableColumns)
					});
				}else if(this.tableIndex==1){
					uni.navigateTo({
						url:"/pages/common/tableDetail?tableData= " + JSON.stringify(this.tableDataAllFB) + '&tableColumns=' + JSON.stringify(this.tableColumnsFB)
					});
				}else if(this.tableIndex==2){
					uni.navigateTo({
						url:"/pages/common/tableDetail?tableData= " + JSON.stringify(this.tableDataAllBK) + '&tableColumns=' + JSON.stringify(this.tableColumnsBK)
					});
				}

			},
			refresh(){
				this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
				this.returnFromDatePicker();
				this.getServerData();
				this.showView();
			},
		},
		mounted(){			
			this.showView();
		},
		watch: {
			'$route':'showView'
		},
		created() {
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			this.getServerData();
			// this.showView();
		},
	}
</script>

<style>
	.container-title{
		display: flex;
		width: 100%;
		margin: 0rpx 5rpx;
		padding: 0 10rpx;
		font-size: 30rpx;
		font-weight: bold;
		justify-content: space-between;
		background-color: #FFFFFF;
	}

	.box-container{
		width: 100%;
		margin: 20rpx 10rpx 40rpx 10rpx;
		/* padding: 20rpx 10rpx 20rpx 10rpx; */
	}
	
	/* 将三个内容view的display设置为none(隐藏) */
	.tab-content{
		margin: 20rpx 10rpx 20rpx 10rpx;
		/* padding: 20rpx 10rpx 20rpx 10rpx; */
	}
	
	/* 将三个内容view的display设置为none(隐藏) */
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
		color: #FFFFFF;
		background:rgba(47, 98, 248 ,0.5);		
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
	
	.table {
		/* line-height: 40px; */
		font-weight: bold;
		border-color:#FFFFFF;
	}
	
	button {
		width: 75%;
	    margin-top: 30rpx;
	    margin-bottom: 30rpx;
		font-size: 30rpx;
	}
	.box-contaniner{
		width: 100%;
	}
	.box-contaniner1{
		width: 100%;
		margin: 10px 10px 10px 10px;
	}
</style>
