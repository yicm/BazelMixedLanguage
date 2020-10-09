#include "jni_caching.h"

#include <jni.h>

#include "logger.h"
#include <android/log.h>

jboolean FindClass(JNIEnv *env, const char *name, jclass *clazz_out) {
    jclass clazz = env->FindClass(name);
    if (NULL == clazz) {
        TEST_LOG_E("can't find class %s", name);
        return JNI_FALSE;
    }
    *clazz_out = (jclass) env->NewGlobalRef(clazz);
    return JNI_TRUE;
}

jboolean GetField(JNIEnv *env, jclass *clazz, const char *name, const char *sig, jfieldID *field_out) {
    jfieldID filed = env->GetFieldID(*clazz, name, sig);
    if (filed == nullptr) {
        TEST_LOG_E("can not find filed name %s, sig %s", name, sig);
        return JNI_FALSE;
    }
    *field_out = filed;
    return JNI_TRUE;
}
    
AwtPoint awt_point;
static void CachingAwtPoint(JNIEnv *env) {
    FindClass(env, "java/awt/Point", &awt_point.clz);
    awt_point.get_x = env->GetMethodID(awt_point.clz, "getX", "()D");
    awt_point.get_y = env->GetMethodID(awt_point.clz, "getY", "()D");
    awt_point.constructor = env->GetMethodID(awt_point.clz, "<init>", "(II)V");
    if (!awt_point.get_x || !awt_point.get_y) {
        TEST_LOG_E("Failed to get method id");
    }
}

GraphicsPointF graphics_pointf;
static void CachingGraphicsPointf(JNIEnv *env) {
    FindClass(env, "android/graphics/PointF", &graphics_pointf.clz);
    GetField(env, &graphics_pointf.clz, "x", "F", &graphics_pointf.x);
    GetField(env, &graphics_pointf.clz, "y", "F", &graphics_pointf.y);
    graphics_pointf.constructor = env->GetMethodID(graphics_pointf.clz, "<init>", "(FF)V");
    if (!graphics_pointf.constructor) {
        TEST_LOG_E("Failed to get method id");
    }
}

ArrayList array_list;
static void CachingArrayList(JNIEnv *env) {
    FindClass(env, "java/util/ArrayList", &array_list.clz);
    array_list.get  = env->GetMethodID(array_list.clz, "get", "(I)Ljava/lang/Object;");
    array_list.size = env->GetMethodID(array_list.clz, "size", "()I");
    array_list.add = env->GetMethodID(array_list.clz, "add", "(Ljava/lang/Object;)Z");
    array_list.constructor = env->GetMethodID(array_list.clz, "<init>", "(I)V");
    if (!array_list.get || !array_list.size) {
        TEST_LOG_E("Failed to get method id");
    }
}

