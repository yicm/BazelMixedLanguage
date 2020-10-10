package net.xiaobaiai.test;

import android.util.Log;

public class StaticMethods {
    private static void callStaticMethod(String str, int i) {  
        Log.d("Test", "StaticMethods::callStaticMethod called!-->str=" + str +  
                ", i=" + i);
    }
}
