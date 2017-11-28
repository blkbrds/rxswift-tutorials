platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!
workspace 'RxSwiftTutorials'

def shared_pods
  	pod 'PromiseKit/Foundation', '~> 4.4'
  	pod 'RxSwift', '~> 4.0'
  	pod 'RxCocoa', '~> 4.0'
end

target 'RxSwiftTutorials' do
	project 'RxSwiftTutorials'
	shared_pods
end

target 'FS' do
	project 'FS/FS'
	shared_pods
	pod 'MVVM'
    pod 'SwiftUtils', '~> 2.1.1'
end
