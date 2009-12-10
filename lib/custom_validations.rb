module CustomValidations    

  def validates_ssn(*attr_names)
    options = attr_names.extract_options!
    options[:with] = /^[\d]{3}-[\d]{2}-[\d]{4}$/
    options[:message] ||= "must be of format ###-##-####"
    attr_names.each do |attr_name|
      validates_format_of attr_name, options
    end
  end

  def validates_email(*attr_names)
    options = attr_names.extract_options!
    options[:with] = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
    attr_names.each do |attr_name|
      validates_format_of attr_name, options
    end
  end

  def validates_zip(*attr_names)
    options = attr_names.extract_options!
    options[:with] = /(^\d{5}$)|(^\d{5}-\d{4}$)/
    attr_names.each do |attr_name|
      validates_format_of attr_name, options
    end
  end

  def validates_ip_address(*attr_names)
    options = attr_names.extract_options!
    options[:with] = /^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})?$/
    attr_names.each do |attr_name|
      validates_format_of attr_name, options
    end
  end

  def validates_url(*attr_names)
    options = attr_names.extract_options!
    options[:with] = /(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?/ix
    attr_names.each do |attr_name|
      validates_format_of attr_name, options
    end
  end

  def validates_tag(*attr_names)
    options = attr_names.extract_options!
    options[:with] = /^[A-Za-z0-9\-_\&\.]+$/
    options[:message] ||= "may only contain letters, numbers, ., &, -, and _ symbols"
    attr_names.each do |attr_name|
      validates_format_of attr_name, options
    end
  end

  def validates_username(*attr_names)
    options = attr_names.extract_options!
    options[:with] = /^[A-Za-z]+[A-Za-z0-9]*$/
    options[:message] ||= "must begin with a letter and may only contain letters and numbers"
    attr_names.each do |attr_name|
      validates_format_of attr_name, options
    end
  end

end

ActiveRecord::Base.extend(CustomValidations)

# :alpha          => /^[A-Za-z ]+$/,
# :numeric        => /^[0-9 ]+$/,
# :alpha_numeric  => /^[A-Za-z0-9 ]+$/,
# :password       => /^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E]){8,40}$/,
# :phone          => /(\+)?([-\._\(\) ]?[\d]{3,20}[-\._\(\) ]?){2,10}/,
# :city           => /^[A-Za-z ]+$/,
# :state          => /^[A-Z]{2}$/,
# :domain         => /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?)?$/ix,
# :cc             => /^((67\d{2})|(4\d{3})|(5[1-5]\d{2})|(6011))(-?\s?\d{4}){3}|(3[4,7])\d{2}-?\s?\d{6}-?\s?\d{5}$/,
# :ccv            => /^\d{3}$/,
