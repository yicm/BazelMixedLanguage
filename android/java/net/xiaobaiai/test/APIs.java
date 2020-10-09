package net.xiaobaiai.test;

import net.xiaobaiai.test.CommonStatus;
import net.xiaobaiai.test.base.Point2D;

import java.util.ArrayList;

import android.content.Context;
import android.graphics.PointF;
import android.graphics.Rect;

public class APIs {
    static {
        try {
            System.loadLibrary("app");
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

    public native CommonStatus SetPoint(PointF point);
    public native CommonStatus SetPointArrayList(ArrayList<PointF> array);

    public native ArrayList<PointF> GetPointArrayList();

    public native int[][] GetInt2DArray(int row, int col);

    public native CommonStatus SetContext(Context context);

    public native CommonStatus InitHandle(PointHandle handle);

    public native CommonStatus DestroyHandle(PointHandle handle);

    public native PointF GetPointf();

    public native CommonStatus GetCStruct(CStruct data);

    public native CommonStatus SetCStruct(CStruct data);
}
