<template>
	<view class="container">
		
		<!-- 左边内容 -->
		<scroll-view class="scroller" :scroll-into-view="toView" scroll-y="true" scroll-with-animation="true">
			<view :id="item.id" class="left" v-for="item in tabBars">{{item.name}}</view>
		</scroll-view>
		
		<!-- 右边索引 -->
		<view>
			<view :data-id="item.id" v-for="item in tabBars" @tap="bindToView">{{item.name}}</view>
		</view>
	</view>
</template>

<script>

	export default {
		components: {
			
		},
		data() {
			return {
				tabBars: [{
					name: '总览',
					id: 'totalView'
				}, {
					name: '赛事',
					id: 'match'
				}, {
					name: '销售',
					id: 'sales'
				}, {
					name: '渠道',
					id: 'channel'
				}, {
					name: '区域',
					id: 'area'
				}, {
					name: '奖池',
					id: 'reward'
				}],
				toView:''
			}
		},
		methods: {
			bindToView(event){
							var id = event.currentTarget.dataset.id;
							console.log(id)
							this.toView = id;
			}
		}
	}
</script>

<style  lang="scss">
 .container{
 		width: 100%;
 		display: flex;
 		scroll-view{
 			height: 100vh;
 			.left{
 				font-size: 50rpx;
 				line-height: 150rpx;
 			}
 		}
 		> view{
 			position: fixed;
 			right: 10rpx;
 		}
 		
 	}
</style>