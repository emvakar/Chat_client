platform :ios, '11.0'

def ownPods
    pod 'Starscream', :git => 'https://github.com/emvakar/Starscream.git'

    pod 'MessengerKit', :path => '../../Frameworks/MessengerKit' #:git => 'https://github.com/emvakar/MessengerKit.git', :branch => 'develop'
    pod 'ReverseExtension', :path => '../../Frameworks/ReverseExtension' #:git => 'https://github.com/emvakar/ReverseExtension.git', :branch => 'swift4.2'
    pod 'StatusProvider', :path => '../../Frameworks/StatusProvider' #:git => 'https://github.com/emvakar/StatusProvider.git', :branch => 'develop'
    pod 'DataSources', :path => '../../Frameworks/DataSources' #:git => 'https://github.com/emvakar/DataSources.git', :branch => 'develop'

end


target 'Alexo Chat' do
    use_frameworks!
    inhibit_all_warnings!
    
    pod 'SnapKit'
    pod 'Moya'
    pod 'KRProgressHUD'
    pod 'Cosmos'
    ownPods
    
    target 'Alexo ChatTests' do
        inherit! :search_paths
        
    end
    
    target 'Alexo ChatUITests' do
        inherit! :search_paths
        
    end
    
end
