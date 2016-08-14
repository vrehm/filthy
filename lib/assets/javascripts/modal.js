$( document ).ready(function(){
  var  $body = $("body");
  
  $(document).on({
      ajaxStart: function() { $body.addClass("loading");    },
      ajaxStop: function() { $body.removeClass("loading");  }    
  }); 
})

var $element = $('.col-button'),

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