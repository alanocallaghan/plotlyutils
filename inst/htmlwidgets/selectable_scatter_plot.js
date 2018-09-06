HTMLWidgets.widget({

  name: "selectable_scatter_plot",

  type: "output",

  factory: function(el, width, height) {
    return {
      renderValue: function(x) {
        selectable_scatter_plot(x, el);
      },
      resize: function(x) {
        Plotly.relayout(el, {width:el.width, height: el.height})
      }
    };
  }
});
