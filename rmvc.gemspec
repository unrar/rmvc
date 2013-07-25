Gem::Specification.new do |s|
  s.name        = 'rmvc'
  s.version     = '2.0.0'
  s.date        = '2013-07-25'
  s.summary     = 'Ruby MVC'
  s.description = 'Use MVC in your Ruby apps!'
  s.authors     = ["Catbuntu"]
  s.email       = "catbuntu@catbuntu.me"
  s.files       = ["lib/rmvc.rb"]
  s.executables << 'rmvc'
  s.homepage    = "http://unrar.github.io/rmvc"
  s.add_dependency('colorize')
end