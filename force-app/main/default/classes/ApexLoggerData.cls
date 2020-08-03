/*
    功能描述：ApexLogger数据类
    创建标识：hpc 2020-08
*/
public class ApexLoggerData {
    //自定义空白异常
    private static final ApexLoggerUtil.BlankException BLANK_EXCEPTION = new ApexLoggerUtil.BlankException();

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

    //构造方法
    public ApexLoggerData() {
        IsBatches=false;
        ApexBatches=new List<Apex_Log__c>();
        initApexLogSetting();
    }

    //初始化
    private void initApexLogSetting(){
        OutputSystemDebugLogs=false;
        OutputDatabaseLogs=false;
        OutputOnlySpecifyClassLogs=false;
        UIShowException=false;
        UIDisplayDetailExceptions=false;
        UIDisplayFriendlyExceptions=false;
        SpecifyClasses='';
        List<Apex_Log_Setting__mdt> settings =getConfiguration();
        for (Apex_Log_Setting__mdt setting : settings) {
			switch on setting.DeveloperName {
				when 'Output_System_Debug_Logs' {
					OutputSystemDebugLogs = setting.Enabled__c;
                }
                when 'Output_Database_Logs' {
					OutputDatabaseLogs = setting.Enabled__c;
                }
                when 'Output_Only_Specify_Class_Logs' {
                    OutputOnlySpecifyClassLogs = setting.Enabled__c;
                    SpecifyClasses= setting.SpecifyClasses__c;
                }
                when 'UI_Show_Exception' {
					UIShowException = setting.Enabled__c;
                }
                when 'UI_Display_Detail_Exceptions' {
					UIDisplayDetailExceptions = setting.Enabled__c;
                }
                when 'UI_Display_Friendly_Exceptions' {
					UIDisplayFriendlyExceptions = setting.Enabled__c;
				}
			}
		}
    }

    //获取配置信息
    private List<Apex_Log_Setting__mdt> getConfiguration() {
		List<Apex_Log_Setting__mdt> settings = [SELECT DeveloperName, Enabled__c,SpecifyClasses__c FROM Apex_Log_Setting__mdt];
		return settings;
    }
    
    //保存Log
    public void Savelog(String severity, String className, String methodName, String message, Exception thrownException) {
        String exceptionMessage=buildExceptionMessage(thrownException);
		Apex_Log__c log = new Apex_Log__c(
			Severity__c = severity,
			Class__c = className,
			Method__c = methodName,
			Message__c = buildLogMessage(message, thrownException),
			Exception__c = exceptionMessage,
            WithException__c = (thrownException == BLANK_EXCEPTION) ? false : true,
            ExceptionType__c=thrownException.getTypeName()
        );
        systemDebug(message,exceptionMessage,log.Severity__c);
        saveToDatabase(log);
    }

    //通过System.debug输出
    private void systemDebug(String message,String exceptionMessage,String severity){
		if (this.OutputSystemDebugLogs) {
            System.debug(severityToLoggingLevel(severity), (String.isEmpty(message)?'':message+'\n')+exceptionMessage);
        }
    }
    //记录到Database
    private void saveToDatabase(Apex_Log__c log){
        //记录到Database
        if(this.OutputDatabaseLogs){
            //是否记录当前Class
            if(isRecordCurClass(log.Class__c)){
                //批次处理
                if(this.IsBatches){
                    this.ApexBatches.add(log);
                }
                else{
                    INSERT log;
                }
            }
        }
    }

    //是否记录当前Class
    private Boolean isRecordCurClass(String className){
        Boolean result=true;
        if(this.OutputOnlySpecifyClassLogs){
            result=false;
            if(String.isNotEmpty(this.SpecifyClasses)){
                List<String> parts =this.SpecifyClasses.split(',');
                if(parts.contains(className)){
                    result=true;
                }
            }
        }
        return result;
    }

    //批量保存并刷新
    public void flush() {
		if (!this.ApexBatches.isEmpty()) {
			insert this.ApexBatches;
			this.ApexBatches.clear();
		}
	}
    
    //构建错误消息
    private String buildLogMessage(String message, Exception thrownException) {
		if (String.isBlank(message)) {
			message = 'Exception thrown: ' + thrownException.getTypeName();
		}
		return message;
	}
    
    //获取LoggingLevel
    private LoggingLevel severityToLoggingLevel(String severity) {
		switch on severity {
			when 'DEBUG' { return LoggingLevel.DEBUG; }
			when 'INFO' { return LoggingLevel.INFO; }
			when 'WARN' { return LoggingLevel.WARN; }
			when 'ERROR' { return LoggingLevel.ERROR; }
			when else { return LoggingLevel.DEBUG; }
		}
    }
    
    //构建异常消息
	private String buildExceptionMessage(Exception thrownException) {
		String message = '';
		while (thrownException != BLANK_EXCEPTION && thrownException != null) {
			message += thrownException.getTypeName() + ': ' + thrownException.getMessage() + '\n';
			message += thrownException.getStackTraceString() + '\n\n';
			thrownException = thrownException.getCause();
		}
		return message;
    }
    
    //获取友好的异常
    public String getFriendlyExceptionMessage(String exceptionType){
        String message='';
        for(Schema.PicklistEntry pickItem: Apex_Log__c.ExceptionType__c.getDescribe().getPicklistValues()){
            if(exceptionType==pickItem.getValue()){
                message= pickItem.getLabel();
                break;
            }
        }
        return message;
    }
}
