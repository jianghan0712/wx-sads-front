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
	.mescroll-lazy-in,
	.mescroll-fade-in {
		-webkit-animation: mescrollFadeIn .3s linear forwards;
		animation: mescrollFadeIn .3s linear forwards;
	}
	.picture{
		/* height: 100px;
		width: 100px; */
	    /* display: flex; */
	    display: -webkit-flex;
	    align-items:center;
	    justify-content:center;
	}

	.title{
		font-size: 15px;
		justify-content:center;
		text-align: center;	
	}

</style>
