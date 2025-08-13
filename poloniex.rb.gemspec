require_relative './lib/Poloniex/VERSION'

Gem::Specification.new do |spec|
  spec.name = 'poloniex.rb'

  spec.version = Poloniex::VERSION
  spec.date = '2025-08-13'

  spec.summary = "Access the Poloniex API with Ruby."
  spec.description = "Access the Poloniex API with Ruby."

  spec.author = 'thoran'
  spec.email = 'code@thoran.com'
  spec.homepage = 'http://github.com/thoran/poloniex.rb'
  spec.license = 'Ruby'

  spec.required_ruby_version = '>= 2.7'

  spec.add_dependency('http.rb')
  spec.files = [
    'poloniex.rb.gemspec',
    'Gemfile',
    Dir['lib/**/*.rb'],
    'README.md',
    Dir['test/**/*.rb']
  ].flatten
  spec.require_paths = ['lib']
end
