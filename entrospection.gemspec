Gem::Specification.new do |s|
  s.name          = 'prolaag-entrospection'
  s.version       = '0.0.1'
  s.authors       = ['Eric Davidson']
  s.email         = ['edavidson@prolaag.com']

  s.homepage      = 'https://github.com/prolaag/entrospection'

  s.summary       = 'Random number visualizer'
  s.description   = ''
  s.files         = Dir.glob("{lib,data,bin,test}/**/*") + %w(README.md)

  s.executables   << 'entrospect'
  s.executables   << 'entrogen'

  s.add_development_dependency 'bundler'

  s.add_runtime_dependency 'chunky_png'
end
