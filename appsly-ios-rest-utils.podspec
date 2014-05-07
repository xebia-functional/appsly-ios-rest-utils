Pod::Spec.new do |spec|
  spec.name         = 'AppslyRESTUtils'
  spec.version      = '1.0.0'
  spec.license      = { :type => 'Apache2' }
  spec.homepage     = 'https://github.com/47deg/appsly-ios-rest-utils'
  spec.authors       = { "47 Degrees" => "hello@47deg.com" }
  spec.summary      = 'RestKit Utils'
  spec.source       = { :git => 'https://github.com/47deg/appsly-ios-rest-utils.git', :tag => 'HEAD' }
  spec.source_files = 'appsly-ios-rest-utils/*.{h,m}'
  spec.framework    = 'SystemConfiguration'
  spec.requires_arc = true
  spec.dependency 'RestKit'
end