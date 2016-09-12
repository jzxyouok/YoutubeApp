# Uncomment this line to define a global platform for your project
platform :ios, ‘9.0’
# Uncomment this line if you're using Swift
use_frameworks!

target 'YoutubeApp' do
    
    pod 'Alamofire', '~> 3.0'
    pod 'Koloda', :git => 'https://github.com/LemonSpike/Koloda.git'
    pod 'AlamofireObjectMapper', '~> 3.0'
    pod 'GoogleAPIClientForREST/YouTube', :git => 'https://github.com/google/google-api-objectivec-client-for-rest.git'
    pod 'GTMOAuth2', :git => 'https://github.com/google/gtm-oauth2.git'
    pod 'ReachabilitySwift'
    pod 'StatefulViewController', :git => 'https://github.com/aschuch/StatefulViewController.git'
    pod 'NVActivityIndicatorView'
    
    post_install do |installer|
        `find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
    end
    
end

