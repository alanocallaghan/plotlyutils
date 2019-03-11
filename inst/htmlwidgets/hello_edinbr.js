HTMLWidgets.widget({

  name: "hello_edinbr",

  type: "output",

  factory: function(el, width, height) {
    return {
      renderValue: function(x) {
        hello(el, "Edinbr")
      },
      resize: function(x) {
      }
    };
  }
});
