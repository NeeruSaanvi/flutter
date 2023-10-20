package com.pinesucceed.tricorder.service

import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanResult
import android.content.*
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log

class BLEManager(private val mContext: Context, adapter: BluetoothAdapter) {
    private val mBluetoothAdapter: BluetoothAdapter = adapter
    private var mTargetDevice: BluetoothDevice? = null
    private var mBluetoothLeService: BluetoothLeService? = null
    private var bScanning = false
    private val mHandler: Handler = Handler(Looper.getMainLooper())
    private var bBindServ = false

    @SuppressLint("MissingPermission")
    fun scanLeDevice(enable: Boolean) {
        if (enable) {
            // Stops scanning after a pre-defined scan period.
            mHandler.postDelayed({
                mBluetoothAdapter.bluetoothLeScanner.stopScan(scanCallback)
//                mBluetoothAdapter.stopLeScan(mLeScanCallback)
                if (bScanning) {
                    //tv_BlueState.setText("search time out!");
                    broadcastUpdate(ACTION_SEARCH_TIME_OUT)
                    Log.d(TAG, "search time out!")
                }
            }, SCAN_PERIOD)
            bScanning = true
            broadcastUpdate(ACTION_START_SCAN)
            mBluetoothAdapter.bluetoothLeScanner.startScan(scanCallback)
//            mBluetoothAdapter.startLeScan(mLeScanCallback)
        } else {
            bScanning = false
            mBluetoothAdapter.bluetoothLeScanner.stopScan(scanCallback)
//            mBluetoothAdapter.stopLeScan(mLeScanCallback)
        }
    }

    private val scanCallback = object : ScanCallback() {
        @SuppressLint("MissingPermission")
        override fun onScanResult(callbackType: Int, result: ScanResult?) {
            super.onScanResult(callbackType, result)
            if (result == null) return
            if (result.device == null || result.device.name.isNullOrEmpty()) return
            if (result.device.name.lowercase().contains("pod")) {
                myBLEConnect(result.device)
            }
        }
    }

//    private val mLeScanCallback: BluetoothAdapter.LeScanCallback =
//        BluetoothAdapter.LeScanCallback { device, rssi, scanRecord -> //			Log.d(TAG, "scan-->"+device.getName());
//            //			if (device!=null && device.getName()!=null
//            //					&& (device.getName().contains("PC-60F")|| "BabyMonitor".equalsIgnoreCase(device.getName()))) {
//            //				mTargetDevice = device;
//            //				scanLeDevice(false);
//            //				Log.i(TAG, "find-->"+mTargetDevice.getName());
//            //				broadcastUpdate(ACTION_FIND_DEVICE);
//            //
//            //				// start BluetoothLeService
//            //				synchronized (this) {
//            //					bBindServ = true;
//            //					Intent gattServiceIntent = new Intent(mContext, BluetoothLeService.class);
//            //					mContext.bindService(gattServiceIntent, mServiceConnection, mContext.BIND_AUTO_CREATE);
//            //				}
//            //			}
//
//            //test
//            (mContext as Activity).runOnUiThread {
////                if (MainActivity.mLeDeviceListAdapter != null /*&& device.getName()!=null
////                                && device.getName().contains("PC-60F")*/) {
////                    MainActivity.mLeDeviceListAdapter.addDevice(device)
////                    MainActivity.mLeDeviceListAdapter.notifyDataSetChanged()
////                }
//            }
//        }

    // Code to manage Service lifecycle.
    private val mServiceConnection: ServiceConnection = object : ServiceConnection {
        override fun onServiceConnected(componentName: ComponentName, service: IBinder) {
            mBluetoothLeService = (service as BluetoothLeService.LocalBinder).service
            if (!mBluetoothLeService!!.initialize()) {
                Log.e(TAG, "Unable to initialize Bluetooth")
                //Toast.makeText(mContext, "Unable to initialize Bluetooth", Toast.LENGTH_SHORT).show();
                return
            }
            mBleHelper = BLEHelper(mBluetoothLeService)

            // Automatically connects to the device upon successful start-up
            // initialization.
            mBluetoothLeService!!.connect(mTargetDevice?.address)
        }

        override fun onServiceDisconnected(componentName: ComponentName) {
            mBluetoothLeService = null
            mBleHelper = null
        }
    }

    fun closeService() {
        synchronized(this) {
            if (bBindServ) {
                mContext.unbindService(mServiceConnection)
                bBindServ = false
            }
            if (mBluetoothLeService != null) {
                mBluetoothLeService!!.close()
                mBluetoothLeService = null
            }
            Log.d(TAG, "-- closeService --")
        }
    }

    /**
     * 断开连接
     */
    fun disconnect() {
        if (mBluetoothLeService != null) {
            mBluetoothLeService!!.disconnect()
        }
    }

    private fun broadcastUpdate(action: String) {
        val intent = Intent(action)
        mContext.sendBroadcast(intent)
    }

    //test
    fun myBLEConnect(device: BluetoothDevice?) {
        mTargetDevice = device
        scanLeDevice(false)
        synchronized(this) {
            bBindServ = true
            val gattServiceIntent = Intent(mContext, BluetoothLeService::class.java)
            mContext.bindService(gattServiceIntent, mServiceConnection, Context.BIND_AUTO_CREATE)
        }
    }

    companion object {
        private const val TAG = "frf" //"BLEManager";
        var mBleHelper: BLEHelper? = null
        private const val SCAN_PERIOD: Long = 15000
        const val ACTION_FIND_DEVICE = "find_device"
        const val ACTION_SEARCH_TIME_OUT = "search_timeout"
        const val ACTION_START_SCAN = "start_scan"

        /**
         * 自定义过滤器
         * custom intentFilter
         */
        fun makeGattUpdateIntentFilter(): IntentFilter {
            val intentFilter = IntentFilter()
            intentFilter.addAction(BluetoothLeService.ACTION_GATT_CONNECTED)
            intentFilter.addAction(BluetoothLeService.ACTION_GATT_DISCONNECTED)
            intentFilter.addAction(BluetoothLeService.ACTION_GATT_SERVICES_DISCOVERED)
            intentFilter.addAction(BluetoothLeService.ACTION_DATA_AVAILABLE)
            //---
            intentFilter.addAction(BluetoothLeService.ACTION_SPO2_DATA_AVAILABLE)
            intentFilter.addAction(BluetoothLeService.ACTION_CHARACTER_NOTIFICATION)
            intentFilter.addAction(ACTION_FIND_DEVICE)
            intentFilter.addAction(ACTION_SEARCH_TIME_OUT)
            intentFilter.addAction(ACTION_START_SCAN)
            return intentFilter
        }
    }

}