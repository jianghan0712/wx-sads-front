<template>
	<!-- <view>
		<uni-list>
		    <uni-list-item  v-for="(item, index) in uidata" :key="index" title="" note="">{{item[2]}}</uni-list-item>
		</uni-list>
	</view> -->
	 <view class="content">
	         <view class="uni-list">
				 <table  style="width: 100%;">
					 <view v-for="(item,gameindex) in uidata" :key="gameindex" style="width: 100%;">
						 <tr style="font-size: 30rpx;width: 100%;">
							<td align="left" style="width: 190rpx;">{{item[0]}}</td>
							<td align="left" style="width: 150rpx;">{{item[2].toFixed(2)}}</td>
							<td align="left" style="width: 150rpx;"></td>
							<td align="left" style="width: 150rpx;">{{(item[1]/10000).toFixed(2)}}万元</td>  
						 </tr>
						 <tr style="font-size: 30rpx;width: 100%;"  >
							<td align="left" colspan='4'> <progress :percent="item[2].toFixed(2)" stroke-width="4" /></td>
						 </tr>
						<view class="line-h" colspan='4' style="width: 100%;"></view>
					 </view>
				 </table>
	         </view>
	    </view>
</template>

<script>
	import vTable  from  '@/components/table/table.vue';
	import urlAPI from '@/common/vmeitime-http/';
	export default{
		components:{
			vTable
		},
		props: {
			model:{
				//数据
				type: Object,
				default: () => ({})
			}
		},
		data(){
			return {
				uidata:{},
				contents :[],
				type:'all',
				btnnum:0,
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
			}
		},
		methods:{
			returnFromDatePicker(){
				const dateType = uni.getStorageSync("dateType")
				const bussinessDate = JSON.parse(uni.getStorageSync("businessDate"))
				this.selfParam.businessDate = bussinessDate;
				console.log('returnFromDatePicker:dateType=',this.selfParam.businessDate)	
						
				const area = uni.getStorageSync("area")
				const areaName = uni.getStorageSync("areaName")
				console.log('returnFromDatePicker:area=',area,', areaName=',areaName)					
				this.selfParam.provinceCenterId=area
				this.selfParam.provinceCenterName=areaName
				this.selfParam.token=uni.getStorageSync("token");
			},
			createParam(){
				console.log("createParam begin")
				var dateType = this.selfParam.businessDate.dateType
				var param = {}
				if(dateType=='date'){
					param = {dateTimeStart: this.selfParam.businessDate.date.startDate,
							 dateTimeEnd: this.selfParam.businessDate.date.endDate,
							 dateFlag:"1",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='week'){
					param = {dateTimeStart: this.selfParam.businessDate.week.startDate,
							 dateTimeEnd: this.selfParam.businessDate.week.endDate,
							 dateFlag:"2",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='month'){
					param = {dateTimeStart: this.selfParam.businessDate.month.startDate,
							 dateTimeEnd: this.selfParam.businessDate.month.endDate,
							 dateFlag:"3",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}else if(dateType=='year'){
					param = {dateTimeStart: this.selfParam.businessDate.year.startDate,
							 dateTimeEnd: this.selfParam.businessDate.year.endDate,
							 dateFlag:"4",
							 regionId:this.selfParam.provinceCenterId,
							 token:this.selfParam.token }
				}
				
				if(this.btnnum==0){
					param.gameFlag = 1
				}else if(this.btnnum==1){
					param.gameFlag = 2
				}
				
				console.log("createParam end:",param)
				return param
			},
			loadData(){
				var url = '/pentaho/sales/getCheckpointSalesProp';
				var param = this.createParam()
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
				   var dataFilter=[];					//获取全局的ballType
				   for(var i=0;i<data.length;i++){
						var item=[];
						item[0]=data[i].customsName;
						item[1]=data[i].values[0];
						item[2]=parseInt(data[i].values[1]);
						console.log(item)
						dataFilter.push(item);
				   }
				   that.uidata = dataFilter;
					console.log(data)
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				})
				
		},
		onLoad(option){
			this.btnnum=JSON.parse(option.btnnum);
			uni.setNavigationBarTitle({
				title :option.title
			});
			this.returnFromDatePicker();
			this.loadData();
		}
		
	},
	}
</script>

<style>
	.line-h {
	    height: 5rpx;
		width: 100%;
	    background-color: #cccccc;
	}
</style>