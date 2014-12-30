# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
require 'date'
require 'modules/objet'
class Mot
  include Rhom::PropertyBag
  include Objet

  # Uncomment the following line to enable sync with Mot.
  enable :sync

  #add model specific code here
  belongs_to :theme_id, 'Theme'
    
    
  def self.init(themes,liste)
    
    @date = Application.find(:first).date_mots
    
    liste.each_with_index do |m,index|
      if (index+1).modulo(10)==0 or (index+1)==liste.size then
        puts "mot #{index+1}/#{liste.size}"
      end 
      @m = Mot.find(:first,:conditions => {:dist_id => m[0],:langue_id => $session[:langue][0..1]})
      if @m then
        @m.update_attributes(:theme_id => themes[m[1]],
                             :langue => $session[:langue][0..1],
                             :directeur => m[3],
                             :francais => m[2],
                             :langue => m[4],
                             :derniere_revision => Date.new(1900,1,31).to_s,
                             :date_maj => @date)
      else
        @m = Mot.create(:langue_id => $session[:langue][0..1],
                        :dist_id => m[0],
                        :langue => $session[:langue][0..1],
                        :theme_id => themes[m[1]], 
                        :directeur => m[3],
                        :francais => m[2],
                        :poids => "00001",
                        :nb_err => "00",
                        :langue => m[4],
                        :derniere_revision => Date.new(1900,1,31).to_s,
                        :date_maj => @date)
      end
    end
    
    Objet.nettoye(Mot,@date,$session[:langue][0..1])
    
    Mot.count
    
  end
end
