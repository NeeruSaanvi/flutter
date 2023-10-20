package com.pinesucceed.tricorder

import android.app.Activity
import android.os.Bundle
import android.util.Log
import com.creative.FingerOximeter.FingerOximeter
import com.creative.FingerOximeter.IFingerOximeterCallBack
import com.creative.FingerOximeter.IPC60FCallBack
import com.creative.base.BaseDate
import com.pinesucceed.tricorder.service.BLEManager
import com.pinesucceed.tricorder.service.ReaderBLE
import com.pinesucceed.tricorder.service.SenderBLE
import io.flutter.plugin.common.EventChannel

class PulseO2StreamHandler(
    private var activity: Activity?
) : EventChannel.StreamHandler {

    companion object {
        private const val TAG = "PulseO2StreamHandler"
    }

    private var mFingerOximeter: FingerOximeter? = null

    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        activity = null
    }

    fun startFingerOximeter() {
        if (BLEManager.mBleHelper != null) {
            mFingerOximeter = FingerOximeter(
                ReaderBLE(BLEManager.mBleHelper),
                SenderBLE(BLEManager.mBleHelper),
                FingerOximeterCallBack()
            )
            mFingerOximeter?.Start()
            mFingerOximeter?.QueryDeviceVer()
//            startDraw()

//			stopWrite();
//			writeTimeFile();
        }
    }

    fun stopOximeter() {
        if (mFingerOximeter != null) mFingerOximeter!!.Stop()
        mFingerOximeter = null
    }

    inner class FingerOximeterCallBack : IFingerOximeterCallBack, IPC60FCallBack {
        override fun OnGetSpO2Param(
            nSpO2: Int,
            nPR: Int,
            fPI: Float,
            nStatus: Boolean,
            nMode: Int,
            nPower: Float,
            powerLevel: Int
        ) {
            Log.i(
                TAG,
                "OnGetSpO2Param nSpO2: $nSpO2, nPR: $nPR, fPI: $fPI \n mStatus: $nStatus, nMode: $nMode, nPower: $nPower, powerLevel: $powerLevel"
            )
//            val msg: Message = myHandler.obtainMessage(PulseO2MethodsHandler.MSG_DATA_SPO2_PARA)
            val data = Bundle()
            data.putInt("nSpO2", nSpO2)
            data.putInt("nPR", nPR)
            data.putFloat("fPI", fPI)
            data.putFloat("nPower", nPower)
            data.putBoolean("nStatus", nStatus)
            data.putInt("nMode", nMode)
            data.putInt("powerLevel", powerLevel)

            activity?.runOnUiThread {
                eventSink?.success(
                    mapOf(
                        "spo2" to nSpO2,
                        "pr" to nPR,
                        "pi" to fPI,
                        "status" to nStatus
                    )
                )
            }
//            msg.data = data
//            myHandler.send Message(msg)
            //Log.d(TAG, "nSpO2:"+nSpO2+",nPR:"+nPR+",fPI:"+fPI);
        }

        //血氧波形数据采样频率：50Hz，每包发送 5 个波形数据，即每 1 秒发送 10 包波形数据
        //参数 waves 对应一包数据
        //spo2 sampling rate is 50hz, 5 wave data in a packet,
        //send 10 packet 1/s. param "waves" is 1 data packet
        override fun OnGetSpO2Wave(waves: List<BaseDate.Wave>) {
            Log.d(TAG, "wave.size:" + waves.size) // size = 5
            /*waves.forEach {
                Log.i(TAG, "data: ${it.data}")
                Log.w(TAG, "flag: ${it.flag}")
            }*/
            activity?.runOnUiThread {
                eventSink?.success(waves.map { it.data })
            }
//            SPO_RECT.addAll(waves)
//            SPO_WAVE.addAll(waves)
        }

        override fun OnGetDeviceVer(hardVer: String, softVer: String, deviceName: String) {
            val bundle = Bundle()
            bundle.putString("sVer", softVer)
            bundle.putString("hVer", hardVer)
//            myHandler.obtainMessage(PulseO2MethodsHandler.MSG_VERSION, bundle)
//                .sendToTarget()
        }

        override fun OnConnectLose() {
//            myHandler.obtainMessage(PulseO2MethodsHandler.MSG_BLUETOOTH_STATE, "connect lost").sendToTarget()
        }

        override fun onGetWorkStatus_60F(mode: Int, pointMesureStep: Int, param: Int, pr: Int) {
            Log.d(TAG, "60F mode:$mode,pointMesureStep:$pointMesureStep,param:$param,pr:$pr")
//            val msg: Message = myHandler.obtainMessage(PulseO2MethodsHandler.MSG_WORK_STATUS)
            val bundle = Bundle()
            bundle.putInt("mode", mode)
            bundle.putInt("pointMesureStep", pointMesureStep)
            bundle.putInt("param", param)
            bundle.putInt("pr", pr)
//            msg.data = bundle
//            myHandler.sendMessage(msg)
        } //		@Override
        //		public void OnGetSpO2Param_BabyRedLight(int IR_LightLevel, int RED_LightLevel) {
        //			myHandler.obtainMessage(1001, IR_LightLevel, RED_LightLevel).sendToTarget();
        //		}


    }
}