package net.xiaobaiai.test;

import android.graphics.Rect;
import net.xiaobaiai.test.base.Point2D;
import net.xiaobaiai.test.MyRect;

public class CStruct {
    public enum InnerEnum {
        INNER_ONE(1),
        INNER_TWO(2),
        INNER_THREE(3);

        private int value;
        InnerEnum(int value) {
            this.value = value;
        }
        public int getValue() {
            return value;
        }
    }

    public int getInnerValue() {
        return this.innerEnum.getValue();
    }

    public static class InnerClass {
        public String msg;
    }

    public boolean ztype;
    public byte btype;
    public char ctype;
    public short stype;
    public int itype;
    public long jtype;
    public float ftype;
    public double dtype;

    public int[][] doubleDArray;

    public Point2D point;
    public Rect rect;
    public byte[] data;

    public MyRect myRect;

    public InnerEnum innerEnum;

    public InnerClass innerClass;
}
