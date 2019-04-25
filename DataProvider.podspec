Pod::Spec.new do |s|
  s.name             = 'DataProvider'
  s.version          = '0.1.0'
  s.summary          = 'A short description of DataProvider.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Giovane Possebon/DataProvider'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Giovane Possebon' => 'giovane.possebon@involves.com.br' }
  s.source           = { :git => 'https://github.com/Giovane Possebon/DataProvider.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.module_name = 'DataProvider'
  s.swift_version = '5.0'
  
  s.dependency 'RealmSwift'
  
  s.subspec 'Timeline' do |ss|
    ss.source_files = 'DataProvider/Classes/Timeline/*'
  end
  
  s.subspec 'Core' do |ss|
    ss.source_files = 'DataProvider/Classes/Core/*'
  end
  
end
