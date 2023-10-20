package com.pinesucceed.tricorder.service

import com.creative.base.Ireader
import java.io.IOException

class ReaderBLE(private var mHelper: BLEHelper?) : Ireader {
    @Throws(IOException::class)
    override fun read(buffer: ByteArray): Int {
        return mHelper!!.read(buffer)
    }

    override fun close() {
        mHelper = null
    }

    override fun clean() {
        mHelper!!.clean()
    }

    @Throws(IOException::class)
    override fun available(): Int {
        return if (mHelper != null) {
            mHelper!!.available()
        } else 0
    }
}