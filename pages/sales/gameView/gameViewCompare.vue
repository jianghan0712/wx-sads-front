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
							<td align="left" style="width: 190rpx;">{{item[2]}}</td>
							<td align="left" style="width: 150rpx;">{{item[4].toFixed(2)}}</td>
							<td align="left" style="width: 150rpx;">销量</td>
							<td align="left" style="width: 150rpx;">{{(item[3]/10000).toFixed(2)}}万元</td>  
						 </tr>
						 <tr style="font-size: 30rpx;width: 100%;"  >
							<td align="left" colspan='4'> <progress :percent="item[4].toFixed(2)" stroke-width="4" /></td>
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
				type:'all'
			}
		},
		methods:{
			loadData(){
				if('all'==this.type){
				
				var url = 'exhibition/gameSales/queryGamesSalesList/{currentDate}/{provinceCenterId}/{cityCenterId}';
				var that =this;
				urlAPI.getRequest(url, null).then((res)=>{
					this.loading = false;
					var data =res.data.concreteBean;
					var ballType = getApp().globalData.ballType;
					var dataFilter=[];					//获取全局的ballType
					for(var i=0;i<data.length;i++){
						//需要 索引1 2 4
						if(data[i][1].indexOf(ballType)!=-1){
							dataFilter.push(data[i]);
						}
					}
					that.uidata = dataFilter;
					
					/* arcbar1: {
							type: 'radar',
							series:[
									{name: '胜平负',data: 100},
									 {name: '半全场胜平负',data: 30},
									 {name: '让球胜平负',data: 50},
							],
							索引1	String		游戏种类
							索引2	String		游戏名称
							索引3	Integer		销量
							索引4	Double		销量占比
							extra: {
								pie: {
									lableWidth: 15,
									ringWidth: 10, //圆环的宽度
									offsetAngle: 0 //圆环的角度
								}
							}
					}, */
				}).catch((err)=>{
					this.loading = false;
					console.log('request fail', err);
				});
				}else if('all'!=this.type){
					
				}
				
				}
				
				
		},
		onLoad(option){
			console.log(option.title)
			uni.setNavigationBarTitle({
				title :option.title
			});
			const eventChannel = this.getOpenerEventChannel();
			eventChannel.on('all', function(data) {
				
			});
			this.loadData()
		}
		
	}
</script>

<style>
	.line-h {
	    height: 5rpx;
		width: 100%;
	    background-color: #cccccc;
	}
</style>