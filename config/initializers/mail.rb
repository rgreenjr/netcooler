ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :address        => 'mail.netcooler.com',
  :port           => 25,
  :domain         => 'netcooler.com',
  :authentication => :login,
  :user_name      => 'admin@netcooler.com', 
  :password       => 'firstrule'
}
