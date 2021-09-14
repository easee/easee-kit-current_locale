import 'current_locale_platform.dart' if (dart.library.js) "current_locale_web.dart";

class CurrentLocale
{
	final CurrentLocaleManager _manager = CurrentLocaleFactory.createManager();

	bool get isPlatformSupported => _manager.isPlatformSupported;

	Future<String?> getCurrentLanguage() => _manager.getCurrentLanguage();

	Future<String?> getCurrentCountryCode() => _manager.getCurrentCountryCode();

	Future<CurrentLocaleResult?> getCurrentLocale() => _manager.getCurrentLocale();
}

abstract class CurrentLocaleManager
{ 
	bool get isPlatformSupported; 
	Future<String?> getCurrentCountryCode();
	Future<String?> getCurrentLanguage();
	Future<CurrentLocaleResult?> getCurrentLocale();
}

class CurrentLocaleResult
{
	final String? identifier;
	final String? decimals;
	final CurrentLocaleInfo? language;
	final CurrentCountryInfo? country;

	CurrentLocaleResult({required this.identifier,required this.decimals,required this.language,required this.country});
}

class CurrentLocaleInfo
{
	final String? phone;
	final String? locale;

	CurrentLocaleInfo({this.phone,this.locale});
}

class CurrentCountryInfo extends CurrentLocaleInfo
{
	final String? region;

	CurrentCountryInfo({String? phone,String? locale,this.region}) : super(phone:phone,locale:locale);
}
