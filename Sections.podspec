#
# Be sure to run `pod lib lint Sections.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Sections'
  s.version          = '0.6.0'
  s.summary          = 'Library for partitioning data into sections displayable in a TableView'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Sections helps you partition arrays or other data structures into arrays of arrays with corresponding descriptions. This is useful for when you have named sections in your table view.
                       DESC

  s.homepage         = 'https://github.com/litso/Sections'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Robert Manson' => 'robmanson@gmail.com' }
  s.source           = { :git => 'https://github.com/litso/Sections.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Sections/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Sections' => ['Sections/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
