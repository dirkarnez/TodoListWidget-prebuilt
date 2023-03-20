#!/bin/bash

echo $JAVA_HOME_8_X64 && \
echo $JAVA_HOME_11_X64 && \
curl -L -O -J https://dl.google.com/android/repository/commandlinetools-win-9477386_latest.zip && \
7z x commandlinetools-win-9477386_latest.zip -o"$USERPROFILE/Downloads/commandlinetools-win-9477386_latest" && \
\ 
export JAVA_HOME="$(cygpath -u $JAVA_HOME_8_X64)" && \
export ANDROID_HOME="$(cygpath -u $USERPROFILE/Downloads/commandlinetools-win-9477386_latest)" && \
export PATH="$ANDROID_HOME/cmdline-tools/bin:/usr/local/bin/:/usr/bin/:$JAVA_HOME:$JAVA_HOME/bin" && \
echo $ANDROID_HOME && \
echo $JAVA_HOME && \
sdkmanager.bat --list --sdk_root=$ANDROID_HOME && \
yes | sdkmanager.bat --sdk_root=$ANDROID_HOME --install "platform-tools" "platforms;android-23" "build-tools;27.0.1" && \
\ 
export JAVA_HOME="$(cygpath -u $JAVA_HOME_11_X64)" && \
export ANDROID_HOME="$(cygpath -u $USERPROFILE/Downloads/commandlinetools-win-9477386_latest)" && \
export PATH="$ANDROID_HOME/cmdline-tools/bin:/usr/local/bin/:/usr/bin/:$JAVA_HOME:$JAVA_HOME/bin" && \
echo $ANDROID_HOME && \
echo $JAVA_HOME && \
\
rm -v -f -r ./obj && \
rm -v -f -r ./bin && \
rm -v -f -r ./key && \
mkdir ./obj && \
mkdir ./bin && \
mkdir ./key && \
\ 
export JAVA_HOME="$(cygpath -u $JAVA_HOME_8_X64)" && \
$ANDROID_HOME/build-tools/27.0.1/aapt package -v -f -m -S ".\res" -J ".\src" -M ./AndroidManifest.xml -I $ANDROID_HOME/platforms/android-23/android.jar && \
\
javac -d ./obj/ -source 1.7 -target 1.7 -classpath $ANDROID_HOME/platforms/android-23/android.jar -sourcepath ./src/*.java ./src/org/chrisbailey/todo/*.java  ./src/org/chrisbailey/todo/activities/*.java ./src/org/chrisbailey/todo/db/*.java  ./src/org/chrisbailey/todo/utils/*.java  ./src/org/chrisbailey/todo/widgets/*.java && \
$ANDROID_HOME/build-tools/27.0.1/dx.bat --dex --output=".\bin\classes.dex" ".\obj" && \
$ANDROID_HOME/build-tools/27.0.1/aapt package -f -M ./AndroidManifest.xml -S ".\res" -I $ANDROID_HOME/platforms/android-23/android.jar -F "./bin/HelloWorld.unsigned.apk" ./bin
keytool -genkeypair -validity 10000 -dname "CN=Kolodez, OU=Kolodez, O=Kolodez, C=US" -keystore ./key/mykey.keystore -storepass mypass -keypass mypass -alias myalias -keyalg RSA
jarsigner -keystore ./key/mykey.keystore -storepass mypass -keypass mypass -signedjar ./bin/HelloWorld.signed.apk ./bin/HelloWorld.unsigned.apk myalias
$ANDROID_HOME/build-tools/27.0.1/zipalign -f 4 ./bin/HelloWorld.signed.apk ./bin/HelloWorld.apk
