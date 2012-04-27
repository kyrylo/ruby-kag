require './lib/kag/version'

Gem::Specification.new do |s|
  s.name         = 'kag'
  s.version      = KAG::VERSION
  s.date         = Time.now.strftime('%Y-%m-%d')
  s.summary      = "King Arthur's Gold (KAG) game API wrapper written in Ruby."
  s.author       = 'Kyrylo Silin'
  s.email        = 'kyrylosilin@gmail.com'
  s.homepage     = 'https://github.com/kyrylo/ruby-kag'
  s.license      = 'zlib'

  s.require_path = 'lib'
  s.files        = `git ls-files`.split "\n"
  s.test_files   = `git ls-files -- spec`.split "\n"

  s.extra_rdoc_files = %W{README.md LICENSE}
  s.rdoc_options     = ["--charset=UTF-8"]

  s.add_runtime_dependency     'httparty', '~>0.8.3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'webmock',  '>=1.8.6'
  s.add_development_dependency 'vcr',      '>=2.1.1'

  s.required_ruby_version = '~>1.9'

  s.description  = <<description
    Ruby implementation of King Arthur's Gold (aka KAG) Application Programming
    Interface (aka API).
description
end
