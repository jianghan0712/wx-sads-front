import Page from '../../../common/page';
var util = require('../../../utils/util.js');
import * as echarts from '../../../components/ec-canvas/echarts';

const app = getApp();

Page({
  data: {
    tabs5: ['总览', '游戏', '关次', '票面','赛事'],
    tabsWithName: [
      { name: '总览', index: 1 },
      { name: '游戏', index: 2 },
      { name: '关次', index: 3 },
      { name: '票面', index: 4 },
      { name: '赛事', index: 5 }
    ],
    currentDate: util.formatDate(new Date()) ,
    ec: {
      onInit: initChart
    }
  },

  onClickDisabled(event) {
    wx.showToast({
      title: `标签 ${event.detail.title} 已被禁用`,
      icon: 'none'
    });
  },

  onChange(event) {
    wx.showToast({
      title: `切换到 ${event.detail.title}`,
      icon: 'none'
    });
  },

  onClickNavRight() {
    wx.showToast({
      title: '点击 right nav',
      icon: 'none'
    });
  },

  onClick(event) {
    wx.showToast({
      title: `点击标签 ${event.detail.index + 1}`,
      icon: 'none'
    });
  },
  showCalendar(){
    wx.navigateTo({
      url: '/components/calendar/index'
    })
  },
  onReady() {
  }

});

function initChart(canvas, width, height, dpr) {
  console.log(123);
  const chart = echarts.init(canvas, null, {
    width: width,
    height: height,
    devicePixelRatio: dpr // new
  });
  canvas.setChart(chart);

  var option = {
    title: {
      text: '测试下面legend的红色区域不应被裁剪',
      left: 'center'
    },
    color: ["#37A2DA", "#67E0E3", "#9FE6B8"],
    legend: {
      data: ['A', 'B', 'C'],
      top: 50,
      left: 'center',
      backgroundColor: 'red',
      z: 100
    },
    grid: {
      containLabel: true
    },
    tooltip: {
      show: true,
      trigger: 'axis'
    },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
      // show: false
    },
    yAxis: {
      x: 'center',
      type: 'value',
      splitLine: {
        lineStyle: {
          type: 'dashed'
        }
      }
      // show: false
    },
    series: [{
      name: 'A',
      type: 'line',
      smooth: true,
      data: [18, 36, 65, 30, 78, 40, 33]
    }, {
      name: 'B',
      type: 'line',
      smooth: true,
      data: [12, 50, 51, 35, 70, 30, 20]
    }, {
      name: 'C',
      type: 'line',
      smooth: true,
      data: [10, 30, 31, 50, 40, 20, 10]
    }]
  };

  chart.setOption(option);
  return chart;
}

