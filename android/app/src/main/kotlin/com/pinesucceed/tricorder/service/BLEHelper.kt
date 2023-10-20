package com.pinesucceed.tricorder.service

import java.io.IOException

class BLEHelper(
    private val mBluetoothLeService: BluetoothLeService?
) {
    fun write(bytes: ByteArray?) {
        synchronized(this) {
            if (mBluetoothLeService != null) {
                val gattChara = mBluetoothLeService.getGattCharacteristic(
                    BluetoothLeService.UUID_CHARACTER_WRITE
                )
                if (gattChara != null) {
                    mBluetoothLeService.write(gattChara, bytes!!)
                }
            }
        }
    }

    @Throws(IOException::class)
    fun read(bytes: ByteArray?): Int {
        var temp = 0
        if (mBluetoothLeService != null) {
            temp = mBluetoothLeService.read(bytes!!)
        }
        return temp
    }

    fun clean() {
        mBluetoothLeService?.clean()
    }

    @Throws(IOException::class)
    fun available(): Int {
        return mBluetoothLeService?.available() ?: 0
    }
}