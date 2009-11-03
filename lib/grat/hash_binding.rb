# A class to assist in turning a hash into a binding (for erb rendering)
class Grat::HashBinding
  
  attr_accessor :hash
  
  def initialize(hsh)
    self.hash = hsh
  end
  
  def get_binding
    binding
  end
  
  def method_missing(meth,*args)
    hash[meth]
  end
  
end