CstructCacheHeader cstruct_cache_header;
static void CachingCstruct(JNIEnv *env) {
    jboolean ret = FindClass(env, "net/xiaobaiai/test/CStruct", &cstruct_cache_header.clz);
    jclass clazz = cstruct_cache_header.clz;
    // Get constructor method
    cstruct_cache_header.constructor = env->GetMethodID(clazz, "<init>", "()V");
    if (!cstruct_cache_header.constructor) {
        TEST_LOG_E("Failed to get method id");
    }
    // Get all members field id
    GetField(env, &clazz, "ztype", "Z", &cstruct_cache_header.jid_ztype);
    GetField(env, &clazz, "btype", "B", &cstruct_cache_header.jid_btype);
    GetField(env, &clazz, "ctype", "C", &cstruct_cache_header.jid_ctype);
    GetField(env, &clazz, "stype", "S", &cstruct_cache_header.jid_stype);
    GetField(env, &clazz, "itype", "I", &cstruct_cache_header.jid_itype);
    GetField(env, &clazz, "jtype", "J", &cstruct_cache_header.jid_jtype);
    GetField(env, &clazz, "ftype", "F", &cstruct_cache_header.jid_ftype);
    GetField(env, &clazz, "dtype", "D", &cstruct_cache_header.jid_dtype);
    GetField(env, &clazz, "doubleDArray", "[[I", &cstruct_cache_header.jid_double_d_array);
    GetField(env, &clazz, "data", "[B", &cstruct_cache_header.jid_data);
    GetField(env, &clazz, "rect", "Landroid/graphics/Rect;", &cstruct_cache_header.jid_rect);
    GetField(env, &clazz, "point", "Lnet/xiaobaiai/test/base/Point2D;", &cstruct_cache_header.jid_point2d);
    GetField(env, &clazz, "myRect", "Lnet/xiaobaiai/test/MyRect;", &cstruct_cache_header.jid_myrect);
    GetField(env, &clazz, "innerEnum", "Lnet/xiaobaiai/test/CStruct$InnerEnum;", &cstruct_cache_header.jid_inner_enum);
    GetField(env, &clazz, "innerClass", "Lnet/xiaobaiai/test/CStruct$InnerClass;", &cstruct_cache_header.jid_innter_class);
    // Inner enum
    FindClass(env, "net/xiaobaiai/test/CStruct$InnerEnum", &cstruct_cache_header.inner_enum_header.clz);
    cstruct_cache_header.inner_enum_header.jid_one = 
        env->GetStaticFieldID(cstruct_cache_header.inner_enum_header.clz, "INNER_ONE", "Lnet/xiaobaiai/test/CStruct$InnerEnum;");
    cstruct_cache_header.inner_enum_header.jid_one = 
        env->GetStaticFieldID(cstruct_cache_header.inner_enum_header.clz, "INNER_TWO", "Lnet/xiaobaiai/test/CStruct$InnerEnum;");
    cstruct_cache_header.inner_enum_header.jid_one = 
        env->GetStaticFieldID(cstruct_cache_header.inner_enum_header.clz, "INNER_THREE", "Lnet/xiaobaiai/test/CStruct$InnerEnum;");
    // Innter class
    FindClass(env, "net/xiaobaiai/test/CStruct$InnerClass", &cstruct_cache_header.innter_class_header.clz);
    cstruct_cache_header.innter_class_header.constructor = env->GetMethodID(cstruct_cache_header.innter_class_header.clz, 
        "<init>", "()V");
    if (!cstruct_cache_header.innter_class_header.constructor) {
        TEST_LOG_E("Failed to get method id");
    }
    GetField(env, &cstruct_cache_header.innter_class_header.clz, 
        "msg", "Ljava/lang/String;", &cstruct_cache_header.innter_class_header.msg);
    // Inner enum
    cstruct_cache_header.inner_enum_md = env->GetMethodID(clazz, "getInnerValue", "()I");
}


Point2D point2d;
static void CachingPoint2D(JNIEnv *env) {
    // Point2D
    FindClass(env, "net/xiaobaiai/test/base/Point2D", &point2d.clz);
    point2d.constructor = env->GetMethodID(point2d.clz, "<init>", "()V");
    if (!point2d.constructor) {
        TEST_LOG_E("Failed to get method id");
    }
    GetField(env, &point2d.clz, "x", "F", &point2d.x);
    GetField(env, &point2d.clz, "y", "F", &point2d.y);
}

Rect rect;
static void CachingRect(JNIEnv *env) {
    // Rect
    FindClass(env, "android/graphics/Rect", &rect.clz);
    rect.constructor = env->GetMethodID(rect.clz, "<init>", "()V");
    if (!rect.constructor) {
        TEST_LOG_E("Failed to get method id");
    }
    GetField(env, &rect.clz, "left", "I", &rect.left);
    GetField(env, &rect.clz, "top", "I", &rect.top);
    GetField(env, &rect.clz, "right", "I", &rect.right);
    GetField(env, &rect.clz, "bottom", "I", &rect.bottom);
}

MyRect my_rect;
static void CachingMyRect(JNIEnv *env) {
    // MyRect
    FindClass(env, "net/xiaobaiai/test/MyRect", &my_rect.clz);
    my_rect.constructor = env->GetMethodID(my_rect.clz, "<init>", "()V");
    if (!my_rect.constructor) {
        TEST_LOG_E("Failed to get method id");
    }
    GetField(env, &my_rect.clz, "leftTop", "Lnet/xiaobaiai/test/base/Point2D;", &my_rect.left_top);
    GetField(env, &my_rect.clz, "rightBottom", "Lnet/xiaobaiai/test/base/Point2D;", &my_rect.right_bottom);
}

void InitCaching(JNIEnv *env) {
    //CachingAwtPoint(env);
    CachingGraphicsPointf(env);
    CachingArrayList(env);
    CachingPoint2D(env);
    CachingRect(env);
    CachingMyRect(env);
    CachingCstruct(env);
}

void UninitCaching(JNIEnv *env) {
    env->DeleteGlobalRef(awt_point.clz);
    env->DeleteGlobalRef(graphics_pointf.clz);
    env->DeleteGlobalRef(array_list.clz);
    env->DeleteGlobalRef(cstruct_cache_header.clz);
    env->DeleteGlobalRef(cstruct_cache_header.innter_class_header.clz);
    env->DeleteGlobalRef(point2d.clz);
    env->DeleteGlobalRef(rect.clz);
    env->DeleteGlobalRef(my_rect.clz);
}