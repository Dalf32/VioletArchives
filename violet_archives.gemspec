# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'violet_archives/version'

Gem::Specification.new do |spec|
  spec.name          = 'violet_archives'
  spec.version       = VioletArchives::VERSION
  spec.authors       = ['Dalf32']
  spec.email         = ['kylepmullins@gmail.com']

  spec.summary       = 'A client for the DotA 2 game data and patch APIs'
  spec.description   = ''
  spec.homepage      = 'https://github.com/Dalf32/VioletArchives'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/Dalf32/VioletArchives'
    spec.metadata['changelog_uri'] = spec.metadata['source_code_uri']
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
            'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
  #   `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  # end
  spec.files = Dir.chdir(File.expand_path(__dir__)) do |dir|
    Dir.glob(File.join('**', '*.rb'))
  end
  spec.bindir        = 'bin'
  spec.executables   = ['va_console.rb', 'va_patch_parser.rb']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>=3.0.4'
  spec.add_development_dependency 'bundler', '~>2.5.14'
  spec.add_development_dependency 'rake', '>=13.0.3'
  spec.add_dependency 'chronic_duration', '>=0.10.6'
  spec.add_dependency 'json', '>=2.6.1'
end
