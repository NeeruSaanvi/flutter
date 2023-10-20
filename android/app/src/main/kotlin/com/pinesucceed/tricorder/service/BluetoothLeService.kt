package com.pinesucceed.tricorder.service

import android.annotation.SuppressLint
import android.app.Service
import android.bluetooth.*
import android.content.Intent
import android.os.Binder
import android.os.IBinder
import android.util.Log
import java.io.IOException
import java.util.*
import java.util.concurrent.LinkedBlockingQueue


/**
 * Service for managing connection and data communication with a GATT server hosted on a
 * given Bluetooth LE device.
 */
@SuppressLint("NewApi")
class BluetoothLeService : Service() {
    private var mBluetoothManager: BluetoothManager? = null
    private var mBluetoothAdapter: BluetoothAdapter? = null
    private var mBluetoothDeviceAddress: String? = null
    private var mBluetoothGatt: BluetoothGatt? = null

    // Implements callback methods for GATT events that the app cares about.  For example,
    // connection change and services discovered.
    private val mGattCallback: BluetoothGattCallback = object : BluetoothGattCallback() {
        @SuppressLint("MissingPermission")
        override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
            val intentAction: String
            if (newState == BluetoothProfile.STATE_CONNECTED) {
                intentAction = ACTION_GATT_CONNECTED
                mConnectionState = STATE_CONNECTED
                broadcastUpdate(intentAction)
                Log.i(TAG, "Connected to GATT server.")
                // Attempts to discover services after successful connection.
                Log.i(
                    TAG, "Attempting to start service discovery:" +
                            mBluetoothGatt!!.discoverServices()
                )
            } else if (newState == BluetoothProfile.STATE_DISCONNECTED) {
                intentAction = ACTION_GATT_DISCONNECTED
                mConnectionState = STATE_DISCONNECTED
                Log.i(TAG, "Disconnected from GATT server.")
                broadcastUpdate(intentAction)
            }
        }

        override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
            if (status == BluetoothGatt.GATT_SUCCESS) {
                broadcastUpdate(ACTION_GATT_SERVICES_DISCOVERED)
            } else {
                Log.w(
                    TAG,
                    "onServicesDiscovered received: $status"
                )
            }

