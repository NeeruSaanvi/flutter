package com.pinesucceed.tricorder

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    companion object {
        private const val ENT_METHOD_CHANNEL = "tricorder/method.otoscope"
        private const val PULSE_METHOD_CHANNEL = "tricorder/method.pulse"
        private const val EVENT_CHANNEL = "tricorder/otoscope"
        private const val PULSE_EVENT_CHANNEL = "tricorder/pulse"
    }

    private lateinit var entMethodChannel: MethodChannel
    private lateinit var pulseMethodChannel: MethodChannel

    private lateinit var eventChannel: EventChannel
    private lateinit var pulseO2EventChannel: EventChannel

    private lateinit var otoScopeStreamHandler: OtoScopeStreamHandler

    private lateinit var pulseO2StreamHandler: PulseO2StreamHandler
    private lateinit var pulseO2MethodsHandler: PulseO2MethodsHandler


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        // Method Channels >>>>>>>>>> [[ START ]] >>>>>>>>>>>>>>>>>>>>
        entMethodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, ENT_METHOD_CHANNEL
        )
        pulseMethodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, PULSE_METHOD_CHANNEL
        )
        eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
        pulseO2EventChannel = EventChannel(
            flutterEngine.dartExecutor.binaryMessenger, PULSE_EVENT_CHANNEL
        )
        // Method Channels >>>>>>>>>> [[ END ]] >>>>>>>>>>>>>>>>>>>>


        // Ent
        otoScopeStreamHandler = OtoScopeStreamHandler(this)
        eventChannel.setStreamHandler(otoScopeStreamHandler)
        EntMethodsHandler(entMethodChannel, otoScopeStreamHandler)

        // Pulse + O2
        pulseO2StreamHandler = PulseO2StreamHandler(this)
        pulseO2EventChannel.setStreamHandler(pulseO2StreamHandler)
        pulseO2MethodsHandler = PulseO2MethodsHandler(
            this, pulseMethodChannel, pulseO2StreamHandler
        )


        super.configureFlutterEngine(flutterEngine)
    }

    override fun onStart() {
        super.onStart()
        pulseO2MethodsHandler.registerReceiver()
    }


    override fun onDestroy() {
        super.onDestroy()
        pulseO2MethodsHandler.unregisterReceiver()
    }

}
