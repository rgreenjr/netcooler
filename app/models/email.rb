class Email

  include Validateable
  
  attr_accessor  :subject
  attr_accessor  :message
  attr_accessor  :recipients
  
  def initialize(hash)
    @message = hash[:message]
    @subject = hash[:subject]
    self.recipients = hash[:recipients]
  end
  
  def recipients=(list)
    if list.nil?
      @recipients = []
    else
      list = list.split(',')
      list.each { |r| r.strip! }
      list.uniq!
      list.delete_if {|t| t.blank? }
      @recipients = list
    end
  end
  
  def recipients
    @recipients.join(', ')
  end
  
  def recipients_array
    @recipients
  end
  
  def validate
    errors.add("Subject", "can't be blank") if @subject.empty?
    errors.add("Subject", "is too long (maximum is 256 characters)") if @subject && @subject.size > 256
    errors.add("Message", "is too long (maximum is 2048 characters)") if @message && @message.size > 2048
    errors.add("Recipient's email", "can't be blank") if @recipients.empty?
    errors.add("Recipient's email", "may contain up to 6 addresses") if @recipients.size > 6
    @recipients.each do |recipient|
      errors.add("Recipient email '#{recipient}'", "is invalid") if !RegexpUtil.valid_email?(recipient)
    end
  end
  
  def self.human_attribute_name(attribute_key_name)
    attribute_key_name.humanize 
  end
  
end
