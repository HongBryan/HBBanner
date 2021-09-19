Pod::Spec.new do |s|

  s.name         = "KBBase"
  s.version      = "0.0.1"
  s.summary      = "基础库"
  s.description  = "基础库"
  s.homepage     = "http://www.homeking365.com"

  s.license      = { :type => 'MIT', :file => 'LICENSE.md' }

  s.author       = { "Bryan" => "hongjb@homeking365.com" }

  s.ios.deployment_target  = '9.0'
  s.requires_arc = true
  # s.source       = { :git => "git@gitlab.homeking365.com:mobile/hk-ios-base.git", :tag => "#{s.version}" }
   s.source       = { :git => "git@gitlab.homeking365.com:mobile/hk-ios-base.git", :tag => "#{s.version}" }
  # s.resource_bundles = {'HKInnerBundle' => ['HKInnerLibs/resource/*.*']}  #该种方式无法在cocoapod直接使用
  # s.resources    = "HKInnerLibs/resource/HKInnerBundle.bundle"   

  s.subspec 'HKJSONBase' do |subspec|
      subspec.source_files = "HKJSONBase/*.{swift}"
      subspec.dependency "HandyJSON"
      subspec.dependency "SwiftyJSON", "~> 4.0.0"
  end

  s.subspec 'HKDatabase' do |subspec|
      subspec.source_files = "HKDatabase/*.{swift}"
      subspec.dependency "HandyJSON"
      subspec.dependency "SwiftyJSON", "~> 4.0.0"
      subspec.dependency "HWCDB.swift"
      subspec.dependency 'HKBase/HKJSONBase'
  end
end