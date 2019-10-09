# Nim实现的Telegram中文搜索方案

## 原理

用[**telegram-export**](https://github.com/expectocode/telegram-export)导出数据库，通过本程序查询并在网页上呈现

## 使用方法

1. 安装并设置telegram-export （详见该项目的[说明](https://github.com/expectocode/telegram-export/blob/master/README.rst)）

   > sudo pip3 install --upgrade telegram_export cryptg
   >
   > 下载[config.ini.example](https://github.com/expectocode/telegram-export/raw/master/config.ini.example) 放在 `~/.config/telegram-export/config.ini` 
   >
   > 修改config.ini里面的ApiId ApiHash 以及PhoneNumber，其他根据需要修改

2. 筛选会话

   > 运行`telegram-export --list-dialogs` 获取会话ID，根据需要填入config.ini的白名单中
   
3.  导出数据

   > 运行`telegram-export` 导出数据库

4.  搜索聊天记录

   > 把数据库文件（export.db）与主程序search放在同一目录
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