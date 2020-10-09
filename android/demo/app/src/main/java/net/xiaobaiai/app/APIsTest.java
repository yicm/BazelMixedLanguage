package net.xiaobaiai.app;

import android.content.Context;
import android.graphics.PointF;
import android.util.Log;

import net.xiaobaiai.test.APIs;
import net.xiaobaiai.test.CommonStatus;
import net.xiaobaiai.test.PointHandle;
import net.xiaobaiai.test.base.Point2D;
import net.xiaobaiai.test.CStruct;

import java.util.ArrayList;

public class APIsTest {
    private static final String TAG = "APIsTest";
    private static final int TEST_NUM = 10;
    private APIs apis = new APIs();

    private Context context;

    public APIsTest(Context context) {
        this.context = context;
    }

    private void testSetString() {
        for (int i = 0; i < TEST_NUM; i++) {
            CommonStatus status = apis.SetString("hello");
        }
    }

    private void  testGetString() {
        for (int i = 0; i < TEST_NUM; i++) {
            Log.d(TAG, apis.GetString());
        }
    }

    private void testSetBaseTypeArray() {
        int array[] = {1, 2, 3, 4, 5, 6};
        for (int i = 0; i < TEST_NUM; i++) {
            apis.SetBaseTypeArray(array);
        }
    }

    private void testGetSetStringArray() {
        for (int i = 0; i < TEST_NUM; i++) {
            String array[] = apis.GetStringArray(5);
            for (int j = 0; j < array.length; j++) {
                Log.d(TAG, "GetStringArray[" + j + "] = " + array[j]);
            }
            apis.SetStringArray(array);
        }
    }

    private void testSetPoint2DArray() {
        Point2D point = new Point2D();
        point.x = 1.1f;
        point.y = 1.2f;
        Point2D points[] = {point, point, point, point};
        for (int i = 0; i < TEST_NUM; i++) {
            apis.SetPoint2DArray(points);
        }
    }

    private void testSetPoint() {
        PointF pointf = new PointF(1.2f, 2.2f);
        for (int i = 0; i < TEST_NUM; i++) {
            apis.SetPoint(pointf);
        }
    }

    private void testGetSetPointArrayList() {
        PointF pointf = new PointF(1.2f, 2.2f);
        ArrayList<PointF> pointfArray = new ArrayList<>();
        pointfArray.add(pointf);
        pointfArray.add(pointf);
        pointfArray.add(pointf);
        for (int i = 0; i < TEST_NUM; i++) {
            apis.SetPointArrayList(pointfArray);
        }
        for (int i = 0; i < TEST_NUM; i++) {
            ArrayList<PointF> retArray = apis.GetPointArrayList();
            apis.SetPointArrayList(retArray);
        }
    }

    private void testGetInt2DArray() {
        for (int i = 0; i < TEST_NUM; i++) {
            int array2d[][] = apis.GetInt2DArray(3, 4);
            for (int n = 0; n < 3; n++) {
                for (int m = 0; m < 3; m++) {
                    Log.d(TAG, "array2d[" + n + "][" + m + "] = " + array2d[n][m]);
                }
            }
        }
    }

    private void testSetContext() {
        for (int i = 0; i < TEST_NUM; i++) {
            apis.SetContext(context);
        }
    }

    private PointHandle handle = new PointHandle();
    private void testInitDestroyHandle() {
        for (int i = 0; i < TEST_NUM; i++) {
            apis.InitHandle(handle);
            apis.DestroyHandle(handle);
        }
    }

    private void testGetPointf() {
        for (int i = 0; i < TEST_NUM; i++) {
            PointF pointf = apis.GetPointf();
        }
    }

    private void testGetSetCStruct() {
        CStruct cstruct = null;

        for (int i = 0; i < TEST_NUM; i++) {
            cstruct = apis.GetCStruct();
            Log.d(TAG, "cstruct = " + cstruct);
            apis.SetCStruct(cstruct);
        }
    }

    public void Start() {
        testSetString();
        testGetString();
        testSetBaseTypeArray();
        testGetSetStringArray();
        testSetPoint2DArray();
        testSetPoint();
        testGetSetPointArrayList();
        testGetInt2DArray();
        testSetContext();
        testInitDestroyHandle();
        testGetPointf();
        testGetSetCStruct();
    }
}
