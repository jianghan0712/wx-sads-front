<template>
	<view>
		<view style="text-align: center;">
			<button type="default" plain="true" style="width: 200;" @click="toAll()">查看全部</button>
		</view>
	</view>
</template>

<script>
	export default {
		components: {},
		props: {
			model:{
				//数据
				type: Object,
				default: () => ({})
			}
		},
		data() {
			return {
			}
		},
		methods: {
			toAll() {
				var title = getApp().globalData.ballType+"游戏销量及占比";
				uni.navigateTo({
					url: './gameView/gameViewCompare?title='+JSON.stringify(title),
				
				});
			}
		}
	}
</script>

<style>
	page {
		width: 100%;
		min-height: 100%;
		display: flex;
		background-color: #FFFFFF;
	}
</style>