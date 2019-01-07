platform :ios, '11.0'

def ownPods
    pod 'Starscream', :git => 'https://github.com/emvakar/Starscream.git'

    pod 'MessageKit', :git => 'https://github.com/emvakar/MessageKit.git', :branch => 'master'
    pod 'ReverseExtension', :git => 'https://github.com/emvakar/ReverseExtension.git', :branch => 'swift4.2'
    pod 'StatusProvider', :git => 'https://github.com/emvakar/StatusProvider.git', :branch => 'develop'
    pod 'DataSources', :git => 'https://github.com/emvakar/DataSources.git', :branch => 'develop'
    pod 'PagingTableView'
    pod 'NotificationBannerSwift'
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
