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
    @params = construit_hash(@request["request-query"])
    $session[:param][:objet] = @params["objet"]
    if @params["themes"] then
      $session[:param][:themes] = @params["themes"]
    else
      $session[:param][:themes] = []
    end
    if @params["verbes"] then 
      $session[:param][:verbes] = @params["verbes"]
    else
      $session[:param][:verbes] = []
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
    render :string => @message, :use_layout_on_ajax => true    
  end
  
  private
  def construit_hash(texte)
    resultat = {}
    texte.split('&').each  do |egalite|
      eclate = egalite.split('=')
      eclate << ''
      eclate[1]= eclate[1].split('%24')
      unless ["themes","verbes"].include?(eclate[0]) then
        eclate[1]=[""] if eclate[1].size==0
        eclate[1]=eclate[1][0] if eclate[1].size==1
      end
      resultat[eclate[0]]=eclate[1]
    end
    resultat
  end

end
