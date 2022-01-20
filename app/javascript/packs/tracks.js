document.addEventListener("turbolinks:load", function() {

  $input = $('*[data-behavior="autocomplete"]');

  var options = {
    url: function(phrase) {
      return "/tracks/search.json?t=" + phrase;
    },
    getValue: "title",
  };

  $input.easyAutocomplete(options);

  
});






