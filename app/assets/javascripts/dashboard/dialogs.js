$(function () {
  $('.delete-table').on('click', function(e) {
    e.preventDefault();
    var btnDelete = $(this);
    var table_name = btnDelete.data('name');
    var post_url  = btnDelete.data('url');

    swal({
      title: "Are you sure?",
      text: "Once deleted, '"+table_name+"' table can't be recovered back.",
      type: "warning",
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Yes, delete.",
      showCancelButton: true,
      closeOnConfirm: false,
      showLoaderOnConfirm: true,
    }, function () {
      swal("Deleted!", "Your table has been deleted.", "success");
      setTimeout(function () {
          window.location.href = post_url;
      }, 500);
    });
  });

  $('.delete-collection').on('click', function(e) {
    e.preventDefault();
    var btnDelete = $(this);
    var collection_name = btnDelete.data('name');
    var post_url  = btnDelete.data('url');

    swal({
      title: "Are you sure?",
      text: "Once deleted, '"+collection_name+"' folder can't be recovered back.",
      type: "warning",
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Yes, delete.",
      showCancelButton: true,
      closeOnConfirm: false,
      showLoaderOnConfirm: true,
    }, function () {
      swal("Deleted!", "Your folder has been deleted.", "success");
      setTimeout(function () {
          window.location.href = post_url;
      }, 500);
    });
  });
});
