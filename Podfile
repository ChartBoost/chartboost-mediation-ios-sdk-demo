platform :ios, '13.0'

abstract_target 'Demo' do

  use_frameworks!

  if ENV['MEDIATION_DEMO_BUILD_TYPE'] == "DEVELOPMENT"
    # Local pod dependencies for internal use
    pod 'ChartboostCoreSDK', :path => '../../Core'
    pod 'ChartboostMediationSDK', :path => '../'
    pod 'ChartboostSDK', :path => '../../Monetization'
    pod 'ChartboostMediationAdapterChartboost', :path => '../Adapter/chartboost-mediation-ios-adapter-chartboost'
  else
    # Production pod dependencies for general use
    pod 'ChartboostCoreSDK', '~> 1.0'
    pod 'ChartboostMediationSDK', '~> 5.4'
    pod 'ChartboostSDK'
    # Uncomment any of the following lines to use provider
    # *** Remember to add your GADApplicationIdentifier to Info.plist if you use AdMob ***
    # pod 'ChartboostMediationAdapterAdMob'
    # pod 'ChartboostMediationAdapterAppLovin'
    # pod 'ChartboostMediationAdapterAmazonPublisherServices'
    pod 'ChartboostMediationAdapterChartboost'
    # pod 'ChartboostMediationAdapterDigitalTurbineExchange'
    # pod 'ChartboostMediationAdapterGoogleBidding'
    # pod 'ChartboostMediationAdapterInMobi'
    # pod 'ChartboostMediationAdapterIronSource'
    # pod 'ChartboostMediationAdapterMetaAudienceNetwork'
    # pod 'ChartboostMediationAdapterMintegral'
    # pod 'ChartboostMediationAdapterPangle'
    # pod 'ChartboostMediationAdapterUnityAds'
    # pod 'ChartboostMediationAdapterVungle'
  end

  target 'ChartboostMediationDemo-UIKit'
  target 'ChartboostMediationDemo-SwiftUI'
  target 'ChartboostMediationDemo-ObjC'

end
