<template>
	<view>
		<view class="box-contaniner">
			<view class="tab-content">
				<view class="end-title">
				　　<view @tap="change(0)" :class="btnnum == 0?'btna':'hide'">足球</view>
				  　<view @tap="change(1)" :class="btnnum == 1?'btna':'hide'">篮球</view>
				</view>	
				<view class="end-cont" :class="{dis:btnnum == 0}">
					<view class="box-contaniner">
						<view style="font-size: 30rpx;font-weight: bold;">top5 赛制销量</view>
						<view class="example">
							<v-table :columns="matchTypeTableColumns" :list="matchTypeTableData"  border-color="#FFFFFF"></v-table>
						</view>
					</view>
					<view class="box-contaniner">
						<view style="font-size: 30rpx;font-weight: bold;">top5 赛事销量</view>
						<view class="example">
							<v-table :columns="matchEventTableColumns" :list="matchEventTableData"  border-color="#FFFFFF"></v-table>
						</view>
					</view>
				</view>
				<view class="end-cont" :class="{dis:btnnum == 1}">	
					<view class="box-contaniner">
						<view style="font-size: 30rpx;font-weight: bold;">top5 赛制销量</view>
						<view class="example">
							<v-table :columns="matchTypeTableColumns" :list="matchTypeTableData"  border-color="#FFFFFF"></v-table>
						</view>
					</view>
					<view class="box-contaniner">
						<view style="font-size: 30rpx;font-weight: bold;">top5 赛事销量</view>
						<view class="example">
							<v-table :columns="matchEventTableColumns" :list="matchEventTableData"  border-color="#FFFFFF"></v-table>
						</view>
					</view>
				</view>
			</view>		
		</view>
	<slot />
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
			vTable,PieChart
		},
		props: {
			param:{
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
						view:'',//用于展示日期、年、月等
						date:{startDate:'', endDate:''},
						week:{startDate:'', endDate:''},
						month:{startDate:'', endDate:''},
						year:{startDate:'', endDate:''},
					},	
					userId:'',			
					selfProvinceCenterId:''//存登录时候的id
				},
				btnnum: 0,
				index: 0,
				matchTypeTableData: [],
				matchTypeTableColumns: [{
						title: "排名",
						key: "id",
						$width:"50px",
					},{
						title: '赛制',
						key: 'matchType',
						$width:"150px"
					},{
						title: '销量（百万元）',
						key: 'amount',
						$width:"150px"
					}
				],	
				matchEventTableData: [],
				matchEventTableColumns: [{
						title: "排名",
						key: "id",
						$width:"50px",
					},{
						title: '赛制',
						key: 'matchType',
						$width:"150px"
					},{
						title: '销量（百万元）',
						key: 'amount',
						$width:"150px"
					}
				],	
				array: [{name:'单关'},{name: '2X1'}, {name:'3X1'}, {name:'4X1-8X1'}, {name:'MXN'}, {name:'自由过关'}],
			};
		},
		onLoad() {
			_self = this;
			// this.selfParam = this.param
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			this.returnFromDatePicker();
			this.getServerData(getServerData);
		},
		methods: {
			showView(){
				this.$nextTick(() => {				
				});
			},
			getServerData(btnnum) {
				this.getMatchTable(btnnum);
				this.getMatchEventTable(btnnum);
			},
		    change(e) {
			    this.btnnum = e;
			    console.log(this.btnnum);
				this.getServerData(this.btnnum);
		    },
			bindPickerChange: function(e) {
				console.log('picker发送选择改变，携带值为：' + e.detail.value)
				this.index = e.detail.value
			},
			gotoLunBo(btnnum){
				uni.navigateTo({	
					url:"/pages/common/levelRingDetail?btnnum="+btnnum
				});
			},
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
				this.selfParam.token=uni.getStorageSync("token")
				this.selfParam.shopNo = uni.getStorageSync("shopNo");
			},
			createParam(btnnum){
				console.log("createParam begin")
				var dateType = this.selfParam.businessDate.dateType
				var param = {}
				if(dateType=='date'){
					param = {dateTimeStart: this.selfParam.businessDate.date.startDate,
							 dateTimeEnd: this.selfParam.businessDate.date.endDate,
							 dateFlag:"1",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token,
							 gameFlag:btnnum+1 }
				}else if(dateType=='week'){
					param = {dateTimeStart: this.selfParam.businessDate.week.startDate,
							 dateTimeEnd: this.selfParam.businessDate.week.endDate,
							 dateFlag:"2",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token,
							 gameFlag:btnnum+1}
				}else if(dateType=='month'){
					param = {dateTimeStart: this.selfParam.businessDate.month.startDate,
							 dateTimeEnd: this.selfParam.businessDate.month.endDate,
							 dateFlag:"3",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token,
							 gameFlag:btnnum+1 }
				}else if(dateType=='year'){
					param = {dateTimeStart: this.selfParam.businessDate.year.startDate,
							 dateTimeEnd: this.selfParam.businessDate.year.endDate,
							 dateFlag:"4",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token,
							 gameFlag:btnnum+1 }
				}	

				console.log("createParam end:",param)
				return param
			},
			// 获取最上层的两个tab {startDate}/{endDate}/{startDatePre}/{endDatePre}/{sportsType}/{provinceCenterId}/{cityCenterId}
			getMatchTable(btnnum){
				var url = '/pentaho/match/getTop5FormatSales';
				var param = this.createParam(btnnum)
				
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
						format0 = numberFun.formatCNumber(data[0][1]);							
					}else{
						return;
					}	

					this.matchTypeTableColumns= [{
							title: "排名",
							key: "id",
							$width:"50px",
						},{
							title: '赛制',
							key: 'matchType',
							$width:"200px"
						},{
							title: '销量（'+format0.name + '元）',
							key: 'amount',
							$width:"150px"
						}
					]
					
					for(var i=0;i<data.length;i++){
						var jsonData = {id:i+1, matchType:data[i][0], amount:data[i][1]/format0.value}
						this.matchTypeTableData[i]=jsonData;
						if(i==4){
							break;
						}
					}

					console.log('request matchTypeTableData', this.matchTypeTableData);				
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
			getMatchEventTable(btnnum){
				var param = this.createParam(btnnum)
				var url = '/pentaho/match/getTop5MatchSales';

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
						format0 = numberFun.formatCNumber(data[0][1]);							
					}else{
						return;
					}					

					for(var i=0;i<data.length;i++){
						var jsonData = {id:i+1, matchName:data[i][0], amount:data[i][1]/format0.value}
						this.matchEventTableData[i]=jsonData;
						if(i==4){
							break;
						}
					}
					console.log('request matchEventTableData', this.matchEventTableData);	
					
					this.matchEventTableColumns = [{
							title: "排名",
							key: "id",
							$width:"50px",
						},{
							title: '赛事',
							key: 'matchName',
							$width:"200px"
						},{
							title: '销量（' + format0.name + '元）',
							key: 'amount',
							$width:"150px"
						}
					];
					
								
					this.res = '请求结果 : ' + JSON.stringify(res);
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
			},
		},
		created() {
			// this.selfParam = this.param
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			//ajax调用
			this.getServerData(this.btnnum);
		},
		mounted(){
			this.selfParam = JSON.parse(uni.getStorageSync("selfParam"))
			this.showView();
		},
		watch: {
			'$route':'showView'
		},
	}
</script>

<style>
	.box-contaniner{
		width: 100%;
		margin: 20rpx 10rpx 40rpx 10rpx;
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

</style>
