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
                val path = call.argument<String>("path")
                
                println("📎 Path from Flutter in MainActivity: $path")

                if (path == null) {
            result.error("INVALID_ARGUMENTS", "Expected 'path' arguments but got null.", null)
            return@setMethodCallHandler
        }
                try {
                    val python = Python.getInstance()
                    val module = python.getModule("preprocessing_XML_new")  // <-- Load it only when called

                    //println(" before reults in MainActivity  ln 38")
                    val output = module.callAttr("xml_to_json_corrected", path)
                    result.success(output.toString())

                    //println(" after reults in MainActivity  ln 38")

                } catch (e: Exception) {
                    result.error("PYTHON_ERROR", e.message, null)
                }
            }
        }
    }
}
