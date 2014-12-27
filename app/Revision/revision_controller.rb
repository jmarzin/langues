require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'modules/objet'
class RevisionController < Rho::RhoController
  include BrowserHelper


  def pose_question
    $session[:nb_ok] ||= 0
    $session[:nb_ko] ||= 0
    $session[:pour_cent] ||= 0
    $session[:param][:objet] ||= 'Mot'
    $session[:question] = Objet.tirage(Object.const_get($session[:param][:objet]))
    if $session[:question] then
      if @request["request-query"] == 'ajax' then
        render :string => $session[:question][:texte], :use_layout_on_ajax => true 
      else
        render :back => '/app'
      end
    else
      if @request["request-query"] == 'ajax' then
        render :string => "vide", :use_layout_on_ajax => true 
      else
        render :action => :plus_rien, :back => '/app'
      end
    end
  end
  
  def ajax_verifie
#    reponse = URI.decode(@request["request-query"])
    reponse = @request["request-query"].uri_decode
    if Objet.egaux(reponse.force_encoding("UTF-8"),$session[:question][:objet].langue.force_encoding("UTF-8")) then
      $session[:question][:objet].reduit_poids
      $session[:nb_ok] += 1
      $session[:pour_cent]= $session[:nb_ok]*100/($session[:nb_ok]+$session[:nb_ko])
      @message = "ok"
    else
      $session[:question][:objet].augmente_poids
      $session[:nb_ko] += 1
      $session[:pour_cent]= $session[:nb_ok]*100/($session[:nb_ok]+$session[:nb_ko])
      @message = "ko"
    end
    @message += $session[:question][:objet].langue + '$' +
                "#{$session[:nb_ko]+$session[:nb_ok]} questions : #{$session[:pour_cent]} " +
                "% (poids restants = #{$session[:liste].count})$"
    if $session[:question][:objet].prononciation then 
      p = "[#{$session[:question][:objet].prononciation}] " 
    else 
      p="" 
    end
    @message += "#{$session[:question][:objet].langue} #{p}(poids #{$session[:question][:objet].poids})"
    render :string => @message, :use_layout_on_ajax => true 
  end

  def plus_rien
  end
end
