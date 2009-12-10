class RegexpUtil
  
  @@regex = {
    :email    => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
    :username => /^[A-Za-z]+[A-Za-z0-9]*$/,
  }
  
  # TODO: optimize by defining "valid_x?" methods dynamically
  def self.method_missing(method, *args)
    if method.to_s =~ /^valid_(.*)\?/
      exp = @@regex[$1.to_sym]
      raise NoMethodError if exp.nil?
      return (args.first =~ exp) != nil
    else
      exp = @@regex[method]
      raise NoMethodError if exp.nil?
      return exp
    end
  end

end
