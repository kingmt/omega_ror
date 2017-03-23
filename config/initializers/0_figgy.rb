Figs = Figgy.build do |config|
  config.root = Rails.root.join('etc')

  # config.foo is read from etc/foo.yml
  config.define_overlay :default, nil

  config.define_overlay(:environment) { Rails.env }
end
