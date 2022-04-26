#
# Be sure to run `pod lib lint Sections.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Sections'
  s.version          = '0.10.0'
  s.swift_version    = '5.0'
  s.summary          = 'Library for partitioning data into sections displayable in a TableView'

  s.description      = <<-DESC
Sections helps you partition arrays or other data structures into arrays of arrays with corresponding descriptions. This is useful for when you have named sections in your table view.
                       DESC

  s.homepage         = 'https://github.com/litso/Sections'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Robert Manson' => 'robmanson@gmail.com' }
  s.source           = { :git => 'https://github.com/litso/Sections.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.1'

  s.source_files = 'Sources/Sections/Classes/**/*'
end
