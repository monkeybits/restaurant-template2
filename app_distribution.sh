#!/bin/bash

firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk --app 1:250930131752:android:c0f5943a28a6943b5f161d --release-notes "First distribution" --groups "admin"  # --testers "bellinitom97@gmail.com"
