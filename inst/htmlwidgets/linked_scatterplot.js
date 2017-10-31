HTMLWidgets.widget({

  name: "linked_scatterplot",
  
  type: "output",
  
  factory: function(el, width, height) {    
    return {
      renderValue: function(x) {
        linked_scatterplot(x, el);
      },
      resize: function(x) {
        Plotly.relayout(el, {width:el.width, height: el.height})
      }
    };
  }
});
