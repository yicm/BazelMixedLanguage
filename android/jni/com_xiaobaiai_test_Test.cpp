#include "com_xiaobaiai_test_Test.h"

#include <jni.h>
#include <android/log.h>

#ifdef __cplusplus
extern "C" {
#endif

static jobject getStatus(JNIEnv *env, jint code) {
    jobject status;
    jclass clazz = env->FindClass("com/xiaobaiai/test/CommonStatus");
    if (NULL == clazz) {
        __android_log_print(ANDROID_LOG_ERROR, __FUNCTION__, "Line %d: %s\n", 
            __LINE__, "Failed to find CommonStatus class.");
        return NULL;
    }
    jmethodID method_status = env->GetMethodID(clazz, "<init>", "(I)V");
    if (NULL == method_status) {
        __android_log_print(ANDROID_LOG_ERROR, __FUNCTION__, "Line %d: %s\n", 
            __LINE__, "Failed to get CommonStatus init method.");
        return NULL;
    }

    status = env->NewObject(clazz, method_status, code);
    return status;
}

/*
 * Class:     com_xiaobaiai_test_Test
 * Method:    GetStatus
 * Signature: (Landroid/content/Context;)Lcom/xiaobaiai/test/CommonStatus;
 */
JNIEXPORT jobject JNICALL Java_com_xiaobaiai_test_Test_GetStatus
  (JNIEnv *env, jobject, jobject) {
    return getStatus(env, 0);
}

#ifdef __cplusplus
}
#endif