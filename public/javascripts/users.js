$(function(){
  $("#add-email-address-field").click(function(){
    var p = $(this).parent().prev();
    p.clone().insertAfter(p).children(":first").val('');
    return false;
  });
});