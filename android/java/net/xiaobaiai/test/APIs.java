package net.xiaobaiai.test;

import java.util.ArrayList;

import android.content.Context;
import net.xiaobaiai.test.CommonStatus;
import net.xiaobaiai.test.base.Point2D;
import java.awt.Point;
import android.graphics.PointF;
import android.graphics.Rect;

public class APIs {
    static {
        System.out.println("java.library.path: " + System.getProperty("java.library.path"));
        try {
            System.loadLibrary("jni_lib");
        } catch (Throwable ex) {
            ex.printStackTrace();
        }
    }

    public native CommonStatus SetString(String str);

    public native String GetString();

    public native CommonStatus SetBaseTypeArray(int[] intArray);

    //https://stackoverflow.com/questions/1610045/how-to-return-an-array-from-jni-to-java
    public native String[] GetStringArray(int size);

    public native CommonStatus SetStringArray(String[] strArray);

    public native CommonStatus SetPoint2DArray(Point2D[] pointArray);

    public native CommonStatus SetPoint(Point point);
    public native CommonStatus SetPointArrayList(ArrayList<Point> array);

    public native ArrayList<Point> GetPointArrayList();

    public native int[][] GetInt2DArray(int row, int col);

    public native CommonStatus SetContext(Context context);

    public native CommonStatus InitHandle(PointHandle handle);

    public native CommonStatus DestroyHandle(PointHandle handle);

    public native PointF GetPointf();

    public native CommonStatus GetCStruct(CStruct data);

    public native CommonStatus SetCStruct(CStruct data);
}
