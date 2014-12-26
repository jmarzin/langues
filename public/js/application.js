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
	origine= $(this).text();
    if (origine == 'Parametrer') {
      	event.preventDefault();
    };
	$(".chargement").show();
	$.ajax({
		url: "/app/Application/verif_maj",
		  data: langue,
		  timeout: 0
    }).done(function(data) {
    	$(".chargement").hide();
	      if (data.indexOf("inconnu") > -1) {
	    	  $('#langue').html('Choisissez la langue');
	    	  event.preventDefault();
	    	  return;
	      };
	      if (data != 'ok') {
		      alert(data);
	      };
	      if (origine == 'Parametrer') {
	      	event.preventDefault();
	      	window.location = "/app/Parametre/saisie";
	      };
    }).fail(function(request, textStatus, errorThrown) {
    });
  });

  $('#objet').change(function(){
	    if($('#objet').val() == 'Mot'){
	        $('#liste_themes').show();
	        $('#liste_verbes').hide();
	    } else {
	        $('#liste_themes').hide();
	        $('#liste_verbes').show();
	};
  });
  $("#reconstruire").click(function (event) {
  		param= {objet:$('#objet' ).val(),
  			poids_min:$('#poids_min').val(),
			age_rev_min:$('#age_rev_min').val(),
			age_rev_min:$('#err_min').val(),
			themes:$('#liste_themes :checked').map(function() {return $(this).val();}).get().join('$'),
			verbes:$('#liste_verbes :checked').map(function() {return $(this).val();}).get().join('$'),
  		};
		$.ajax({
			url: "/app/Parametre/stockage",
			  data: param,
			  timeout: 0
	    }).done(function(message) {
	    	  $('#message').html(message);
	    }).fail(function(request, textStatus, errorThrown) {
	    });
  });
});
