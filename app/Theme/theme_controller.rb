require 'rho/rhocontroller'
require 'helpers/browser_helper'

class ThemeController < Rho::RhoController
  include BrowserHelper

  # GET /Theme
  def index
  @themes = prepare_page(Theme.find(:all,:conditions => {:langue_id=>$session[:langue][0..1]},:order => 'nom'))
    render :back => '/app'
  end

  # GET /Theme/{1}
  def show
    @theme = Theme.find(@params['id'])
    if @theme
      $session[:origine]= "/app/Theme/#{@params['id']}/show"
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

end