            //设置监听,获取onCharacteristic()的通知回调
            Log.i(
                TAG,
                "set linstening of notificaiton callback(Function onCharacteristicChanged() callback) ,in writting characteristic "
            )
            val characteristic = getGattCharacteristic(UUID_CHARACTER_READ)
            characteristic?.let {
                setCharacteristicNotification(characteristic, true)
            }
        }

        override fun onCharacteristicRead(
            gatt: BluetoothGatt,
            characteristic: BluetoothGattCharacteristic, status: Int
        ) {
            Log.d(TAG, "onCharacteristicRead $status")
            if (status == BluetoothGatt.GATT_SUCCESS) {
                broadcastUpdate(ACTION_DATA_AVAILABLE, characteristic)
            }
        }

        override fun onCharacteristicChanged(
            gatt: BluetoothGatt,
            characteristic: BluetoothGattCharacteristic
        ) {
            //Log.d(TAG, "service receive data："+ Arrays.toString(characteristic.getValue()));
            //broadcastUpdate(ACTION_SPO2_DATA_AVAILABLE, characteristic);
            mBuffer.add(characteristic.value)
        }

        /**
         * 当写characteristics得到结果时回调 ,命令是否发送成功
         * whether or not Characteristic Write success
         */
        override fun onCharacteristicWrite(
            gatt: BluetoothGatt,
            characteristic: BluetoothGattCharacteristic,
            status: Int
        ) {
            //Log.d(TAG, "onCharacteristicWrite " + status);
            if (status == BluetoothGatt.GATT_SUCCESS) {
//            	try {
//                     byte[] mByte = characteristic.getValue();
//                     StringBuilder strBuilder = new StringBuilder(mByte.length);
//                     for (byte mByteChar : mByte) {
//                         strBuilder.append(String.format("%02x", mByteChar));
//                     }
//                     Log.d(TAG, strBuilder.toString());
//                 } catch (Exception e) {
//                     e.printStackTrace();
//                 }
                val mByte = characteristic.value
                if (mByte != null && mByte.isNotEmpty()) {
                    if (mByte[4].toInt() and 0xff == 0x84) {
                        Log.i(TAG, "enable param of request-> send success")
                    } else if (mByte[4].toInt() and 0xff == 0x85) {
                        Log.d(TAG, "enable [ wave ] of request-> send success")
                    }
                }
            }
        }

        //listen for whether or not notification success
        override fun onDescriptorWrite(
            gatt: BluetoothGatt,
            descriptor: BluetoothGattDescriptor,
            status: Int
        ) {
//        	if (status == BluetoothGatt.GATT_SUCCESS){
//				Log.d(TAG, descriptor.getCharacteristic().getUuid()+ " Notification Enabled");
//        	}
            if (UUID_CHARACTER_READ == descriptor.characteristic.uuid) {
                Log.d(TAG, "CHARACTER_READ-> Notification Enabled")
                broadcastUpdate(ACTION_CHARACTER_NOTIFICATION)
            }
        }
    }

    private fun broadcastUpdate(action: String) {
        val intent = Intent(action)
        sendBroadcast(intent)
    }

    private val buf = ByteArray(20)
    private fun broadcastUpdate(
        action: String,
        characteristic: BluetoothGattCharacteristic
    ) {
        val intent = Intent(action)
        if (UUID_CHARACTER_WRITE == characteristic.uuid) {
            var bufIndex = 0
            val data = characteristic.value
            for (b in data) {
                buf[bufIndex] = b
                bufIndex++
                if (bufIndex == buf.size) {
                    intent.putExtra(EXTRA_DATA, buf)
                    sendBroadcast(intent)
                }
            }
        } else {
            // For all other profiles, writes the data formatted in HEX.
            val data = characteristic.value
            if (data != null && data.isNotEmpty()) {
                //final StringBuilder stringBuilder = new StringBuilder(data.length);
                intent.putExtra(EXTRA_DATA, String(data))
                sendBroadcast(intent)
            }
        }
    }

    inner class LocalBinder : Binder() {
        val service: BluetoothLeService
            get() = this@BluetoothLeService
    }

    override fun onBind(intent: Intent): IBinder? {
        return mBinder
    }

    override fun onUnbind(intent: Intent): Boolean {
        // After using a given device, you should make sure that BluetoothGatt.close() is called
        // such that resources are cleaned up properly.  In this particular example, close() is
        // invoked when the UI is disconnected from the Service.
        close()
        return super.onUnbind(intent)
    }

    private val mBinder: IBinder = LocalBinder()

    /**
     * Initializes a reference to the local Bluetooth adapter.
     *
     * @return Return true if the initialization is successful.
     */
    fun initialize(): Boolean {
        // For API level 18 and above, get a reference to BluetoothAdapter through
        // BluetoothManager.
        if (mBluetoothManager == null) {
            mBluetoothManager = getSystemService(BLUETOOTH_SERVICE) as BluetoothManager
            if (mBluetoothManager == null) {
                Log.e(TAG, "Unable to initialize BluetoothManager.")
                return false
            }
        }
        mBluetoothAdapter = mBluetoothManager!!.adapter
        if (mBluetoothAdapter == null) {
            Log.e(TAG, "Unable to obtain a BluetoothAdapter.")
            return false
        }
        return true
    }

    /**
     * Connects to the GATT server hosted on the Bluetooth LE device.
     *
     * @param address The device address of the destination device.
     *
     * @return Return true if the connection is initiated successfully. The connection result
     * is reported asynchronously through the
     * `BluetoothGattCallback#onConnectionStateChange(android.bluetooth.BluetoothGatt, int, int)`
     * callback.
     */
    @SuppressLint("MissingPermission")
    fun connect(address: String?): Boolean {
        if (mBluetoothAdapter == null || address == null) {
            Log.w(TAG, "BluetoothAdapter not initialized or unspecified address.")
            return false
        }

        // Previously connected device.  Try to reconnect.
        if (mBluetoothDeviceAddress != null && address == mBluetoothDeviceAddress && mBluetoothGatt != null) {
            Log.d(TAG, "Trying to use an existing mBluetoothGatt for connection.")
            return if (mBluetoothGatt!!.connect()) {
                mConnectionState = STATE_CONNECTING
                true
            } else {
                false
            }
        }
        val device = mBluetoothAdapter!!.getRemoteDevice(address)
        if (device == null) {
            Log.w(TAG, "Device not found.  Unable to connect.")
            return false
        }
        // We want to directly connect to the device, so we are setting the autoConnect
        // parameter to false.
        mBluetoothGatt = device.connectGatt(this, false, mGattCallback)
        Log.d(TAG, "Trying to create a new connection.")
        mBluetoothDeviceAddress = address
        mConnectionState = STATE_CONNECTING
        return true
    }

    /**
     * Disconnects an existing connection or cancel a pending connection. The disconnection result
     * is reported asynchronously through the
     * `BluetoothGattCallback#onConnectionStateChange(android.bluetooth.BluetoothGatt, int, int)`
     * callback.
     */
    @SuppressLint("MissingPermission")
    fun disconnect() {
        if (mBluetoothAdapter == null || mBluetoothGatt == null) {
            Log.w(TAG, "BluetoothAdapter not initialized->1")
            return
        }
        mBluetoothGatt!!.disconnect()
    }

    /**
     * After using a given BLE device, the app must call this method to ensure resources are
     * released properly.
     */
    @SuppressLint("MissingPermission")
    fun close() {
        if (mBluetoothGatt == null) {
            return
        }
        mBluetoothGatt!!.close()
        mBluetoothGatt = null
    }

    /**
     * Request a read on a given `BluetoothGattCharacteristic`. The read result is reported
     * asynchronously through the `BluetoothGattCallback#onCharacteristicRead(android.bluetooth.BluetoothGatt, android.bluetooth.BluetoothGattCharacteristic, int)`
     * callback.
     *
     * @param characteristic The characteristic to read from.
     */
    @SuppressLint("MissingPermission")
    fun readCharacteristic(characteristic: BluetoothGattCharacteristic?) {
        if (mBluetoothAdapter == null || mBluetoothGatt == null) {
            Log.w(TAG, "BluetoothAdapter not initialized->2")
            return
        }
        mBluetoothGatt!!.readCharacteristic(characteristic)
    }

    /**
     * Enables or disables notification on a give characteristic.
     *
     * @param characteristic Characteristic to act on.
     * @param enabled If true, enable notification.  False otherwise.
     */
    @SuppressLint("MissingPermission")
    fun setCharacteristicNotification(
        characteristic: BluetoothGattCharacteristic,
        enabled: Boolean
    ) {
//    	final int charaProp = characteristic.getProperties();
//    	if ((charaProp | BluetoothGattCharacteristic.PROPERTY_NOTIFY) > 0){}
        if (mBluetoothAdapter == null || mBluetoothGatt == null) {
            Log.w(TAG, "BluetoothAdapter not initialized->3")
            return
        }
        mBluetoothGatt!!.setCharacteristicNotification(characteristic, enabled)

//        for(BluetoothGattDescriptor des:characteristic.getDescriptors()){
//        	Log.d(TAG, "descriptor->"+des.getUuid());
//        	des.setValue(BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE);
//        	mBluetoothGatt.writeDescriptor(des);
//        }
        val descriptor = characteristic.getDescriptor(UUID_CLIENT_CHARACTER_CONFIG)
        descriptor.value = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
        mBluetoothGatt!!.writeDescriptor(descriptor)
    }

    /**
     * Retrieves a list of supported GATT services on the connected device. This should be
     * invoked only after `BluetoothGatt#discoverServices()` completes successfully.
     *
     * @return A `List` of supported services.
     */
    val supportedGattServices: List<BluetoothGattService>?
        get() = if (mBluetoothGatt == null) null else mBluetoothGatt!!.services

    fun getGattCharacteristic(characterUUID: UUID?): BluetoothGattCharacteristic? {
        if (mBluetoothAdapter == null) {
            Log.e(TAG, "BluetoothAdapter not initialized->4")
            return null
        } else if (mBluetoothGatt == null) {
            Log.e(TAG, "BluetoothGatt not initialized->5")
            return null
        }
        val service =
            mBluetoothGatt!!.getService(UUID_SERVICE_DATA)
        if (service == null) {
            Log.e(TAG, "Service is not found!")
            return null
        }
        return service.getCharacteristic(characterUUID)
    }

    /**
     * Split the package into small pieces to transfer.
     * @param ch
     * @param bytes
     */
    @SuppressLint("MissingPermission")
    fun write(ch: BluetoothGattCharacteristic, bytes: ByteArray) {
        var byteOffset = 0
        while (bytes.size - byteOffset > TRANSFER_PACKAGE_SIZE) {
            val b = ByteArray(TRANSFER_PACKAGE_SIZE)
            System.arraycopy(bytes, byteOffset, b, 0, TRANSFER_PACKAGE_SIZE)
            ch.value = b
            mBluetoothGatt!!.writeCharacteristic(ch)
            byteOffset += TRANSFER_PACKAGE_SIZE
        }
        if (bytes.size - byteOffset != 0) {
            val b = ByteArray(bytes.size - byteOffset)
            System.arraycopy(bytes, byteOffset, b, 0, bytes.size - byteOffset)
            ch.value = b
            mBluetoothGatt!!.writeCharacteristic(ch)
        }
    }


    private val mBuffer: LinkedBlockingQueue<ByteArray> = LinkedBlockingQueue()
    /**
     * push data to analyse protocal of buffer
     * @param dataBuffer  :analyse buffer
     * @return
     */
    fun read(dataBuffer: ByteArray): Int {
        if (mBuffer.size > 0) {
            val temp = mBuffer.poll()
            if (temp != null && temp.isNotEmpty()) {
                val len = if (temp.size < dataBuffer.size) temp.size else dataBuffer.size
                for (j in 0 until len) {
                    dataBuffer[j] = temp[j]
                }
                return len
            }
        }
        return 0
    }

    fun clean() {
        mBuffer.clear()
    }

    @Throws(IOException::class)
    fun available(): Int {
        return mBuffer.size
    }

    companion object {
        private val TAG = BluetoothLeService::class.java.simpleName
        const val STATE_DISCONNECTED = 0
        const val STATE_CONNECTING = 1
        const val STATE_CONNECTED = 2
        var mConnectionState = STATE_DISCONNECTED

        // BLE action
        const val ACTION_GATT_CONNECTED = "com.bluetooth.le.ACTION_GATT_CONNECTED"
        const val ACTION_GATT_DISCONNECTED = "com.bluetooth.le.ACTION_GATT_DISCONNECTED"
        const val ACTION_GATT_SERVICES_DISCOVERED =
            "com.bluetooth.le.ACTION_GATT_SERVICES_DISCOVERED"
        const val ACTION_DATA_AVAILABLE = "com.bluetooth.le.ACTION_DATA_AVAILABLE"
        const val EXTRA_DATA = "com.bluetooth.le.EXTRA_DATA"

        // business action
        const val ACTION_CHARACTER_NOTIFICATION = "com.bluetooth.le.notification.success"
        const val ACTION_SPO2_DATA_AVAILABLE = "com.bluetooth.le.ACTION_SPO2_DATA_AVAILABLE"
        val UUID_CLIENT_CHARACTER_CONFIG: UUID =
            UUID.fromString("00002902-0000-1000-8000-00805f9b34fb")
        //babyMonitor/PC-60F UUID
        /** 血氧 SpO2 service-> uuid  */
        val UUID_SERVICE_DATA: UUID = UUID.fromString("6e400001-b5a3-f393-e0a9-e50e24dcca9e")

        /** 血氧 SpO2 character->write uuid  */
        val UUID_CHARACTER_WRITE: UUID = UUID.fromString("6e400002-b5a3-f393-e0a9-e50e24dcca9e")

        /** 血氧 SpO2 character->read uuid  */
        val UUID_CHARACTER_READ: UUID = UUID.fromString("6e400003-b5a3-f393-e0a9-e50e24dcca9e")
        private const val TRANSFER_PACKAGE_SIZE = 10
    }
}