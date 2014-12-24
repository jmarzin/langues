require 'rho/rhocontroller'
require 'helpers/browser_helper'

class VerbeController < Rho::RhoController
  include BrowserHelper

  # GET /Verbe
  def index
  @verbes = prepare_page(Verbe.find(:all,:conditions => {:langue_id=>$session[:langue][0..1]},:order => 'infinitif'))
    render :back => '/app'
  end
  
  # GET /Verbe/{1}
  def show
    @verbe = Verbe.find(@params['id'])
    if @verbe
      $session[:origine]= "/app/Verbe/#{@params['id']}/show"
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

end
