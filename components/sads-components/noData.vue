<template>
	<view>
		<view  class="picture" >
			<image src="../../static/noData.png"></image>
		</view>
		<view class="title">{{title}}</view>
	</view>
</template>

<script>
	export default {
		
		props: {
			message: {
				type: String,
				default: ''
			},
		},
		data() {
			return {
				title:'未找到数据'
			}
		},
		onLoad(){
			this.title = this.message
		},
		methods: {

		},

	}
</script>

<style>
	.picture{
	    display: flex;
		background-size: 50upx 50upx;
	    align-items:center;
	    justify-content:center;
		display: flex;
		flex-direction: row;	
	}

	.title{
		font-size: 15px;
		justify-content:center;
		text-align: center;	
	}

</style>
