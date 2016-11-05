Pod::Spec.new do |spec|
  spec.name = 'Runes'
  spec.version = '4.0.1'
  spec.summary = 'Functional operators for Swift'
  spec.homepage = 'https://github.com/thoughtbot/runes'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = {
    'Gordon Fontenot' => 'gordon@thoughtbot.com',
    'thoughtbot' => nil,
  }
  spec.social_media_url = 'http://twitter.com/thoughtbot'
  spec.source = { :git => 'https://github.com/thoughtbot/runes.git', :tag => "v#{spec.version}" }
  spec.source_files = 'Sources/**/*.{h,swift}'
  spec.requires_arc = true
  spec.compiler_flags = '-whole-module-optimization'
  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.9'
  spec.watchos.deployment_target = '2.0'
  spec.tvos.deployment_target = '9.0'
end
