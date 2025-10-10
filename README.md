# convenient_dev_toolkit

[![pub package](https://img.shields.io/pub/v/convenient_dev_toolkit)](https://pub.dev/packages/convenient_dev_toolkit)

便捷开发工具包

## 使用方法

### 安装依赖

```yaml
dependencies:
  flutter:
    sdk: flutter
  # 添加依赖
  convenient_dev_toolkit: ^{latest version}
```

#### 货币格式化

```dart
'12345678'.toCurrencyFormatter() // 12,345,678
```

#### 有界数字输入框

限制0到100区间范围内输入

使用方法

```dart
TextField(
  inputFormatters: [
    BoundedNumberFormatter(min: 0, max: 100),
  ],
  controller: controller,
  decoration: const InputDecoration(hintText: '0-100'),
 ),
```
