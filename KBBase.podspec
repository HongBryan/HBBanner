Pod::Spec.new do |s|

  s.name         = "KBBase"
  s.version      = "0.0.8"
  s.summary      = "基础库"
  s.description  = "基础库"
  s.homepage     = "https://github.com/HongBryan"

  s.license      = { :type => 'MIT', :file => 'LICENSE.md' }

  s.author       = { "Bryan" => "hongjb@homeking365.com" }

  s.ios.deployment_target  = '9.0'
  s.requires_arc = true
  # s.source       = { :git => "git@gitlab.homeking365.com:mobile/hk-ios-base.git", :tag => "#{s.version}" }
   s.source       = { :git => "https://github.com/HongBryan/HBBanner.git", :tag => "v#{s.version}" }
  # s.resource_bundles = {'HKInnerBundle' => ['HKInnerLibs/resource/*.*']}  #该种方式无法在cocoapod直接使用
  # s.resources    = "HKInnerLibs/resource/HKInnerBundle.bundle"   

  s.subspec 'KBJSONBase' do |subspec|
      subspec.source_files = "KBJSONBase/*.{swift}"
      subspec.dependency "HandyJSON"
      subspec.dependency "SwiftyJSON", "~> 4.0.0"
  end

   s.subspec 'KBHelper' do |subspec|
      subspec.source_files = "KBHelper/*.{swift}"
  end

  s.subspec 'KBDatabase' do |subspec|
      subspec.source_files = "KBDatabase/*.{swift}"
      subspec.dependency "HandyJSON"
      subspec.dependency "SwiftyJSON", "~> 4.0.0"
      subspec.dependency "HWCDB.swift"
      # subspec.ios.vendored_frameworks = "Framework/WCDBSwift.framework"
      subspec.dependency 'KBBase/KBJSONBase'
      subspec.dependency 'KBBase/KBHelper'
  end
end
