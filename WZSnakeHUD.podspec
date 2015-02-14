#
#  Be sure to run `pod spec lint WZSnakeHUD.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "WZSnakeHUD"
  s.version      = "0.1"
  s.summary      = "A clean and neat HUD."
  s.description  = <<-DESC
                   This is my first open source repo. The idea is inspired by Snake Game. This is also an easy-dead HUD, I hope you will like it.
                   DESC
  s.homepage     = "http://wongzigii.com"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Wongzigii" => "wongzigii@outlook.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "http://github/wongzigii/WZSnakeHUD.git", :tag => "0.1" }
  s.source_files  = "WZSnakeHUD", "WZSnakeHUD/*.{h,m}"
  s.requires_arc = true
end
