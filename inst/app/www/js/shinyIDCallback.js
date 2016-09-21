
var shinyIDCallback = new Shiny.InputBinding();



// An input binding must implement these methods
$.extend(shinyIDCallback, {


  // This returns a jQuery object with the DOM element
  find: function(scope) {
    // return $(scope).find('.saxophon');
    return $(scope).find('.shiny-id-callback');
  },

  // return the ID of the DOM element
  getId: function(el) {
    alert(el.id);
    return el.id;
  },

  // Given the DOM element for the input, return the value
  getValue: function(el) {







// var v = $(el).find("#sax").attr('id');
// alert(v);

    // var values = $(".shiny-id-el").attr('id')



    // $(".shiny-id-el").on('click', function(event) {
    // // $(el).find("panel-body").on('click', function(event) {
    //   alert("hy");


    //    // values.push($(".shiny-id-el").attr('id'));
    //   // callback(false);
    //   // When called with false, it will NOT use the rate policy,
    //   // so changes will be sent immediately
    // });

    // hacky, but it works: main series
   
    // $.each($(el).find(".shiny-id-el"), function() {
    //   values.push($(this).attr('id'));
    // });

    var values = new Array();

    
    // $(".shiny-id-callback").on('click', function(event) {
    // // $(el).find("panel-body").on('click', function(event) {
    //   // alert("hy");
    //   var values = new Array();
    //   // When called with false, it will NOT use the rate policy,
    //   // so changes will be sent immediately
    // });

    // $.each($(el).find(".shiny-id-el"), function() {
    //   values.push($(this).attr('id'));
    // });
    
    // $(".shiny-id-el").on('click', function(event) {
    // // $(el).find("panel-body").on('click', function(event) {
    //   // alert("hy");
    //   var values = new Array();
    //   alert($(event.target).attr('id'));
    //   values.push($(event.target).attr('id'));
    //   // When called with false, it will NOT use the rate policy,
    //   // so changes will be sent immediately
    // });

    $.each($(el).find(".shiny-id-el.active"), function() {
            alert("dfsdf");

      values.push($(this).attr('id'));
      if ($(this).hasClass("shiny-force")) {
        values.push(Math.random());  // to cause reevaluateion at each click

      }
    });




   
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
    // $(el).on('keyup.shinyIDCallback click.shinyIDCallback', function(event) {
    //   callback(true);
    //   // When called with true, it will use the rate policy,
    //   // which in this case is to debounce at 500ms.
    // });
    // $(el).find("a").on('click', function(event) {
    //   callback(false);
    //   // When called with false, it will NOT use the rate policy,
    //   // so changes will be sent immediately
    // });

    // $(el).find("select").on('change', function(event) {
    //   callback(false);
    //   // When called with false, it will NOT use the rate policy,
    //   // so changes will be sent immediately
    // });

    $(el).on('click.shinyIDCallback', function(event) {

      // $(el).find("panel-body")

    // $(el).find("panel-body").on('click', function(event) {
      // alert("hy");
      callback(true);
      // When called with false, it will NOT use the rate policy,
      // so changes will be sent immediately
    });
  },

  // Remove the event listeners
  unsubscribe: function(el) {
    $(el).off('.shinyIDCallback');
  },

  // Receive messages from the server.
  // Messages sent by updateUrlInput() are received by this function.
  // receiveMessage: function(el, data) {
  //   if (data.hasOwnProperty('value'))
  //     this.setValue(el, data.value);

  //   if (data.hasOwnProperty('label'))
  //     $(el).parent().find('label[for="' + $escape(el.id) + '"]').text(data.label);

  //   $(el).trigger('change');
  // },

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

Shiny.inputBindings.register(shinyIDCallback, 'shiny.shinyIDCallback');




// $( document ).ready(function() {

//   $(".shinylist-group a.list-group-item").click(function() {
//     // alert(this.id); // get id of clicked li
//     // $('.small').not($(this)).removeClass('small');
//     $(this).toggleClass('active');

//   });
// });


                        
