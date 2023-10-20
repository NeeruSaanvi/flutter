package com.pinesucceed.tricorder.service

import com.creative.base.Isender
import java.io.IOException

class SenderBLE(private var mHelper: BLEHelper?) : Isender {
    @Throws(IOException::class)
    override fun send(d: ByteArray) {
        mHelper!!.write(d)
    }

    override fun close() {
        mHelper = null
    }
}