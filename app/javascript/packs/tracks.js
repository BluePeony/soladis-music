document.addEventListener("turbolinks:load", function() {

  $input = $('*[data-behavior="autocomplete"]');

  //var availableTags = {
  //  url: function(phrase) {
  //    return "/tracks/search.json?t=" + phrase;
  //  },
  //  getValue: "label",
  //};

  //$input.easyAutocomplete(options);

  function split( val ) {
    return val.split( /,\s*/ );
  }
  function extractLast( term ) {
    return split( term ).pop();
  }

  $input
  	.on( "keydown", function( event ) {
      if ( event.keyCode === $.ui.keyCode.TAB &&
          $( this ).autocomplete( "instance" ).menu.active ) {
        event.preventDefault();
      }
    })
    .autocomplete({
      minLength: 0,
      source: function( request, response ) {
	      $.ajax({
				  url: "/tracks/search.json",
				  data: { t: extractLast(request.term) },
				  success: function (data) {
				      var transformed = $.map(data, function (el) {
				          return {
				              value: el.title
				          };
				      });
				      response(transformed);
				  },
				  error: function () {
				      response([]);
				  }
				});
      },
      focus: function() {
        // prevent value inserted on focus
        return false;
      },
      select: function( event, ui ) {
        var terms = split( this.value );
        // remove the current input
        terms.pop();
        // add the selected item
        terms.push( ui.item.value );
        // add placeholder to get the comma-and-space at the end
        terms.push( "" );
        this.value = terms.join( ", " );
        return false;
      }
    });
});






