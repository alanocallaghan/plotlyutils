HTMLWidgets.widget({

  name: "twitternetwork",

  type: "output",

  factory: function(el, width, height) {
    return {
      renderValue: function(x) {
        twitternetwork(x, el);
      },
      resize: function(x) {

      }
    };
  }
});
