# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here

class Application
  include Rhom::PropertyBag


  # Uncomment the following line to enable sync with Application.
  enable :sync

  #add model specific code here
  
  def self.sauve_session
    $session[:nb_ok],$session[:nb_ko],$session[:pour_cent],$session[:deja_maj] = nil, nil, nil,'false'
    @appli = Application.find(:first,:conditions=>{:langue=>$session[:langue]})
    if @appli then
      @appli.update_attributes(:session => Marshal.dump($session,limit=-1))
    end
  end
  
  def self.mise_a_jour(langue)

    sauve_session
    
    $session[:langue] = langue
    $session[:deja_maj] = 'false'
    
    
    nb_objets = 0
    date = "1901-01-01"
    Application.find(:all).each do |app|
      app.update_attributes(:derniere_session=>'false')
    end
    @appli = Application.find(:first,:conditions => {:langue=>$session[:langue]})
    if @appli then
      @appli.update_attributes(:derniere_session=>'true')
    else
      @appli = Application.create(:langue=>$session[:langue],
                         :date_categories=>date,
                         :date_mots=>date,
                         :date_verbes=>date,
                         :date_formes=>date,
                         :derniere_session=>'true')
    end
   
    sauve_session
    
    site = "http://langues.jmarzin.fr/#{$session[:langue].downcase}/api/v2/"
    #mise à jour des thèmes et des mots
    
    response = Rho::Network.get({:url => site + "date_categories.json"})
    return "erreur reseau" if response["status"] != "ok"
    date_categories = response["body"]
    response = Rho::Network.get({:url => site + "date_mots.json"})
    return "erreur reseau" if response["status"] != "ok"
    date_mots = response["body"]
    if date_categories > @appli.date_categories or date_mots > @appli.date_mots then
      @appli.update_attributes(:date_categories => [date_categories,date_mots].max,
                               :date_mots => [date_categories,date_mots].max)
      response = Rho::Network.get({:url => site + "categories.json"})
      return "erreur reseau" if response["status"] != "ok"
      liste = Rho::JSON.parse(response["body"])
      @themes = Theme.init(liste)
      response = Rho::Network.get({:url => site + "mots.json"})
      liste = Rho::JSON.parse(response["body"])
      nb_mots = Mot.init(@themes,liste)
      nb_objets += nb_mots
    end
    
    #mise à jour des verbes et des formes
    
    response = Rho::Network.get({:url => site + "date_verbes.json"})
    return "erreur reseau" if response["status"] != "ok"
    date_verbes = response["body"]
    response = Rho::Network.get({:url => site + "date_formes.json"})
    return "erreur reseau" if response["status"] != "ok"
    date_formes = response["body"]
    if date_verbes > @appli.date_verbes or date_formes > @appli.date_formes then
      @appli.update_attributes(:date_verbes => [date_verbes,date_formes].max,
                               :date_formes => [date_verbes,date_formes].max)
      response = Rho::Network.get({:url => site + "verbes.json"})
      return "erreur reseau" if response["status"] != "ok"
      liste = Rho::JSON.parse(response["body"])
      @verbes = Verbe.init(liste)
      response = Rho::Network.get({:url => site + "formes.json"})
      liste = Rho::JSON.parse(response["body"])
      nb_formes = Forme.init(@verbes,liste)
      nb_objets += nb_formes
    end
    $session[:deja_maj] = 'true'
    return "#{nb_objets} objets mis à jour"
  end

end
