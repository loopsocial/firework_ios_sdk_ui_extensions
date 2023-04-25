Pod::Spec.new do |s|
  s.name         = 'FireworkVideoUI'
  s.version      = '0.1.0'
  s.summary      = 'An extension library meant to provide easier interfaces for the FireworkVideoSDK.'
  s.homepage     = 'https://github.com/loopsocial/firework_ios_sdk_ui_extensions'
  s.license      = 'Apache License, Version 2.0'
  s.authors      = 'Loop Now Technologies, Inc.'

  s.platforms    = { ios: '12.0' }
  s.source       = { git: 'https://github.com/loopsocial/firework_ios_sdk_ui_extensions.git', tag: "#{s.version}" }

  s.swift_version = '5.0'
  s.source_files = 'Sources/**/*.{h,m,mm,swift}'

  s.dependency 'FireworkVideo'
end
