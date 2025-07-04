package com.easee.current_locale

import android.content.Context
import android.icu.text.DecimalFormatSymbols
import android.os.Build
import android.telephony.TelephonyManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class CurrentLocalePlugin : FlutterPlugin, MethodCallHandler
{
	private lateinit var channel : MethodChannel

	private var model : CurrentLocaleModel? = null

	override fun onAttachedToEngine(flutterPluginBinding : FlutterPlugin.FlutterPluginBinding)
	{
		model = CurrentLocaleModel(flutterPluginBinding.applicationContext)

		channel = MethodChannel(flutterPluginBinding.binaryMessenger, "plugins.easee.com/current_locale")
		channel.setMethodCallHandler(this)
	}

	override fun onDetachedFromEngine(binding : FlutterPlugin.FlutterPluginBinding)
	{
		model = null
		channel.setMethodCallHandler(null)
	}

	override fun onMethodCall(call : MethodCall, result : Result)
	{
		model?.onMethodCall(call, result)
	}
}

data class CurrentLocaleModel(val context : Context)
{
	fun onMethodCall(call : MethodCall, result : Result)
	{
		when (call.method)
		{
			"getCurrentLanguage" -> result.success(getCurrentLanguage())
			"getCurrentCountryCode" -> result.success(getCurrentCountryCode() ?: fallbackCountryCode())
			"getCurrentLocale" ->
			{

				val identifier = getIdentifier()
				val decimalSeparator = getDecimalSeparator()

				val language = mapOf(
					"phone" to getCurrentLanguage(), "locale" to getCurrentLanguage()
				)

				val country = mapOf(
					"phone" to getCurrentCountryCode(), "locale" to fallbackCountryCode(), "region" to getRegion()
				)

				result.success(
					mapOf(
						"identifier" to identifier, "decimals" to decimalSeparator, "language" to language, "country" to country
					)
				)
			}

			else -> result.notImplemented()
		}
	}

	private fun getCurrentCountryCode() : String?
	{
		val manager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager?
		if (manager != null)
		{
			val countryId = manager.simCountryIso
			if (countryId != null && countryId.isNotEmpty())
			{
				return countryId.uppercase()
			}
		}
		return null
	}

	private fun fallbackCountryCode() : String?
	{
		if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N)
		{
			val configuration = context.resources.configuration
			val list = configuration.locales
			if (list.size() > 0)
			{
				val locale = list.get(0)
				return locale.country.uppercase()
			}
			return null
		}
		else
		{
			@Suppress("DEPRECATION")
			val current = context.resources.configuration.locale
			return current.country.uppercase()
		}
	}

	private fun getIdentifier() : String?
	{
		if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N)
		{
			val configuration = context.resources.configuration
			val list = configuration.locales
			if (list.size() > 0)
			{
				val locale = list.get(0)
				return locale.toLanguageTag()
			}
			return null
		}
		else
		{
			@Suppress("DEPRECATION")
			val current = context.resources.configuration.locale
			return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP)
			{
				current.toLanguageTag()
			}
			else
			{
				val language : String = current.language
				val country : String = current.country

				return if (country.isNotEmpty())
				{
					"$language-$country"
				}
				else
				{
					language
				}
			}
		}
	}

	private fun getRegion() : String?
	{
		if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N)
		{
			val configuration = context.resources.configuration
			val list = configuration.locales
			if (list.size() > 0)
			{
				val locale = list.get(0)
				return locale.country.uppercase()
			}
			return null
		}
		else
		{
			@Suppress("DEPRECATION")
			val current = context.resources.configuration.locale
			return current.country.uppercase()
		}
	}

	private fun getDecimalSeparator() : String?
	{
		if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N)
		{
			val configuration = context.resources.configuration
			val list = configuration.locales
			if (list.size() > 0)
			{
				val locale = list.get(0)
				val symbols = DecimalFormatSymbols(locale)
				return symbols.decimalSeparator.toString()
			}
			return null
		}
		else
		{
			val symbols = java.text.DecimalFormatSymbols.getInstance()
			return symbols.decimalSeparator.toString()
		}
	}

	private fun getCurrentLanguage() : String?
	{
		val configuration = context.resources.configuration
		if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N)
		{
			val list = configuration.locales
			if (list.size() > 0)
			{
				val locale = list.get(0)
				return locale.language
			}
			return null
		}
		else
		{
			@Suppress("DEPRECATION")
			val current = context.resources.configuration.locale
			return current.language
		}
	}
}
