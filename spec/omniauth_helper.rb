omniauth_hash = {
    :provider => 'facebook',
    :uid => Faker::Number.number(15),
    :info => {
      :name => Faker::Name.name,
      :username => Faker::Name.name,
      :email => Faker::Internet.email
    }
}

empty_hash = {
    :provider => 'facebook',
    :uid => nil,
    :info => {
      :name => nil,
      :username => nil,
      :email => nil
    }
}

OmniAuth.config.test_mode = true
OmniAuth.config.add_mock(:facebook, omniauth_hash)
OmniAuth.config.add_mock(:empty, empty_hash)