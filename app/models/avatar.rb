class Avatar < ActiveRecord::Base

  belongs_to :user

  has_attachment :content_type => :image,
                 :storage => :file_system,
                 :max_size => 1.megabyte,
                 :resize_to => '256x256>',
                 :thumbnails => { :large => '96x96>', :medium => '48x48>', :small => '24x24>' },
                 :storage => :db_file,
                 :processor => 'MiniMagick'

  validate :attachment_valid?

  def attachment_valid?
    unless self.filename
      errors.add_to_base("No file was selected")
    else
      content_type = attachment_options[:content_type]
      unless content_type.nil? || content_type.include?(self.content_type)
        errors.add_to_base("File must be an image")
      end
    
      size = attachment_options[:size]
      unless size.nil? || size.include?(self.size)
        errors.add_to_base("Image must be 1MB or less")
      end
    end
  end
  
  def public_filename(thumbnail=:medium)
    thumbnail_name = thumbnail_name_for(thumbnail)
    avatar = Avatar.find(:first, :conditions => ["parent_id = ? and thumbnail = ?", id, thumbnail.to_s])
    "/avatars/#{avatar.id}-#{thumbnail_name}"
  end
  
  def editable_by?(user)
    user && ((user.id == self.user.id) || user.admin?)
  end

end
