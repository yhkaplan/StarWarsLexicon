target 'StarWarsLexicon' do
    platform :ios, '11.0'
    # Use frameworks instead of static libraries for Pods
    use_frameworks!
    
    pod 'RxSwift', '4.0.0'
    # To integrate RxCocoa later
    # pod 'RxCocoa', '~> 4.0'
    pod 'RealmSwift', '3.0.2'
    # To add RxRealm later ('RxRealm')

end

# Adding Quick and Nimble to test target as well
target 'StarWarsLexiconTests' do
    use_frameworks!
    platform :ios, '11.0'
    
    # Tools used in the app
    pod 'RxSwift', '4.0.0'
    pod 'RealmSwift', '3.0.2'
    
    # General testing tools
    pod 'Nimble', '7.0.3'
    pod 'Quick', '1.2.0'
    
    # Rx Testing tools
    #pod 'RxNimble' not working...
    pod 'RxBlocking', '~> 4.0'
    pod 'RxTest', '~> 4.0'
end
