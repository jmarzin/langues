$(document).ready(function() {
  $('#italien').click(function (event) {
	if ($('#langue').html() != 'Italien') {
	  $('#langue').html('Italien');
	  $('#deja_maj').html('false')
	}
  });
  $('#anglais').click(function (event) {
	if ($('#langue').html() != 'Anglais') {
	  $('#langue').html('Anglais');
	  $('#deja_maj').html('false')
	}
  });
  $(".controle").click(function (event) {
    langue= $('#langue').html();
	if (langue.indexOf("langue") > -1) {
	  alert("Cliquez d'abord sur un drapeau");
	  event.preventDefault();
	return;
	};
	origine= $(this).text();
    if (origine == 'Paramétrer' || origine == 'Révision') {
      	event.preventDefault();
    };
	if ($('#deja_maj').html() == 'true') {
	    if (origine == 'Paramétrer') {
	    	window.location = "/app/Parametre/saisie";
	    };
	    if (origine == 'Révision') {
	    	window.location = "/app/Revision/pose_question";
	    };
	    return
	};
    $(".chargement").show();
	$.ajax({
		url: "/app/Application/ajax_verif_maj",
		  data: langue,
		  timeout: 600000
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
	    if (origine == 'Paramétrer') {
	    	window.location = "/app/Parametre/saisie";
	    	return
	    };
	    if (origine == 'Révision') {
	    	window.location = "/app/Revision/pose_question";
	    	return
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
			verbes:$('#liste_verbes :checked').map(function() {return $(this).val();}).get().join('$')
  		};
		$.ajax({
			url: "/app/Parametre/stockage",
			  data: param,
			  timeout: 600000
	    }).done(function(message) {
	    	  $('#message').html(message);
	    }).fail(function(request, textStatus, errorThrown) {
	    });
  });
  
  $("#appel").click(function (event) {
	    event.preventDefault();
  		if ($(this).html() == 'Vérifier') {
  			$.ajax({
  				url: "/app/Revision/ajax_verifie",
  				  data: $('#reponse').val(),
  				  timeout: 600000
  		    }).done(function(message) {
  		    	  $('#appel').html('Autre question');
  		    	  $('#bouton .ui-btn-text').html('Autre question');
  		    	  $('#reponse_attendue').html(message.substring(2).split('$')[0]);
  		    	  $('#synthese_session').html(message.split('$')[1]);
  		    	  $('#reponse_attendue').html(message.split('$')[2]);
  		    	  if (message.substring(0,2) == 'ok') {
  		    	  		$('#titre_question').html('Bravo !');
						$('#titre_question').addClass( "vert" );
  		    	  } else {
  		    	  		$('#titre_question').html('Erreur !');
						$('#titre_question').addClass( "rouge" );
  		    	  };
  		    }).fail(function(request, textStatus, errorThrown) {
  		    });
  		} else {
  			$.ajax({
  				url: "/app/Revision/pose_question",
  				  data: 'ajax',
  				  timeout: 600000
  		    }).done(function(message) {
  		    	  if (message == 'vide') {
  		    		window.location = "/app/Revision/plus_rien";
  		    		return;
  		    	  };
  		    	  $('#appel').html('Vérifier');
  		    	  $('#bouton .ui-btn-text').html('Vérifier');
  		    	  $('#reponse_attendue').html('<br>');
  		    	  $('#titre_question').removeClass("vert rouge");
  		    	  $('#titre_question').html('Question');
  		    	  $('#question').html(message);
  		    	  $('#reponse').val('');
  		    	  $('#reponse').focus();
  		    }).fail(function(request, textStatus, errorThrown) {
  		    });  			
  		};
  });
});