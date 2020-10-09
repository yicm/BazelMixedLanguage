package net.xiaobaiai.app;

import androidx.appcompat.app.AppCompatActivity;

import android.graphics.PointF;
import android.os.Bundle;
import android.util.Log;

import net.xiaobaiai.test.APIs;

public class MainActivity extends AppCompatActivity {
    private APIs apis;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        apis = new APIs();

        PointF pointf = apis.GetPointf();
        Log.d("Test", "pointf: " + pointf);
    }
}