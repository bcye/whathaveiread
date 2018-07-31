project 'WHIR.xcodeproj'

# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'WHIR' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for WHIR
  pod 'KMPlaceholderTextView', '~> 1.3.0'
  pod 'BarcodeScanner'

post_install do |installer| installer.pods_project.build_configurations.each do |config|
config.build_settings.delete('CODE_SIGNING_ALLOWED') 
config.build_settings.delete('CODE_SIGNING_REQUIRED') end end
  
end
