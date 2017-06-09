Gem::Specification.new do |s|
  s.name = 'oplogjam'
  s.summary = 'A Ruby library to convert MongoDB oplog entries into SQL'
  s.version = '0.1.0'
  s.authors = ["Paul Mucur"]
  s.homepage = 'https://github.com/mudge/oplogjam'
  s.license = 'MIT'
  s.files = %w[README.md LICENSE] + Dir['lib/**/*.rb']
  s.test_files = Dir['spec/**/*.rb']

  s.add_development_dependency('rspec', '~> 3.6')
  s.add_development_dependency('bson', '~> 4.2')
end

