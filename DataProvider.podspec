Pod::Spec.new do |s|
  s.name             = 'DataProvider'
  s.version          = '0.1.1'
  s.summary          = 'A short description of DataProvider.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/giovanepossebon/DataProvider'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Giovane Possebon' => 'giovane.possebon@involves.com.br' }
  s.source           = { :git => 'https://github.com/giovanepossebon/DataProvider.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/giovanepossebon'

  s.platform         = :ios, '10.0'
  s.requires_arc = true

  s.module_name = 'DataProvider'
  s.swift_version = '5.0'
  
  s.dependency 'RealmSwift'
  s.dependency 'Fakery'
  
  s.source_files = 'DataProvider/Classes/**/*'
  
end
