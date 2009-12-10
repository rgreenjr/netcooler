require 'digest/sha1'

class User < ActiveRecord::Base

  has_many    :posts, :dependent => :destroy do
    def news
      find(:all, :conditions => ["category = 'News'"])
    end
    def gossip
      find(:all, :conditions => ["category = 'Gossip'"])
    end
    def questions
      find(:all, :conditions => ["category = 'Question'"])
    end
  end

  has_many    :comments,        :dependent => :destroy
  has_many    :taggings,        :dependent => :destroy
  has_many    :tags,            :through => :taggings, :select => "DISTINCT tags.*", :order => "name"
  
  has_one     :avatar,          :dependent => :destroy
  
  # password_hash should not be accessible outside this class
  attr_protected            :password_hash
  validates_presence_of     :password_hash, :if => lambda { |user| !user.new_record? or (user.new_record? and user.password) }
                            
  validates_presence_of     :password, :if => lambda { |user| user.new_record? }
  validates_length_of       :password, :within => 4..40, :if => lambda { |user| user.new_record? or user.password }
  validates_confirmation_of :password
                            
  validates_inclusion_of    :status, :in => %w( Registered Blocked )
                            
  validates_uniqueness_of   :username, :case_sensitive => false
  validates_username        :username
  validates_length_of       :username, :minimum => 2
                            
  validates_uniqueness_of   :email, :case_sensitive => false
  validates_email           :email
                                
  before_create do |user|
    user.last_login_at = Time.now
  end
  
  def self.authenticate(username, password)
    user = find_by_username_and_password_hash(username, User.hash_password(password))
    user = nil if user and user.blocked?
    if user
      user.last_login_at = Time.now 
      user.save!
    end
    user
  end
    
  def self.hash_password(pass)
    Digest::SHA1.hexdigest(pass + PASSWORD_SALT) if pass
  end

  def password
    @password
  end

  def password=(value)
    self.password_hash = User.hash_password(value)
    @password = value
  end

  # Resets the password by hashing email with last_login_at time. 
  # This gives a random password unique to the user but guards against multiple reset requests -
  # the user will receive the same random password until next successful login.
  def reset_password
    self.password = Digest::SHA1.hexdigest(email + last_login_at.to_i.to_s)[0..8]
  end

  def name
    first_name + ' ' + last_name
  end
  
  def active=(flag)
    self.deleted_at = flag ? nil : Time.now
  end
  
  def active?
    deleted_at == nil
  end
  
  def privileges
    admin? ? "Administrator" : "Normal"
  end
  
  def block=(flag)
    self.status = flag ? 'Blocked' : 'Registered'
  end
  
  def blocked?
    status == 'Blocked'
  end
  
  def to_param
    username
  end

end
