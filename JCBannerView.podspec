#
# Be sure to run `pod lib lint JCBannerView.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = "JCBannerView"
s.version          = "1.0.1"
s.summary          = "Supports automatic rolling and click event."
s.homepage         = "http://lijingcheng.github.io/"
# s.screenshots     = "http://7x00ed.com1.z0.glb.clouddn.com/JCBannerView_ScreenShot.png"
s.license          = 'MIT'
s.author           = { "lijingcheng" => "bj_lijingcheng@163.com" }
s.source           = { :git => "https://github.com/lijingcheng/JCBannerView.git", :tag => s.version.to_s }
s.social_media_url = 'http://weibo.com/lijingcheng1984'
s.requires_arc = true
s.source_files = 'Pod/Classes/**/*'
s.platform     = :ios, '8.0'
s.dependency 'SDWebImage', '3.8.2'
s.dependency 'Masonry', '1.0.2'
end
