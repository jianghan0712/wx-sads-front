<template>
	<view>
		<view style="text-align: center;">
			<text @click="toAll" style="font-family: 'Courier New', Courier, monospace;font-size: medium;">查看全部</text>
		</view>
	</view>
</template>

<script>
	export default {
		components: {},

		data() {
			return {
			}
		},
		methods: {
			toAll() {
				uni.navigateTo({
					url: './gameView/gameViewCompare?title='+JSON.stringify(encodeURIComponent("全部")),
					success: function(res) {
					    // 通过eventChannel向被打开页面传送数据
					    res.eventChannel.emit('hahahah', 
												{ type: 'all' },
												);
					}
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