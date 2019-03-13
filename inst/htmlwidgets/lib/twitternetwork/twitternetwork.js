var s
function twitternetwork(x, el) {

  var d3 = Plotly.d3;
  var nodes = x.nodes;
  var links = x.links;
  var threshold = 0;

  var counts = nodes.map(
    function(d) {
      return(d.name)
    }
  ).map(
      function(d) {
        return(
          {
            count: links.map(
              function(d) {
                return(d.target)
              }).filter(function(n) {
                return(nodes[n].name === d);
              }).length,
            name: d
          }
        );
    }
  );

  var max = d3.max(
    counts.map(
      function(d) {
        return(d.count);
      }
    )
  );

  var slidecontainer = d3.select("#" + el.id)
    .append("div")
    .attr("class", "slidecontainer");
  var slider = slidecontainer
    .append("input")
    .attr("width", el.clientWidth)
    .attr("class", "slider")
    .attr("type", "range")
    .attr("min", 0)
    .attr("max", max)
    .attr("value", 0)
    .attr("id", "myRange")
    .on("input", function() {
      threshold = this.value;
      redraw();
    });

  var axisScale = d3.scale.linear()
    .domain([0, max])
    .range([0, slidecontainer[0][0].clientWidth]);
  var axis = d3.svg.axis()
    .scale(axisScale)
    .tickFormat(function(d) {
      return d3.format("d")(d);
    });
  var axisG = slidecontainer.append("svg")
    .attr("width", el.clientWidth)
    .attr("height", 22.5)
    .attr("overflow", "visible")
    .append("g")
    .call(axis);
  d3.select("path").remove();

  nodes = nodes.map(function(d) {
    count = counts.filter(function(t) {
      return(t.name === d.name);
    })[0].count;
    d.count = count;
    return(d);
  });


  var svg = d3.select("#" + el.id).append("svg")
    .attr("width", el.clientWidth)
    .attr("height", el.clientHeight)
    .attr("id", "mysvg");

  var force = d3.layout.force()
    .gravity(0.05)
    .distance(100)
    .charge(-50)
    .size([el.clientWidth, el.clientHeight])
    .nodes(nodes)
    .links(links)
    .start();

  var link = svg.selectAll(".link")
    .data(x.links)
    .enter().append("line")
    .attr("class", "link")
    .style("stroke-width", function(d) {
      // return Math.sqrt(d.weight);
      var c = nodes.filter(function(n) {
        return(n.name === d.source.name)
      })[0].count;
      return (c >= threshold ? 2: 0);
    });

  var node = svg.selectAll(".node")
    .data(x.nodes)
    .enter().append("g")
    .attr("class", "node")
    .call(force.drag);
  var node_circles = node.insert("circle")
    .attr("r", function(d) {
      return(d.count >= threshold ? "5": "0");
    });

  var node_text = node.insert("text")
    .attr("dx", 12)
    .attr("dy", ".35em")
    .text(function(d) {
      return (d.count >= threshold ? d.name: "");
    });

  force.on("tick", function() {
    link.attr("x1", function(d) { return (d.source.x); })
        .attr("y1", function(d) { return (d.source.y); })
        .attr("x2", function(d) { return (d.target.x); })
        .attr("y2", function(d) { return (d.target.y); });
    node.attr("transform", function(d) {
      return ("translate(" + d.x + "," + d.y + ")");
    });
  });

  function redraw() {
    link.style("stroke-width", function(d) {
      var c = nodes.filter(function(n) {
        return(n.name === d.target.name)
      })[0].count;
      return (c >= threshold ? 2: 0);
    });
    node_circles.attr("r", function(d) {
      return(d.count >= threshold ? "5": "0");
    });
    node_text.text(function(d) {
      return(d.count >= threshold ? d.name: "");
    });
  }
  redraw();

  window.onresize = function(event) {
    svg.attr("width", el.clientWidth)
      .attr("height", el.clientHeight);
    force.stop();
    force.size([el.clientWidth, el.clientHeight]);
    force.start();
  };
  function onlyUnique(value, index, self) {
      return self.indexOf(value) === index;
  }
}
