#
# Be sure to run `pod spec lint NCLFramework.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
  s.name         = "NCLFramework"
  s.version      = "1.2.5"
  s.summary      = "This iOS library is a collection of commonly used software components shared among various NetJets iOS projects."
  s.homepage     = "http://stash.netjets.com/projects/MOBILE/repos/ios-common-library/browse"

  s.license      = 'NetJets'
  s.authors      = { "Chad Long" => "chlong@netjets.com", "Jeff Bailey" => "jbailey@netjets.com" }

  # Specify the location from where the source should be retrieved.
  #
  #s.source       = { :git => "https://github.com/NetJets/iOSCommonFramework.git", :tag => "0.0.1" }

  s.source       = { :git => "http://stash.netjets.com/scm/mobile/ios-common-library.git" }
  s.prefix_header_file = 'NCLFramework/NCLFramework/NCLFramework-Prefix.pch'


  # If this Pod runs only on iOS or OS X, then specify the platform and
  # the deployment target.
  #
  s.platform     = :ios, '7.0'

  # ――― MULTI-PLATFORM VALUES ――――――――――――――――――――――――――――――――――――――――――――――――― #

  # A list of file patterns which select the source files that should be
  # added to the Pods project. If the pattern is a directory then the
  # path will automatically have '*.{h,m,mm,c,cpp}' appended.
  #
  s.source_files = 'NCLFramework', 'NCLFramework/NCLFramework/**/*.{h,m,xcdatamodeld}'
  s.exclude_files = 'Classes/Exclude'
  
 # A list of resources included with the Pod. These are copied into the
 # target bundle with a build phase script.
 #
 s.resources = "NCLFramework/NCLFramework/*.png",'NCLFramework/NCLFramework/**/*.xcdatamodeld'

  # Specify a list of frameworks that the application needs to link
  # against for this Pod to work.
  s.frameworks = 'Foundation', 'CoreData','UIKit','SystemConfiguration','AudioToolbox'

  s.requires_arc = true
  non_arc_files = 'NCLFramework/NCLFramework/Reachability.m'
  s.exclude_files = non_arc_files
  s.subspec 'no-arc' do |sna|
    sna.requires_arc = false
    sna.source_files = non_arc_files
  end

  # If you need to specify any other build settings, add them to the
  # xcconfig hash.
  #
  # s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }

  # Finally, specify any Pods that this Pod depends on.
  #
  # s.dependency 'JSONKit', '~> 1.4'
end
