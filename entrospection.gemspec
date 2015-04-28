Gem::Specification.new do |s|
  s.name          = 'entrospection'
  s.version       = '0.0.1'
  s.authors       = ['Prolaag']
  s.email         = ['prolaag@gmail.com']

  s.homepage      = 'https://github.com/prolaag/entrospection'

  s.summary       = 'Visualize statistical properties of RNGs'
  s.description   = ''
  s.files         = Dir.glob("{lib,bin}/**/*") + %w(README.md)

  s.executables   << 'entrospect'
  s.executables   << 'entrogen'
  s.executables   << 'entrocine'

  s.add_development_dependency 'bundler'

  s.add_runtime_dependency 'chunky_png'
end
