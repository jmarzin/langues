# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
require 'date'
require 'modules/objet'

class Forme
  include Rhom::PropertyBag
  include Objet
  
  CODES = [
    ["Gérondif",""],
    ["Participe passé",""],
    ["1ère pers sing. présent indic.","io"],
    ["2ème pers sing. présent indic.","tu"],
    ["3ème pers sing. présent indic.","lui/lei"],
    ["1ère pers plur. présent indic.","noi"],
    ["2ème pers plur. présent indic.","voi"],
    ["3ème pers plur. présent indic.","loro"],
    ["1ère pers sing. imparfait indic.","io"],
    ["2ème pers sing. imparfait indic.","tu"],
    ["3ème pers sing. imparfait indic.","lui/lei"],
    ["1ère pers plur. imparfait indic.","noi"],
    ["2ème pers plur. imparfait indic.","voi"],
    ["3ème pers plur. imparfait indic.","loro"],
    ["1ère pers sing. passé simple indic.","io"],
    ["2ème pers sing. passé simple indic.","tu"],
    ["3ème pers sing. passé simple indic.","lui/lei"],
    ["1ère pers plur. passé simple indic.","noi"],
    ["2ème pers plur. passé simple indic.","voi"],
    ["3ème pers plur. passé simple indic.","loro"],
    ["1ère pers sing. futur indic.","io"],
    ["2ème pers sing. futur indic.","tu"],
    ["3ème pers sing. futur indic.","lui/lei"],
    ["1ère pers plur. futur indic.","noi"],
    ["2ème pers plur. futur indic.","voi"],
    ["3ème pers plur. futur indic.","loro"],
    ["1ère pers sing. présent cond.","io"],
    ["2ème pers sing. présent cond.","tu"],
    ["3ème pers sing. présent cond.","lui/lei"],
    ["1ère pers plur. présent cond.","noi"],
    ["2ème pers plur. présent cond.","voi"],
    ["3ème pers plur. présent cond.","loro"],
    ["1ère pers sing. présent subj.","che io"],
    ["2ème pers sing. présent subj.","che tu"],
    ["3ème pers sing. présent subj.","che lui/lei"],
    ["1ère pers plur. présent subj.","che noi"],
    ["2ème pers plur. présent subj.","che voi"],
    ["3ème pers plur. présent subj.","che loro"],
    ["1ère pers sing. imparfait subj.","che io"],
    ["2ème pers sing. imparfait subj.","che tu"],
    ["3ème pers sing. imparfait subj.","che lui/lei"],
    ["1ère pers plur. imparfait subj.","che noi"],
    ["2ème pers plur. imparfait subj.","che voi"],
    ["3ème pers plur. imparfait subj.","che loro"],
    ["2ème pers sing. impératif",""],
    ["3ème pers sing. impératif",""],
    ["1ère pers plur. impératif",""],
    ["2ème pers plur. impératif",""],
    ["3ème pers plur. impératif",""]]

      # Uncomment the following line to enable sync with Forme.
  enable :sync

  #add model specific code here
  belongs_to :verbe_id, 'Verbe'


  def self.init(verbes,liste)

    @date = Application.find(:first).date_formes
    
    liste.each_with_index do |f,index|
      if (index+1).modulo(10)==0 or (index+1)==liste.size then
        puts "forme #{index+1}/#{liste.size}"
      end 
      @f = Forme.find(:first,:conditions => {:dist_id => f[0],:langue_id => $session[:langue][0..1]})
      if @f then
        @f.update_attribute(:dist_id => f[0],
                            :verbe_id => verbes[f[1]], 
                            :code_forme => "%02d" % (f[2]-1),
                            :langue => f[3],
                            :derniere_revision => Date.new(1900,1,31).to_s,
                            :date_maj => @date)
      else
        @f = Forme.create(:dist_id => f[0],
                          :langue_id => $session[:langue][0..1],
                          :verbe_id => verbes[f[1]], 
                          :code_forme => "%02d" % (f[2]-1),
                          :poids => "00001",
                          :nb_err => "00",
                          :langue => f[3],
                          :derniere_revision => Date.new(1900,1,31).to_s,
                          :date_maj => @date)
      end
    end
    
    Forme.delete_all(:conditions => {{:name => 'date_maj',:op => '<'} => @date,
                                     {:name => 'langue_id',:op => '='} => $session[:langue][0..1],
                                      :op => 'AND'})

    Forme.count
    
  end
end
