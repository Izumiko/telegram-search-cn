# Nim实现的Telegram中文搜索方案

## 原理

用[**telegram-export**](https://github.com/expectocode/telegram-export)导出数据库，通过本程序查询并在网页上呈现

## 使用方法

1. 安装并设置telegram-export （详见该项目的[说明](https://github.com/expectocode/telegram-export/blob/master/README.rst)）

   Linux:
   > python3 -m venv tgexport  
   > source tgexport/bin/activate  
   > pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple -U telegram_export cryptg PySocks  

   Windows:
   > py -3 -m venv tgexport  
   > tgexport\Scripts\activate.bat  
   > pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple -U telegram_export cryptg PySocks  
   
   配置文件：
   > 下载[config.ini.example](https://github.com/expectocode/telegram-export/raw/master/config.ini.example) ，去掉example后缀后放在想存放数据的文件夹  
   >
   > 修改config.ini里面的ApiId, ApiHash, PhoneNumber, OutputDirectory，其他根据需要修改

2. 筛选会话

   Linux:
   > 运行`tgexport/bin/telegram-export --config-file FILE --list-dialogs` 获取会话ID，根据需要填入config.ini的白名单中
   
   Windows:
   > 运行`python tgexport\Scripts\telegram-export --config-file FILE --list-dialogs` 获取会话ID，根据需要填入config.ini的白名单中
   
   上面FILE为config.ini的完整路径
   
3.  导出数据

    > 去掉前一步命令后面的`--list-dialogs`，再次执行来导出数据库。（如果聊天记录很多，此过程耗时较长）
    > 以后更新聊天记录时只需要再次执行命令，脚本就会下载更新的记录，速度比较快。

4.  搜索聊天记录

    > 下载[搜索主程序](https://github.com/Izumiko/telegram-search-cn/releases/latest)  
    > 把主程序search(Windows平台还有sqlite的dll)放在数据库文件（export.db）所在目录
    >
    > 运行`./search` 
    >
    > 打开浏览器，访问`http://127.0.0.1:8090` 进行搜索

## 开发

本程序依赖jester框架，Windows下编译还需mingw64。编译步骤：

```bash
nimble install jester
nim c search.nim
```

## 感谢

本项目参考[cxumol/tg-search](https://github.com/cxumol/tg-search/tree/master)完成。
