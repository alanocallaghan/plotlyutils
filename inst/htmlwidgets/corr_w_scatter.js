HTMLWidgets.widget({

  name: "corr_w_scatter",
  
  type: "output",
  
  factory: function(el, width, height) {    
    return {
      renderValue: function(x) {
        draw(x, el);
      },
      resize: function(x) {
        Plotly.relayout(el, {width:el.width, height: el.height})
      }
    };
  }
});
