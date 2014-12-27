module Objet
  
  def reduit_poids
    ancien_poids = self.poids.to_i
    if ancien_poids > 1 then 
      nouveau_poids = ancien_poids / 2
      nb_supp = ancien_poids - nouveau_poids
    else 
      nouveau_poids = ancien_poids
      nb_supp = 1
    end
    
    if $session[:param][:err_min] and $session[:param][:err_min] > "00" and self.nb_err and self.nb_err > "00" then
      err = self.nb_err.to_i - 1
    elsif self.nb_err and self.nb_err > "00" then
      err = self.nb_err.to_i
    else
      err = 0
    end
          
    self.update_attributes(
                :poids => "%05d" % nouveau_poids,
                :nb_err => "%02d" % err,
                :derniere_revision => Date.today.to_s)
    (1..nb_supp).each do
      $session[:liste].delete_at($session[:liste].index(self.object))
    end
  end
  
  def augmente_poids
    if self.poids.class == String then ancien_poids = self.poids.to_i else ancien_poids = self.poids end
    nouveau_poids = ancien_poids * 2
    
    if self.nb_err then
      err = self.nb_err.to_i + 1
    else
      err = 1
    end

    self.update_attributes(
                :poids => "%05d" % nouveau_poids,
                :nb_err => "%02d" % err,
                :derniere_revision => Date.today.to_s)
    $session[:liste] += Array.new(nouveau_poids - ancien_poids, self.object)
  end
  
  def self.cherche(classe)
    if classe == Mot then
      peres = :themes
      id = 'theme_id'
    else
      peres = :verbes
      id = 'verbe_id'
    end
    $session[:param] ||= {}
    $session[:param][:date_rev_max] ||= Date.today.to_s
    $session[:param][peres] ||= []
    @poids_min = $session[:param][:poids_min] || "00000"
    @err_min = $session[:param][:err_min] || "00"
           
    if $session[:param] and $session[:param][peres].size >= 1 then
      cond1 = {:conditions => { {:name => id,:op => 'IN'} => $session[:param][peres].to_s[1..-2], 
                                {:name => 'poids',:op => '>='} => @poids_min}, 
                                :op => 'AND'}
      cond2 = {:conditions => { {:name => 'derniere_revision',:op => '<='} => $session[:param][:date_rev_max],
                                {:name => 'nb_err',:op => '>='} => @err_min},
                                :op => 'AND'}
    else
      cond1 = {:conditions => { {:name => 'derniere_revision',:op => '<='} => $session[:param][:date_rev_max], 
                                {:name => 'poids',:op => '>='} => @poids_min },
                                :op => 'AND'}
      cond2 = {:conditions => { {:name => 'nb_err',:op => '>='} => @err_min}}
    end
    cond3 = {:conditions => {:langue_id => $session[:langue][0..1]}} 
    classe.find(:all, 
             :conditions => [cond1, cond2, cond3], 
             :op => 'AND', 
             :order => 'directeur')
  end
  
  def self.tirage(classe)
    if $session[:liste] == nil then
      $session[:liste]=[]
      Objet.cherche(classe).each do |m|
        $session[:liste] += Array.new(m.poids.to_i, m.object)
      end
    end
    if $session[:liste].empty? then
      return false
    else
      question = {}
      tire = classe.find($session[:liste][rand($session[:liste].size)])
      question[:objet] = tire
      if classe == Mot then
        question[:texte] = "Theme #{Theme.find(tire.theme_id).nom}<br>#{tire.francais}"
      else
        question[:texte] = "Verbe #{Verbe.find(tire.verbe_id).infinitif}<br>#{Forme::CODES[$session[:langue]][tire.code_forme.to_i][0]}"
      end
      return question
    end
  end
  
  def self.egaux (reponse,cible)
    @reponse = reponse.downcase
    cible.lines("/").each do |l| 
      return true if @reponse == l.chomp("/")
    end
    return false
  end

end