#
# Be sure to run `pod lib lint YGFileBrowser.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YGFileBrowser'
  s.version          = '0.1.5'
  s.summary          = 'iOS文件管理和预览.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
iOS文件管理和预览，可预览图片，word，txt，pdf，ptt，等。
                       DESC

  s.homepage         = 'https://github.com/rays77/YGFileBrowser'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rays77' => '376906177@qq.com' }
  s.source           = { :git => 'https://github.com/rays77/YGFileBrowser.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'YGFileBrowser/Classes/**/*.{h,m}'

  s.resource     = 'YGFileBrowser/Assets/YGFileBrowser.bundle'

  # NSBundle *bundle = [NSBundle bundleForClass:<#ClassFromPodspec#>];
  # [UIImage imageWithContentsOfFile:[bundle pathForResource:@"PodTest.bundle/imageName@2x" ofType:@"png"]];
  # s.resource_bundles = {
  #   'YGFileBrowser' => ['YGFileBrowser/Assets/*.{png,jpeg,jpg}']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks    = 'Foundation', 'UIKit', 'QuickLook'
  s.dependency 'AFNetworking', '~> 3.0'
  s.dependency 'Masonry', '~> 0.6.3'
  s.dependency 'SDWebImage', '~> 3.7.3'
  s.dependency 'MJExtension', '~> 3.0.10'

end
