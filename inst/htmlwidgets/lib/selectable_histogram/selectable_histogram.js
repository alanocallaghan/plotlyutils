function selectable_histogram(data, div) {

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

    xSelect.on("change", function() {
        xVar = this.options[this.selectedIndex].value;
        draw();
    });

    var keys = Object.keys(data.coords);
    var xVar = defaultX = keys[0];

    for (var key of keys) {
        var option = xSelect.append("option")
            .text(key)
            .attr("value", key)
            .attr("selected", key == defaultX ? "selected": undefined);
    }

    var plotdiv = document.getElementById("plot");

    function draw() {

        // var hovertext = [];
        // for (var i = 0; i < data.coords[xVar].length; i++) {
        //     hovertext.push(
        //         names[i] + "<br>" +
        //         xVar + ": " + data.coords[xVar][i] + "<br>" +
        //         yVar + ": " + data.coords[yVar][i] + "<br>" +
        //         colourVar + ": " + colourby[i]
        //     );
        // }
        Plotly.newPlot(plotdiv,
            [{
                x: data.coords[xVar],
                // text: hovertext,
                // hoverinfo: "text",
                histnorm: data.histnorm,
                type: 'histogram',
                autobinx: false,
                nbinsx: Math.round(freedmanDiaconisBreaks(data.coords[xVar])),

            }],
            {
                title: data.title,
                xaxis: {
                    title: xVar
                },
                // Count or density as above
                yaxis: {
                    title: data.histnorm == "" ? "Count" : capitalise(data.histnorm)
                },
                width: plotWidth,
                height: plotHeight,
                hovermode: "closest"
            }
        );
    }
    draw()
}

window.onresize = function() {
    Plotly.relayout(plotdiv, {
        'width': plotdiv.clientWidth,
        'height': plotdiv.clientHeight
    });
}

function freedmanDiaconisBreaks(nums) {
    return(2 * IQR(nums) / Math.cbrt(nums.length));
}

function IQR(nums) {
    var med = median(nums);
    var lower, higher;
    if (nums % 2 == 0) {
        lower = takeN(nums, 0, nums.length / 2);
        upper = takeN(nums, (nums.length / 2) + 1, nums.length);
    } else {
        lower = takeN(nums, 0, Math.floor(nums.length / 2));
        upper = takeN(nums, Math.floor(nums.length / 2) + 1, nums.length);
    }   
    return(median(upper) - median(lower)) 
}

function median(nums) {
    nums.sort();
    if (nums.length % 2 == 0) {
        var midish = nums.length / 2;
        return((nums[midish - 1] + nums[midish]) / 2);
    } else {

        return(nums[Math.ceil(nums.length / 2) - 1]);
    }
}

function takeN(nums, start, end) {
    out = [];
    for (var i = start; i < end; i++) {
        out.push(nums[i]);
    }
    return(out);
}
