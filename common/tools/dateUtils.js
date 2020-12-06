
export const getToday = () => {
	var date = new Date(),
	year = date.getFullYear(),
	month = date.getMonth() + 1,
	day = date.getDate();
	month >= 1 && month <= 9 ? (month = "0" + month) : "";
	day >= 0 && day <= 9 ? (day = "0" + day) : "";
	var timer = year + '-' + month + '-' + day;
	return timer;
}
export const getTime = () => {
	var date = new Date(),
	year = date.getFullYear(),
	month = date.getMonth() + 1,
	day = date.getDate(),
	hour = date.getHours() < 10 ? "0" + date.getHours() : date.getHours(),
	minute = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes(),
	second = date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds();
	month >= 1 && month <= 9 ? (month = "0" + month) : "";
	day >= 0 && day <= 9 ? (day = "0" + day) : "";
	var timer = year + '-' + month + '-' + day + ' ' + hour + ':' + minute + ':' + second;
	return timer;
}

export const getDate = (date, AddDayCount = 0)=> {
	if (!date) {
		date = new Date()
	}
	if (typeof date !== 'object') {
		date = date.replace(/-/g, '/')
	}
	const dd = new Date(date)

	dd.setDate(dd.getDate() + AddDayCount) // 获取AddDayCount天后的日期

	const y = dd.getFullYear()
	const m = dd.getMonth() + 1 < 10 ? '0' + (dd.getMonth() + 1) : dd.getMonth() + 1 // 获取当前月份的日期，不足10补0
	const d = dd.getDate() < 10 ? '0' + dd.getDate() : dd.getDate() // 获取当前几号，不足10补0
	return y + '-' + m + '-' + d
}

export const getMonth = () => {
	var date = new Date(),
	year = date.getFullYear(),
	month = date.getMonth() + 1,
	day = date.getDate();
	month >= 1 && month <= 9 ? (month = "0" + month) : "";
	day >= 0 && day <= 9 ? (day = "0" + day) : "";
	var timer = year + '-' + month;
	return timer;
}

export const getYear = () => {
	var date = new Date(),
	year = date.getFullYear(),
	month = date.getMonth() + 1,
	day = date.getDate();
	month >= 1 && month <= 9 ? (month = "0" + month) : "";
	day >= 0 && day <= 9 ? (day = "0" + day) : "";
	var timer = year;
	return timer;
}


export default {
	getToday, getTime,getDate,getYear,getMonth
}