<template>
	<view>
		<view class="box-contaniner">
			<text @click="onShowDatePicker('dateTime')" class="datetext" >{{date}}</text>
			<mx-date-picker :show="showPicker" :type="type" :value="value" :show-tips="true" :begin-text="'起始日期'" :end-text="'终止日期'" :show-seconds="true" @confirm="onSelected" @cancel="onSelected" />
		</view>	 
		<view class="input">
			<input class="uni-input" type="number"  placeholder="请输入门店或终端编号" />
			<view style="color: #007AFF">搜索</view>
		</view>
		
		<view class="box-contaniner">
			<dataContainer ref="dataContain" :dataAs="totalData"></dataContainer>
		</view>
		
		<view class="box-contaniner">
			<view class="container-title">				
				<view>销售top100门店</view>
				<view>全部>></view>
			</view>
			<view class="table">
				<v-table :columns="amountTableColumns" :list="amountTableData"  selection="single"  :slot-cols="['number']" on-selection-change="onSelectionChange" border-color="#FFFFFF">
					<template v-slot="{ row }">
						<view style="font-weight: blod;color:blue;" @click="goDetail(row.number)">{{ row.number }}</view>
					</template>
				</v-table>
			</view>
		</view>
		
		<view class="box-contaniner">
			<view class="container-title">				
				<view>各地区超限门店</view>
				<view>全部>></view>
			</view>
			<view class="table">
				<v-table :columns="beyondLimitTableColumns" :list="beyondLimitTableData"   :slot-cols="['area']"  border-color="#FFFFFF">
					<template v-slot="{ row }">
						<view style="font-weight: blod;color:blue;" @click="goDetail(row.area)">{{ row.area }}</view>
					</template>
				</v-table>
			</view>
		</view>
	</view>
</template>

<script>
	import MxDatePicker from "@/components/mx-datepicker/mx-datepicker.vue";
	import dataContainer from '@/components/sads-components/dataContainer.vue';
	import vTable from "@/components/table/table.vue";
	
	export default {
			components:{
				MxDatePicker, dataContainer, vTable
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
					totalData:{
						big1:{name:'在售门店数',value:'1494', left:{name:'周同比',value:'-1.39%'},right:{name:'环比',value:'+3.61%'}},
						big2:{name:'在售率',value:'80.50%', left:{name:'周同比',value:'-1.59%'},right:{name:'环比',value:'+3.79%'}},
					},	
					scrollInto: "",
					showTips: false,
					navigateFlag: false,
					pulling: false,
					refreshIcon: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAB5QTFRFcHBw3Nzct7e39vb2ycnJioqK7e3tpqam29vb////D8oK7wAAAAp0Uk5T////////////ALLMLM8AAABxSURBVHja7JVBDoAgDASrjqj//7CJBi90iyYeOHTPMwmFZrHjYyyFYYUy1bwUZqtJIYVxhf1a6u0R7iUvWsCcrEtwJHp8MwMdvh2amHduiZD3rpWId9+BgPd7Cc2LIkPyqvlQvKxKBJ//Qwq/CacAAwDUv0a0YuKhzgAAAABJRU5ErkJggg==",
					showPicker: false,
					date: '2019/01/01',
					time: '15:00:12',
					datetime: '2019/01/01 15:00:12',
					range: ['2019/01/01','2019/01/06'],
					rangetime: ['2019/01/08 14:00','2019/01/16 13:59'],
					type: 'rangetime',
					amountTableData: [{
								id: "1",
								area: "北京市",
								number: "1224568045",
								amount:"10233.5"
							},
							{
								id: "2",
								area: "上海市",
								number: "1224568123",
								amount:"9965.5"
							},
							{
								id: "3",
								area: "广东省",
								number: "9754.5",
								amount: "9785.00"
							},
							{
								id: "4",
								area: "重庆市",
								number: "1224568045",
								amount: "9685.00"
							},
							{
								id: "5",
								area: "河北省",
								number: "1224568045",
								amount: "8785.00"
							}
						],
					amountTableColumns: [{
								title: "排名",
								key: "id",
								$width:"50px",
							},
							{
								title: '省份/地市',
								key: 'area',
								$width:"100px"
							},
							{
								title: '门店编号',
								key: 'number',
								$width:"150px"
							},
							{
								title: '销量',
								key: 'amount'
							}
						],	
					beyondLimitTableData: [{
								id: "1",
								area: "北京市",
								count: "107",
								change:44
							},
							{
								id: "2",
								area: "上海市",
								count: "90",
								change:25
							},
							{
								id: "3",
								area: "广东省",
								count: "76",
								change: 21
							},
							{
								id: "4",
								area: "重庆市",
								count: "70",
								change: 15
							},
							{
								id: "5",
								area: "河北省",
								count: "59",
								change: 12
							}
						],
					beyondLimitTableColumns: [{
								title: "排名",
								key: "id",
								$width:"50px",
							},
							{
								title: '省份/地市',
								key: 'area',
								$width:"100px"
							},
							{
								title: '门店数量',
								key: 'count',
								$width:"150px"
							},
							{
								title: '环比变化值',
								key: 'change'
							}
						],
				}				
			},
			methods:{
				onShowDatePicker(type){//显示
					this.type = type;
					this.showPicker = true;
					this.value = this[type];
				},
				onSelected(e) {//选择
					this.showPicker = false;
					if(e) {
						this[this.type] = e.value; 
						//选择的值
						console.log('value => '+ e.value);
						//原始的Date对象
						console.log('date => ' + e.date);
					}
				},
				onSelectionChange(obj){
					console.log("对比前后，选中的变化")
					console.log(obj)
				},
				goDetail(number){
					console.log(number)
					uni.navigateTo({
						url:"/pages/channel/index-inner?number="+number
					});
				}
			},
			created() {
				this.$nextTick(() => {
					this.$refs['dataContain'].showDataContainer();				
				});
			}
		}
</script>

<style>
	.box-contaniner{
		width: 100%;
		margin: 20rpx 10rpx 40rpx 10rpx;
		text-align: center;
	}
	.datePick{
		text-align: center;
		padding: 0upx 5upx;
	}
	.datetext{
		font-size: 35rpx;
		background-color:  #ebebeb;
		text-align: center;
	}
	.input{
		/*  */
		justify-content: center;
		display: flex;
		flex-direction: row;
		margin: 20rpx 10rpx 40rpx 10rpx;		
	}
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
	
	.table {
		/* line-height: 40px; */
		font-weight: bold;
		border-color:#FFFFFF;
	}
</style>
