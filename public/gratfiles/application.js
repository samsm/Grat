// once page is loaded ...
$(document).ready(function(){
  $('.template select').change(function() {
    // if template has url
    selected_option = $(this).val()
    if (selected_option) {
      // look up template data
      $.getJSON(selected_option, {ajax: 'true'}, function(j) {
        for (var i = 0; i < j.length; i++) {
          // place fields in form
          console.log('hi');
        }
      })
    }
  })
  
  // New field button + features
  $('a[href=#new_field]').click(function(){
    
    $('#new_fields').prepend("<div class='new_field'><p class='myEditableText sameaslabel'>Write the title here</p><input name='content[new_field]' value='' /></div>");
    
    // upon click make label editable and other junk associated with customizing the new field
    $('.myEditableText').click(function(){
      editable = $(this);
      
      editable.attr('contentEditable',true);
      editable.addClass('editing'); // style for editing
      editable.focus(); // put cursor in element
            
      // this should only clear if default text is in there
      if (!editable[0].className.match(/edited/)) {
        editable.text(''); // clear text
        editable.addClass('edited')
      }
      
      // On focus of input, change name= to correspond to p sibling
      editable.parent().children().filter('input').focus(function() {
        input = $(this);
        key = input.parent().children().filter('p').text();
        // need to sanitize key
        sanitized_key = key.replace(/[^a-zA-Z]/g,'_').toLowerCase().replace(/[^a-z]/,'').toLowerCase()
        new_name = 'content[' + sanitized_key + ']';
        
        input.attr('name',new_name);
      })
      
      // Move to input field on enter
      editable.keypress(function(event){
        
        // move to field input is cancelled if enter is pressed
        if (event.which == 13) {
          
          // Remove editing class -- should add edited class maybe
          editable.removeClass('editing');
          
          // forward to text input
          $(editable).parent().children().filter('input').focus();
          return false
        } else {
          return event.which
        }
      });
      
      editable.change(function() {
        console.log('blur');
        editable.removeClass('editing');
      })
      
    });
    
    //  bind an event listener that will be called when
    //  user saves changed content
    $('.editableText').change(function(){
      var newValue = $(this).html();
    });
    
    
    
    return false;
  })
  
  // Beautify default data textarea
  $('#default_content_vars').each(function() {
    this.innerHTML = js_beautify(this.innerHTML, {'indent_size':2});
  })
  
});
