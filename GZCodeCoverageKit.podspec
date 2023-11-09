#
# Be sure to run `pod lib lint GZCodeCoverageKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides. .org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GZCodeCoverageKit'
  s.version          = '1.0.2'
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
  s.source           = { :git => 'git@github.com:GE-GAO-ZHAO/GZCodeCoverageKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.source_files = 'GZCodeCoverageKit/Classes/**/*'
  
  s.frameworks = 'Foundation', 'UIKit'
  
  s.pod_target_xcconfig = {
      'OTHER_LDFLAGS' => '-fprofile-instr-generate' ,
      'OTHER_SWIFT_FLAGS' => '-profile-generate' ,
      'OTHER_LDFLAGS' => '-fprofile-instr-generate'
  }
end
