<template>
	<view class="content">
		<progress ref="progress" :dataAs="pieData"></progress>
	</view>
	
</template>

<script>
	import progress from "@/components/sads-components/progress.vue";
	export default {
			components: {
				progress
			},
			data() {
				return{
					pieData: {					//饼状图数据
						series: [],
					}			
				}
			},
			methods: {
			
			},
			onLoad(option){
				console.log("ring=",option)
				this.pieData = JSON.parse(option.data); 
				this.$nextTick(() => {
					this.$refs['progress'].showProgress(this.pieData);
				});
			}
		}
</script>

<style>
	.content{
		width: 95%;
	}
</style>
