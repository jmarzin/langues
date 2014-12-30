# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
class Theme
  include Rhom::PropertyBag

  # Uncomment the following line to enable sync with Theme.
  enable :sync

  #add model specific code here
  def self.liste
  Theme.find(:all,:conditions=>{:langue_id=>$session[:langue][0..1]},:order => 'nom')
  end
  
  def self.init(liste)

    @date = Application.find(:first).date_categories
        
    objets = {}
      
    liste.each_with_index do |c,index|
      if (index+1).modulo(10)== 0 or (index+1)==liste.size then
        puts "theme #{index+1}/#{liste.size}"
      end 
      @c = Theme.find(:first,:conditions => {:dist_id => c[0],:langue_id => $session[:langue][0..1]})
      if @c then
        @c.update_attributes(:nom => "%03d" % c[1] + " " + c[2],
                             :date_maj => @date)
      else  
        @c = Theme.create(:langue_id => $session[:langue][0..1],
                          :nom => "%03d" % c[1] + " " + c[2],
                          :dist_id => c[0],
                          :date_maj => @date)
      end
      objets[c[0]] = @c.object
    end

    Objet.nettoye(Theme,@date,$session[:langue][0..1])

    objets
      
  end
end
