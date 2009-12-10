class EmailsController < ApplicationController

  before_filter :authenticate
  before_filter :find_post

  def new
    @email = Email.new(:subject => "Netcooler: #{@post.title}", :message => 'I thought you might find this interesting.')
  end

  def create
    @email = Email.new(params[:email])
    if @email.valid?
      @email.recipients_array.each do |recipient|
        EmailNotifier.deliver_email_friend(current_user, recipient, @email.subject, @email.message, @post, post_url(@post))
      end
    else
      render :action => 'new'
    end
  end

  private

  def find_post
    @post = Post.find(params[:post_id], :include => :user)
  end

end