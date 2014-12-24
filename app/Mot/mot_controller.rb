require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'modules/objet'

class MotController < Rho::RhoController
  include BrowserHelper

  # GET /Mot
  def index
    $session[:origine]= "/app/Mot"
    @mots = prepare_page(Objet.cherche(Mot))
    render :back => '/app'
  end

  # GET /Mot/{1}
  def show
    @mot = Mot.find(@params['id'])
    if @mot
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end
  

end
