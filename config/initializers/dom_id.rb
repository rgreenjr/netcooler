ActiveRecord::Base.class_eval do
  def dom_id
    [self.class.name.downcase.pluralize.dasherize, id] * '-'
  end
end
