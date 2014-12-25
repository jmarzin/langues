require 'rho/rhocontroller'
require 'helpers/browser_helper'

class ApplicationController < Rho::RhoController
  include BrowserHelper
  
  def verif_maj
    @langue = @request["request-query"]
    if @langue == $session[:langue] and $session[:deja_maj]== 'true' then
      render :string => 'ok', :use_layout_on_ajax => true
    elsif ['Italien','Anglais'].include?(@langue) then
      render :string => Application.mise_a_jour(@langue) , :use_layout_on_ajax => true
    else
      render :string => "#{@langue} inconnu", :use_layout_on_ajax => true  
    end
  end
  
  def quit_app
    Application.sauve_session
    Rho::Application.quit
  end

end
