// Created by ipbforumskins.com

jQuery.noConflict();

jQuery(document).ready(function($){

	$('a[href=#top], a[href=#ipboard_body]').click(function(){
		$('html, body').animate({scrollTop:0}, 400);
        return false;
	});
	
	$(".forum_name").hover(function() {
		$(this).next(".forum_desc_pos").children(".forum_desc_con").stop()
		.animate({left: "0", opacity:1}, "fast")
		.css("display","block")
	}, function() {
		$(this).next(".forum_desc_pos").children(".forum_desc_con").stop()
		.animate({left: "10", opacity: 0}, "fast", function(){
			$(this).hide();
		})
	});
	
	$("#nav_search a").click(function(){
		$("#toggle_background").slideUp();
		$("#toggle_search").slideToggle();
		$("#main_search").focus();
		return false;
	});
	
	$("#nav_background a").click(function(){
		$("#toggle_search").slideUp();
		$("#toggle_background").slideToggle();
		return false;
	});

	$("#custom_background span").click(function(){
		$.cookie('custom_url',null,{ expires: -5, path: '/'});
		var bgid = $(this).attr("id");
		$.cookie('custombg',bgid,{ expires: 365, path: '/'});
		$("body[data-customBackground]").removeClass().addClass(bgid);
	});
	
	$("#custom_submit").click(function(){
		$.cookie('custombg',"bg_custom",{ expires: 365, path: '/'});
		var customurl = $("#custom_input").val();
		$.cookie('custom_url',customurl,{ expires: 365, path: '/'});
		$("<style type='text/css'>body.bg_custom, .bg_custom .forum_icon, .bg_custom .maintitle, .bg_custom #branding, .bg_custom .col_c_icon img[src*='f_']{ background-image: url(" + customurl + ")}</style>").appendTo("head");
		$("body[data-customBackground]").removeClass().addClass("bg_custom");
	});
		
	if ( ($.cookie('custombg') != null))	{
		$("body[data-customBackground]").addClass($.cookie('custombg'));
	}
	else{
		$("body[data-customBackground]").addClass("bg1");
	}
	
	if ( ($.cookie('custom_url') != null))	{
		$("<style type='text/css'>body.bg_custom, .bg_custom .forum_icon, .bg_custom .maintitle, .bg_custom #branding, .bg_custom .col_c_icon img[src*='f_']{ background-image: url(" + $.cookie('custom_url') + ")}</style>").appendTo("head");
		$("body[data-customBackground]").addClass("bg_custom");
	}
	
	$("#custom_input[placeholder]").focus(function() {
	  var input = $(this);
	  if (input.val() == input.attr("placeholder")) {
		input.val("");
		input.removeClass("placeholder");
	  }
	}).blur(function() {
	  var input = $(this);
	  if (input.val() == "" || input.val() == input.attr("placeholder")) {
		input.addClass("placeholder");
		input.val(input.attr("placeholder"));
	  }
	}).blur();
	
	$('#topicViewBasic').click(function(){
		$(this).addClass("active");
		$('#topicViewRegular').removeClass("active");
		$("#customize_topic").addClass("basicTopicView");
		$.cookie('ctv','basic',{ expires: 365, path: '/'});
		return false;
	});
	
	$('#topicViewRegular').click(function(){
		$(this).addClass("active");
		$('#topicViewBasic').removeClass("active");
		$("#customize_topic").removeClass("basicTopicView");
		$.cookie('ctv',null,{ expires: -1, path: '/'});
		return false;
	});
	
	if ( ($.cookie('ctv') != null))	{
		$("#customize_topic").addClass("basicTopicView");
		$("#topicViewBasic").addClass("active");
	}
	else{
		$("#topicViewRegular").addClass("active");
	}

});