## <u>Phần 5:</u> Certificate và Provisioning profile

Muốn có được tụi này thì bạn phải bỏ tiền là mua account **Apple Developer Program**, với giá là 99$/năm. Khá chua cho cuộc tình nhưng theo lời khuyên chân thành thì cứ nên đầu tư 1 cái, vì mình còn có nhiều thứ làm với account đó nữa. 

Xin cảm ơn **Viblo** vì đã giải thích quá rõ : <https://viblo.asia/p/khai-quat-ve-apple-developer-account-certificates-provioning-profiles-RQqKLgap57z>

#### 5.1. Certificates

- Sau khi đã join vào Membership Program của Apple, điều bạn cần quan tâm đến là Certificates, App IDs và Provisioning Profiles. Certificate có thể coi là chứng minh nhân dân hoặc bằng lái xe của bạn vậy. 
- Bạn cần request, download và sử dụng các signing certificate để xác thực, chứng nhận bạn có quyền phát triển và phát hành ứng dụng với tài khoản Apple developer tương ứng. 
- Certificate được quản lý dưới dạng 
  - public key 
  - private key. 
- Khi muốn share certificate, bạn cần export certificate (private key) dưới dạng file **.p12**. Nếu làm mất private key, bạn phải tạo lại certificate khác từ đầu. 
- Có 2 loại certificate cần chú ý. Đó là:
  - **Development Certificates**  : Là những certificate dành cho giai đoạn phát triển ứng dụng. Gồm 2 loại chính:
    - **iOS App Development**: Development Certificate được dùng trong quá trình develop app. Giúp developer có thể run và debug app trong môi trường development. Thường thì mỗi thành viên trong team phát triển sẽ cần tạo một certificate loại này để chứng nhận quyền develop app. Mỗi member được tạo tối đa 4 certificate development.
    - **Apple Push Notification service SSL (Sandbox)**: dùng cho server push notification ở môi trường development cho một App ID cụ thể. Ví dụ bạn cần push notification về một app có App ID là com.xxx.yyy thì server push cần được cấp quyền push. Quyền push được thể hiện qua certificate dạng này.
  - Production Certificates : Là những certificate dùng để phát hành ứng dụng. Có nhiều loại, nhưng thường thì ta chỉ cần quan tâm đến 3 loại:
    - **App Store and Ad Hoc**: Certificate loại này cho phép bạn có quyền distribute app lên App Store hoặc trên một list các thiết bị có sẵn trong tài khoản dạng Ad Hoc.
    - **Apple Push Notification service SSL (Production)**: Tương tự như **Apple Push Notification service SSL (Sandbox)**, certificate này cấp quyền cho server push notification đến app trong môi trường production.
    - **In-House and Ad Hoc**: Certificate này chỉ xuất hiện với tài khoản enterprise, cho phép phát hành app dạng Ad Hoc hoặc In-House (không giới hạn số lượng thiết bị, không cần biết trước UUID...).

