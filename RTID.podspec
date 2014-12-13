Pod::Spec.new do |s|
  s.name         = "RTID"
  s.version      = "1.0.0"
  s.summary      = "A Drop-in replacement for device UDID"
  s.homepage     = "http://rickytan.cn"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'rickytan' => 'ricky.tan.xin@gmail.com' }
  s.source       = { :git => "https://github.com/rickytan/RTID.git", :tag => s.version.to_s }
  s.platform     = :ios
  s.ios.deployment_target = '6.0'
  s.source_files = 'RTID/*.{h,m}'
  s.requires_arc = true
  s.framework    = 'Security'
end
