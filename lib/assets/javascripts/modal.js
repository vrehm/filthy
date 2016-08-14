$( document ).ready(function(){

  var $element = $('.col-button'),
      $body = $("body");

  $(document).on({
      ajaxStart: function() { $body.addClass("loading");    },
      ajaxStop: function() { $body.removeClass("loading");  }    
  });

  $element.on('click', function() { 
    var id = $(this).data('id'); 

    $.ajax({
      type: 'GET',
      data: 'json',
      url: "/collections/:"+id,
      dataType: 'JSON',
      success: function(data) {
        console.log(data);
      }
    });

  });    
})