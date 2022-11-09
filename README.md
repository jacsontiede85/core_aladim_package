## Add pubspec.yaml

```yaml
    dependencies:
      flutter:
          sdk: flutter
        cupertino_icons: ^1.0.5
      core_aladim_package:
          git:
            url: https://github.com/jacsontiede85/tisa_api_package.git
```

## import e usage
```dart
    import 'package:tisa_api/tisa_api.dart';
    
    class MyClass{
      myFunction() async{
        String sql = "select sysdate from dual";
        var response = await ApiPackage().jwt(urlServer: 'http://localhost:8080/api/', sql: sql);
        //...
      }
    }
```
