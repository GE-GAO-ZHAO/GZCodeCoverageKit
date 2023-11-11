# GZCodeCoverageKit 使用手册

## 第一步：podfile引入GZCodeCoverageKit库

```ruby
source 'https://github.com/CocoaPods/Specs.git'

target 'XXX' do
  pod 'GZCodeCoverageKit' #不需要指定版本，越新越稳定
end

```
## 第二步：podfile添加覆盖率配置

```ruby
post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        if config.name == 'Debug'
           # 覆盖率配置
           config.build_settings['OTHER_CFLAGS'] = '$(inherited) -fprofile-instr-generate -fcoverage-mapping'
           config.build_settings['OTHER_SWIFT_FLAGS'] = '$(inherited) -profile-generate -profile-coverage-mapping'
           config.build_settings['OTHER_LDFLAGS'] = '$(inherited) -fprofile-instr-generate'
           # End of 覆盖率配置
        end
      end
    end
  end
end

# 修改主工程
project = Xcodeproj::Project.open('XXX.xcodeproj')
puts project
project.targets.each do |target|
  if target.name == 'XXX'
    target.build_configurations.each do |config|
      if config.name == 'Debug'
        # 覆盖率配置
        config.build_settings['OTHER_CFLAGS'] = '$(inherited) -fprofile-instr-generate -fcoverage-mapping'
        config.build_settings['OTHER_SWIFT_FLAGS'] = '$(inherited) -profile-generate -profile-coverage-mapping'
        config.build_settings['OTHER_LDFLAGS'] = '$(inherited) -fprofile-instr-generate'
        # End of 覆盖率配置
      end
    end
  end
end
project.save()
```

## 第三步：引入
```
  GZCodeCoverageManager.shared().registerCoverage("demo")
```

## 第四步：操作app
- 运行APP
- 退到后台
- 去xcode -> windows -> devices and simulators 下载app沙盒信息，捞取.profraw文件
## 处理.profraw文件
步骤1: xcrun llvm-profdata merge -sparse [.profraw文件名字].profraw -o [产物名字].profdata
步骤2:把app的二进制文件拷贝到.profraw一个目录下
步骤3: xcrun llvm-cov show [二进制文件的路径] --instr-profile=[步骤1产生的文件名字].profdata  --format=html -use-color --output-dir ./coverage_report

## demo效果如下
![Xnip2023-11-11_21-46-04](https://github.com/GE-GAO-ZHAO/GZCodeCoverageKit/assets/66877871/3eee25e5-d8aa-4031-b3e4-04126022e85c)


