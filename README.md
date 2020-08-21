# apex-logger
包括各级别日志记录、系统&amp;DB输出开关、UI友好异常提示、特定Class日志记录等

## 目录
- [`类`](#is-class)
- [`数据结构`](#is-data)
- [`示例`](#is-example)

## 1、类
<a name="is-class"></a>
| 类名 | 描述 |
|-------------------|-------------|
| `ApexLoggerUtil` 		| ApexLogger工具类|
| `ApexLoggerData` 		| ApexLogger数据类|
| `ApexLogger` 		    | 日志记录器类|
| `ApexLoggerExceptionHandler` 		| ApexLogger异常处理类|
### （1）ApexLoggerUtil
<details>
<summary>内部类</summary>

    * Caller 调用者实体类
    ~~~ C#
    public class Caller {
        public String className { get; set; }
        public String methodName { get; set; }
    ~~~
    * Reflector 反射类（获取调用者）
    ~~~ C#
    String stacktrace = new NullPointerException().getStackTraceString();
    Matcher matcher = callerPattern.matcher(stacktrace);

    Caller caller = new Caller();
    //获取第一级的调用者
    while (matcher.find()) {
    List<String> haystack = matcher.group(1).split('\\.');
    caller.methodName = haystack.remove(haystack.size() - 1);
    caller.className = String.join(haystack, '.');
    }
    ~~~

</details>
### （2）ApexLoggerData
<details>
<summary>字段</summary>

~~~ C#
//自定义空白异常
private static final Exception BLANK_EXCEPTION = null;
~~~

</details>
<details>
<summary>属性</summary>

~~~ C#
//通过System.debug输出
public Boolean OutputSystemDebugLogs{get;set;}
//记录到Database
public Boolean OutputDatabaseLogs{get;set;}
//仅记录指定Class的Logs
public Boolean OutputOnlySpecifyClassLogs{get;set;}
//界面显示异常
public Boolean UIShowException{get;set;}
//界面输出详细Exceptions
public Boolean UIDisplayDetailExceptions{get;set;}
//界面输出友好Exceptions
public Boolean UIDisplayFriendlyExceptions{get;set;}
//指定Class
public String SpecifyClasses{get;set;}
//是否分批处理
public Boolean IsBatches{get;set;}
//ApexLog待处理集合
public List<Apex_Log__c> ApexBatches{get;set;}
~~~

</details>
<details>
<summary>方法</summary>

~~~ C#
//构造方法
public ApexLoggerData() {
    IsBatches=false;
    ApexBatches=new List<Apex_Log__c>();
    initApexLogSetting();
}
//初始化
private void initApexLogSetting(){
//获取配置信息
private List<Apex_Log_Setting__mdt> getConfiguration() {
//保存Log
public void Savelog(String severity, String className, String methodName, String message, Exception thrownException) {
//获取日志消息
private String getLogMessage(String message, Exception thrownException) {
//获取异常消息
private String getExceptionMessage(Exception thrownException) {
//通过System.debug输出
private void systemDebug(String message,String exceptionMessage,String severity){
//获取System.debug输出的LoggingLevel
private LoggingLevel severityToLoggingLevel(String severity) {
//记录到Database
private void saveToDatabase(Apex_Log__c log){
//是否记录当前Class到Database
private Boolean isRecordCurClass(String className){
//批量保存并刷新
public void flush() {
//获取友好的异常【给到View】
public String getFriendlyExceptionMessage(String exceptionType){
~~~

</details>
### （3）ApexLogger
* 枚举
~~~ C#
 //日志严重类别
public enum LogSeverity {
    DEBUG,INFO,WARN,ERROR
}
~~~
* 字段
~~~ C#
//自定义空白异常
private static final Exception BLANK_EXCEPTION = null;
//ApexLogger数据类
private ApexLoggerData curApexLoggerData;
~~~
* 构造器
~~~ C#
//构造方法
public ApexLogger() {
//构造方法
public ApexLogger(Boolean isBatch) {
~~~
* log 创建日志的重载
~~~ C#
/// <summary>
/// 创建日志
/// </summary>
/// <param name="severity">严重级别</param>
/// <param name="className">类名</param>
/// <param name="methodName">方法名</param>
/// <param name="message">自定义消息</param>
/// <param name="thrownException">异常</param>
/// <returns></returns>
public void log(String severity,String className,String methodName,String message,Exception thrownException) {
public void log(String severity,String className,String methodName,String formatMessage,Object[] arguments,Exception thrownException) {
public void log(String severity,String className,String methodName,String formatMessage,Object[] arguments) {
public void log(String severity,String className,String methodName,String message) {
public void log(String severity,String className,String methodName,Exception thrownException) {
public void log(String severity,String formatMessage,Object[] arguments,Exception thrownException) {
public void log(String severity, String formatMessage, Object[] arguments) {
public void log(String severity, String message, Exception thrownException) {
public void log(String severity, Exception thrownException) {
public void log(String severity, String message) {
~~~
* DEBUG严重级的重载
~~~ C#
public void debug(String message) {
public void debug(Exception thrownException) {
public void debug(String messageFormat, Object[] arguments) {
public void debug(String messageFormat,Object[] arguments,Exception thrownException) {
public void debug(String message, Exception thrownException) {
~~~
* INFO严重级的重载
~~~ C#
public void info(String message) {
public void info(Exception thrownException) {
public void info(String messageFormat, Object[] arguments) {
public void info(String messageFormat,Object[] arguments,Exception thrownException) {
public void info(String message, Exception thrownException) {
~~~
* WARN严重级的重载
~~~ C#
public void warn(String message) {
public void warn(Exception thrownException) {
public void warn(String messageFormat, Object[] arguments) {
public void warn(String messageFormat,Object[] arguments,Exception thrownException) {
public void warn(String message, Exception thrownException) {
~~~
* ERROR严重级的重载
~~~ C#
public void error(String message) {
public void error(Exception thrownException) {
public void error(String messageFormat, Object[] arguments) {
public void error(String messageFormat,Object[] arguments,Exception thrownException) {
public void error(String message, Exception thrownException) {
~~~
* 记录LIMITS
~~~ C#
public void limits() {
public void limits(String messageFormat, Object[] arguments) {
public void limits(String message) {
~~~
* 其它
~~~ C#
//批量保存
public void flush() {
~~~
### （4）ApexLoggerExceptionHandler
TODO


## 2、数据结构
<a name="is-data"></a>
Custom Metadata做开关及特定Class的配置,Custom Object记录日志
### （1）整体结构如下
![](https://github.com/fearless87/apex-logger/blob/master/image/db-log.png)

### （2）开关
Enabled__c=true则为开启，若Output_Only_Specify_Class_Logs为开启则对仅其SpecifyClasses__c指定的Class的日志记录到DB
![](https://github.com/fearless87/apex-logger/blob/master/image/log-setting.png)


## 3、示例
<a name="is-example"></a>
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

