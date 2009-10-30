// once page is loaded ...
$(document).ready(function(){
  $('a[href=#new_field]').click(function(){
    
    $('#new_fields').prepend("<div class='new_field'><p class='editableText sameaslabel'>Write the title here</p><input name='page[new_field]' value='' /></div>");
    
    // $('#new_fields div:first').highlight();
    // $('#new_fields div:first label')[0].textContent = 'hi'
    // $('#new_fields div:first p').change(function() {
    //   alert('hi');
    // })
    
    $('.editableText').editableText({
         // default value
         newlinesEnabled: false
    });
    
    //  bind an event listener that will be called when
    //  user saves changed content
    $('.editableText').change(function(){
      var newValue = $(this).html();
      

          // do something
          // For example, you could place an AJAX call here:
        //  $.ajax({
        //    type: "POST",
        //    url: "some.php",
        //    data: "newfieldvalue=" + newValue,
        //    success: function(msg){
        //      alert( "Data Saved: " + msg );
        //    }
        // });
    });
    
    
    
    return false;
  })
});
