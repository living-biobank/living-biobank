include Warden::Test::Helpers

  def login_user_for_each_test(user=nil, honest_broker: false)
    before :each do
      Warden.test_mode!
      user ||= create(:user, honest_broker: honest_broker)
      login_as(user)
    end

    after :each do
      Warden.test_reset!
    end
  end

  def login_user(user=nil, honest_broker: false)
    Warden.test_reset!
    Warden.test_mode!
    user ||= create(:user, honest_broker: honest_broker)
    login_as(user)
  end
