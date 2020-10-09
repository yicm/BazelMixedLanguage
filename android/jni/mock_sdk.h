#ifndef _TEST_JNI_MOCK_SDK_H_
#define _TEST_JNI_MOCK_SDK_H_

#if defined _MSC_VER
    #if defined API_EXPORT_ON
        #define API_EXPORT __declspec(dllexport)
    #else
        #define API_EXPORT __declspec(dllimport)
    #endif
#else
    #if defined API_EXPORT_ON
        #define API_EXPORT __attribute__((visibility("default")))
    #else
        #define API_EXPORT
    #endif
#endif

typedef struct CHandleInner *CHandle;
typedef struct CStructInner *CStructDesc;

typedef enum CommonStatus {
    SUCCESS = 0,
    FAILED  = -1,
} CommonStatus;

#ifdef __cplusplus
extern "C" {
#endif

API_EXPORT
CommonStatus InitCHandle(CHandle *handle);

API_EXPORT
CommonStatus DestroyCHandle(CHandle handle);

// API_EXPORT
// CommonStatus GetCStructData(CStructDesc out);

#ifdef __cplusplus
}
#endif

#endif