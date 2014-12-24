require 'rho/rhoapplication'

class AppApplication < Rho::RhoApplication
  def initialize

    @derniere_session = Application.find(:first,:conditions => {:derniere_session => 'true'})
    if @derniere_session then
      Mot.count
      Forme.count
      $session = Marshal.load(@derniere_session.session)
      $session[:deja_maj] = 'false'
    else
      $session = {}
      $session[:langue] = 'Choisissez la langue'
      $session[:deja_maj] = 'false'
    end

#    Application.mise_a_jour      

    # Tab items are loaded left->right, @tabs[0] is leftmost tab in the tab-bar
    # Super must be called *after* settings @tabs!
    @tabs = nil
    #To remove default toolbar uncomment next line:
    @@toolbar = nil
    super


    # Uncomment to set sync notification callback to /app/Settings/sync_notify.
    # Rho::RhoConnectClient.setObjectNotification("/app/Settings/sync_notify")
    Rho::RhoConnectClient.setNotification('*', "/app/Settings/sync_notify", '')
    
  end
end