module BrowserHelper

  def placeholder(label=nil)
    "placeholder='#{label}'" if platform == 'apple'
  end

  def platform
    System::get_property('platform').downcase
  end

  def selected(option_value,object_value)
    "selected=\"yes\"" if option_value == object_value
  end

  def checked(option_value,object_value)
    "checked=\"yes\"" if option_value == object_value
  end

  def is_bb6
    platform == 'blackberry' && (Rho::System.getProperty('os_version').split('.')[0].to_i >= 6)
  end

  def page_suiv
    set_page(1)
  end

  def page_suiv_2
    set_page(1)
  end

  def page_prec
    set_page(-1)
  end

  def page_prec_2
    set_page(-1)
  end
  
  def pagination
    if $session[:action_change] then
      action_prec = :page_prec_2
      action_suiv = :page_suiv_2
    else
      action_prec = :page_prec
      action_suiv = :page_suiv
    end
    html_texte = "<h1>p.#{$session[symbole_page]+1}/#{$session[symbole_page_max]+1}</h1>\n"
    if $session[symbole_page]>0 then
      html_texte += "<a href='#{url_for :action => action_prec}' class='ui-btn-left' data-icon='arrow-l'>\nPrec\n</a>\n"
    end
    if $session[symbole_page]<$session[symbole_page_max] then
      html_texte += "<a href='#{url_for :action => action_suiv}' class='ui-btn-right' data-icon='arrow-r'>\nSuiv\n</a>"
    end
    html_texte
  end

  private

  def prepare_page(tableau)
    $session[symbole_page] ||= 0
    $session[symbole_page_max] = (tableau.count-1)/10
    if $session[symbole_page] > $session[symbole_page_max] then
      $session[symbole_page] = 0
    end
    tableau[$session[symbole_page]*10,10]
   
  end
  
  def symbole_page
    (self.class.to_s+"_page").to_sym
  end
  
  def symbole_page_max
    (self.class.to_s+"_page_max").to_sym
  end
    
  def set_page(n)
    $session[symbole_page] += n
    $session[:action_change] = !$session[:action_change]
    redirect :action => :index  
  end
 
end