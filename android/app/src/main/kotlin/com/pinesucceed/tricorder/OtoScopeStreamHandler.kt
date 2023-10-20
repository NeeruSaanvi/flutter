package com.pinesucceed.tricorder

import android.app.Activity
import android.graphics.Bitmap
import android.util.Log
import io.flutter.plugin.common.EventChannel
import io.grus.xrhcamera.socket.CameraListener
import io.grus.xrhcamera.socket.UDPManager
import java.io.ByteArrayOutputStream

class OtoScopeStreamHandler(private var activity: Activity?) : EventChannel.StreamHandler {

    companion object {
        private const val TAG = "OtoScopeStreamHandler"
    }

    private lateinit var udpManager: UDPManager

    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
//        stream?.close()
        eventSink = null
        activity = null
//        stream = null
    }

    private val cameraListener = object : CameraListener {
        // Real-time image data, and gyroscope rotation angle callback, bitmap is real-time image data,
        // angle is gyroscope rotation angle
        override fun receiveImageData(bitmap: Bitmap?, angle: Int) {
//            Log.d(TAG, "bitmap: $bitmap")
            Log.d(TAG, "angle: $angle")
            if (bitmap == null) return

            if (activity == null) return

            // Compress the drawable using the quality passed from Flutter
            val stream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.JPEG, 90, stream)

            // Convert the compressed image stream to byte array
            val byteArray = stream.toByteArray() ?: byteArrayOf()

            activity?.runOnUiThread {
                eventSink?.success(
                    mapOf(
                        "image" to byteArray,
                        "angle" to angle
                    )
                )
            }

//            activity?.runOnUiThread { eventSink?.success(Constants.eof) }
        }

        // Battery level information callback When batteryData is greater than 0,
        // it returns the current battery percentage of the device from 0 to 100.
        // When batteryData is less than 0, it means the device is charging
        override fun receiveBatteryData(batteryData: Int) {
//            Log.d(TAG, "batteryData: $batteryData")
//            activity?.runOnUiThread { eventSink?.success(batteryData) }
        }

        // Device connection status and device type callback, isConnect is the device connection status,
        // true means the device is connected, false means the device is disconnected.
        // deviceType returns the device type, for example: SA39A
        override fun connectStateChanged(isConnect: Boolean, deviceType: String?) {
//            Log.d(TAG, "isConnect: $isConnect")
//            Log.d(TAG, "deviceType: $deviceType")
            // Notify Flutter that the network is disconnected
//            activity?.runOnUiThread { eventSink?.success(isConnect) }
        }
    }

    fun startPreview() {
        udpManager = UDPManager.getInstance(cameraListener)
        udpManager.startPreview()
    }

    fun stopPreview(): Boolean {
        if (this::udpManager.isInitialized) {
            udpManager.stopPreview()
            udpManager.removeListener(cameraListener)
            return true
        }
        return false
    }
}