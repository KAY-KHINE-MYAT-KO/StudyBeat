# Android Release Checklist

This project is ready to use a real Android upload keystore through
`android/key.properties`.

## 1. Choose the final app identity

Before your first Play Store upload, replace the placeholder app id:

- `android/app/build.gradle.kts`
  - `namespace = "com.example.studybeat"`
  - `applicationId = "com.example.studybeat"`
- `android/app/src/main/kotlin/com/example/studybeat/MainActivity.kt`
  - update the `package` line to match the new id
  - move the file into the matching folder structure if the package changes

Pick an id you will keep forever, for example:

`com.yourcompany.studybeat`

## 2. Set the release version

Update `pubspec.yaml`:

```yaml
version: 1.0.0+1
```

- `1.0.0` is the user-visible version name
- `1` is the Android version code and must increase on every upload

## 3. Create an upload keystore

Run:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Keep the file and passwords safe. You need the same keystore for future updates.

## 4. Create `android/key.properties`

Copy the example file:

```bash
cp android/key.properties.example android/key.properties
```

Then replace the placeholder values:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=/Users/your-mac-user/upload-keystore.jks
```

## 5. Verify the app locally

Run:

```bash
flutter clean
flutter pub get
flutter test
flutter run --release
```

Check login, Firebase, storage, routing, and any network features.

## 6. Build the Play Store bundle

Run:

```bash
flutter build appbundle --release
```

The output file will be:

`build/app/outputs/bundle/release/app-release.aab`

## 7. Complete Play Console setup

In Google Play Console, complete these sections:

- App details
- Store listing
- App access
- Ads declaration
- Content rating
- Data safety
- Privacy policy
- Target audience

If your developer account is subject to personal-account testing rules,
complete the required closed testing step before production.

## 8. Upload the release

In Play Console:

1. Open your app
2. Go to `Testing` or `Production`
3. Create a new release
4. Enable Play App Signing if prompted
5. Upload `app-release.aab`
6. Add release notes
7. Review and roll out
