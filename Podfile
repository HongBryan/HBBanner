source 'https://github.com/CocoaPods/Specs.git'
#source 'http://gitlab.homeking365.com/mobile/app-pod-specs.git'

platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

target 'KBBase' do
    pod 'SwiftyRSA'
    pod 'Alamofire', '~> 4.8.1'
    pod 'HandyJSON'
    pod 'SwiftyJSON', '~> 4.0.0'
end

target 'KBDatabase' do
    pod 'HWCDB.swift', '~> 0.0.12'
    pod 'HandyJSON'
    pod 'SwiftyJSON', '~> 4.0.0'
end

swift42 = ['KBBase']

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if swift42.include?(target.name)
            print "set pod #{target.name} swift version to 4.2\n"
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.2' # or '3.0'
            end
        else
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0' # or '3.0'
            end
        end
    end
end
