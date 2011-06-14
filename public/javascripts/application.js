$(function(){
  defaultText($('#search_query'),'Search');

  $.waypoints.settings.scrollThrottle = 30;
  $('#inner-header').waypoint(function(e,direction){
    if (direction === 'down'){
      $('#nav-holder').css('position','fixed');
    } else {
      $('#nav-holder').css('position','absolute');
    }
  });
});

/*
 * utility functions that encompass common patterns
 */

// clicking on the element 'button' toggles the display
// of the element 'elem'. 'elem' hidden by default.
function toggle(button,elem){
  button.click(function(e){
    e.preventDefault();
    if (elem.css('display') === 'none') elem.show();
    else                                elem.hide();
  });
};

// hides default text in a text input when clicked on
// and makes sure default text doesn't get submitted
function defaultText(textInput,text){
  function hideText(){
    if (textInput.val() === text) {
      textInput.val('');
      textInput.removeClass('default-text');
    }
  };
  function showText(){
    if (textInput.val() === '') {
      textInput.val(text);
      textInput.addClass('default-text');
    };
  };
  showText(); // this gets called once at start to set text
  textInput.click(hideText).blur(showText);
  textInput.parents('form').submit(hideText);
}

