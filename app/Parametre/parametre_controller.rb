require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'date'
require 'modules/objet'

class ParametreController < Rho::RhoController
  include BrowserHelper

  # GET /Mot
  def saisie
    $session[:param] ||= {}
    $session[:param][:themes] ||= []
    $session[:param][:verbes] ||= []
    $session[:liste] ||= []
    @nb = $session[:liste].uniq.size
    @message = "#{@nb} #{'élément'.pluralize(@nb)} dans la liste"
    render :back => '/app'
  end
  
  def stockage
    $session[:param][:objet] = @params["objet"]
    if @params["themes"] then
      $session[:param][:themes] = @params["themes"].values
    else
      $session[:param][:themes] = []
    end
    if @params["verbe_id"] == "" then 
      $session[:param][:verbes] = []
    else
      $session[:param][:verbes] = [@params["verbe_id"]]
    end
    $session[:param][:poids_min] = "%05d" % @params["poids_min"].to_i
    $session[:param][:age_rev_min] = @params["age_rev_min"]
    if $session[:param][:age_rev_min] == "" then
      $session[:param][:date_rev_max] = Date.today.to_s
    else
      $session[:param][:date_rev_max] = (Date.today-@params["age_rev_min"].to_i).to_s
    end
    $session[:param][:err_min] = "%02d" % @params["err_min"].to_i
    if $session[:param][:objet] == "Mot" then
      @nb = Objet.cherche(Mot).count
      @texte = "mots" 
    else
      @nb = Objet.cherche(Forme).count
      @texte = "formes verbales"
    end
    if @nb == 0 then
      @message = "Aucun mot pour ce parametrage !"
    else
      $session[:liste] = nil
      @message = "#{@nb} #{@texte} dans la liste"
    end
    render :action => :saisie, :back => '/app'
  end
  
end
