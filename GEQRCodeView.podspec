#
#  Be sure to run `pod spec lint GEQRCodeView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "GEQRCodeView"
  s.version      = "0.0.1"
  s.summary      = "QRCode scanning ViewController for ios6/7"

  s.description  = <<-DESC
                   A longer description of GEQRCodeView in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/lerosua/GEQRCodeView"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  
  s.author             = { "lerosua" => "lerosua+github@gmail.com" }
  # Or just: s.author    = "lerosua"
  # s.authors            = { "lerosua" => "lerosua+github@gmail.com" }
  # s.social_media_url   = "http://twitter.com/lerosua"

  s.platform     = :ios, "6.0"

  s.source       = { :git => "https://github.com/lerosua/GEQRCodeView.git",:tag => "0.0.1" }


  s.source_files  = "GEQRCodeView/core", "GEQRCodeView/core/**/*.{h,m}"
  #s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"


  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"


  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


   s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  #s.dependency  "ZBarSDK", :podspec => 'https://raw.githubusercontent.com/lerosua/ZBarSDK/master/ZBarSDK.podspec'
  s.dependency  'ZBarSDK', '~> 1.3.1'

end
