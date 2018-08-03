HTMLWidgets.widget({

  name: "manyboxplots2",
  
  type: "output",
  
  factory: function(el, width, height) {    
    return {
      renderValue: function(x) {
        draw2(x, el);
      }
      ,
      resize: function(x) {
        Plotly.relayout(el, {width:el.width, height: el.height})
      }
    };
  }
});
