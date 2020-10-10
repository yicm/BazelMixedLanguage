#ifndef _TEST_JNI_CACHING_H_
#define _TEST_JNI_CACHING_H_

#include <jni.h>

// java.awt.Point
typedef struct AwtPoint_t {
    jclass clz;
    jmethodID get_x;
    jmethodID get_y;
    jmethodID constructor;
} AwtPoint;

// android.graphics.PointF
typedef struct GraphicsPointF_t {
    jclass clz;
    jfieldID x;
    jfieldID y;
    jmethodID constructor;
} GraphicsPointF;

// java.util.ArrayList
typedef struct ArrayList_t {
    jclass clz;
    jmethodID constructor;
    jmethodID get;
    jmethodID size;
    jmethodID add;
} ArrayList;


// android.graphics.Rect
typedef struct Rect_t {
    jclass clz;
    jfieldID left;
    jfieldID top;
    jfieldID right;
    jfieldID bottom;
    jmethodID constructor;
} Rect;

// net.xiaobaiai.test.base.Point2D
typedef struct Point2D_t {
    jclass clz;
    jfieldID x;
    jfieldID y;

    jmethodID constructor;
} Point2D;

// net.xiaobaiai.test.MyRect
typedef struct MyRect_t {
    jclass clz;
    jfieldID left_top;
    jfieldID right_bottom;
    jmethodID constructor;
} MyRect;

// net.xiaobaiai.test.CStruct$InnerClass
typedef struct CstructInnerClass_t {
    jclass clz;
    jfieldID msg;
    jmethodID constructor;
} CstructInnerClass;

typedef struct CstructInnerEnum_t {
    jclass clz;
    jfieldID jid_one;
    jfieldID jid_two;
    jfieldID jid_three;
} CstructInnerEnum;

// net.xiaobaiai.test.CStruct
typedef struct CstructCacheHeader_t {
    jclass clz;
    jfieldID jid_data;
    jfieldID jid_ztype;
    jfieldID jid_btype;
    jfieldID jid_ctype;
    jfieldID jid_stype;
    jfieldID jid_itype;
    jfieldID jid_jtype;
    jfieldID jid_ftype;
    jfieldID jid_dtype;
    jfieldID jid_double_d_array;

    jfieldID jid_rect;
    jfieldID jid_point2d;
    jfieldID jid_myrect;
    jfieldID jid_inner_enum;
    jfieldID jid_innter_class;
    jmethodID constructor;
    jmethodID inner_enum_md;

    CstructInnerEnum_t inner_enum_header;
    CstructInnerClass innter_class_header;
} CstructCacheHeader;

typedef struct StaticMethodsHeader_t {
    jclass clz;
    jmethodID static_md;
} StaticMethodHeader;

void InitCaching(JNIEnv *env);

void UninitCaching(JNIEnv *env);

#endif