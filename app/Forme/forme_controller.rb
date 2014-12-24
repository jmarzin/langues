require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'modules/objet'

class FormeController < Rho::RhoController
  include BrowserHelper

  # GET /Forme
  def index
    $session[:origine]= "/app/Forme"
    @formes = prepare_page(Objet.cherche(Forme))
    render :back => '/app'
  end

  # GET /Forme/{1}
  def show
    @forme = Forme.find(@params['id'])
    if @forme
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end
end
