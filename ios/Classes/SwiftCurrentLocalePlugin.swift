import Flutter
import UIKit
import CoreTelephony

public class SwiftCurrentLocalePlugin: NSObject, FlutterPlugin
{
    static let kChannelName = "plugins.easee.com/current_locale"
    
    func getCurrentLocaleIdentifier() -> String
    {
        let fallback = Locale.current
        guard let preferred = Locale.preferredLanguages.first else { return fallback.identifier }
        let locale = Locale(identifier:preferred)
        guard let region = locale.regionCode else { return fallback.identifier }
        guard let language = locale.languageCode else { return fallback.identifier }
        return "\(language)_\(region)"
    }
    
    func getCurrentLocaleDecimalSeparator() -> String?
    {
        let locale = Locale.current
        return locale.decimalSeparator
    }
    
    func getCurrentLanguage() -> String?
    {
        guard let preferred = Locale.preferredLanguages.first else { return nil }
        return Locale(identifier:preferred).languageCode
    }

    func getCurrentCountryCode() -> String?
    {
        guard let carrier = CTTelephonyNetworkInfo().subscriberCellularProvider else { return nil }
        guard let countryCode = carrier.isoCountryCode else { return nil }
        return countryCode
    }
    
    func fallbackRegionLocale() -> String?
    {
        let fallback = Locale.current.regionCode
        guard let preferred = Locale.preferredLanguages.first else { return fallback }
        let locale = Locale(identifier:preferred)
        return locale.regionCode ?? fallback
    }

    func getCurrentRegion() -> String?
    {
        return Locale.current.regionCode
    }
    
    func fallbackLanguage() -> String?
    {
        return Locale.current.languageCode
    }
    
    func getCurrentLocale() -> [String:Any]
    {
        var d = [String:Any]()
        d["identifier"] = getCurrentLocaleIdentifier()
        d["decimals"] = getCurrentLocaleDecimalSeparator()
        
        var language = [String:Any]()
        language["phone"] = getCurrentLanguage()
        language["locale"] = fallbackLanguage()
        d["language"] = language
        
        var country = [String:Any]()
        country["phone"] = getCurrentCountryCode()
        country["locale"] = fallbackRegionLocale()
        country["region"] = getCurrentRegion()
        d["country"] = country
        
        return d
    }
    	
    public static func register(with registrar: FlutterPluginRegistrar)
    {
        let channel = FlutterMethodChannel(name:kChannelName, binaryMessenger: registrar.messenger())
        let instance = SwiftCurrentLocalePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        switch call.method
        {
        case "getCurrentLanguage": result(getCurrentLanguage() ?? fallbackLanguage())
        case "getCurrentCountryCode": result(getCurrentCountryCode() ?? fallbackRegionLocale())
        case "getCurrentLocale": result(getCurrentLocale())
        default: result(FlutterMethodNotImplemented)
        }
    }
}
