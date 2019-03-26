## <u>Phần 2:</u> Using Xcode Configuration (.xcconfig) to Manage Different Build Settings

Đọc tham khảo tại đây : <https://www.appcoda.com/xcconfig-guide/>

#### 2.1 Creating the Build Configuration

- Thêm configuration cho project, thường sẽ là:
  - Debug
  - Staging
  - Release

- Việc này đơn giản là `Duplicate` 1 cái có sẵn trong Project

#### 2.2 Using Xcode Configuration File (.xcconfig)

- Về Xcode Configuration file (`. xcconfig`) chứa những cặp giá trị (key/value) dùng trong project
- New file (**.xcconfig**) —> tạo 3 file cho 3 môi trường —> set vào các config đã đc tạo ra
- Tiến hành edit hay thêm các cặp giá trị vào các file config. Chú ý tất cả các key phải đều đc có mặt ở tất cả các file config

*Ví dụ:*

​	**Debug:**

```swift
IS_APP_NAME = Project (dev)

IS_APP_VERSION = 0.3

IS_APP_BUNDLE_ID = com.fx.TheLastProject.Debug
```

​	**Staging**

```swift
IS_APP_NAME = Project (Staging)

IS_APP_VERSION = 0.2

IS_APP_BUNDLE_ID = com.fx.TheLastProject.Staging
```

​	**Release:**

```swift
IS_APP_NAME = The Last Project

IS_APP_VERSION = 0.1

IS_APP_BUNDLE_ID = com.fx.TheLastProject.Release
```

Mình có thể change cả icon (cái này để sau đi hì)

#### 2.3 Accessing Variables from Code

- Đây là phần cần quan tâm, vì chứa nhiều thứ quan trọng như: Key, Endpoint …

  **Debug.xcconfig:**

```swift
BACKEND_URL = http:\/\/api.intensifystudio.com/development

CONSUMER_KEY = ck_a57e4fa2e14c12ae3f400371cf2951ec3dea5_dev

CONSUMER_SECRET = cs_c847caa35ce1041e9c69d239141f13f63bb22b_dev
```

​	**Staging.xcconfig:**

```swift
BACKEND_URL = http:\/\/api.intensifystudio.com/staging

CONSUMER_KEY = ck_a57e4fa2e14c12f400371cf2951ec3dea5_staging

CONSUMER_SECRET = cs_c847caa35ce1041e9c69d239141f13f63bb22b_staging
```

​	**Release.xcconfig:**

```swift
BACKEND_URL = http:\/\/api.intensifystudio.com/

CONSUMER_KEY = ck_a57e4fa2e14c12f400371cf2951ec3dea5

CONSUMER_SECRET = cs_c847caa35ce1041e9c69d239141f1f63bb22b
```

XONG —> vào file Info.plist mà thêm chúng vào (add row)

Lấy giá trị từ file *Info.plist* vào trong code như sau:

```swift
func infoForKey(_ key: String) -> String? {
        return (Bundle.main.infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "")
 }
```

#### 2.4  Switching Between Build Configurations

Vào scheme -> Edit scheme -> Run -> Build Config : mà thay đổi