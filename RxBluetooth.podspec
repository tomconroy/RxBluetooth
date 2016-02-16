Pod::Spec.new do |s|
  s.name         = "RxBluetooth"
  s.version      = '0.3'
  s.license      = 'MIT'
  s.platform     = :ios, "8.0"
  s.summary      = 'RxSwift CoreBluetooth'
  s.homepage     = 'https://github.com/SideEffects-xyz/RxBluetooth'
  s.authors      = { 'Junior B.' => 'junior@bonto.ch' }
  s.source       = { :git => "https://github.com/SideEffects-xyz/RxBluetooth.git", :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.frameworks   = 'CoreBluetooth'
  s.source_files = ["RxBluetooth/Source/*swift"]
  s.requires_arc = true

  s.dependency "RxSwift", "~> 2.2.0"
  s.dependency "RxCocoa", "~> 2.2.0"
end
