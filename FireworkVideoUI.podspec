Pod::Spec.new do |s|
  s.name         = 'FireworkVideoUI'
  s.version      = '0.2.4'
  s.summary      = 'An extension library meant to provide easier interfaces for the FireworkVideoSDK.'
  s.homepage     = 'https://github.com/loopsocial/firework_ios_sdk_ui_extensions'
  s.license      = 'Apache License, Version 2.0'
  s.authors      = 'Loop Now Technologies, Inc.'

  s.platforms    = { ios: '13.0' }
  s.source       = { git: 'https://github.com/loopsocial/firework_ios_sdk_ui_extensions.git', tag: "v#{s.version}" }

  s.swift_version = '5.3'
  s.source_files = 'Sources/**/*.{swift}'

  s.dependency 'FireworkVideo'
end
