/*
    功能描述：ApexLogger工具类
    创建标识：hpc 2020-08
*/
public class ApexLoggerUtil {
  public ApexLoggerUtil() {
  }

  //反射类（获取调用者）
  public class Reflector {
    private final Caller anonymousCaller = new Caller(
      'AnonymousApex',
      'AnonymousApex'
    );
    private final Pattern callerPattern = Pattern.compile('\\.(.+):');
    private final List<String> ignoredClasses; //忽略的类

    public Reflector() {
      // this.ignoredClasses = new List<String>{'ApexLoggerUtil','ApexLogger','ApexLoggerExceptionHandler'};
    }

    //获取调用者
    public Caller getCaller() {
      String stacktrace = new NullPointerException().getStackTraceString();
      Matcher matcher = callerPattern.matcher(stacktrace);

	  Caller caller = new Caller();
	  //获取第一级的调用者
      while (matcher.find()) {
        List<String> haystack = matcher.group(1).split('\\.');
        caller.methodName = haystack.remove(haystack.size() - 1);
        caller.className = String.join(haystack, '.');
      }

      if (String.isNotEmpty(caller.className))
        return caller;
      else {// 如匿名窗口执行
        return anonymousCaller;
      }
    }
  }

  //调用类
  public class Caller {
    public String className { get; set; }
    public String methodName { get; set; }
    public Caller() {
    }
    public Caller(String className, String methodName) {
      this.className = className;
      this.methodName = methodName;
    }
  }
}
