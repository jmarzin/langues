require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'modules/objet'

class RevisionController < Rho::RhoController
  include BrowserHelper


  def question
    $session[:nb_ok] ||= 0
    $session[:nb_ko] ||= 0
    $session[:pour_cent] ||= 0
    @mot_tire = Objet.tirage(Mot)
    if @mot_tire then
      $session[:question] = @mot_tire
      render :back =>'/app'
    else
      render :action => :plus_rien, :back => '/app'
    end
  end
  
  def reponse
    if Objet.egaux(@params["reponse"].force_encoding("UTF-8"),$session[:question].langue.force_encoding("UTF-8")) then
      $session[:question].reduit_poids
      $session[:nb_ok] += 1
      $session[:pour_cent]= $session[:nb_ok]*100/($session[:nb_ok]+$session[:nb_ko])
      render :action => :bravo, :back => url_for(:action => :question)
    else
      $session[:question].augmente_poids
      $session[:nb_ko] += 1
      $session[:pour_cent]= $session[:nb_ok]*100/($session[:nb_ok]+$session[:nb_ko])
      render :action => :erreur, :back => url_for(:action => :question)
    end
  end
  
  def bravo
  end
  
  def erreur
  end

  def plus_rien
  end
  
  def question_f
    $session[:nb_ok] ||= 0
    $session[:nb_ko] ||= 0
    $session[:pour_cent] ||= 0
    @forme_tire = Objet.tirage(Forme)
    if @forme_tire then
      $session[:question] = @forme_tire
      render :back =>'/app'
    else
      render :action => :plus_rien, :back => '/app'
    end
  end
  
  def reponse_f
    if Objet.egaux(@params["reponse"].force_encoding("UTF-8"),$session[:question].langue.force_encoding("UTF-8")) then
      $session[:question].reduit_poids
      $session[:nb_ok] += 1
      $session[:pour_cent]= $session[:nb_ok]*100/($session[:nb_ok]+$session[:nb_ko])
      render :action => :bravo_f, :back => url_for(:action => :question_f)
    else
      $session[:question].augmente_poids
      $session[:nb_ko] += 1
      $session[:pour_cent]= $session[:nb_ok]*100/($session[:nb_ok]+$session[:nb_ko])
      render :action => :erreur_f, :back => url_for(:action => :question_f)
    end
  end
  
  def bravo_f
  end
  
  def erreur_f
  end

  def plus_rien
  end
end
