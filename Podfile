# Uncomment this line to define a global platform for your project
platform :ios, ‘10.0’
# Uncomment this line if you're using Swift
use_frameworks!

def testing_pods
    pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire'
    pod 'Koloda', :git => 'https://github.com/LemonSpike/Koloda.git'
    # pod 'Koloda', :git => 'https://github.com/lukas2/Koloda.git'
    # pod 'Koloda', :git => 'https://github.com/Yalantis/Koloda.git', :branch => 'swift-3'
    pod 'AlamofireObjectMapper', :git => 'https://github.com/tristanhimmelman/AlamofireObjectMapper.git'
    pod 'ObjectMapper', :git => 'https://github.com/Hearst-DD/ObjectMapper.git'
    pod 'GoogleAPIClientForREST/YouTube', :git => 'https://github.com/google/google-api-objectivec-client-for-rest.git'
    pod 'GTMOAuth2', :git => 'https://github.com/google/gtm-oauth2.git'
    pod 'ReachabilitySwift', :git => 'https://github.com/ashleymills/Reachability.swift.git'
    pod 'StatefulViewController', :git => 'https://github.com/aschuch/StatefulViewController.git'
    pod 'NVActivityIndicatorView'
    pod 'Fabric'
    pod 'TwitterKit'
    pod 'TwitterCore'
    pod 'PEGKit', '~> 0.4.2'
    
    post_install do |installer|
        `find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end

end

target 'YoutubeApp' do
    testing_pods
end

target 'YoutubeAppTests' do
    testing_pods
end

