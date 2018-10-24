project 'WHIR.xcodeproj'
platform :ios, '11.0'

target 'WHIR' do
  use_frameworks!
  
  # Vendors
  pod 'KMPlaceholderTextView', '~> 1.3.0'
  pod 'BarcodeScanner'
  pod 'SwiftLint'

post_install do |installer|
   installer.pods_project.build_configurations.each do |config|
    config.build_settings.delete('CODE_SIGNING_ALLOWED') 
    config.build_settings.delete('CODE_SIGNING_REQUIRED') 
  end
 end  
end
