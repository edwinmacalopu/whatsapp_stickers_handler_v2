package com.indiagenisys.whatsapp_stickers_handler_v2

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry

/**
 * WhatsappStickersHandlerV2Plugin
 */
class WhatsappStickersHandlerV2Plugin : FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private var channel: MethodChannel? = null
    private var context: Context? = null
    private var activity: Activity? = null
    private var result: MethodChannel.Result? = null
    private var stickerPacks = ArrayList<StickerPack>()


    override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "whatsapp_stickers_handler_v2")
        channel!!.setMethodCallHandler(this)
        Stash.clearAll();
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        this.result = result;
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "isWhatsAppInstalled" -> {
                result.success(WhitelistCheck.isWhatsAppInstalled(context as Context))
            }
            "isWhatsAppConsumerAppInstalled" -> {
                result.success(WhitelistCheck.isWhatsAppConsumerAppInstalled(context?.packageManager))
            }
            "isWhatsAppSmbAppInstalled" -> {
                result.success(WhitelistCheck.isWhatsAppSmbAppInstalled(context?.packageManager))
            }
            "isStickerPackInstalled" -> {
                val stickerPackIdentifier = call.argument<String>("identifier");
                Log.e("DEBUG PACK", "CHECK EIATHER $stickerPackIdentifier IS INSTALLED!");
                if (stickerPackIdentifier != null && context != null) {
                    val installed = WhitelistCheck.isWhitelisted(context!!, stickerPackIdentifier)
                    result.success(installed)
                }
            }
            "launchWhatsApp" -> {
                try {
                    val launchIntent: Intent = context?.packageManager?.getLaunchIntentForPackage(WhitelistCheck.CONSUMER_WHATSAPP_PACKAGE_NAME)!!
                    activity?.startActivity(launchIntent)
                    result.success(true)
                } catch (e: Exception) {
                    e.message?.let {
                        result.error("error", "There some error occurred while launching WhatsApp", "")
                    }
                }
            }
            "addStickerPackToWhatsApp" -> {

                Stash.clearAll();

                Log.d("DEBUG",
                    call.argument<Any>("identifier").toString() + " " + call.argument("name") + " " +
                            call.argument("publisher") + " " + call.argument("trayimagefile") + " " +
                            call.argument("publisheremail") + " " + call.argument("publisherwebsite") + " " +
                            call.argument("privacypolicywebsite") + " " + call.argument("licenseagreementwebsite") + " " +
                            call.argument("stickers") + " " + call.argument("avoidCache") + " "+  call.argument("animatedStickerPack")
                            + " " +call.argument("imageDataVersion")
                )

                try {
                    val stickerPack = StickerPack(
                        call.argument("identifier"),
                        call.argument("name"),
                        call.argument("publisher"),
                        call.argument("trayimagefile"),
                        call.argument("publisheremail"),
                        call.argument("publisherwebsite"),
                        call.argument("privacypolicywebsite"),
                        call.argument("licenseagreementwebsite"),
                        call.argument("imageDataVersion"),
                        call.argument("avoidCache")!!,
                        call.argument("animatedStickerPack")!!,
                    )

                    val sts = call.argument<HashMap<String,List<String>>>("stickers")!!
                    val stickers: ArrayList<Sticker> = ArrayList();
                    sts.map {
                        val sticker = Sticker(
                            it.key,
                            it.value
                        );
                        stickers.add(sticker);
                    }

                    stickerPack.setAndroidPlayStoreLink("https://play.google.com/store/apps/details?id=${context?.packageName}")
                    stickerPack.setIosAppStoreLink("")
                    stickerPack.setStickers(stickers)

                    context?.let { StickerPackValidator.verifyStickerPackValidity(it, stickerPack) };
                    // send intent to whatsapp
                    val ws = WhitelistCheck.isWhatsAppConsumerAppInstalled(context?.packageManager)
                    if (!(ws || WhitelistCheck.isWhatsAppSmbAppInstalled(context?.packageManager))) {
                        throw InvalidPackException(InvalidPackException.OTHER, "WhatsApp is not installed on target device!")
                    }
                    val stickerPackIdentifier = stickerPack.identifier
                    val stickerPackName = stickerPack.name
                    val authority: String? = context?.let { getContentProviderAuthority(it) }

                    stickerPack.setAndroidPlayStoreLink("https://play.google.com/store/apps/details?id=${context?.packageName}")
                    stickerPack.setIosAppStoreLink("")
                    stickerPack.setStickers(stickers)
                    stickerPacks.add(stickerPack)
                    Stash.put("sticker_pack", stickerPacks)

                    val intent = createIntentToAddStickerPack(authority, stickerPackIdentifier, stickerPackName)

                    try {
                        this.activity?.startActivityForResult(Intent.createChooser(intent, "ADD Sticker"), 200)
                    } catch (e: ActivityNotFoundException) {
                        throw InvalidPackException(
                            InvalidPackException.FAILED,
                            "Sticker pack not added. If you'd like to add it, make sure you update to the latest version of WhatsApp."
                        )
                    }

                } catch (e: InvalidPackException) {
                    e.message?.let { Log.e("ERROR", it) };
                    result.error(e.code, e.message, null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        channel!!.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        context = binding.activity.applicationContext;
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
        context = null
        result = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        context = binding.activity.applicationContext;
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null
        context = null
        result = null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if(result == null){
            Log.e("DEBUG", "RESULT IS NULL");
        }else{
            Log.e("DEBUG", "RESULT IS NOT NULL");
        }

        if (requestCode == 200) {
            if (resultCode == Activity.RESULT_CANCELED) {
                if (data != null) {
                    val validationError = data.getStringExtra("validation_error")
                    if (validationError != null) {
                        result?.error("error", validationError, "")
                    }
                } else {
                    result?.error("cancelled", "cancelled", "")
                }
            } else if (resultCode == Activity.RESULT_OK) {
                if (data != null) {
                    val bundle = data.extras!!
                    if (bundle!!.containsKey("add_successful")) {
                        result?.success("add_successful")
                    } else if (bundle!!.containsKey("already_added")) {
                        result?.error("already_added", "already_added", "")
                    } else {
                        result?.success("success")
                    }
                } else {
                    result?.success("success")
                }
            } else {
                result?.success("unknown")
            }
        }
        return true
    }

    fun createIntentToAddStickerPack(authority: String?, identifier: String?, stickerPackName: String?): Intent? {
        val intent = Intent()
        intent.action = "com.whatsapp.intent.action.ENABLE_STICKER_PACK"
        intent.putExtra(EXTRA_STICKER_PACK_ID, identifier)
        intent.putExtra(EXTRA_STICKER_PACK_AUTHORITY, authority)
        intent.putExtra(EXTRA_STICKER_PACK_NAME, stickerPackName)
        return intent
    }

    companion object {
        private const val EXTRA_STICKER_PACK_ID = "sticker_pack_id"
        private const val EXTRA_STICKER_PACK_AUTHORITY = "sticker_pack_authority"
        private const val EXTRA_STICKER_PACK_NAME = "sticker_pack_name"

        @JvmStatic
        fun getContentProviderAuthority(context: Context): String {
            return context.packageName + ".stickercontentprovider"
        }
    }
}