// $(document).on('ready page:load', function () {
document.addEventListener("turbolinks:load", function() {
  // event listener for radio buttons; as soon as one of them is selected, the
  // submit button is re-enabled
  $('.radio-btn').on('click', function() {
    $('.submit-btn').prop('disabled', false);
    $('.submit-btn').removeClass('cursor-not-allowed');
  });

  $('[data-toggle="popover"]').popover({ trigger: 'hover' });
})
// });