![cert](https://viblo.asia/uploads/d77e6d52-39d5-4f9f-bd40-ed059e5f406c.png)

#### 5.2. App IDs, Device and Provisioning Profile

- **App IDs** : là định danh các ứng dụng thông mà 1 chuỗi ký tự để đảm bảo là duy nhất mà giang hồ hay gọi là bundle id
- **Devices**: các thiết bị được thêm vào với mã UUID của nó vào account dev. Có như vậy thì bạn mới có thể cài đc app lên thiết bị của bạn với app build ở môi trường distribution.
- **Provisioning Profile:**
  - Một cách ngắn gọn để giải thích về provisioning profile là công thức sau: 
    - **Provisioning Profile = Certificate (Development hoặc Production) + App ID + Devices List (nếu distribute dạng Ad Hoc hoặc debug development).** 
  - Provisioning Profile có thể được tạo ra tự động nếu bạn enable option **Auto Signing** trên Xcode hoặc có thể được tạo và quản lý bởi các tài khoản admin trở lên. 
  - Để tạo provisioning profile cho một app ở môi trường development, bạn cần chọn App ID, chọn các Certificate được join vào, chọn list devices. 
  - Một trong các thành phần của provisioning profile bị invalid thì profile đó sẽ **invalid** và không sử dụng được. 
    - *Ví dụ* một team member *revoke development certificate* của người đó thì tất cả các provisioning profile chứa certificate đó sẽ bị invalid. Hoặc khi xóa một App ID thì tất cả các provisioning profile liên quan cũng sẽ bị xóa theo

![provisioning](https://viblo.asia/uploads/4d6c18ab-3171-4c45-aab9-2a5327eb4e2d.png)

#### 5.3. Thêm các file Certificates và Provisioning vào CI

Bạn cần hiểu nôm na là CI sẽ chạy 1 con máy MAC OS trên server và con máy đó không có gì hết, công việc của mình là sẽ thêm bằng tay tất cả những thứ cần cho việc build vào con CI đó.

- **Chuẩn bị các file:**

  - Tạo 1 app id với bundle id của project của bạn
  - 2 file certificates cho 2 môi trường Development và Distribution
    - Public key là các file .cer
    - Private key là các file .p12 (tụi nó có pass)
  - 2 file provisioning cho 2 môi trường đó

  Các bạn có thể sử dụng các file của mình trong repo này, tuy nhiên sau này nếu không chạy đc thì do mình đã xoá trên account dev của mình. Vì vậy tốt nhất là nên sài đồ của bản thân cho chắc.

- **Cấu hình lại project** của các bạn để có thể build và test đc project bằng Xcode với 2 kiểu sau:

  - Auto signing
  - Dùng Provisioning và Certificate

- **Coding**

  - Di chuyển script `linter` vào thư mục `./script` để tiện quản lý
  - Viết scripts để thêm các file trên vào máy ảo Travis CI. Bạn tạo 1 shell bash tên là `add-key.sh` trong thư mục `./scripts`

  ```bash
  #!/bin/bash
  
  KEY_CHAIN=ios-build.keychain
  security create-keychain -p travis $KEY_CHAIN
  # Make the keychain the default so identities are found
  security default-keychain -s $KEY_CHAIN
  # Unlock the keychain
  security unlock-keychain -p travis $KEY_CHAIN
  # Set keychain locking timeout to 3600 seconds
  security set-keychain-settings -t 3600 -u $KEY_CHAIN
  
  # Add certificates to keychain and allow codesign to access them
  security import ./scripts/certs/dis.cer -k $KEY_CHAIN -T /usr/bin/codesign
  security import ./scripts/certs/dev.cer -k $KEY_CHAIN -T /usr/bin/codesign
  
  security import ./scripts/certs/dis.p12 -k $KEY_CHAIN -P 12345678  -T /usr/bin/codesign
  security import ./scripts/certs/dev.p12 -k $KEY_CHAIN -P 12345678  -T /usr/bin/codesign
  
  security set-key-partition-list -S apple-tool:,apple: -s -k travis ~/Library/Keychains/ios-build.keychain
  
  echo "list keychains: "
  security list-keychains
  echo " ****** "
  
  echo "find indentities keychains: "
  security find-identity -p codesigning  ~/Library/Keychains/ios-build.keychain
  echo " ****** "
  
  # Put the provisioning profile in place
  mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
  
  uuid=`grep UUID -A1 -a ./scripts/profiles/TheLastProject_Dev.mobileprovision | grep -io "[-A-F0-9]\{36\}"`
  cp ./scripts/profiles/TheLastProject_Dev.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/$uuid.mobileprovision
  
  uuid=`grep UUID -A1 -a ./scripts/profiles/TheLastProject_AdHoc.mobileprovision | grep -io "[-A-F0-9]\{36\}"`
  cp ./scripts/profiles/TheLastProject_AdHoc.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/$uuid.mobileprovision
  
  #cp ./scripts/profiles/TheLastProject_Dev.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/
  #cp ./scripts/profiles/TheLastProject_AdHoc.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/
  
  echo "show provisioning profile"
  ls ~/Library/MobileDevice/Provisioning\ Profiles
  echo " ****** "
  ```

  - Edit lại file `.travis.yml` để chạy các shell bass này

  ```bash
  before_script:
    - chmod a+x ./scripts/add-key.sh
    - sh ./scripts/add-key.sh
  script:
    - ./scripts/linter
  ```



#### 5.4. Giải thích

- Tạo `keychain`
  - Là nơi để chứa các certificate và provisioning trong MAC OS
  - MAC OS có thể tìm nhanh chóng và bạn có thể dùng `ctrl + space` sẽ thấy
  - Tạo 1 keychain với:
    - Tên: `ios-build.keychain`
    - Pass: `travis`
  - Phần này cho các thanh niên chuyên copy dán mà lỡ chạy bậy thì còn có `pass` để mà xoá

```bash
KEY_CHAIN=ios-build.keychain
security create-keychain -p travis $KEY_CHAIN
```

```bash
# Make the keychain the default so identities are found
security default-keychain -s $KEY_CHAIN
# Unlock the keychain
security unlock-keychain -p travis $KEY_CHAIN
# Set keychain locking timeout to 3600 seconds
security set-keychain-settings -t 3600 -u $KEY_CHAIN
```

- Set thuộc tính có keychain
  - Default : để MAC OS tìm trước
  - Unlock chúng để khỏi phải nhập pass nếu truy xuất tới
  - Time out cho nó `1 giờ` để tự huỹ, chứ cài nhiều quá loạn
- Thêm các file **certificates**  vào
  - Add lần lượt từng cái vào từng thư mục
  - 2 em file cert ko cần add cũng đc, chủ yếu là 2 em .p12
  - Pass của file p12 là `12345678`

```bash
# Add certificates to keychain and allow codesign to access them
security import ./scripts/certs/dis.cer -k $KEY_CHAIN -T /usr/bin/codesign
security import ./scripts/certs/dev.cer -k $KEY_CHAIN -T /usr/bin/codesign

security import ./scripts/certs/dis.p12 -k $KEY_CHAIN -P 12345678  -T /usr/bin/codesign
security import ./scripts/certs/dev.p12 -k $KEY_CHAIN -P 12345678  -T /usr/bin/codesign
```

- Tuy nhiên đời không phải là mơ, nếu bạn chạy với Travis CI là MAC OS, thì đôi khi add đc rồi nhưng lại không hoạt động.
  - Bạn vào đây để điều tra lỗi : <https://docs.travis-ci.com/user/common-build-problems/#mac-macos-sierra-1012-code-signing-errors>
  - Chú ý `keychainPass` và `keychainName`

```bash
security set-key-partition-list -S apple-tool:,apple: -s -k keychainPass keychainName
```

- Move các file provisioninh vào các thư mục cần thiết
  - Chúng ta cần phải mã hoá theo `MD5` cho file provisioning, vì xcode muốn thế
  - Các bạn có xem và thấm dần trong đoạn code dưới

```bash
# Put the provisioning profile in place
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles

uuid=`grep UUID -A1 -a ./scripts/profiles/TheLastProject_Dev.mobileprovision | grep -io "[-A-F0-9]\{36\}"`
cp ./scripts/profiles/TheLastProject_Dev.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/$uuid.mobileprovision

uuid=`grep UUID -A1 -a ./scripts/profiles/TheLastProject_AdHoc.mobileprovision | grep -io "[-A-F0-9]\{36\}"`
cp ./scripts/profiles/TheLastProject_AdHoc.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/$uuid.mobileprovision

#cp ./scripts/profiles/TheLastProject_Dev.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/
#cp ./scripts/profiles/TheLastProject_AdHoc.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/
```

Kết quả chạy OK thì như sau (trên travis ci)

```
$ sh ./scripts/add-key.sh
1 identity imported.
1 identity imported.
keychain: "/Users/travis/Library/Keychains/[secure]-db"
version: 512
class: 0x00000010 
attributes:
    0x00000000 <uint32>=0x00000010 
    0x00000001 <blob>="iOS Distribution: Tien Le"
    0x00000002 <blob>=<NULL>
    0x00000003 <uint32>=0x00000001 
    0x00000004 <uint32>=0x00000000 
    0x00000005 <uint32>=0x00000000 
    0x00000006 <blob>=0x573F5F26AAF3F17159F89AA601022169D9C4D28C  "W?_&\252\363\361qY\370\232\246\001\002!i\331\304\322\214"
    0x00000007 <blob>=<NULL>
    0x00000008 <blob>=0x7B38373139316361322D306663392D313164342D383439612D3030303530326235323132327D00  "{87191ca2-0fc9-11d4-849a-000502b52122}\000"
    0x00000009 <uint32>=0x0000002A  "\000\000\000*"
    0x0000000A <uint32>=0x00000800 
    0x0000000B <uint32>=0x00000800 
    0x0000000C <blob>=0x0000000000000000 
    0x0000000D <blob>=0x0000000000000000 
    0x0000000E <uint32>=0x00000001 
    0x0000000F <uint32>=0x00000001 
    0x00000010 <uint32>=0x00000001 
    0x00000011 <uint32>=0x00000000 
    0x00000012 <uint32>=0x00000001 
    0x00000013 <uint32>=0x00000001 
    0x00000014 <uint32>=0x00000001 
    0x00000015 <uint32>=0x00000001 
    0x00000016 <uint32>=0x00000001 
    0x00000017 <uint32>=0x00000001 
    0x00000018 <uint32>=0x00000001 
    0x00000019 <uint32>=0x00000001 
    0x0000001A <uint32>=0x00000001 
keychain: "/Users/travis/Library/Keychains/[secure]-db"
version: 512
class: 0x00000010 
attributes:
    0x00000000 <uint32>=0x00000010 
    0x00000001 <blob>="iOS Developer: Tien Le (Tien Le)"
    0x00000002 <blob>=<NULL>
    0x00000003 <uint32>=0x00000001 
    0x00000004 <uint32>=0x00000000 
    0x00000005 <uint32>=0x00000000 
    0x00000006 <blob>=0xC3076BCF7A1B6AA8C739F5DE8D0E16A913DF7FD9  "\303\007k\317z\033j\250\3079\365\336\215\016\026\251\023\337\177\331"
    0x00000007 <blob>=<NULL>
    0x00000008 <blob>=0x7B38373139316361322D306663392D313164342D383439612D3030303530326235323132327D00  "{87191ca2-0fc9-11d4-849a-000502b52122}\000"
    0x00000009 <uint32>=0x0000002A  "\000\000\000*"
    0x0000000A <uint32>=0x00000800 
    0x0000000B <uint32>=0x00000800 
    0x0000000C <blob>=0x0000000000000000 
    0x0000000D <blob>=0x0000000000000000 
    0x0000000E <uint32>=0x00000001 
    0x0000000F <uint32>=0x00000001 
    0x00000010 <uint32>=0x00000001 
    0x00000011 <uint32>=0x00000000 
    0x00000012 <uint32>=0x00000001 
    0x00000013 <uint32>=0x00000001 
    0x00000014 <uint32>=0x00000001 
    0x00000015 <uint32>=0x00000001 
    0x00000016 <uint32>=0x00000001 
    0x00000017 <uint32>=0x00000001 
    0x00000018 <uint32>=0x00000001 
    0x00000019 <uint32>=0x00000001 
    0x0000001A <uint32>=0x00000001 
list keychains: 
    "/Users/travis/Library/Keychains/[secure]-db"
    "/Library/Keychains/System.keychain"
 ****** 
find indentities keychains: 
Policy: Code Signing
  Matching identities
  1) 86890D67F234745572B7EF153C72DEA7CF522EDE "iPhone Distribution: Tien Le (QG598U658S)"
  2) 13F9C39BE0072902F6A60AF738F51BE53E3A8B23 "iPhone Developer: Tien Le (8PKL73LX5A)"
     2 identities found
  Valid identities only
  1) 86890D67F234745572B7EF153C72DEA7CF522EDE "iPhone Distribution: Tien Le (QG598U658S)"
  2) 13F9C39BE0072902F6A60AF738F51BE53E3A8B23 "iPhone Developer: Tien Le (8PKL73LX5A)"
     2 valid identities found
 ****** 
show provisioning profile
3aec5b06-93af-4a41-bfa0-5060954f79c1.mobileprovision
dc18ac75-6cf8-4ccb-a6b7-1180d5efaecd.mobileprovision
```