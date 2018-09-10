HTMLWidgets.widget({

  name: "selectable_histogram",

  type: "output",

  factory: function(el, width, height) {
    return {
      renderValue: function(x) {
        selectable_histogram(x, el);
      },
      resize: function(x) {
        Plotly.relayout(el, {width:el.width, height: el.height})
      }
    };
  }
});
