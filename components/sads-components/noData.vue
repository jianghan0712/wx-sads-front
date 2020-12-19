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
		/* height: 100px;
		width: 100px; */
	    /* display: flex; */
		background-size: 100px 100px;
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
