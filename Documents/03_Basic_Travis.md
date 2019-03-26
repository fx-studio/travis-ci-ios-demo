## <u>Phần 3:</u> Basic config Travis CI

Phần này dành cho các bạn mù về CI, nếu bạn đã trùm thì có thể bỏ qua phần này. Ahihi. Trước tiên thì đi vào mấy khái niệm cơ bản trước đã:

- **CI là gì?**
  - Viết tắt của ***Continuous Integration (CI)*** ; gọi là tích hợp liên tục
  - Giúp cho mình trong việc kiểm tra, build app, test (UI và Unit), review code giúp
  - Tích hợp vào GitHub để thông báo cho dev biết tình trạng các pull request của mình
  - Về iOS thì CI khá đắt do giá máy MAC OS trên các dịch vụ CI tốn phí nhiều. 
- **Travis CI**
  - Là dịch vụ CI cho lập trình viên
  - Tích hợp đc với Github
  - Có 2 phiên bản
    - Free (chỉ chạy đc public repo) : <https://travis-ci.org/>
    - Trả phí (chạy đc private repo) : <https://travis-ci.com/>

#### 3.1 The YAML File

- Là file có đuôi là `yml` 

- Các dịch vụ CI sẽ tự động clone source code từ repo của bạn về, nếu trong repo có `yaml file` thì sẽ tự động đọc file đó và thực thi các lệnh hay setup cấu hình mà mình ghi trong đó.

- Với Travis CI thì file sẽ tên là `.travis.yml`

  Ví dụ:

  ```ruby
  language: objective-c
  osx_image: xcode10.1
  xcode_workspace: TheLastProject.xcworkspace
  xcode_scheme: TheLastProject_Development
  xcode_destination: platform=iOS Simulator,OS=12.1,name=iPhone X
  before_install:
    - bundle install
    - bundle exec pod install --repo-update
  ```

#### 3.2 Cấu trúc cơ bản của YAML File

- **language**

  - Travis hỗ trợ cả 2 ngôn ngữ `Objective-C` và `Swift`
  - Tuy nhiên cài đặt thì `objective-c` cho cả 2

- **osx_image**

  - Đây là máy ảo chọn để build project lên mình
  - Có nhiều cấu hình máy áo, bạn nên chọn loại phù hợp với project của mình. Nếu như chọn máy ảo đời thấp hơn so với yêu cầu project thì sẽ ko build đc
  - Danh sách các máy ảo đc support của Tracis CI sau [đây](https://docs.travis-ci.com/user/reference/osx/)

- **xcode_workspace**

  - Vì có nhiều project trong 1 workspace (Pod, project hiện tại, các thư viện nếu build trực tiếp từ project)
  - Nên hãy chọn cho đúng
  - Nếu có thư mục thì hãy trỏ đường dẫn vào. Ví dụ:

  ```ruby
  ./Example/TravisCIBlog.xcworkspace
  ```

- **xcode_scheme**

  - Cực kì quan trọng vì nó sẽ quyết định bạn muốn build gì hay kiểm tra gì. Hãy chọn cho đúng.
  - Ngoài ra, thì cần phải ***share*** scheme để CI có thể build đc (vào Scheme -> Managment —> xem vào chọn)

- **xcode_destination**

  - Lựa chọn cho các thanh niên nhà nghèo khi dùng `iPhone simulator`
  - Bạn có thể quyết định chọn máy ảo nào để build
  - Danh sách các máy ảo được support ở [đây](https://gist.github.com/jgsamudio/4a38d468c12aaec84cdc5f5b2c77b726)

- **before_install**

  - Cực kì quan trọng, vì nó sẽ chạy các lệnh cơ bản trước khi thực hiện
  - Vì máy ảo đó trên mạng nên ko có như local là bạn chỉ cần chạy các lệnh như `pod` rồi cứ thế mà build tới. Nên mình phải thêm các lệnh đó vào phần này

  ```ruby
  before_install:
    - bundle install
    - bundle exec pod install --repo-update
  ```

  - Nếu có lệnh nào phức tạp hơn thì hay chuẩn bị gì thêm thì bỏ thêm vào

#### 3.3 Triggering a Build

- Phần này thì mặc định Tracis CI sẽ theo dõi các `pull request` vào `master`
- Nên bạn cứ tạo `new branch` và gởi `pull request` . Các lần sau chỉ cần `commit` và `push` vào `branch` đó thì CI auto chạy
- Vì sài đồ free hoặc nếu có trả phí thì cũng sẽ bị giới hạn các repo build cùng lúc nêu

```
Chờ đợi là hạnh phúc. Ahihi
```

- Các trigger phức tạp thì sẽ để phần sau nha. :-)

#### 3.4 Cấu hình lại Project

- Đời không đơn giản khi bạn cấu hình xong `yaml file` là CI sẽ chạy. Lỗi đầu tiên gặp như sau:

```
The command "set -o pipefail && xcodebuild -workspace TheLastProject.xcworkspace -scheme TheLastProject_Development build test | xcpretty" exited with 66
```

- Bạn nên xem lại project đã có các target `test` chưa, nếu chưa có thì:
  - Tạo thêm các target test (Unit & UI)
  - Config build cho tụi nó
  - Check lại 1 lượt các scheme
- Tiếp theo lỗi như thế này

```
error: No profiles for 'com.fx.TheLastProject' were found: Xcode couldn't find any iOS App Development provisioning profiles matching 'com.fx.TheLastProject'. Automatic signing is disabled and unable to generate a profile. To enable automatic signing, pass -allowProvisioningUpdates to xcodebuild. (in target 'TheLastProject')
```

- Chúc mừng là đã thiếu profile `dev, certificate, provisioning profile` … Nôm na là phần `dev signing` để có thể build đc app. Khắc phục sau:
  - Cần phải tắt auto signing
  - Nếu tắt rồi mà không đc thì xoá `team developer`
  - Nếu như vậy mà không đc nữa thì chú ý phần **xcode_destination**, cấu hình lại cho `simulator` chạy. Vì đôi khi một số xcode của anh/chị/em đã ăn với account dev nào rồi nên pó tay thôi.

```
Đừng lo lắng về phần này quá. Vì sẽ được giải quyết tiếp ở phần sau. Ahuhu
```

#### 3.5 Làm đẹp YAML

- **cache** : vì các lệnh `bundler` và `pod` chạy khá tốn thời gian, nên mình sẽ cache lại phần này. Có thể chọn đường dẫn để trỏ tới thư mục cache

```ruby
cache:
  - bundler
  - cocoapods
```

- **script**: dùng để chạy các tập lệnh phức tạp hơn chút
- **install**: thêm các tiện ích khác.

Tạm thời như vậy, sau đây là `yaml file` cơ bản của mình. Ahihi

```ruby
language: objective-c
osx_image: xcode10.1
cache:
  - bundler
  - cocoapods
xcode_workspace: TheLastProject.xcworkspace
xcode_scheme: TheLastProject_Development
xcode_destination: platform=iOS Simulator,OS=12.1,name=iPhone X
before_install:
  - bundle install
  - bundle exec pod install --repo-update
install:
  - set -o pipefail
  - sudo systemsetup -settimezone Asia/Ho_Chi_Minh
  - bundle install --path=vendor/bundle --jobs 4 --retry 3
```

