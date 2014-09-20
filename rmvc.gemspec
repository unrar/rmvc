Gem::Specification.new do |s|
  s.name        = 'rmvc'
  s.version     = '3.2'
  s.date        = '2014-09-20'
  s.summary     = 'Ruby MVC'
  s.description = 'Use MVC in your Ruby apps!'
  s.authors     = ["Catbuntu"]
  s.email       = "catbuntu@catbuntu.me"
  s.files       = ["lib/rmvc.rb"]
  s.executables << 'rmvc'
  s.homepage    = "http://unrar.github.io/rmvc"
  s.add_dependency('colorize')
  s.add_dependency('sqlite3')
  s.license     = "MIT"
end
