project 'WHIR.xcodeproj'
platform :ios, '11.0'

target 'WHIR' do
  use_frameworks!
  
  # Vendors
  pod 'KMPlaceholderTextView', :git => "https://github.com/MoZhouqi/KMPlaceholderTextView.git" # Current pod has build errors that are fixed on master
  pod 'SwiftLint'
  pod 'Sentry'
  # pod 'SPPermission'
  pod 'WhatsNewKit'

post_install do |installer|
   installer.pods_project.build_configurations.each do |config|
    config.build_settings.delete('CODE_SIGNING_ALLOWED') 
    config.build_settings.delete('CODE_SIGNING_REQUIRED') 
  end
 end  
end
