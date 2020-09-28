#include "jni_common.h"

#include <android/asset_manager.h>
#include <android/asset_manager_jni.h>
#include <unistd.h>
#include <sys/stat.h>
#include <fstream>
#include <mutex>

jobject getStatus(JNIEnv *env, jint code) {
    jobject status;
    jclass clazz = env->FindClass(TEST_SIG_ENUM_COMMONSTATUS);
    if (NULL == clazz) {
        TEST_LOG_E("Failed to find class.");       
        return NULL;
    }
    jmethodID method_status = env->GetMethodID(clazz, "<init>", "(I)V");
    if (NULL == method_status) {
        TEST_LOG_E("Failed to get init method.");
        return NULL;
    }

    status = env->NewObject(clazz, method_status, code);
    return status;
}

static jstring getPackageName(JNIEnv *env, jobject context) {
    jclass context_clazz = env->GetObjectClass(context);
    jmethodID mId = env->GetMethodID(context_clazz, "getPackageName", "()Ljava/lang/String;");
    jstring packName = static_cast<jstring>(env->CallObjectMethod(context, mId));

    return packName;
}

std::string getPath(JNIEnv *env, jobject context,
        const std::string path_prefix,
        const std::string path_suffix) {
    jstring pkg_name = getPackageName(env, context);
    std::string package_name = env->GetStringUTFChars(pkg_name, 0);

    return path_prefix + package_name + path_suffix;
}

static bool createDir(std::string path) {
    if (access(path.c_str(), F_OK) == 0) {
        return true;
    }
    mkdir(path.c_str(), S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
    if (access(path.c_str(), F_OK) != 0) {
        TEST_LOG_E("Have no permission to create folder.\n");
        return false;
    }
    return true;
}

static void createDirs(std::string dir_path) {
    createDir(dir_path);
}

static void copyFileFromAsset(std::string file_path, AAsset *p_asset, bool cover) {
    TEST_LOG_E("%s", file_path.c_str());
    uint buf_size = 1024;
    if(p_asset == NULL ) return;
    if (!cover && access(file_path.c_str(), 0) != -1) {
        TEST_LOG_E("Failed to find asset file or not necessary to cover the file.");
        return;
    }
    TEST_LOG_E("%s", file_path.c_str());
    std::fstream out(file_path.c_str(), std::ios::out|std::ios::binary);
    if (!out) {
        TEST_LOG_E("Failed to create file.");
        return;
    }
    do {
        off_t size = AAsset_getRemainingLength(p_asset);
        if( size > 0 )
        {
            char *buffer = new char[buf_size];
            int ret = AAsset_read(p_asset, buffer, buf_size);
            if( ret <= 0 ) {
                delete[] buffer;
                out.close();
                break;
            }
            off_t length = (size > buf_size) ? buf_size: size;
            out.write(buffer, length * sizeof(char));
            delete[] buffer;
        } else {
            out.close();
            break;
        }
    } while(true);
    return;
}

static std::mutex g_mutex;

jboolean copyFilesFromAssets(JNIEnv *env, jobject context) {
    std::lock_guard<std::mutex> lock(g_mutex);
    static bool init = false;
    if (init) {
        return JNI_TRUE;
    }
    jstring pkg_name = getPackageName(env, context);    
    const char* pkg_name_c = env->GetStringUTFChars(pkg_name, 0);    
    jclass context_clazz = env->GetObjectClass(context);
    jmethodID assets_m = env->GetMethodID(context_clazz, "getAssets", "()Landroid/content/res/AssetManager;");
    jobject asset_manager = env->CallObjectMethod(context, assets_m);
    AAssetManager *mgr = AAssetManager_fromJava(env, asset_manager);
    const char* datas_dir = "adas_datas";
    AAssetDir *asset_dir = AAssetManager_openDir(mgr, datas_dir);
    if (!asset_dir) {
        TEST_LOG_E("open asset dir failed.");
        return JNI_FALSE;
    }
    
    std::string config_dir_str = std::string("/sdcard/android/data/") + std::string(pkg_name_c);
    
    bool success = createDir(config_dir_str);
    if (!success) {
        std::string msg = std::string("Failed to create directory: ") + config_dir_str;
        TEST_LOG_E("%s", msg.c_str());
        return JNI_FALSE;
    }
    
    std::string models_dir_str = config_dir_str + "/models";
    success = createDir(models_dir_str);
    if (!success) {
        std::string msg = std::string("Failed to create directory: ") + models_dir_str;
        TEST_LOG_E("%s", msg.c_str());
        return JNI_FALSE;
    }
    
    const char* file_name;
    while ((file_name = AAssetDir_getNextFileName(asset_dir))) {
        std::string file_name_s = std::string(file_name);
        std::string file_dir = "adas_datas/" + file_name_s;
        AAsset* p_asset = AAssetManager_open(mgr, file_dir.c_str(), AASSET_MODE_STREAMING);
        if (!p_asset) {
            TEST_LOG_E("open asset failed.");
            continue;
        }
        if (std::string::npos != file_name_s.find("adas_config.yml")) {
            copyFileFromAsset(config_dir_str + "/" + file_name_s,
                p_asset, true);
        } else {           
            copyFileFromAsset(config_dir_str + "/models/" + file_name_s,
                p_asset, false);
        }
        AAsset_close(p_asset);
    }
    AAssetDir_close(asset_dir);
    init = true;
    return JNI_TRUE;
}

jlong getHandle(JNIEnv *env, jobject handle) {
    static jclass handle_clz = NULL;
    if (NULL == handle_clz) {
        jclass handle_tmp = env->GetObjectClass(handle);
        if (NULL == handle_tmp) {
            TEST_LOG_E("Failed to find class.");
            return (jlong)0L;
        }
        handle_clz = (jclass)env->NewGlobalRef(handle_tmp);
        env->DeleteLocalRef(handle_tmp);
    }
    jfieldID handle_fieldID = env->GetFieldID(handle_clz, "p_handle", "J");
    jlong j_handle = env->GetLongField(handle, handle_fieldID);

    return j_handle;    
}