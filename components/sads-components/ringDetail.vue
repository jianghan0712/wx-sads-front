<template>
	<view>
		<view v-for="(i, index) in leftData" >
			<text class="big-text">{{leftData[index].title}}</text>
			<view class="sale-row-2">					
				<view class="row-box">					
					<view class="left-column_box_2">
						<view class="column-box">
							<text class="small-text">{{leftData[index].name1}} : {{leftData[index].value1}}</text>
							<text class="small-text">{{leftData[index].name2}} : {{leftData[index].value2}}</text>
						</view>
					</view>			
				</view>
				<view class="row-box">
					<view class="right-column_box_2">
						<view class="column-box">
							<text class="small-text">{{rightData[index].name1}} : {{rightData[index].value1}} </text>
							<text class="small-text">{{rightData[index].name2}} : {{rightData[index].value2}}</text>
						</view>
					</view>			
				</view>	
			</view>
		</view>
	</view>
</template>

<script>
	import numberFun from '@/common/tools/number.js';
	
	export default {
		props: {
			leftDataAs: {
				//数据
				type: Object,
				default: () => ({})
			},
			rightDataAs: {
				//数据
				type: Object,
				default: () => ({})
			},
			dataType:{
				//数据
				type: Object,
				default: () => ({})
			}
		},
		data() {
			return{	
				leftSeries:[],
				rightSeries:[],
				leftData:[],//title:'',name1:'票数',value1:100,name2:'占比',value2:20%
				rightData:[]
			}
		},
		methods: {
			dealPercent(){				
				if(this.leftSeries==null || this.rightSeries==null){
					return
				}
				var totalLeft = 0,totalRight = 0
				for(var i = 0;i<this.leftSeries.length;i++){
					totalLeft = totalLeft + this.leftSeries[i].data
					totalRight = totalRight + this.rightSeries[i].data				
				}
				var name1=''
				var pre = ''
				if(this.type=='level'){
					name1 = '销量'
					pre = '元'
				}else if(this.type=='ticket'){
					name1 = '票数'
					pre = '张'
				}else if(this.type=='game'){
					name1 = '销量'
					pre = '元'
				}
				for(var i = 0;i<this.leftSeries.length;i++){
					var format = numberFun.formatCNumber(this.leftSeries[i].data);
					var format1 = numberFun.formatCNumber(this.rightSeries[i].data);
					var json1 = {title:this.leftSeries[i].name,
							    name1:name1,
								value1:(this.leftSeries[i].data/format.value).toFixed(2) +format.name+pre,
								name2:'占比',
								value2: totalLeft==0?'0%':((this.leftSeries[i].data/totalLeft)*100).toFixed(2) + '%'}
								
					var json2 = {title:this.rightSeries[i].name,
							    name1:name1,
								value1:(this.rightSeries[i].data/format1.value).toFixed(2) +format1.name+pre,
								name2:'占比',
								value2: totalRight==0?'0%':((this.rightSeries[i].data/totalRight)*100).toFixed(2) + '%'}	
					this.leftData[i] = json1
					this.rightData[i] = json2
				}				
			}
		},
		showRingDetail(){		
			// var leftPie = JSON.parse(data.leftPie)
			// var rightPie = JSON.parse(data.rightPie)
			this.type = this.dataType
			this.leftSeries = this.leftDataAs;
			this.rightSeries = this.rightDataAs;
			this.dealPercent()
			
			console.log("rightSeries=",this.rightSeries)
		}
	}
</script>

<style>
	.sale-row-2{
		display: flex;
		flex-direction: row;	
		margin: 20rpx 10rpx;
	}
	.row_box_2{
		display: flex;
		flex-direction: row;	
	}
	
	.right-column_box_2{	
		display: flex;
		flex-direction: column;
		background:rgba(250, 225, 220 ,0.5);
		border-radius: 15px;
	}
	
	.left-column_box_2{
		display: flex;
		flex-direction: column;
		background:rgba(220, 241, 250 ,0.5);
		border-radius: 15px;
	}
	
	.row-box {
		display: flex;
		width: 50%;
		margin: 0rpx 5rpx;
		padding: 0 10rpx;
		flex-direction: column;
	}
	
	.column-box{
		display: flex;
		height: 50%;
		margin: 20rpx 5rpx;
		padding: 0 5rpx;
		flex-direction: column;
	}
	
	.big-text{
		text-align: left;
		color: #000000;
		font-size: 36rpx;
	}
	
	.small-text{
		text-align: left;
		/* background-color: #ebebeb; */
		color: #000000;
		font-size: 30rpx;
	}
</style>
