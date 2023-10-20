package com.pinesucceed.tricorder

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodChannel

open class MethodChannelResult(private val mResult: MethodChannel.Result) : MethodChannel.Result {

    private var handler: Handler = Handler(Looper.getMainLooper())

    override fun success(result: Any?) {
        handler.post {
            mResult.success(result)
        }
    }

    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
        handler.post {
            mResult.error(errorCode, errorMessage, errorDetails)
        }
    }

    override fun notImplemented() {
        handler.post {
            mResult.notImplemented()
        }
    }


}