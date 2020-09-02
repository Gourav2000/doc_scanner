package com.example.doc_scanner;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;
import android.widget.Toast;

import com.labters.documentscanner.ImageCropActivity;
import com.labters.documentscanner.helpers.ScannerConstants;

import java.io.ByteArrayOutputStream;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    String CHANNEL="doc_Scanner/Crop";
    Boolean rosult=false;
    Bitmap b;
    Bitmap cropped_photo;
    String cropped_img;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                String img_o=call.arguments();
                ScannerConstants.cropText="Crop";
                ScannerConstants.backText="Cancel";
                ScannerConstants.cropColor="#00E676";
                ScannerConstants.progressColor="#00E676";
                ScannerConstants.imageError="No image selected..Plz try again!!";
                ScannerConstants.cropError="You have not selected a valid field. Please make corrections until the lines are blue.";
                if(call.method.equals("get_it_cropped")){
                    rosult=false;
                    cropped_img="";
                    cropped_photo=null;
                    byte[] decodedString= Base64.decode(img_o,Base64.DEFAULT);
                    b= BitmapFactory.decodeByteArray(decodedString,0,decodedString.length);
                    CropImage(b);
                    result.success(null);
                }
                if(call.method.equals("check")){
                    result.success(rosult);
                }
                if(call.method.equals("get_cropped_img")){
                    result.success(cropped_img);
                }
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if(requestCode==1234&&resultCode== Activity.RESULT_OK){
            if (ScannerConstants.selectedImageBitmap!=null) {
                cropped_photo = ScannerConstants.selectedImageBitmap;
                ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
                cropped_photo.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream);
                byte[] byteArray = byteArrayOutputStream .toByteArray();
                cropped_img= Base64.encodeToString(byteArray, Base64.DEFAULT);
                rosult=true;
                Toast.makeText(MainActivity.this, "Succesful it is mf###sss", Toast.LENGTH_LONG).show();
            }
            else
                Toast.makeText(MainActivity.this,"Something wen't wrong.",Toast.LENGTH_LONG).show();
        }
        else if(requestCode==1234){
            cropped_img=null;
            rosult=true;
            Toast.makeText(MainActivity.this,"It is cancelled.",Toast.LENGTH_LONG).show();
        }
    }

    private void  CropImage(Bitmap b) {
        ScannerConstants.selectedImageBitmap=b;
        Intent intent=new Intent(MainActivity.this, ImageCropActivity.class);
        startActivityForResult(intent,1234 );
    }
}
