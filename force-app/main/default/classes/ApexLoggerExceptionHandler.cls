/*
    功能描述：ApexLogger异常处理类
    创建标识：hpc 2020-08
*/
public virtual class ApexLoggerExceptionHandler {
  //自定义空白异常
  private static final ApexLoggerUtil.BlankException BLANK_EXCEPTION = new ApexLoggerUtil.BlankException();
  private static final String LINE_BREAK = '\r\n';
  private Exception curException;
  private String customMessage;
  private ApexPages.Severity curSeverity;//https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_pages_message.htm
  //ApexLogger数据类
  private ApexLoggerData curApexLoggerData;
  private static final ApexPages.Severity defaultSeverity=ApexPages.Severity.ERROR;

  public ApexLoggerExceptionHandler(String message) {
    this(message,defaultSeverity);
  }
  public ApexLoggerExceptionHandler(String message,ApexPages.Severity severity) {
    this(BLANK_EXCEPTION, message, severity);
  }
  public ApexLoggerExceptionHandler(Exception ex) {
    this(ex, defaultSeverity);
  }
  public ApexLoggerExceptionHandler(Exception ex,ApexPages.Severity severity) {
    this(ex, '', severity);
  }
  public ApexLoggerExceptionHandler(Exception ex, String message) {
    this(ex, message, defaultSeverity);
  }

  /// <summary>
  /// 构造方法
  /// </summary>
  /// <param name="ex">异常</param>
  /// <param name="message">自定义消息</param>
  /// <param name="severity">严重性</param>
  /// <returns></returns>
  public ApexLoggerExceptionHandler(
    Exception ex,
    String message,
    ApexPages.Severity severity
  ) {
    this.customMessage = message;
    this.curException = ex;
    this.curSeverity = severity;
    this.curApexLoggerData = new ApexLoggerData();

    //保存异常到日志
    saveExceptionLog(message,ex);
    //界面显示异常
    showExceptionUI();
  }

  //保存异常到日志
  public virtual void saveExceptionLog(String message,Exception ex){
    new ApexLogger().error(message, ex);
  }

  //界面显示异常
  public virtual void showExceptionUI(){
    if (curApexLoggerData.UIShowException) {
      uishow();
    }
  }

  //获取简单的异常消息
  public virtual String getSimpleMessage(Exception ex) {
    return ex.getMessage();
  }

  //获取含明细的异常消息
  public String getComplexMessage(Exception ex) {
    String out =
      ex.getTypeName() +
      LINE_BREAK +
      ex.getMessage() +
      LINE_BREAK +
      ex.getStackTraceString();
    if (ex.getCause() != null) {
      out = +LINE_BREAK + 'Caused by: ' + getComplexMessage(ex.getCause());
    }

    return out;
  }

  //获取友好的异常消息
  public virtual String getFriendlyMessage(String exceptionType) {
    return this.curApexLoggerData.getFriendlyExceptionMessage(
      exceptionType
    );
  }

  //显示异常
  private void uishow() {
    Pagereference curPage = ApexPages.currentPage();
    if (curPage != null) {
      ApexPages.addMessage(
        new ApexPages.Message(this.curSeverity, getUIExceptionMessage())
      );
    }
  }

  //获取UI异常消息(优先级为：自定义的>友好Exceptions>详细Exceptions>简单的消息)
  public virtual String getUIExceptionMessage() {
    String message = getSimpleMessage(this.curException);
    if (String.isNotEmpty(this.customMessage)) {
      message = this.customMessage;
    } 
    else if (curApexLoggerData.UIDisplayFriendlyExceptions){
      message = getFriendlyMessage(this.curException.getTypeName());
    }
    else if (curApexLoggerData.UIDisplayDetailExceptions) {
      message = getComplexMessage(this.curException);
    }
    return message;
  }
}
