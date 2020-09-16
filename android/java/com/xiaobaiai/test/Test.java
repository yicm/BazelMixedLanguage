package com.xiaobaiai.test;

import android.content.Context;
import com.xiaobaiai.test.CommonStatus;

public class Test {
    static {
        System.out.println("java.library.path: " + System.getProperty("java.library.path"));
        try {
            System.loadLibary("jni_lib");
        } catch (Throwable ex) {
            ex.printStackTrace();
        }
    }

    /**
     * Test
     * @param context The context of android application.
     */
    public native CommonStatus GetStatus(Context context);
}