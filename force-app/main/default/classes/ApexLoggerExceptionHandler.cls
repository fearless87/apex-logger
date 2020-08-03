/*
    功能描述：异常处理类
    创建标识：hpc 2020-08
*/
public virtual class ApexLoggerExceptionHandler {
  private static final String LINE_BREAK = '\r\n';
  private Exception curException;
  private String customMessage;
  private ApexPages.Severity curSeverity;
  //ApexLogger数据类
  private ApexLoggerData curApexLoggerData;
  public ApexLoggerExceptionHandler(Exception ex) {
    this(ex, '', ApexPages.Severity.ERROR);
  }

  public ApexLoggerExceptionHandler(Exception ex, String message) {
    this(ex, message, ApexPages.Severity.ERROR);
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
    this.curApexLoggerData = new ApexLoggerData();
    this.curSeverity = severity;

    //记录异常
    new ApexLogger().error(this.customMessage, ex);
    //界面显示异常
    if (curApexLoggerData.UIShowException) {
      uishow();
    }
  }

  //获取UI异常消息(优先级为：自定义的>友好Exceptions>详细Exceptions>简单的消息)
  public String getUIExceptionMessage() {
    String message = simpleMessage();
    if (String.isNotEmpty(this.customMessage)) {
      message = this.customMessage;
    } else if (curApexLoggerData.UIDisplayFriendlyExceptions)
      message = curApexLoggerData.getFriendlyExceptionMessage(
        curException.getTypeName()
      );
    else if (curApexLoggerData.UIDisplayDetailExceptions) {
      message = complexMessage(this.curException);
    }
    return message;
  }

  //简单的异常消息
  private String simpleMessage() {
    return this.curException.getMessage();
  }

  //含明细的异常消息
  @TestVisible
  private String complexMessage(Exception ex) {
    String out =
      ex.getTypeName() +
      LINE_BREAK +
      ex.getMessage() +
      LINE_BREAK +
      ex.getStackTraceString();
    if (ex.getCause() != null) {
      out = +LINE_BREAK + 'Caused by: ' + complexMessage(ex.getCause());
    }

    return out;
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
}
