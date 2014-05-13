// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree ./bootstrap

$(document).ready(function() {

  $(document).on("submit", "#new_comment", function() {
    var current = $(this);
    remove_error_signatures(current);
    $.ajax({
      url: $(current).attr("action"),
      type: 'post',
      dataType: 'json',
      data: $(current).serialize(),
      success: function(response) {
        $("#comments").html(response.partial);
      }, error: function(response) {
        add_errors(current, response);
      }
    });
    $("html, body").animate({ scrollTop:  $(current).offset().top - 50 }, 'slow');
    return false;
  });

  $(document).on("submit", ".edit_comment", function() {
    var current = $(this);
    remove_error_signatures(current);
    $.ajax({
      url: $(current).attr("action"),
      type: 'put',
      dataType: 'json',
      data: $(current).serialize(),
      success: function(response) {
        var panel_body = $(current).parents(".panel-body:first");
        var panel_heading = $(panel_body).prev(".panel-heading");
        $(panel_heading).before(response.partial);
        $(panel_body).remove();
        $(panel_heading).remove();
      }, error: function(response) {
        add_errors(current, response);
      }
    });
    //$("html, body").animate({ scrollTop:  $(current).offset().top - 50 }, 'slow');
    return false;
  });

  $(document).on("click", ".edit_comment_data", function(event) {
    event.preventDefault();
    var current = $(this);
    $.ajax({
      url: $(current).attr("href"),
      type: 'get',
      dataType: 'json',
      success: function(response) {
        $(current).parents(".panel-heading:first").next(".panel-body").find(".comments_data").html(response.partial);
      }
    });   
  });

  $(document).on("click", ".close_errors", function() {
    $(this).parents(".error_explanation:first").addClass("hide");
    return false;
  });

  $(document).on("click", ".destroy_comment", function(event) {
    event.preventDefault();
    var current = $(this)
    $(current).parents(".row:first").find(".destroy_errors").html("");
    $(current).parents(".row:first").find(".destroy_errors").show().addClass("hide");
    if (confirm("Are you sure?")) {
      $.ajax({
        url: $(this).attr("href"),
        type: "delete",
        dataType: 'json',
        success: function(response) {
          $("#comments").html(response.partial);
        }, error: function(response) {
          var response = $.parseJSON(response.responseText);
          $(current).parents(".row:first").find(".destroy_errors").html(response.error_message);
          $(current).parents(".row:first").find(".destroy_errors").removeClass("hide").delay(5000).fadeOut('slow');
        }
      });
      //$('html, body').animate({ scrollTop:  $("#new_comment").offset().top - 50 }, 'slow');
    }
  });

});

function remove_error_signatures(current) {
  var errors_dom = $(current).find(".error_explanation:first");
  $(errors_dom).find(".error_details:first").html("");
  $(errors_dom).addClass("hide");
  $(current).find(".error_field").each(function(index, field) {
    $(field).removeClass("error_field");
  });
}

function add_errors(current, response) {
  var errors_dom = $(current).find(".error_explanation:first");
  try {
    var response = $.parseJSON(response.responseText);
    if(Object.keys(response).length > 0) {
      $.each(response.error_fields, function(index, value) {
        $(current).find("[name$='["+ index +"]']").addClass("error_field");
      });
      $(errors_dom).find(".error_details:first").html(response.error_message);
      $(errors_dom).removeClass("hide");
    }
  } catch(e) {
    $(errors_dom).find(".error_details:first").html("Sorry! the action failed due to some internal error.");
    $(errors_dom).removeClass("hide");
  }
}
