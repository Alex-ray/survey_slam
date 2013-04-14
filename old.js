$(document).ready(function() {
  hideForm('.header_form');
  hideForm('.survey_form');
  navButtonHide('fade');
  logged_in = false;

  $('nav').click(function(event){
    $target = $(event.target);

    if ($target != $('button')) {
      if (logged_in){
        loginSuccess();
      } else {
        navButtonHide('fade');
      }
      $('.header_form').slideUp(100);
    }
  });

  $(document).on('click', 'button', function(event) {
    var $target = $(event.target);

    if ($target.is('.signup')) {signupForm()}

    if ($target.is('.login')) {loginForm()}

    if ($target.is('.logout')) {logOut()}
  });

  $('.header_form').submit(function(e) {
    e.preventDefault();

    var url = $(this).attr('action');
    var data = $(this).serialize();
    console.log(this);

    $.post(url, data, function(data){

      if (data === "false") {
        loginSuccess();
        logged_in = true;
      } else {
        $('header').append('<span class="errors">'+data+'</span>');
      }

    });

    return false;
  });

});

var logOut = function() {
  $.post('/logout',{},function(){
    hideForm('.header_form');
    navButtonHide('fade');
    logged_in = false;
  });
}

var loginSuccess = function() {
  $('.header_form').slideUp('fast');
  $('.signup').hide();
  $('.login').hide();
  $('.logout').show();
  $('.survey').show();
}

var signupForm = function() {
  $('.header_form').attr('action', '/signup');
  $('button.signup').hide();
  $('button.login').show();
  $('.header_form button').text('Sign Up');
  $('.header_form').slideDown(100);
}

var loginForm = function() {
  $('.header_form').attr('action', '/login');
  $('button.login').hide();
  $('button.signup').show();
  $('.header_form button').text('Log In');
  $('.header_form').slideDown(100);
}

var hideForm = function(form) {
  $(form).hide();
}

var navButtonHide = function(state_change) {
  if (state_change === 'fade') {
    $('.survey').hide();
    $('.logout').hide();
    $('.signup').fadeIn('fast');
    $('.login').fadeIn('fast');
    $('span').remove();
  } else {
    $('.logout').hide();
    $('.signup').show();
    $('.login').show();
    $('span').remove();
  }
}
