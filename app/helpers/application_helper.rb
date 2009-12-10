# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def new_session_url_with_redirect(text="Login", target=nil)
    session[:target_url] = target
    link_to(text, new_session_url)
  end

  def new_user_url_with_redirect(text="Register", target=nil)
    session[:target_url] = target
    link_to(text, new_user_url)
  end

  def truncate_words(text, length=30, end_string="...")
    words = text.split()
    words[0..(length - 1)].join(" ") + (words.length > length ? end_string : "")
  end

  def atom_url(company, category=nil)
    if category
      "#{company_posts_url(company)}.atom?category=#{category}"
    else
      "#{company_url(company)}.atom"
    end
  end
  
  def add_post_link(company, category)
    link_to(image_tag("add_#{category}2.gif"), new_company_post_url(company) + "?category=#{category}", :class => '.add-post')
  end

  def email_link(post)
    image_tag("mail.gif", :align => "bottom") + " " + link_to("Email to a friend", new_post_email_url(post))
  end

  def post_comment_link
    image_tag("comment_arrow.gif", :align => "bottom") + " " + link_to("Post a comment", "#add-comment")
  end

  def comments_link(post)
    image_tag("comment.gif") + " " + link_to(pluralize(post.comments.size, "Comment"), post_url(post) + "#comments")
  end

  def edit_post_link(post, user)
    post.editable_by?(user) ? " | #{link_to('Edit post',  edit_post_url(post))} (posts are editable for 5 minutes after creation)" : ""
  end

  def posted_by(post)
    "posted by #{link_to avatar_for(post.user, :small), user_url(post.user)} <span class='username'>#{link_to(h(post.user.username), user_url(post.user))}</span>"
  end
  
  def avatar_for(user, size=:large)
    user.avatar ? image_tag(user.avatar.public_filename(size), :class => 'user-avatar') : image_tag("avatar_#{size}.jpg")
  end
  
  def change_avatar_link(user)
    if current_user && current_user.id == user.id
      if user.avatar
        link_to('Change picture', edit_user_avatar_path(user, user.avatar))
      else
        link_to('Change picture', new_user_avatar_path(user))
      end
    end
  end

  def posted_by_with_date(post)
    "#{posted_by(post)} at #{post.created_at.to_s(:full_date)} (#{time_ago_in_words(post.created_at)} ago)"
  end

  def cool_rating_image_submit_tag(rating)
    (rating and rating.cool?) ? image_submit_tag("rate-cool2.gif") : image_submit_tag("rate-cool-off2.gif") 
  end

  def uncool_rating_image_submit_tag(rating)
    (rating and rating.uncool?) ? image_submit_tag("rate-uncool2.gif") : image_submit_tag("rate-uncool-off2.gif") 
  end

  def comment_cool_rating_image_submit_tag(rating)
    (rating and rating.cool?) ? image_submit_tag("comment-rate-cool.gif") : image_submit_tag("comment-rate-cool-off.gif") 
  end

  def comment_uncool_rating_image_submit_tag(rating)
    (rating and rating.uncool?) ? image_submit_tag("comment-rate-uncool.gif") : image_submit_tag("comment-rate-uncool-off.gif") 
  end
  
  def city_search_url(company)
    company.offices.empty? ? "" : searches_url + "?city=#{h(company.city)}".gsub(/ /, '+')
  end
  
  def state_search_url(company)
    company.offices.empty? ? "" : searches_url + "?state=#{company.state_name}".gsub(/ /, '+')
  end
  
  def city_and_state_search_url(company)
    company.offices.empty? ? "" : searches_url + "?city=#{h(company.city)}&state=#{company.state_name}".gsub(/ /, '+')
  end
  
  def country_search_url(company)
    company.offices.empty? ? "" : searches_url + "?country=#{h(company.country_name)}".gsub(/ /, '+')
  end
  
  def user_privileges_icon(user)
    user.admin? ? image_tag('admin.png') : image_tag('spacer.gif')
  end

  def user_status_icon(user)
    user.blocked? ? image_tag('block.png') : image_tag('approve2.png')
  end
  
  def post_status_icon(post)
    post.blocked? ? image_tag('block.png') : image_tag('approve2.png')
  end

  def rounded_box(title=nil, color='blue', &block)
    raise ArgumentError, "Missing block" unless block_given?
    concat("<div class='cB-#{color}'><div class='cBt-#{color}'><div></div></div>", block.binding)
    concat("<p class='title'>#{title}</p>", block.binding) if title
    block.call
    concat("<div class='cBb-#{color}'><div></div></div></div>", block.binding) 
  end

  def tag_cloud(tags, classes)
    max, min = -100_000_000, 100_000_000
    tags.each do |t|
      max = t.count.to_i if t.count.to_i > max
      min = t.count.to_i if t.count.to_i < min
    end
    divisor = ((max - min) / classes.size) + 1
    tags.each do |t| 
      yield t, classes[(t.count.to_i - min) / divisor]
    end
  end
  
  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end
  
end
