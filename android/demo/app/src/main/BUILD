android_binary(
    name = "app",
    srcs = [
        ":java/net/xiaobaiai/app/MainActivity.java",
        ":java/net/xiaobaiai/app/APIsTest.java",
    ],
    manifest = "AndroidManifest.xml",
    # To find R.class
    custom_package = "net.xiaobaiai.app",
    deps = [ 
        "@maven//:androidx_appcompat_appcompat_1_2_0",
        "@maven//:androidx_constraintlayout_constraintlayout_2_0_1",
        "//android:android_java_lib",
    ],
    resource_files = glob(["res/**"]),
)
