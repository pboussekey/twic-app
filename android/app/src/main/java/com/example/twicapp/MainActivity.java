package com.example.twicapp;

import android.os.Bundle;

import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.share.FlutterShareReceiverActivity;

public class MainActivity extends FlutterShareReceiverActivity {

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

  }
}
