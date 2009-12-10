class EmailNotifier < ActionMailer::Base

  def registration(user, sent_at=Time.now)
    @subject    = 'Welcome to Netcooler'
    @recipients = user.email
    @from       = 'Netcooler <auto@netcooler.com>'
    @sent_on    = sent_at
    content_type 'text/html'
    @body       = {:user => user}
  end

  def reset_password(user, sent_at=Time.now)
    @subject    = 'Netcooler Password Reset'
    @recipients = user.email
    @from       = 'Netcooler <auto@netcooler.com>'
    @sent_on    = sent_at
    content_type 'text/html'
    @body       = {:user => user}
  end

  def change_password(user, sent_at=Time.now)
    @subject    = 'Netcooler Password Change'
    @recipients = user.email
    @from       = 'Netcooler <auto@netcooler.com>'
    @sent_on    = sent_at
    content_type 'text/html'
    @body       = {:user => user}
  end

  def email_friend(sender, recipent, subject, message, post, post_url, sent_at=Time.now)
    @subject    = subject
    @recipients = recipent
    @from       = 'Netcooler <auto@netcooler.com>'
    @sent_on    = sent_at
    content_type 'text/html'
    @body       = {:sender => sender, :company => post.company, :post_title => post.title, :post_url => post_url, :message => message}
  end

end
