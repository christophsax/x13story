
var shinySplitMenu = new Shiny.InputBinding();

// An input binding must implement these methods
$.extend(shinySplitMenu, {
  // This returns a jQuery object with the DOM element
  find: function(scope) {
    return $(scope).find('.shiny-split-menu');
  },

  // return the ID of the DOM element
  getId: function(el) {
    // alert(el.id);   // this should be iSplit, in the example
    return el.id;
  },

  // Given the DOM element for the input, return the value
  getValue: function(el) {

    var values = new Array();
    // collect all ids of all elements within el that have class selected
    $.each($(el).find(".list-group-item.split-selected"), function() {
      values.push($(this).attr('id'));
    });
    // alert(values);
    return values;
  },

  // Given the DOM element for the input, set the value
  setValue: function(el, value) {
    el.value = value;
  },

  // Set up the event listeners so that interactions with the
  // input will result in data being sent to server.
  // callback is a function that queues data to be sent to
  // the server.
  subscribe: function(el, callback) {
    $(el).on('click.shinySplitMenu', function(event) {
     callback(true);
    });
  },

  // Remove the event listeners
  unsubscribe: function(el) {
    $(el).off('.shinySplitMenu');
  },

  // Receive messages from the server.
  // Messages sent by updateUrlInput() are received by this function.
  receiveMessage: function(el, data) {
    // alert(data.value)
    // if (data.hasOwnProperty('id'))
      // alert(data.id)
      // this.setValue(el, data.value);
    // if (data.hasOwnProperty('color'))
      // alert(data.color)


    id = data.id;
    color = data.color;
    disabled_id = data.disabled_id;

// alert("#" + id.replace(".", "\\."))
    
    // alert(disabled_id);

    if (id instanceof Array){
      for (i = 0; i < id.length; i++) {
        // alert(id[i])
        var item = $(el).find("#" + id[i]);
        item.addClass("split-colored");
        item.css("border-left-color", color[i]);
        // alert(item.attr('id'))
      }
    } else {
      var item = $(el).find("#" + id);
      item.addClass("split-colored");
      item.css("border-left-color", color);
    }


    $(el).find(".disabled").removeClass("disabled");

    if (disabled_id instanceof Array){
      for (i = 0; i < disabled_id.length; i++) {
        var item = $(el).find("#" + disabled_id[i])
        item.addClass("disabled");
        item.removeClass("split-colored");
      }
    } else {
        var item = $(el).find("#" + disabled_id)
        item.addClass("disabled");
        item.removeClass("split-colored");
    }



    // alert($('#PLIMOINCHQ.1.G').attr('id'));
    // var item = $(el).find("#" + id);

    // // alert(item.attr('id'))
    

    // item.addClass("split-colored");
    // item.css("border-left-color", color);


    // if (data.hasOwnProperty('label'))
    //   $(el).parent().find('label[for="' + $escape(el.id) + '"]').text(data.label);

    // $(el).trigger('change');
  },

  // This returns a full description of the input's state.
  // Note that some inputs may be too complex for a full description of the
  // state to be feasible.
  // getState: function(el) {
  //   return {
  //     label: $(el).parent().find('label[for="' + $escape(el.id) + '"]').text(),
  //     value: el.value
  //   };
  // },

  // The input rate limiting policy
  // getRatePolicy: function() {
  //   return {
  //     // Can be 'debounce' or 'throttle'
  //     policy: 'debounce',
  //     delay: 500
  //   };
  // }
});

Shiny.inputBindings.register(shinySplitMenu, 'shiny.shinySplitMenu');

