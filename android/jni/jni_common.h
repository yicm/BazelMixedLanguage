#ifndef _TEST_JNI_COMMON_H_
#define _TEST_JNI_COMMON_H_

#include <jni.h>
#include <string>

#include "logger.h"

// enum class
#define TEST_SIG_ENUM_COMMONSTATUS          "net/xiaobaiai/test/CommonStatus"


// common class


jobject getStatus(JNIEnv *env, jint code);

jobject getEnumObject(JNIEnv *env, jint index, const char *clazz_sig);

jlong getHandle(JNIEnv *env, jobject handle);

#endif