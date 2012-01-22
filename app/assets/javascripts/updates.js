$(function(){
  $('.comment-input').click(function(){
    var par = $(this).parent();
    par.children('.comment-submit').show();
    par.blur(function(){
      $(this).children('.comment-submit').hide();
    });
  });
});
