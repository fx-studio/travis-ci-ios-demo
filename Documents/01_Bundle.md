## <u>Phần 1:</u> Cài đặt Bundle cho project

Cài đặt `bundle` (nếu chưa có), mở Terminal lên và gõ

```ruby
gem install bundle
```

Nếu chưa cài đặt luôn *gem* thì làm ơn lên Google tìm cách nha

- **Bước 1: init gemfile**

```ruby
bundle init
```

Nó sẽ tạo ra 1 file tên là `gemfile` . 

- **Bước 2: edit gemfile**

Dùng trình editor nào đó mà mở lên edit lại, ví dụ như sau:

```ruby
gem 'fastlane', '2.97.0'
gem 'xcpretty', '0.2.8'
gem 'cocoapods', '1.5.3'
gem 'linterbot', '0.2.7'
gem 'slather', '2.4.5'
```

- **Bước 3: install gem**

Sinh ra file `gemfile.lock` 

```ruby
bundle install
```

- **Bước 4: install cocoapod**

Bạn trước tiên sẽ edit và thêm `cocoapod` vào gemfile, sau đó chạy lệnh sau để tạo cocoapod

```ruby
bundle exec pod init
```

Tạo ra file `Podfile`. Qua lệnh trên bạn sẽ thấy để dùng `bundle` thực thi 1 thứ gì đó thì bạn cần có `exec` , sau đó là nhưng thứ gì bạn muốn thực hiện

- **Bước 4: edit Podfile**

Bạn mở file `Podfile` lên và thêm các thư viện mà bạn cần, như bao lần trước đây khi bạn làm với dự án.

- **Bước 5: install pod**

Tiếp tục sử dụng `bundler exce pod` để thực hiện các lệnh của `pod` thông qua `bundle` 

```ruby
bundle exce pod install
```

Lệnh này tương tự `pod install` nó sẽ tạo ra `Podfile.lock` và file `workspace` cho project của bạn.

#### Dùng đầu óc tưởng tượng thêm xí:

- CocoaPod là chỗ chứa các thư viện cho iOS: muốn sài thì phải:

  `init` --> edit *podfile* --> `pod install`

- Bundle thì là chỗ chứa các thứ trâu chó như là *cocoapod* và nó cũng làm tương tự như thế : 

  `init` --> edit gemfile --> `install` --> thêm 1 bữa nữa là muốn chạy gì thì gọi lệnh `exec` mà chạy

---

