// Left panel is a heat map of a correlation matrix; hover over pixels
// to see the values; click to see the corresponding scatterplot on the right

function draw(data, el) {

  var d3 = Plotly.d3;
  // dimensions of SVG
  var h = 450,
    w = h,
    pad = {left:70, top:40, right:5, bottom: 70},
    innerPad = 5;

  var totalh = h + pad.top + pad.bottom;
  var totalw = (w + pad.left + pad.right) * 2;

  var svg = d3.select("#" + el.id)
    .append("svg")
    .attr("height", totalh)
    .attr("width", totalw);

  // panel for correlation image
  var corrplot = svg.append("g")
    .attr("id", "corrplot")
    .attr("transform", "translate(", + pad.left + "," + pad.top + ")");

  // panel for scatterplot
  var scatterplot = svg.append("g")
    .attr("id", "scatterplot")
    .attr("transform", "translate(" + (pad.left*2+pad.right+w) + "," +pad.top + ")");

  // no. data points
  var nind = data.ind.length;
  var nvar = data.var.length;

  var corXscale = d3.scale.ordinal().domain(d3.range(nvar)).rangeBands([0, w]);
  var corYscale = d3.scale.ordinal().domain(d3.range(nvar)).rangeBands([h, 0]);
  var corZscale = d3.scale.linear().domain([-1, 0, 1]).range(["darkslateblue", "white", "crimson"]);

  // create list with correlations
  var corr = [];
  for (var i = 0; i < data.corr.length; i ++) {
    for (var j = 0; j < data.corr[i].length; j ++) {
      corr.push({row:i, col:j, value:data.corr[i][j]});
    }
  }

  // gray background on scatterplot
  scatterplot.append("rect")
    .attr("height", h)
    .attr("width", w)
    .attr("fill", d3.rgb(200, 200, 200))
    .attr("stroke", "black")
    .attr("stroke-width", 1)
    .attr("pointer-events", "none");

  var cells = corrplot.append("g").attr("id", "cells").selectAll("empty")
    .data(corr)
    .enter().append("rect")
    .attr("class", "cell")
    .attr("x", function(d) {
      return(corXscale(d.col))
    })
    .attr("y", function(d) {
      return(corYscale(d.row))
    })
    .attr("width", corXscale.rangeBand())
    .attr("height", corYscale.rangeBand())
    .attr("fill", function(d) {
      return(corZscale(d.value))
    })
    .attr("stroke", "none")
    .attr("stroke-width", 2)
    .on("mouseover", 
      function(d) {
        d3.select(this).attr("stroke", "black")
        corrplot.append("text").attr("id", "corrtext")
          .text(d3.format(".2f")(d.value))
          .attr("x", function(d) {
            mult = -1;
            if (d.col < nvar / 2) {
              mult = +1;
            }
            return(corXscale(d.col) + mult * 30);
          })
          .attr("y", function(d) {
            mult = +1;
            if (d.row < nvar / 2) {
              mult = -1 ;
            }
            return(corYscale(d.row) + (mult + 0.35) * 20);
          })
          .attr("fill", "black")
          .attr("dominant-baseline", "middle")
          .attr("text-anchor", "middle")
        corrplot.append("text").attr("class","corrlabel")
          .attr("x", corXscale(d.col))
          .attr("y", h+pad.bottom*0.2)
          .text(data.var[d.col])
          .attr("dominant-baseline", "middle")
          .attr("text-anchor", "middle")
        corrplot.append("text").attr("class","corrlabel")
          .attr("y", corYscale(d.row))
          .attr("x", -pad.left*0.1)
          .text(data.var[d.row])
          .attr("dominant-baseline", "middle")
          .attr("text-anchor", "end")
      })
    .on("mouseout", 
      function() {
        d3.selectAll("text.corrlabel").remove()
        d3.selectAll("text#corrtext").remove()
        d3.select(this).attr("stroke","none")
      })
    .on("click", function(d) {drawScatter(d.col, d.row)});

  // colors for scatterplot
  var nGroup = d3.max(data.group);
  if (nGroup == 1) {
    var colors = [ d3.rgb(150, 150, 150) ];
  } else if (nGroup <= 3) {
    var colors = ["crimson", "green", "darkslateblue"];
  }
  else {
    if (nGroup <= 10) {
      var colorScale = d3.scale.category10();
    } else {
      var colorScale = d3.scale.category20();
    }
    console.log(d3.range(nGroup))
    // var colors = (colorScale(i) for i of )
  }

  function drawScatter(i,j) {
    d3.selectAll("circle.points").remove()
    d3.selectAll("text.axes").remove()
    d3.selectAll("line.axes").remove()
    xScale = d3.scale.linear()
      .domain(d3.extent(data.dat[i]))
      .range([innerPad, w-innerPad])
    yScale = d3.scale.linear()
      .domain(d3.extent(data.dat[j]))
      .range([h-innerPad, innerPad])
     // axis labels
    scatterplot.append("text")
               .attr("id", "xaxis")
               .attr("class", "axes")
               .attr("x", w/2)
               .attr("y", h+pad.bottom*0.7)
               .text(data.var[i])
               .attr("dominant-baseline", "middle")
               .attr("text-anchor", "middle")
               .attr("fill", "slateblue")
    scatterplot.append("text")
               .attr("id", "yaxis")
               .attr("class", "axes")
               .attr("x", -pad.left*0.8)
               .attr("y", h/2)
               .text(data.var[j])
               .attr("dominant-baseline", "middle")
               .attr("text-anchor", "middle")
               .attr("transform", "rotate(270," + (-pad.left * 0.8) + "," + (h / 2) + ")")
               .attr("fill", "slateblue")
     // axis scales
    xticks = xScale.ticks(5)
    yticks = yScale.ticks(5)
    scatterplot.selectAll("empty")
      .data(xticks)
      .enter()
      .append("text")
      .attr("class", "axes")
      .text(
        function(d) {
          return(d3.format(".2f")(d))
        })
      .attr("x", 
        function(d) {
          return(xScale(d))
        })
      .attr("y", h+pad.bottom*0.3)
      .attr("dominant-baseline", "middle")
      .attr("text-anchor", "middle")
    scatterplot.selectAll("empty")
      .data(yticks)
      .enter()
      .append("text")
      .attr("class", "axes")
      .text(
        function(d) {
          return(d3.format(".2f")(d))
        })
      .attr("x", -pad.left*0.1)
      .attr("y", 
        function(d) {
          return(yScale(d))
        })
      .attr("dominant-baseline", "middle")
      .attr("text-anchor", "end")
    scatterplot.selectAll("empty")
      .data(xticks)
      .enter()
      .append("line")
      .attr("class", "axes")
      .attr("x1", function(d) {
        return(xScale(d))
      })
      .attr("x2", 
        function(d) {
          return(xScale(d))
        })
      .attr("y1", 0)
      .attr("y2", h)
      .attr("stroke", "white")
      .attr("stroke-width", 1)
    scatterplot.selectAll("empty")
      .data(yticks)
      .enter()
      .append("line")
      .attr("class", "axes")
      .attr("y1", 
        function(d) {
          return(yScale(d))
        })
      .attr("y2", 
        function(d) {
          return(yScale(d))
        })
      .attr("x1", 0)
      .attr("x2", w)
      .attr("stroke", "white")
      .attr("stroke-width", 1)
     // the points
    scatterplot.selectAll("empty")
      .data(d3.range(nind))
      .enter()
      .append("circle")
      .attr("class", "points")
      .attr("cx", 
        function(d) {
          return(xScale(data.dat[i][d]))
        })
      .attr("cy", 
        function(d) {
          return(yScale(data.dat[j][d]))
        })
      .attr("r", 3)
      .attr("stroke", "black")
      .attr("stroke-width", 1)
      .attr("fill", 
        function(d) {
          return(colors[data.group[d]-1])
        })
  }

   // boxes around panels
  corrplot.append("rect")
    .attr("height", h)
    .attr("width", w)
    .attr("fill", "none")
    .attr("stroke", "black")
    .attr("stroke-width", 1)
    .attr("pointer-events", "none")

  scatterplot.append("rect")
    .attr("height", h)
    .attr("width", w)
    .attr("fill", "none")
    .attr("stroke", "black")
    .attr("stroke-width", 1)
    .attr("pointer-events", "none")

  // # text above
  corrplot.append("text")
    .text("Correlation matrix")
    .attr("id", "corrtitle")
    .attr("x", w/2)
    .attr("y", -pad.top/2)
    .attr("dominant-baseline", "middle")
    .attr("text-anchor", "middle")

  scatterplot.append("text")
    .text("Scatterplot")
    .attr("id", "corrtitle")
    .attr("x", w/2)
    .attr("y", -pad.top/2)
    .attr("dominant-baseline", "middle")
    .attr("text-anchor", "middle")

  d3.select("div#legend")
    .style("opacity", 1)

}
