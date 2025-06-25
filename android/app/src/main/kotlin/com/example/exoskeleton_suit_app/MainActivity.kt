package com.example.exoskeleton_suit_app

import com.chaquo.python.Python
import com.chaquo.python.android.AndroidPlatform
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.exo.xml"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        if (!Python.isStarted()) {
            Python.start(AndroidPlatform(this))
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "preprocessXml") {
                val path = call.argument<String>("path")!!
                val outputDir = call.argument<String>("outputDir")!!

                try {
                    val python = Python.getInstance()
                    val module = python.getModule("preprocess")  // <-- Load it only when called
                    module.callAttr("xml_to_json_corrected", path, outputDir, 200)
                    result.success("done")
                } catch (e: Exception) {
                    result.error("PYTHON_ERROR", e.message, null)
                }
            }
        }
    }
}
