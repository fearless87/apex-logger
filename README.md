# apex-logger
包括各级别日志记录、系统&amp;DB输出开关、UI友好异常提示、特定Class日志记录等

## 1、使用
### （1）直接使用
以info为列，debug、warn、error使用方式相同
~~~ C#
ApexLogger logger = new ApexLogger(true);//isBatch=true代表批量处理，结合flush()一次性提交
logger.debug(message);
logger.info(message, thrownException);
logger.info(messageFormat, arguments);
logger.info(messageFormat, arguments, thrownException);
logger.info(thrownException);
logger.info(message);
logger.flush();
~~~
### （2）结合try...catch使用
~~~ C#
try{
    Integer x=10;
    Integer y=0;
    Integer z=x/y;
}catch(Exception ex){
    new ApexLoggerExceptionHandler(ex);
}
~~~
可根据配置输出到System.debug、Database及UI呈现
![](https://github.com/fearless87/apex-logger/blob/master/image/messages-error.png)

## 2、数据结构
Custom Metadata做开关及特定Class的配置,Custom Object记录日志
### （1）整体结构如下
![](https://github.com/fearless87/apex-logger/blob/master/image/db-log.png)

### （2）开关
Enabled__c=true则为开启，若Output_Only_Specify_Class_Logs为开启则对仅其SpecifyClasses__c指定的Class的日志记录到DB
![](https://github.com/fearless87/apex-logger/blob/master/image/log-setting.png)

## 3、注意事项
TODO

## 4、代码说明
TODO


