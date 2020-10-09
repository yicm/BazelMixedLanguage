#include "net_xiaobaiai_test_APIs.h"

#include <jni.h>
#include <android/log.h>
#include <android/asset_manager.h>
#include <android/asset_manager_jni.h>

#include <stdlib.h>

#include "jni_common.h"
#include "jni_caching.h"
#include "mock_sdk.h"

#ifdef __cplusplus
extern "C" {
#endif

extern GraphicsPointF graphics_pointf;
extern ArrayList array_list;
extern Point2D point2d;
extern Rect rect;
extern MyRect my_rect;
extern CstructCacheHeader cstruct_cache_header;

// Is automatically called once the native code is loaded via System.loadLibary(...);
jint JNI_OnLoad(JavaVM* vm, void* reserved) {
    TEST_LOG_E("JNI_OnLoad");
    JNIEnv *env = NULL;
    jint result = JNI_ERR;
    if (vm->GetEnv((void **) &env, JNI_VERSION_1_6) != JNI_OK) {
        TEST_LOG_E("Failed to get env");
        return result;
    } else {
        InitCaching(env);
    }
    
    return JNI_VERSION_1_6;
}

// Is automatically called once the Classloader is destroyed
void JNI_OnUnload(JavaVM *vm, void *reserved) {
    TEST_LOG_E("JNI_OnUnLoad");
    JNIEnv *env = NULL;
    jint result = JNI_ERR;
    if (vm->GetEnv((void **) &env, JNI_VERSION_1_6) != JNI_OK) {
        TEST_LOG_E("Failed to get env");
        return;
    } else {
        UninitCaching(env);
    }
   
}

/*
 * Class:     net_xiaobaiai_test_APIs
 * Method:    SetString
 * Signature: (Ljava/lang/String;)Lnet/xiaobaiai/test/CommonStatus;
 */
JNIEXPORT jobject JNICALL Java_net_xiaobaiai_test_APIs_SetString
  (JNIEnv *env, jobject, jstring j_str) {
    const char *c_str = NULL;
    
    c_str = env->GetStringUTFChars(j_str, NULL);
    if (NULL == c_str) {
        TEST_LOG_E("Failed to get string UTF chars.");
        return getStatus(env, FAILED);
    }
    TEST_LOG_D("c str: %s", c_str);
    // 如使用 GetStringUTFRegion 与 GetStringRegion，则内部未分配内存，无需释放
    env->ReleaseStringUTFChars(j_str, c_str);
    return getStatus(env, SUCCESS);
}

/*
 * Class:     net_xiaobaiai_test_APIs
 * Method:    GetString
 * Signature: ()Ljava/lang/String;
 */
JNIEXPORT jstring JNICALL Java_net_xiaobaiai_test_APIs_GetString
  (JNIEnv *env, jobject) {
    char str[60] = "Hello";
    // 1. 可以用 const char *
    //const char *str = "Hello";
    // 2. 可以用 std::string str = std::string("Hello"); str.c_str()

    jstring result;
    result = env->NewStringUTF(str);
    return result; 
}

/*
 * Class:     net_xiaobaiai_test_APIs
 * Method:    SetBaseTypeArray
 * Signature: ([I)Lnet/xiaobaiai/test/CommonStatus;
 */
JNIEXPORT jobject JNICALL Java_net_xiaobaiai_test_APIs_SetBaseTypeArray
  (JNIEnv *env, jobject, jintArray j_array) {
    // step: get length
    int arr_len = env->GetArrayLength(j_array);
    // step: get array
    int * array = env->GetIntArrayElements(j_array, NULL);
    if (!array) {
        TEST_LOG_E("Failed to get int array elements");
        return getStatus(env, FAILED);
    }

    for (int i = 0; i < arr_len; i++) {
        TEST_LOG_D("int array[%d] = %d", i, array[i]);
    }
    // 也可以使用 GetIntArrayRegion/GetPrimitiveArrayCritical 区别不在展开
    env->ReleaseIntArrayElements(j_array, array, 0);

    return getStatus(env, SUCCESS);
}

/*
 * Class:     net_xiaobaiai_test_APIs
 * Method:    GetStringArray
 * Signature: (I)[Ljava/lang/String;
 */
JNIEXPORT jobjectArray JNICALL Java_net_xiaobaiai_test_APIs_GetStringArray
  (JNIEnv *env, jobject, jint j_size) {
    jobjectArray result;

    result = (jobjectArray)env->NewObjectArray(j_size, env->FindClass("java/lang/String"), env->NewStringUTF(""));
    if (!result) {
        TEST_LOG_E("Failed to new object array");
        return NULL;
    }
    for(int i = 0; i < j_size; i++) {
         env->SetObjectArrayElement(result, i, 
            env->NewStringUTF((std::string("item ") + std::to_string(i)).c_str()));
    }
    return result;
}

/*
 * Class:     net_xiaobaiai_test_APIs
 * Method:    SetStringArray
 * Signature: ([Ljava/lang/String;)Lnet/xiaobaiai/test/CommonStatus;
 */
JNIEXPORT jobject JNICALL Java_net_xiaobaiai_test_APIs_SetStringArray
  (JNIEnv *env, jobject, jobjectArray j_str_array) {
    // step1: get array length
    int array_size = env->GetArrayLength(j_str_array);

    // step2: get object array item with a loop
    for (int i = 0; i < array_size; i++) {
        jstring j_str = (jstring)(env->GetObjectArrayElement(j_str_array, i));
        const char *c_str = env->GetStringUTFChars(j_str, NULL);
        TEST_LOG_D("str array[%d] = %s", i, c_str);

        env->ReleaseStringUTFChars(j_str, c_str);
    }

    return getStatus(env, SUCCESS);
}

/*
 * Class:     net_xiaobaiai_test_APIs
 * Method:    SetPoint2DArray
 * Signature: ([Lnet/xiaobaiai/test/base/Point2D;)Lnet/xiaobaiai/test/CommonStatus;
 */
JNIEXPORT jobject JNICALL Java_net_xiaobaiai_test_APIs_SetPoint2DArray
  (JNIEnv *env, jobject, jobjectArray j_array) {
    // step1: get array length
    int array_len = env->GetArrayLength(j_array);
    // step2: get object array item with a loop
    for (int i = 0; i < array_len; i++) {
        // step2.1: get array element
        jobject j_object = env->GetObjectArrayElement(j_array, i);
        if (!j_object) {
            TEST_LOG_E("Failed to get object array element");
            return getStatus(env, FAILED);
        }
        // step2.2: get value
        float x = env->GetFloatField(j_object, point2d.x);
        float y = env->GetFloatField(j_object, point2d.y);
        TEST_LOG_D("array[%d], x = %f, y = %f", i, x, y);
    }
    return getStatus(env, SUCCESS);
}

/*
 * Class:     net_xiaobaiai_test_APIs
 * Method:    SetPoint
 * Signature: (Landroid/graphics/PointF;)Lnet/xiaobaiai/test/CommonStatus;
 */
JNIEXPORT jobject JNICALL Java_net_xiaobaiai_test_APIs_SetPoint
  (JNIEnv *env, jobject, jobject j_pointf) {
     // step2.2: get value
    float x = env->GetFloatField(j_pointf, graphics_pointf.x);
    float y = env->GetFloatField(j_pointf, graphics_pointf.y);
    TEST_LOG_E("x = %f, y = %f", x, y);
    return getStatus(env, SUCCESS);
}

/*
 * Class:     net_xiaobaiai_test_APIs
 * Method:    SetPointArrayList
 * Signature: (Ljava/util/ArrayList;)Lnet/xiaobaiai/test/CommonStatus;
 */
JNIEXPORT jobject JNICALL Java_net_xiaobaiai_test_APIs_SetPointArrayList
  (JNIEnv *env, jobject, jobject j_point_array) {
    int point_count = static_cast<int>(env->CallIntMethod(j_point_array, array_list.size));

    if (point_count < 1) {
        TEST_LOG_W("The array size less than 1");
        return getStatus(env, FAILED);
    }

    double x, y;

    for (int i = 0; i < point_count; ++i) {
        jobject point = env->CallObjectMethod(j_point_array, array_list.get, i);
        jfloat x = env->GetFloatField(point, graphics_pointf.x);
        jfloat y = env->GetFloatField(point, graphics_pointf.y);
        env->DeleteLocalRef(point);

        TEST_LOG_D("x: %lf, y: %lf", x, y);
    }

    return getStatus(env, SUCCESS);
}

/*
 * Class:     net_xiaobaiai_test_APIs
 * Method:    GetPointArrayList
 * Signature: ()Ljava/util/ArrayList;
 */
JNIEXPORT jobject JNICALL Java_net_xiaobaiai_test_APIs_GetPointArrayList
  (JNIEnv *env, jobject j_obj) {
    const int array_size = 5;
    jobject result = env->NewObject(array_list.clz, array_list.constructor, array_size);

    for (int i = 0; i < array_size; i++) {
        // step 1/2: new point
        // The generated values are for testing only
        jobject pt_object = env->NewObject(graphics_pointf.clz, graphics_pointf.constructor, j_obj, 0 + i, 1 + i);
        // step 2/2: add point to array list
        env->CallBooleanMethod(result, array_list.add, pt_object);
        env->DeleteLocalRef(pt_object);
    }
    
    return result;   
}

/*
 * Class:     net_xiaobaiai_test_APIs
 * Method:    GetInt2DArray
 * Signature: (II)[[I
 */
JNIEXPORT jobjectArray JNICALL Java_net_xiaobaiai_test_APIs_GetInt2DArray
  (JNIEnv *env, jobject, jint row, jint col) {
    jobjectArray result;  
    jclass cls_int_array;  
    jint i,j;  
    // step1: find class
    cls_int_array = env->FindClass("[I");  
    if (cls_int_array == NULL) {  
        return NULL;  
    }  
    // step2: create int array object
    result = env->NewObjectArray(row, cls_int_array, NULL);  
    if (result == NULL) {  
        return NULL;  
    }  

    // step3: set value
    for (i = 0; i < row; ++i) {  
        jint buff[256];  
        jintArray int_array = env->NewIntArray(col);  
        if (int_array == NULL) {  
            return NULL;  
        }  
        for (j = 0; j < col; j++) {  
            buff[j] = i + j;  
        }  
        env->SetIntArrayRegion(int_array, 0, col, buff);  
        env->SetObjectArrayElement(result, i, int_array);  
        env->DeleteLocalRef(int_array);  
    }  

    return result;  
}

/*
 * Class:     net_xiaobaiai_test_APIs
 * Method:    SetContext
 * Signature: (Landroid/content/Context;)Lnet/xiaobaiai/test/CommonStatus;
 */
JNIEXPORT jobject JNICALL Java_net_xiaobaiai_test_APIs_SetContext
  (JNIEnv *env, jobject, jobject context) {
    jclass context_clz = env->GetObjectClass(context);

    // get android application package name
    jmethodID m_getpackagename_id = env->GetMethodID(context_clz, "getPackageName", "()Ljava/lang/String;");
    if (!context_clz || !m_getpackagename_id) {
        TEST_LOG_E("Failed to get class or method id");
        return getStatus(env, FAILED);
    }

    jstring j_pkg_name = static_cast<jstring>(env->CallObjectMethod(context, m_getpackagename_id));
    if (!j_pkg_name) {
        TEST_LOG_E("Failed to call object method.");
        return getStatus(env, FAILED);
    }

    const char* pkg_name = env->GetStringUTFChars(j_pkg_name, 0);
     if (NULL == pkg_name) {
        TEST_LOG_E("Failed to get string UTF chars.");
        return getStatus(env, FAILED);
    }
    TEST_LOG_D("package name = %s", pkg_name);
    env->ReleaseStringUTFChars(j_pkg_name, pkg_name);

    return getStatus(env, SUCCESS);
}

/*
 * Class:     net_xiaobaiai_test_APIs
 * Method:    InitHandle
 * Signature: (Lnet/xiaobaiai/test/PointHandle;)Lnet/xiaobaiai/test/CommonStatus;
 */
JNIEXPORT jobject JNICALL Java_net_xiaobaiai_test_APIs_InitHandle
  (JNIEnv *env, jobject, jobject j_handle) {
    CHandle* handle = (CHandle*)malloc(sizeof(CHandle));
    if (!handle) {
        TEST_LOG_E("Failed to new handle.");
        return getStatus(env, FAILED);
    }

    CommonStatus status = InitCHandle(handle);
    if (SUCCESS != status) {
        TEST_LOG_E("Failed to init handle with %d.", status);
        return getStatus(env, status);
    }
    jclass clz_handle = env->GetObjectClass(j_handle);
    if (NULL == clz_handle) {
        TEST_LOG_E("Failed to get handle object class.");
        return getStatus(env, FAILED);
    }
    jfieldID p_handle = env->GetFieldID(clz_handle, "p_handle", "J");
    if (NULL == p_handle) {
        TEST_LOG_E("Failed to get handle pointer.");
        return getStatus(env, FAILED);
    }
    TEST_LOG_E("handle value: %ld", (jlong)handle);
    env->SetLongField(j_handle, p_handle, (jlong)handle);

    return getStatus(env, SUCCESS);
}

/*
 * Class:     net_xiaobaiai_test_APIs
 * Method:    DestroyHandle
 * Signature: (Lnet/xiaobaiai/test/PointHandle;)Lnet/xiaobaiai/test/CommonStatus;
 */
JNIEXPORT jobject JNICALL Java_net_xiaobaiai_test_APIs_DestroyHandle
  (JNIEnv *env, jobject, jobject j_handle) {
    jlong handle = getHandle(env, j_handle);
    CHandle *p_handle = (CHandle*)handle;
    if (!p_handle) {
        TEST_LOG_E("Failed to get handle.");
        return getStatus(env, FAILED);
    }
    CommonStatus status = DestroyCHandle(*p_handle);
    if (SUCCESS != status) {
        TEST_LOG_E("Failed to destroy handle with %d.", status);
        return getStatus(env, FAILED);
    }

    free(p_handle);
    p_handle = NULL;
    return getStatus(env, SUCCESS);
}

/*
 * Class:     net_xiaobaiai_test_APIs
 * Method:    GetPointf
 * Signature: ()Landroid/graphics/PointF;
 */
JNIEXPORT jobject JNICALL Java_net_xiaobaiai_test_APIs_GetPointf
  (JNIEnv *env, jobject j_obj) {
    // The generated values are for testing only
    jobject pt_object = env->NewObject(graphics_pointf.clz, 
        graphics_pointf.constructor, j_obj, 1.22f, 3.14f);
    return pt_object;
}

/*
 * Class:     net_xiaobaiai_test_APIs
 * Method:    GetCStruct
 * Signature: ()Lnet/xiaobaiai/test/CStruct;
 */
JNIEXPORT jobject JNICALL Java_net_xiaobaiai_test_APIs_GetCStruct
  (JNIEnv *env, jobject) {
    // Note: The check of parameter boundary and function return value is omitted here!!!
    // Create Point2D
    jobject j_point2d = env->NewObject(point2d.clz, point2d.constructor);
    env->SetFloatField(j_point2d, point2d.x, 1.1f);
    env->SetFloatField(j_point2d, point2d.y, 1.2f);
    TEST_LOG_D("Create Point2d Successfully");
    // Create Rect
    jobject j_rect = env->NewObject(rect.clz, rect.constructor);
    env->SetIntField(j_rect, rect.left, 1);
    env->SetIntField(j_rect, rect.top, 2);
    env->SetIntField(j_rect, rect.right, 3);
    env->SetIntField(j_rect, rect.bottom, 4);
    TEST_LOG_D("Create Rect Successfully");
    // Create MyRect: Reuse the point that have been created
    jobject j_my_rect = env->NewObject(my_rect.clz, my_rect.constructor);
    env->SetObjectField(j_my_rect, my_rect.left_top, j_point2d);
    env->SetObjectField(j_my_rect, my_rect.right_bottom, j_point2d);
    TEST_LOG_D("Create MyRect Successfully");
    // Create Inner Enum
    jobject j_inner_enum_one_obj = env->GetStaticObjectField(cstruct_cache_header.inner_enum_header.clz, 
        cstruct_cache_header.inner_enum_header.jid_one);
    // Create Inner Class
    jobject j_inner_class_obj = env->NewObject(cstruct_cache_header.innter_class_header.clz, cstruct_cache_header.innter_class_header.constructor);
    char c_msg[60] = "Hello";
    jstring j_msg = env->NewStringUTF(c_msg);
    env->SetObjectField(j_inner_class_obj, cstruct_cache_header.innter_class_header.msg, j_msg);
    TEST_LOG_D("Create Inner Class Successfully");
    // Create byte[]
    const int c_data_len = 256;
    jbyte c_data[c_data_len] = {'b', 'i', 'a', 'd', 'a', 'm', 'm'};
    jbyteArray j_data = env->NewByteArray(c_data_len);
    env->SetByteArrayRegion(j_data, 0, c_data_len, c_data);
    TEST_LOG_D("Create Byte Array Successfully");
    // Create 2d array
    const int c_double_d_array_row = 10;
    const int c_double_d_array_col = 5;
    jclass double_d_clz = env->FindClass("[I");
    jobjectArray j_double_d_array = env->NewObjectArray(c_double_d_array_row, double_d_clz, NULL);
    for (int i = 0; i < c_double_d_array_row; i++) {
        jintArray j_int_array = env->NewIntArray(c_double_d_array_col);
        int c_int_array_data[c_double_d_array_col] = {1, 2, 3, 4, 5};
        env->SetIntArrayRegion(j_int_array, 0, c_double_d_array_col, c_int_array_data);
        env->SetObjectArrayElement(j_double_d_array, i, j_int_array);
    }
    TEST_LOG_D("Create 2d Array Successfully");
    // Create CStruct: If you created an object externally(Java Layer), you don't need to create it here.
    jobject j_struct = env->NewObject(cstruct_cache_header.clz, cstruct_cache_header.constructor);
    TEST_LOG_D("Create CStruct Successfully");
    // Set values
    env->SetObjectField(j_struct, cstruct_cache_header.jid_point2d, j_point2d);
    env->SetBooleanField(j_struct, cstruct_cache_header.jid_ztype, JNI_FALSE);
    env->SetCharField(j_struct, cstruct_cache_header.jid_ctype, 'Y');
    env->SetShortField(j_struct, cstruct_cache_header.jid_stype, 8);
    env->SetIntField(j_struct, cstruct_cache_header.jid_itype, 9);
    env->SetLongField(j_struct, cstruct_cache_header.jid_jtype, 10);
    env->SetFloatField(j_struct, cstruct_cache_header.jid_ftype, 11.0f);
    env->SetDoubleField(j_struct, cstruct_cache_header.jid_dtype, 12.0);
    env->SetObjectField(j_struct, cstruct_cache_header.jid_data, j_data);
    env->SetObjectField(j_struct, cstruct_cache_header.jid_inner_enum, j_inner_enum_one_obj);
    env->SetObjectField(j_struct, cstruct_cache_header.jid_innter_class, j_inner_class_obj);
    env->SetObjectField(j_struct, cstruct_cache_header.jid_rect, j_rect);
    env->SetObjectField(j_struct, cstruct_cache_header.jid_myrect, j_my_rect);
    env->SetObjectField(j_struct, cstruct_cache_header.jid_double_d_array, j_double_d_array);

    return j_struct;
}

/*
 * Class:     net_xiaobaiai_test_APIs
 * Method:    SetCStruct
 * Signature: (Lnet/xiaobaiai/test/CStruct;)Lnet/xiaobaiai/test/CommonStatus;
 */
JNIEXPORT jobject JNICALL Java_net_xiaobaiai_test_APIs_SetCStruct
  (JNIEnv *env, jobject, jobject j_struct) {
    if (!j_struct) {
        TEST_LOG_E("Input struct data is null.");
        return getStatus(env, FAILED);
    }
    // Note: The check of parameter boundary and function return value is omitted here!!!
    // Get byte[] data
    jbyteArray j_data_array = (jbyteArray)env->GetObjectField(j_struct, cstruct_cache_header.jid_data);
    if (NULL == j_data_array) {
        TEST_LOG_E("Failed to get object field.");
        return getStatus(env, FAILED);
    }
    jbyte *c_data = env->GetByteArrayElements(j_data_array, JNI_FALSE);
    // Get basic type value
    jboolean c_ztype = env->GetBooleanField(j_struct, cstruct_cache_header.jid_ztype);
    jchar c_ctype = env->GetCharField(j_struct, cstruct_cache_header.jid_ctype);
    jshort c_stype = env->GetShortField(j_struct, cstruct_cache_header.jid_stype);
    jint c_itype = env->GetIntField(j_struct, cstruct_cache_header.jid_itype);
    jlong c_jtype = env->GetLongField(j_struct, cstruct_cache_header.jid_jtype);
    jfloat c_ftype = env->GetFloatField(j_struct, cstruct_cache_header.jid_ftype);
    jdouble c_dtype = env->GetDoubleField(j_struct, cstruct_cache_header.jid_dtype);
    TEST_LOG_E("Get basic type value successfully");
    // Get Point2D value
    jobject j_point2d = env->GetObjectField(j_struct, cstruct_cache_header.jid_point2d);
    jfloat c_point2d_x = env->GetFloatField(j_point2d, point2d.x);
    jfloat c_point2d_y = env->GetFloatField(j_point2d, point2d.y);
    TEST_LOG_E("Get Point2D value successfully");
    // Get Rect value
    jobject j_rect = env->GetObjectField(j_struct, cstruct_cache_header.jid_rect);
    jint c_rect_left = env->GetIntField(j_rect, rect.left);
    jint c_rect_top = env->GetIntField(j_rect, rect.top);
    jint c_rect_right = env->GetIntField(j_rect, rect.right);
    jint c_rect_bottom = env->GetIntField(j_rect, rect.bottom);
    TEST_LOG_E("Get Rect value successfully");
    // Get MyRect value
    jobject j_my_rect = env->GetObjectField(j_struct, cstruct_cache_header.jid_myrect);
    jobject j_my_rect_point2d_lefttop = env->GetObjectField(j_my_rect, my_rect.left_top);
    jobject j_my_rect_point2d_rightbottom = env->GetObjectField(j_my_rect, my_rect.right_bottom);
    jfloat c_my_rect_lefttop_x = env->GetFloatField(j_my_rect_point2d_lefttop, point2d.x);
    jfloat c_my_rect_lefttop_y = env->GetFloatField(j_my_rect_point2d_rightbottom, point2d.y);
    jfloat c_my_rect_rightbottom_x = env->GetFloatField(j_my_rect_point2d_rightbottom, point2d.x);
    jfloat c_my_rect_rightbottom_y = env->GetFloatField(j_my_rect_point2d_rightbottom, point2d.y);
    TEST_LOG_E("Get MyRect value successfully");
    // Get inner enum type
    jint img_format_value = env->CallIntMethod(j_struct, cstruct_cache_header.inner_enum_md);
    TEST_LOG_E("Get Inner enum value successfully");
    // Get inner class type
    jobject j_inner_class = env->GetObjectField(j_struct, cstruct_cache_header.jid_innter_class);
    jstring j_inner_class_msg = (jstring)env->GetObjectField(j_inner_class, cstruct_cache_header.innter_class_header.msg);
    
    const char *c_str = env->GetStringUTFChars(j_inner_class_msg, NULL);
    if (NULL == c_str) {
        TEST_LOG_E("Failed to get string UTF chars.");
        return getStatus(env, FAILED);
    }
    TEST_LOG_D("c str: %s", c_str);
    // Release byte[]
    env->ReleaseByteArrayElements(j_data_array, c_data, 0);
    return getStatus(env, SUCCESS);
}

#ifdef __cplusplus
}
#endif