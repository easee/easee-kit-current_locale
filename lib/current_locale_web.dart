import 'dart:async';

import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:current_locale/current_locale.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class CurrentLocaleFactory
{
	static CurrentLocaleManager createManager() => CurrentLocaleWeb();
}

class CurrentLocaleWeb extends CurrentLocaleManager
{
	static void registerWith(Registrar registrar) 
	{
		final MethodChannel channel = MethodChannel('plugins.davincium.com/current_locale',const StandardMethodCodec(),registrar,);
		final pluginInstance = CurrentLocaleWeb();
		channel.setMethodCallHandler(pluginInstance.handleMethodCall);
	}

	Future<dynamic> handleMethodCall(MethodCall call) async 
	{
		switch (call.method) 
		{
			case 'getCurrentLanguage': return getCurrentLanguage();
			case 'getCurrentCountryCode': return getCurrentCountryCode();
			case 'getCurrentLocale': return getCurrentLocale();
			default:
				throw PlatformException(
					code: 'Unimplemented',
					details: 'current_locale for web doesn\'t implement \'${call.method}\'',
				);
		}
	}

	@override
	bool get isPlatformSupported
	{
		return kIsWeb;
	}

	@override
	Future<String> getCurrentLanguage() async
	{
		var language = html.window.navigator.language;    
		switch(language)
		{
			case "nb-NO":
			case "nb":
			case "no":
			case "nn": return "nb";
			case "en-US":
			case "en": return "en";
		}
		return "nb";
	}

	@override
	Future<String> getCurrentCountryCode() async
	{
		var language = html.window.navigator.language;    
		switch(language)
		{
			case "nb-NO":
			case "nb":
			case "no":
			case "nn": return "NO";
			case "en-US":
			case "en": return "US";
		}
		return "NO";
	}

	CurrentLocaleResult get _noCurrentLocalResult
	{
		return CurrentLocaleResult(
				identifier: "nb_NO",
				decimals: ",",
				language: CurrentLocaleInfo(phone: "nb",locale: "no"),
				country: CurrentCountryInfo(phone: null, locale: "NO", region: "NO")
		);
	}

	CurrentLocaleResult get _enCurrentLocaleResult
	{
		return CurrentLocaleResult(
				identifier: "en_US",
				decimals: ",",
				language: CurrentLocaleInfo(phone: "en",locale: "en"),
				country: CurrentCountryInfo(phone: null, locale: "US", region: "US")
		);
	}

	@override
	Future<CurrentLocaleResult> getCurrentLocale() async
	{
		var language = html.window.navigator.language;    
		switch(language)
		{
			case "nb-NO":
			case "nb":
			case "no":
			case "nn": return Future.value(_noCurrentLocalResult);
			case "en-US":
			case "en": return Future.value(_enCurrentLocaleResult);
		}
		return Future.value(_noCurrentLocalResult);
	}
}
