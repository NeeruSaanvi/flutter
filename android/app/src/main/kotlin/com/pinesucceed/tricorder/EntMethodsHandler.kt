package com.pinesucceed.tricorder

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class EntMethodsHandler(
    methodChannel : MethodChannel,
    private val otoScopeStreamHandler: OtoScopeStreamHandler
) : MethodChannel.MethodCallHandler {

    init {
        methodChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val resultWrapper = MethodChannelResult(result)

        // Ent
        Thread(EntMethodRunner(call, resultWrapper)).start()
    }

    inner class EntMethodRunner(
        private val call: MethodCall,
        private val methodResult: MethodChannel.Result
    ) : Runnable {
        override fun run() {
            when (call.method) {
                "startPreview" -> {
                    startPreview(methodResult)
                }
                "stopPreview" -> {
                    stopPreview(methodResult)
                }
            }
        }
    }

    private fun startPreview(methodResult: MethodChannel.Result) {
        otoScopeStreamHandler.startPreview()
        methodResult.success(true)
    }

    private fun stopPreview(methodResult: MethodChannel.Result) {
        val result = otoScopeStreamHandler.stopPreview()
        methodResult.success(result)
    }
}