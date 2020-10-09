package net.xiaobaiai.app;

import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;

public class MainActivity extends AppCompatActivity {
    private APIsTest apisTest;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        apisTest = new APIsTest(this.getApplicationContext());
        apisTest.Start();
    }
}