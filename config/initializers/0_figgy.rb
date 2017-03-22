Figs = Figgy.build do |config|
  config.root = Rails.root.join('etc')

  # config.foo is read from etc/foo.yml
  config.define_overlay :default, nil

   # config.foo is then updated with values from etc/development/foo.yml
   #                                        then etc/staging/foo.yml
   #                                        then etc/production/foo.yml
   # up to the current Rails environment, last definition wins
   config.define_overlay(:environment), ['development', 'staging', 'production'].slice(0..(env.index(Rails.env)))
 end
