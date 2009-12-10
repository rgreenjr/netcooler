require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  
  fixtures :users
  
  def setup
    @bob = users(:bob)
    @bob_password = 'pass'
    @sally = users(:sally)
    @dave = users(:dave)
  end
  
  def test_associations
    assert_working_associations
  end

  def test_create
    assert User.create(:username => 'jdoe', :email => 'jdoe@example.com', :password => 'pass', :password_confirmation => 'pass')
  end

  def test_create_fails_without_attributes
    user = User.new
    assert !user.valid?
    assert user.errors.invalid?(:username)
    assert user.errors.invalid?(:email)
    assert user.errors.invalid?(:password)
  end
  
  def test_authenticaiton_success
    assert User.authenticate(@bob.username, @bob_password)
  end

  def test_authenticaiton_wrong_password
    assert_nil User.authenticate(@bob.username, @bob_password + 'wrong')
  end

  def test_authenticaiton_wrong_username
    assert_nil User.authenticate(@bob.username + 'wrong', @bob_password)
  end

  def test_authentication_updates_last_login_at
    before = User.authenticate(@bob.username, @bob_password).last_login_at
    sleep 1.0
    after = User.authenticate(@bob.username, @bob_password).last_login_at
    assert_not_equal before, after
  end
  
  def test_password_too_short
    assert_invalid_value User, :password, 'x'
  end
  
  def test_password_too_long
    assert_invalid_value User, :password, 'x' * 100
  end
  
  def test_changing_password
    @bob.password = 'new_password'
    assert @bob.save
    assert User.authenticate(@bob.username, 'new_password')
  end
  
  def test_reset_password
    original_password = @bob_password
    new_password = @bob.reset_password
    assert_not_equal original_password, new_password
    assert @bob.save
    
    # old password should not work now
    assert_nil User.authenticate(@bob.username, original_password)
    
    # verify password isn't reset again (should be same until user authenticates successfully)
    assert_equal @bob.reset_password, new_password
    
    # verify new password works
    assert @bob = User.authenticate(@bob.username, new_password)
    
    # calling reset should change user password now that the user authenticated successfully
    assert_not_equal new_password, @bob.reset_password
  end

  def test_updating_email
    new_email = 'new_email@example.com'
    @bob.email = new_email
    assert @bob.save
    assert_equal new_email, User.find_by_username(@bob.username).email
  end

  def test_email_uniqueness
    @bob.email = @sally.email
    assert !@bob.valid? 
    assert @bob.errors.invalid?(:email)
  end
  
  def test_username_uniqueness
    @bob.username = @sally.username
    assert !@bob.valid? 
    assert @bob.errors.invalid?(:username)
  end

  def test_updating_username
    new_username = 'flounder'
    @bob.username = new_username
    assert @bob.save
    assert_equal new_username, User.find_by_email(@bob.email).username
  end

  def test_name
    assert_equal("#{@sally.first_name} #{@sally.last_name}", @sally.name)
  end

  def test_to_param
    assert_equal(@sally.username, @sally.to_param)
  end

  def test_privileges
    assert @dave.admin?
    assert_equal('Administrator', @dave.privileges)
    assert !@bob.admin?
    assert_equal('Normal', @bob.privileges)
  end

  def test_changing_status
    assert !@sally.blocked?
    assert_equal('Registered', @sally.status)
    @sally.block = true
    assert @sally.blocked?
    assert_equal('Blocked', @sally.status)
    @sally.block = false
    assert !@sally.blocked?
    assert_equal('Registered', @sally.status)
  end

  def test_marking_deleted
    assert @sally.active?
    assert_equal(nil, @sally.deleted_at)
    @sally.active = false
    assert !@sally.active?
    assert_not_equal(nil, @sally.deleted_at)
  end

end