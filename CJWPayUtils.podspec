Pod::Spec.new do |s|
  s.name         = 'CJWPayUtils'
  s.version      = '1.0.0'
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.homepage     = 'https://github.com/frankcjw/'
  s.author       = { "frank" => "fk911c@gmail.com" }
  s.summary      = 'noting'
  s.platform     =  :ios, '8.0'
  s.source       = { :git => "https://github.com/frankcjw/CJWPayUtils.git"  }
  s.exclude_files = 'CJWPayUtils-Bridging-Header.h'
  s.source_files  = "CJWPayUtils/CJWPayOrder.{h,m}","CJWPayUtils/CJWPayUtils.{h,m}","CJWPayUtils/*.{h,m}","CJWPayUtils/*.swift","CJWOrder.swift"
  s.ios.vendored_frameworks = 'CJWPayUtils/AlipaySDK.framework'
  s.frameworks   =  'UIKit',"Foundation","CoreGraphics","CoreText","QuartzCore","CoreTelephony","SystemConfiguration","CFNetwork","CoreMotion"
  s.requires_arc = true
  s.resource = 'CJWPayUtils/AlipaySDK.bundle','CJWPayUtils/AliLib/AlipaySDK.framework'
  s.vendored_libraries = "CJWPayUtils/libWeChatSDK.a","CJWPayUtils/libUPPayPlugin.a"
  s.libraries = "c++","z","c","sqlite3.0","stdc++.6.0.9"

  s.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC',"ENABLE_BITCODE" =>'NO'}

 
  #,"CJWPayUtils/libssl.a"
  #s.dependency "OpenSSL"
# Pod Dependencies

s.subspec 'OpenSSL' do |openssl|
    #openssl.ios.source_files        = 'CJWPayUtils/openssl/**/*.h'
    #openssl.ios.public_header_files = 'CJWPayUtils/openssl/**/*.h'
    #openssl.ios.header_dir          = 'openssl'
    #openssl.ios.preserve_paths      = 'CJWPayUtils/libcrypto.a', 'CJWPayUtils/libssl.a'
    #openssl.ios.vendored_libraries  = 'CJWPayUtils/libcrypto.a', 'CJWPayUtils/libssl.a'

    openssl.preserve_paths = 'CJWPayUtils/openssl/*.h'
    openssl.vendored_libraries = 'CJWPayUtils/libcrypto.a', 'CJWPayUtils/libssl.a'
    openssl.libraries = 'ssl', 'crypto'
    openssl.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/CJWPayUtils/openssl/*.h" }

end

end