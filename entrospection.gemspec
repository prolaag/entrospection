Gem::Specification.new do |s|
  s.name          = 'prolaag-entrospection'
  s.version       = '0.0.0'
  s.authors       = ['Eric Davidson']
  s.email         = ['edavidson@prolaag.com']

  s.homepage      = 'https://github.com/prolaag/entrospection'

  s.summary       = 'Random number visualizer'
  s.description   = ''
  # s.files         = Dir.glob("{lib,data,bin,test}/**/*") + %w(README.md)
  s.files         = Dir.glob("{lib,data,bin,test}/**/*")

#  s.executables   << 'pcapinate'
#  s.executables   << 'traffic_dispatcher'

  s.add_development_dependency 'bundler'

  s.add_runtime_dependency 'digest'
#  s.add_runtime_dependency 'openssl'
  s.add_runtime_dependency 'chunky_png'
#  s.add_runtime_dependency gem 'chunky_png'
end
