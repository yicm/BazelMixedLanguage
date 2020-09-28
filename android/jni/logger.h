#ifndef _TEST_LOGGER_H_
#define _TEST_LOGGER_H_


#if defined ANDROID_LOGGER_ON
#include <jni.h>
#include <android/log.h>

#define TEST_LOG_D(format, ...) do{__android_log_print(ANDROID_LOG_DEBUG, \
            __FUNCTION__, "Line %d : " format "\n", __LINE__, ##__VA_ARGS__); \
            } while(0)

#define TEST_LOG_I(format, ...) do{__android_log_print(ANDROID_LOG_INFO, \
            __FUNCTION__, "Line %d : " format "\n", __LINE__, ##__VA_ARGS__); \
            } while(0)

#define TEST_LOG_W(format, ...) do{__android_log_print(ANDROID_LOG_WARN, \
            __FUNCTION__, "Line %d : " format "\n", __LINE__, ##__VA_ARGS__); \
            } while(0)

#define TEST_LOG_E(format, ...) do{__android_log_print(ANDROID_LOG_ERROR, \
            __FUNCTION__, "Line %d : " format "\n", __LINE__, ##__VA_ARGS__); \
            } while(0)

#else

#include <stdio.h>

#define TEST_LOG_D(format, ...) do{fprintf(stdout, \
        "[%s][%d] :" format "\n", __FUNCTION__, __LINE__, ##__VA_ARGS__); \
    } while(0)
#define TEST_LOG_I(format, ...) do{fprintf(stdout, \
        "[%s][%d] :" format "\n", __FUNCTION__, __LINE__, ##__VA_ARGS__); \
    } while(0)
#define TEST_LOG_W(format, ...) do{fprintf(stdout, \
        "[%s][%d] :" format "\n", __FUNCTION__, __LINE__, ##__VA_ARGS__); \
    } while(0)
#define TEST_LOG_E(format, ...) do{fprintf(stderr, \
        "[%s][%d] :" format "\n", __FUNCTION__, __LINE__, ##__VA_ARGS__); \
    } while(0)

#endif



#endif