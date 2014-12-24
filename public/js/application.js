$(document).ready(function() {
  $('#italien').click(function (event) {
	$('#langue').html('Italien');
  });
  $('#anglais').click(function (event) {
	$('#langue').html('Anglais');
  });
  $(".controle").click(function (event) {
	langue= $('#langue').html();
	if (langue.indexOf("langue") > -1) {
		alert("Cliquez d'abord sur un drapeau");
		event.preventDefault();
		return;
	};
	$(".chargement").show();
	$.ajax({
	      url: "/app/Application/verif_maj",
		  data: langue,
		  timeout: 0
	  }).done(function(data) {
		  $(".chargement").hide();
	      if (data == '') {
	    	  return;
	      }
	      alert(data);
	      if (data.indexOf("inconnu") > -1) {
	    	  $('#langue').html('Choisissez la langue');
	    	  event.preventDefault();
	    	return;
	      };
	  }).fail(function(request, textStatus, errorThrown) {
		  $(".chargement").hide();
	      alert("An error occurred: "+errorThrown);
	      event.preventDefault();
	      return;
	});
  });
});
