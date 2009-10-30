// once page is loaded ...
$(document).ready(function(){
  $('a[href=#new_field]').click(function(){
    
    $('#new_fields').prepend("<div class='new_field'><p class='myEditableText sameaslabel'>Write the title here</p><input name='page[new_field]' value='' /></div>");
    
    $('.myEditableText').click(function(){
      editable = $(this)
      
      editable.attr('contentEditable',true);
      editable.addClass('editing'); // style for editing
      editable.focus(); // put cursor in element
      editable.text(''); // clear text
      
      editable.keypress(function(event){
				// move to field input is cancelled if enter is pressed
				if (event.which == 13) {
				  // forward to text input
				  $(editable).parent().children().filter('input').focus();
				  return false
				} else {
				  return event.which
				}
			});
			
      
    });
    
    //  bind an event listener that will be called when
    //  user saves changed content
    $('.editableText').change(function(){
      var newValue = $(this).html();
      
    });
    
    
    
    return false;
  })
});
