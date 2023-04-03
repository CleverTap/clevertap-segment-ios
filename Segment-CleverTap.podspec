Pod::Spec.new do |s|
  s.name             = "Segment-CleverTap"
  s.version          = "1.2.5"
  s.summary          = "CleverTap Integration for Segment's analytics-ios library."

  s.description      = <<-DESC
                       Analytics for iOS provides a single API that lets you
                       integrate with over 100s of tools.
                       This is the CleverTap integration for the iOS library.
                       DESC

  s.homepage         = "https://github.com/CleverTap/clevertap-segment-ios"
  s.license          =  { :type => 'MIT' }
  s.author           = { "CleverTap" => "support@clevertap.com" }
  s.source           = { :git => "https://github.com/CleverTap/clevertap-segment-ios.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/clevertap'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.dependency 'Analytics'
  s.dependency 'CleverTap-iOS-SDK', '>= 4.2.2'
  s.source_files = 'Pod/Classes/**/*'

end
