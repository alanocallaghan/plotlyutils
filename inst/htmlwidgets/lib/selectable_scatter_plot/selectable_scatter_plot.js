function selectable_scatter_plot(data, div) {

    const d3 = Plotly.d3;

    var inner = d3.select("#" + div.id)
        .append("div")
        .attr("id", "inner");

    var options = inner
        .append("div")
        .attr("id", "options");

    var plot = inner
        .append("div")
        .attr("id", "plot")

    var plotWidth = plot.clientWidth;
    var plotHeight = plot.clientHeight;

    options.append("span")
        .text("X: ")
    var xSelect = options
        .append("select")
        .attr("id", "xSelect");
    options.append("span")
        .text("Y: ")
    var ySelect = options
        .append("select")
        .attr("id", "ySelect");
    options.append("span")
        .text("Colour: ")
    var colourSelect = options
        .append("select")
        .attr("id", "colourSelect");

    xSelect.on("change", function() {
        xVar = this.options[this.selectedIndex].value;
        draw();
    });

    ySelect.on("change", function() {
        yVar = this.options[this.selectedIndex].value;
        draw();
    });

    colourSelect.on("change", function() {
        colourVar = this.options[this.selectedIndex].value;
        draw();
    });

    var colours = data.colours;
    var colourKeys = Object.keys(colours);
    var keys = Object.keys(data.coords);
    var xVar = defaultX = keys[0];
    var yVar = defaultY = keys[1];
    var colourVar = colourKeys[0];

    for (var key of keys) {
        var option = xSelect.append("option")
            .text(key)
            .attr("value", key)
            .attr("selected", key == defaultX ? "selected": undefined);
        var option = ySelect.append("option")
            .text(key)
            .attr("value", key)
            .attr("selected", key == defaultY ? "selected": undefined);
    }

    for (var colourKey of colourKeys) {
        var option = colourSelect.append("option")
            .text(colourKey)
            .attr("value", colourKey)
            .attr("selected", colourKey == colourKeys[0] ? "selected" : undefined);
    }

    // todo: check if this is good
    plotdiv = plot[0][0];
    
    function draw() {
        var colourby = colours[colourVar];
        if (!colourby.some(function(d) {
            return (typeof d === "string");
        })) {
            var hovertext = [];
            for (var i = 0; i < data.coords[xVar].length; i++) {
                hovertext.push(
                    keys[i] + "<br>" +
                    xVar + ": " + data.coords[xVar][i] + "<br>" +
                    yVar + ": " + data.coords[yVar][i] + "<br>" +
                    colourVar + ": " + colourby[i]
                );
            }

            Plotly.newPlot(plotdiv,
                [{
                    x: data.coords[xVar],
                    y: data.coords[yVar],
                    text: hovertext,
                    hoverinfo: "text",
                    marker: {
                        color: colourby,
                        colorscale: "Viridis",
                        colorbar: {"title": colourVar},
                        size: 10,
                        opacity: 0.8
                    },
                    mode: "markers",
                    type: "scatter"
                }],
                {
                    title: data.title,
                    xaxis: {
                        title: xVar
                    },
                    yaxis: {
                        title: yVar
                    },
                    width: plotWidth,
                    height: plotHeight,
                    hovermode: "closest"
                }
            );

        } else {

            var colour = colourby.filter(onlyUnique);
            var traces = [];
            for (var value of colour) {
                var indices = [];
                var xVals = [];
                var yVals = [];

                var hovertext = [];
                for(var i = 0; i < colourby.length; i++) {
                    if (colourby[i] === value) {
                        xVals.push(data.coords[xVar][i]);
                        yVals.push(data.coords[yVar][i]);
                        indices.push(i);
                        hovertext.push(
                            keys[i] + "<br>" +
                            xVar + ": " + data.coords[xVar][i] + "<br>" +
                            yVar + ": " + data.coords[yVar][i] + "<br>" +
                            colourVar + ": " + colourby[i]
                        );
                    }
                }
                var trace = {
                    name: value === null ? "N/A": value,
                    x: xVals,
                    y: yVals,
                    text: hovertext,
                    hoverinfo: "text",
                    mode: "markers",
                    type: "scatter",
                    marker: {
                        size: 10,
                        opacity: 0.8
                    }
                };
                traces.push(trace);
            }
            Plotly.newPlot(plotdiv,
                traces,
                {
                    xaxis: {
                        title: xVar
                    },
                    yaxis: {
                        title: yVar
                    },
                    title: data.title,
                    width: plotWidth,
                    height: plotHeight,
                    hovermode: "closest"
                }
            );

        }
    }
    window.onresize = function() {
        Plotly.relayout(plotdiv, {
            'width': plotdiv.clientWidth,
            'height': plotdiv.clientHeight
        });
    }

    function onlyUnique(value, index, self) {
        return self.indexOf(value) === index;
    }

    draw()

}
