#
# Be sure to run `pod lib lint GZCodeCoverageKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides. .org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GZCodeCoverageKit'
  s.version          = '0.1.2'
  s.summary          = 'A short description of GZCodeCoverageKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/葛高召/GZCodeCoverageKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '葛高召' => 'gaozhao.ge@huolala.cn' }
  s.source           = { :git => 'https://github.com/GE-GAO-ZHAO/GZCodeCoverageKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
#  s.swift_version = '5.0'
  s.source_files = 'GZCodeCoverageKit/Classes/**/*'
  
#  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
#  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  
#  s.frameworks = 'Foundation', 'UIKit'
#  s.compiler_flags = '-OTHER_CFLAGS=-fcoverage-mapping', 'OTHER_SWIFT_FLAGS=-profile-coverage-mapping', 'OTHER_LDFLAGS=-fprofile-instr-generate"
  
  
  # s.resource_bundles = {
  #   'GZCodeCoverageKit' => ['GZCodeCoverageKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
