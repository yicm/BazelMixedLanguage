#include "mock_sdk.h"

#include "logger.h"
#include <stdlib.h>

struct CHandleInner {
    int * sub_handle;
};

struct Pointf {
    float x;
    float y;
};

struct CStructInner {
    unsigned int ui;
    long j;
    float f;
    double d;
    struct Pointf points[10];
};

CommonStatus InitCHandle(CHandle *handle)
{
    static short is_init = 0;
    if (is_init) {
        TEST_LOG_I("Handle is already initialized");
        return SUCCESS;
    }
    *handle = (struct CHandleInner *)malloc(sizeof(struct CHandleInner));
    if (NULL == *handle) {
        TEST_LOG_E("Faile to malloc");
        return FAILED;
    }

    const int size = 10;
    (*handle)->sub_handle = (int *)malloc(size * sizeof(int));
    if (!((*handle)->sub_handle)) {
        TEST_LOG_E("Faile to malloc");
        free(*handle);
        *handle = NULL;
        return FAILED;
    }

    return SUCCESS;
}

CommonStatus DestroyCHandle(CHandle handle)
{
    if (!handle) {
        TEST_LOG_E("Handle is null");
        return FAILED;
    }
    if (!handle->sub_handle) {
        TEST_LOG_E("Sub Handle is null");
        free(handle);
        handle = NULL;
        return FAILED;
    }
    free(handle);
    handle = NULL;
    return SUCCESS;
}

CommonStatus GetCStructData(CStructDesc out)
{
    static int count = 0;
    struct CStructInner data = {
        .ui =  20 + count ++,
        .j = 21,
        .f = 22.5,
        .d = 23.8,
        .points = {
            {
                .x = 1,
                .y = 2
            },
            {
                .x = 3,
                .y = 4
            }
        }
    };

    *out = data;

    return SUCCESS;
}