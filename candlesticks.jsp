<%@ include file="include/header.jsp" %>

<link href="/css/candlesticks.css" rel="stylesheet">

<div id="chart2">
	<button id="grafic-btn">Update</button>
<script src="http://d3js.org/d3.v4.min.js"></script>
<script src="http://techanjs.org/techan.min.js"></script>
<script>
	var margin = {top: 20, right: 20, bottom: 30, left: 50},
	width = 960 - margin.left - margin.right,
	height = 500 - margin.top - margin.bottom;
	
	var parseDate = d3.timeParse("%d-%b-%y");
	
	var x = techan.scale.financetime()
	.range([0, width]);
	
	var y = d3.scaleLinear()
	.range([height, 0]);
	
	var heikinashi = techan.plot.heikinashi()
	.xScale(x)
	.yScale(y);
	
	var heikinashiIndicator = techan.indicator.heikinashi();
	
	var xAxis = d3.axisBottom(x);
	
	var yAxis = d3.axisLeft(y);
	
	var svg = d3.select("#chart2").append("svg")
	.attr("width", width + margin.left + margin.right)
	.attr("height", height + margin.top + margin.bottom)
	.append("g")
	.attr("transform", "translate(" + margin.left + "," + margin.top + ")");
	
	d3.csv("/data.csv", function(error, data) {
	var accessor = heikinashi.accessor();
	
	data = data.slice(0, 200).map(function(d) {
	return {
	    date: parseDate(d.Date),
	    open: +d.Open,
	    high: +d.High,
	    low: +d.Low,
	    close: +d.Close,
	    volume: +d.Volume
	};
	}).sort(function(a, b) { return d3.ascending(accessor.d(a), accessor.d(b)); });
	
	svg.append("g")
	    .attr("class", "heikinashi");
	
	svg.append("g")
	    .attr("class", "x axis")
	    .attr("transform", "translate(0," + height + ")");
	
	svg.append("g")
	    .attr("class", "y axis")
	    .append("text")
	    .attr("transform", "rotate(-90)")
	    .attr("y", 6)
	    .attr("dy", ".71em")
	    .style("text-anchor", "end")
	    .text("Price ($)");
	
	// Data to display initially
	draw(data.slice(0, data.length-20));
	// Only want this button to be active if the data has loaded
	d3.select("#grafic-btn").on("click", function() { draw(data); }).style("display", "inline");
	});
	
	function draw(data) {
	var heikinashiData = heikinashiIndicator(data);
	x.domain(data.map(heikinashi.accessor().d));
	y.domain(techan.scale.plot.ohlc(heikinashiData, heikinashi.accessor()).domain());
	
	svg.selectAll("g.heikinashi").datum(heikinashiData).call(heikinashi);
	svg.selectAll("g.x.axis").call(xAxis);
	svg.selectAll("g.y.axis").call(yAxis);
	}

</script>
</div>

<%@ include file="include/footer.jsp" %>
