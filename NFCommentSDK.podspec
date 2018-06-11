Pod::Spec.new do |s|
  s.name = "NFCommentSDK"
  s.version      = '1.0.1'
  s.summary      = "网易有料评论SDK"
  s.description  = <<-DESC
                   网易有料评论SDK
                   DESC
  s.homepage     = 'https://youliao.163yun.com/'
  s.authors      = { '蔡三泽' => 'caisanze@corp.netease.com' }
  s.license      = { :type => 'Copyright', :text => '©2018 youliao.163yun.com' }
  s.source       = { :http => "https://github.com/NetEaseYouliao/NFCommentSDK/raw/master/NFCommentSDK/NFCommentSDK-#{s.version}.zip" }
  s.requires_arc = true
  s.platform     = :ios
  s.vendored_frameworks = 'NFCommentSDK/NFCommentSDK.framework'
  s.resource     = 'NFCommentSDK/NFCommentSDK.framework/Versions/A/Resources/NFCommentBundle.bundle'
  s.static_framework = true

  s.ios.deployment_target = "8.0"

  s.frameworks = 'UIKit', 'AdSupport'

  s.weak_frameworks = 'CoreFoundation'

  s.dependency 'NFUtilityFoundation'
  s.dependency 'SDWebImage'
end
