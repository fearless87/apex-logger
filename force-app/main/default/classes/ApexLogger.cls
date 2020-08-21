/*
	功能描述：日志记录器类
	创建标识：hpc 2020-08
 */
public class ApexLogger {
  //日志严重类别
  public enum LogSeverity {
    DEBUG,INFO,WARN,ERROR
  }
  //自定义空白异常
  private static final Exception BLANK_EXCEPTION = null;
  //ApexLogger数据类
  private ApexLoggerData curApexLoggerData;
  //构造方法
  public ApexLogger() {
    this.curApexLoggerData = new ApexLoggerData();
  }

  //构造方法
  public ApexLogger(Boolean isBatch) {
	this.curApexLoggerData = new ApexLoggerData();
	this.curApexLoggerData.IsBatches=isBatch;
  }

  //批量保存
  public void flush() {
	this.curApexLoggerData.flush();
  }

  /* DEBUG */

  public void debug(String message) {
    this.debug(message, BLANK_EXCEPTION);
  }

  public void debug(Exception thrownException) {
    this.debug(null, thrownException);
  }

  public void debug(String messageFormat, Object[] arguments) {
    this.debug(messageFormat, arguments, BLANK_EXCEPTION);
  }

  public void debug(String messageFormat,Object[] arguments,Exception thrownException) {
    this.debug(String.format(messageFormat, arguments), thrownException);
  }

  public void debug(String message, Exception thrownException) {
    this.log(ApexLogger.LogSeverity.DEBUG.name(), message, thrownException);
  }

  /* INFO */

  public void info(String message) {
    this.info(message, BLANK_EXCEPTION);
  }

  public void info(Exception thrownException) {
    this.info(null, thrownException);
  }

  public void info(String messageFormat, Object[] arguments) {
    this.info(messageFormat, arguments, BLANK_EXCEPTION);
  }

  public void info(String messageFormat,Object[] arguments,Exception thrownException) {
    this.info(String.format(messageFormat, arguments), thrownException);
  }

  public void info(String message, Exception thrownException) {
    this.log(ApexLogger.LogSeverity.INFO.name(), message, thrownException);
  }

  /* WARN */

  public void warn(String message) {
    this.warn(message, BLANK_EXCEPTION);
  }

  public void warn(Exception thrownException) {
    this.warn(null, thrownException);
  }

  public void warn(String messageFormat, Object[] arguments) {
    this.warn(messageFormat, arguments, BLANK_EXCEPTION);
  }

  public void warn(String messageFormat,Object[] arguments,Exception thrownException) {
    this.warn(String.format(messageFormat, arguments), thrownException);
  }

  public void warn(String message, Exception thrownException) {
    this.log(ApexLogger.LogSeverity.WARN.name(), message, thrownException);
  }

  /* ERROR */

  public void error(String message) {
    this.error(message, BLANK_EXCEPTION);
  }

  public void error(Exception thrownException) {
    this.error(null, thrownException);
  }

  public void error(String messageFormat, Object[] arguments) {
    this.error(messageFormat, arguments, BLANK_EXCEPTION);
  }

  public void error(String messageFormat,Object[] arguments,Exception thrownException) {
    this.error(String.format(messageFormat, arguments), thrownException);
  }

  public void error(String message, Exception thrownException) {
    this.log(ApexLogger.LogSeverity.ERROR.name(), message, thrownException);
  }

  /* LIMITS */

  public void limits() {
    this.limits('');
  }

  public void limits(String messageFormat, Object[] arguments) {
    this.limits(String.format(messageFormat, arguments));
  }

  public void limits(String message) {
    if (String.isBlank(message)) {
      message = buildLimitsMessage();
    } else {
      message += '\n\n' + buildLimitsMessage();
    }
    this.log('LIMITS', message);
  }

  /* LOG */

  public void log(String severity, String message) {
    this.log(severity, message, BLANK_EXCEPTION);
  }

  public void log(String severity, Exception thrownException) {
    this.log(severity, null, thrownException);
  }

  public void log(String severity, String message, Exception thrownException) {
    ApexLoggerUtil.Caller caller = new ApexLoggerUtil.Reflector().getCaller();
    String className = caller.className;
    String methodName = caller.methodName;
    this.log(severity, className, methodName, message, thrownException);
  }

  public void log(String severity, String formatMessage, Object[] arguments) {
    this.log(severity, formatMessage, arguments, BLANK_EXCEPTION);
  }

  public void log(String severity,String formatMessage,Object[] arguments,Exception thrownException) {
    this.log(
      severity,
      String.format(formatMessage, arguments),
      thrownException
    );
  }

  public void log(String severity,String className,String methodName,Exception thrownException) {
    this.log(severity, className, methodName, null, thrownException);
  }

  public void log(String severity,String className,String methodName,String message) {
    this.log(severity, className, methodName, message, BLANK_EXCEPTION);
  }

  public void log(String severity,String className,String methodName,String formatMessage,Object[] arguments) {
    this.log(
      severity,
      className,
      methodName,
      formatMessage,
      arguments,
      BLANK_EXCEPTION
    );
  }

  public void log(String severity,String className,String methodName,String formatMessage,Object[] arguments,Exception thrownException) {
    this.log(
      severity,
      className,
      methodName,
      String.format(formatMessage, arguments),
      thrownException
    );
  }

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
    this.curApexLoggerData.Savelog(
      severity,
      className,
      methodName,
      message,
      thrownException
    );
  }

  //构建限制信息
  private String buildLimitsMessage() {
    return String.format(
      'Current context limits usage:\n' +
      'CPU Time: {0} / {1} ms\nDB Time: {2} / {3} ms\nHeap: {4} / {5} bytes\n' +
      'DML queries: {6} / {7}\nDML rows: {8} / {9}\n' +
      'SOQL queries: {10} / {11}\nSOSL queries: {12} / {13}',
      new List<Object>{
        Limits.getCpuTime(),
        Limits.getLimitCpuTime(),
        Limits.getDatabaseTime(),
        Limits.getLimitDatabaseTime(),
        Limits.getHeapSize(),
        Limits.getLimitHeapSize(),
        Limits.getDmlStatements(),
        Limits.getLimitDmlStatements(),
        Limits.getDmlRows(),
        Limits.getLimitDmlRows(),
        Limits.getQueries(),
        Limits.getLimitQueries(),
        Limits.getSoslQueries(),
        Limits.getLimitSoslQueries()
      }
    );
  }
}
