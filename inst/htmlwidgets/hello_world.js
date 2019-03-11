HTMLWidgets.widget({

  name: "hello_world",

  type: "output",

  factory: function(el, width, height) {
    return {
      renderValue: function(x) {
        hello(el, "world")
      },
      resize: function(x) {
      }
    };
  }
});
