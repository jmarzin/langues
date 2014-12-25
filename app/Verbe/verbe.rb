# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
class Verbe
  include Rhom::PropertyBag

  # Uncomment the following line to enable sync with Verbe.
  enable :sync

  #add model specific code here

  def self.liste
    Verbe.find(:all,:order => 'infinitif')
  end
  
  def self.init(liste)
    
    @date = Application.find(:first).date_verbes
    
    objets = {}
    liste.each_with_index do |v,index|
      if (index+1).modulo(10)==0 or (index+1)==liste.size then
        puts "verbe #{index+1}/#{liste.size}"
      end 
      @v = Verbe.find(:first,:conditions => {:dist_id => v[0],:langue_id => $session[:langue][0..1]})
      if @v then
        @v.update_attributes(:infinitif => v[1],
                             :date_maj => @date)
      else  
        @v = Verbe.create(:langue_id => $session[:langue][0..1],
                          :dist_id => v[0],
                          :infinitif => v[1],
                          :date_maj => @date)
      end
      objets[v[0]] = @v.object
    end
    
    Verbe.delete_all(:conditions => {{:name => 'date_maj',:op => '<'} => @date,
                                     {:name => 'langue_id',:op => 'LIKE'} => $session[:langue][0..1],
                                      :op => 'AND'})
      
    objets
    
  end
end
