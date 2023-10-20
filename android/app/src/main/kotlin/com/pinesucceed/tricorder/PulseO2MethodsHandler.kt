package com.pinesucceed.tricorder

import android.annotation.SuppressLint
import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Message
import android.util.Log
import com.pinesucceed.tricorder.service.BLEManager
import com.pinesucceed.tricorder.service.BluetoothLeService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PulseO2MethodsHandler(
    private var activity: Activity?,
    methodChannel: MethodChannel,
    private val pulseO2StreamHandler: PulseO2StreamHandler
) : MethodChannel.MethodCallHandler {

    companion object {
        private const val TAG = "PulseO2MethodsHandler"

        /** 血氧参数  */
        const val MSG_DATA_SPO2_PARA = 0x01

        /** 血氧波形数据  */
        const val MSG_DATA_SPO2_WAVE = 0x02

        /** 血氧搏动标记  */
        const val MSG_DATA_PULSE = 0x03

        /** 取消搏动标记  */
        const val RECEIVEMSG_PULSE_OFF = 0x04

        /** 蓝牙状态信息  */
        const val MSG_BLUETOOTH_STATE = 0x05

        /** 导联脱落  */
        const val MSG_PROBE_OFF = 0x06

        /** 版本号  */
        const val MSG_VERSION = 0x07

        /** 测量工作状态  */
        const val MSG_WORK_STATUS = 0x08
    }

    private lateinit var mManager: BLEManager
    private lateinit var mBluetoothAdapter: BluetoothAdapter

    init {
        methodChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val resultWrapper = MethodChannelResult(result)

        Thread(PulseO2MethodRunner(call, resultWrapper)).start()

    }

    inner class PulseO2MethodRunner(
        private val call: MethodCall,
        private val methodResult: MethodChannel.Result
    ) : Runnable {
        override fun run() {
            when (call.method) {
                "initOximeter" -> oximeterStart()
            }
        }
    }

    private fun oximeterStart() {
        activity?.runOnUiThread {
            val bluetoothManager =
                activity?.getSystemService(FlutterActivity.BLUETOOTH_SERVICE) as BluetoothManager
            mBluetoothAdapter = bluetoothManager.adapter
            mManager = BLEManager(activity!!, mBluetoothAdapter)
            mManager.scanLeDevice(true)
        }
    }

    fun registerReceiver() {
        activity?.registerReceiver(mGattUpdateReceiver, BLEManager.makeGattUpdateIntentFilter())
    }

    fun unregisterReceiver() {
        activity?.unregisterReceiver(mGattUpdateReceiver)
        activity = null
    }

    private val mGattUpdateReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            // Log.d(TAG, "action->"+action);
            when (intent.action) {
                BluetoothLeService.ACTION_GATT_CONNECTED -> {
                    //                    Toast.makeText(this@MainActivity, "connected success", Toast.LENGTH_SHORT)
                    //                        .show()
                    //                tv_BlueState.setText("connected success")
                }
                BluetoothLeService.ACTION_GATT_DISCONNECTED -> {
                    pulseO2StreamHandler.stopOximeter()
                    //				stopWrite();
                }
                BluetoothLeService.ACTION_GATT_SERVICES_DISCOVERED -> {
                    // Show all the supported services and characteristics on
                    // theuser interface.
                    // showAllCharacteristic();
                }
                BluetoothLeService.ACTION_DATA_AVAILABLE -> {
                    //Toast.makeText(this,intent.getStringExtra(BluetoothLeService.EXTRA_DATA),Toast.LENGTH_SHORT).show();
                }
                BluetoothLeService.ACTION_SPO2_DATA_AVAILABLE -> {
                    //byte[] data =intent.getByteArrayExtra(BluetoothLeService.EXTRA_DATA);
                    //Log.d(TAG, "MainActivity received:"+Arrays.toString(data));
                }
                BluetoothLeService.ACTION_CHARACTER_NOTIFICATION -> {
                    //                    Toast.makeText(this@MainActivity, "send wave request", Toast.LENGTH_SHORT)
                    //                        .show()
                    Log.d(TAG, "going to startFingerOximeter")
                    pulseO2StreamHandler.startFingerOximeter()
                }
                BLEManager.ACTION_FIND_DEVICE -> {
                    //                tv_BlueState.setText("find device, start service")
                }
                BLEManager.ACTION_SEARCH_TIME_OUT -> {
                    //                tv_BlueState.setText("search time out!")
                    //                if (progressBar != null) {
                    //                    progressBar.setVisibility(View.GONE)
                    //                }
                }
                BLEManager.ACTION_START_SCAN -> {
                    //                tv_BlueState.setText("discoverying")
                }
            }
        }
    }

    private val myHandler: Handler = @SuppressLint("HandlerLeak") object : Handler() {
        override fun handleMessage(msg: Message) {
            super.handleMessage(msg)
            when (msg.what) {
                MSG_BLUETOOTH_STATE -> {
                    //蓝牙状态信息
//                    tv_BlueState.setText(msg.obj as String)
                }
                MSG_DATA_SPO2_PARA -> {
                    //波形参数
                    //nStatus探头状态 ->true为正常 false为脱落
                    //probe status ->true noraml, false off
                    val bundle = msg.data
                    if (!bundle.getBoolean("nStatus")) {
                        sendEmptyMessage(MSG_PROBE_OFF.toInt())
                    }
                    val nSpo2 = bundle.getInt("nSpO2")
                    val nPR = bundle.getInt("nPR")
                    val fPI = bundle.getFloat("fPI")
                    val b = bundle.getFloat("nPower")
                    val powerLevel = bundle.getInt("powerLevel")
                    //Log.d(TAG, "b："+b+",powerLevel:"+powerLevel);
                    var battery = 0
                    //				if(b!=0){ //bybyMonitor 电量nPower会变0
//					if (b < 2.5f) {
//						battery = 0;
//					} else if (b < 2.8f) {
//						battery = 1;
//					} else if (b < 3.0f)
//						battery = 2;
//					else
//						battery = 3;
//				}else {
//					battery = powerLevel;
//				}
                    battery = powerLevel
//                    setBattery(battery)
//                    setTVSPO2(nSpo2.toString() + "")
//                    setTVPR(nPR.toString() + "")
//                    setTVPI(fPI.toString() + "")
                }
                MSG_DATA_PULSE -> {
//                    showPulse(true)
                }
                RECEIVEMSG_PULSE_OFF -> {
//                    showPulse(false)
                }
                MSG_PROBE_OFF -> {
//                    Toast.makeText(this@MainActivity, "probe off", Toast.LENGTH_SHORT).show()
                }
                MSG_VERSION -> {
                    val bundle = msg.obj as Bundle
                    /*tv_Version.setText(
                        "hVer:" + bundle.getString("hVer") + " ,sVer:" + bundle.getString(
                            "sVer"
                        )
                    )*/
                }
                1001 -> {
//                    tv_IR_LightLevel.setText("IR:" + msg.arg1)
//                    tv_RED_LightLevel.setText("RED:" + msg.arg2)
                }
                MSG_WORK_STATUS -> {
                    val bundle = msg.data
                    if (bundle != null) {
                        var meassage: String? = null
                        /*when (bundle.getInt("mode")) {
                            1 -> { //point measure mode
                                val pointMesureStep = bundle.getInt("pointMesureStep")
                                var param = bundle.getInt("param")
                                val pr = bundle.getInt("pr")
                                when (pointMesureStep) {
                                    0 -> {
                                        text1 = getString(R.string.idle)
                                    }
                                    1 -> {
                                        text2 = ""
                                        text1 = getString(R.string.ready)
                                    }
                                    2 -> {
                                        text1 = getString(R.string.remain_time) + param
                                    }
                                    3 -> {
                                        text1 =
                                            getString(R.string.spo2Value) + param + getString(R.string.prValue) + pr
                                    }
                                    4 -> {
                                        if (param == 0x0a) {
                                            param = 10
                                        } else if (param == 0xff) {
                                            param = 11
                                        }
                                        text2 = getString(R.string.pr_result) + pc60f_prResult.get(param)
                                    }
                                    else -> {
                                        Log.d(TAG, "finish")
                                    }
                                }
                                meassage = getString(R.string.point_measure) + text1 + text2
                            }
                            2 -> { //continuous measure mode
                                meassage = getString(R.string.continous)
                            }
                            3 -> { //menu mode
                                meassage = getString(R.string.menu)
                            }
                        }
                        tv_workStatus.setText(meassage)*/
                    }
                }
                else -> {}
            }
        }
    }


}