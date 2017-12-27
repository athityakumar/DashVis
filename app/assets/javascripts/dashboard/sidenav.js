$(function(){
  var current = location.pathname;
  $('#leftsidebar li a').each(function(){
      var $this = $(this);
      console.log($this);
      // if the current path is like this link, make it active
      if($this.attr('href') === current){
        $this.parent().addClass('active');
      }
  })
})