HTMLWidgets.widget({

  name: "hello_world",

  type: "output",

  factory: function(el, width, height) {
    return {
      renderValue: function(x) {
        el.append("Hello, world!")
      },
      resize: function(x) {
      }
    };
  }
});
