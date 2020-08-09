/*
	功能描述：日志记录器测试类
	创建标识：hpc 2020-08
 */
@IsTest
private class ApexLoggerTest {

	private static List<Apex_Log__c> getAllLogs() {
		return [
			SELECT Severity__c, Class__c, Method__c, Message__c, WithException__c, Exception__c,SystemModstamp
			FROM Apex_Log__c
            ORDER BY Id
		];
	}

	//测试debug
	@IsTest
	static void debugTest() {
		ApexLogger logger = new ApexLogger(true);

		String message='message';
		ApexLoggerUtil.BlankException thrownException=new ApexLoggerUtil.BlankException('');
		String messageFormat='field name:{0},error type:{1}';
		Object[] arguments=new Object[]{'Price__c','String'};

		Test.startTest();
		logger.debug(message);
		logger.debug(message, thrownException);
		logger.debug(messageFormat, arguments);
		logger.debug(messageFormat, arguments, thrownException);
		logger.debug(thrownException);
		logger.flush();
		
		Test.stopTest();

		List<Apex_Log__c> logs = getAllLogs();
		System.assertEquals(5, logs.size());
		// for(Integer i=0;i<5;i++) //SystemModstamp、LastMofiedDate直到秒
		// 	System.debug('test:'+logs[i].SystemModstamp+':'+logs[i].Message__c);
		System.assertEquals('Exception thrown: ApexLoggerUtil.BlankException', logs[4].Message__c);
	}

	//测试info
	@IsTest
	static void infoTest() {
		ApexLogger logger = new ApexLogger(true);

		String message='message';
		ApexLoggerUtil.BlankException thrownException=new ApexLoggerUtil.BlankException(message);
		String messageFormat='field name:{0},error type:{1}';
		Object[] arguments=new Object[]{'Price__c','String'};

		Test.startTest();
		logger.info(message, thrownException);
		logger.info(messageFormat, arguments);
		logger.info(messageFormat, arguments, thrownException);
		logger.info(thrownException);
		logger.info(message);
		logger.flush();
		Test.stopTest();

		List<Apex_Log__c> logs = getAllLogs();
		System.assertEquals(5, logs.size());
		System.assertEquals('message', logs[0].Message__c);
	}

	//测试warn
	@IsTest
	static void warnTest() {
		ApexLogger logger = new ApexLogger(true);

		String message='message';
		ApexLoggerUtil.BlankException thrownException=new ApexLoggerUtil.BlankException(message);
		String messageFormat='field name:{0},error type:{1}';
		Object[] arguments=new Object[]{'Price__c','String'};

		Test.startTest();
		logger.warn(message, thrownException);
		logger.warn(messageFormat, arguments);
		logger.warn(messageFormat, arguments, thrownException);
		logger.warn(thrownException);
		logger.warn(message);
		logger.flush();
		Test.stopTest();

		List<Apex_Log__c> logs = getAllLogs();
		System.assertEquals(5, logs.size());
		System.assertEquals('message', logs[0].Message__c);
	}

	//测试error
	@IsTest
	static void errorTest() {
		ApexLogger logger = new ApexLogger(true);

		String message='message';
		ApexLoggerUtil.BlankException thrownException=new ApexLoggerUtil.BlankException(message);
		String messageFormat='field name:{0},error type:{1}';
		Object[] arguments=new Object[]{'Price__c','String'};

		Test.startTest();
		logger.error(message, thrownException);
		logger.error(messageFormat, arguments);
		logger.error(messageFormat, arguments, thrownException);
		logger.error(thrownException);
		logger.error(message);
		logger.flush();
		Test.stopTest();

		List<Apex_Log__c> logs = getAllLogs();
		System.assertEquals(5, logs.size());
		System.assertEquals('message', logs[0].Message__c);
	}

	//测试limit
	@isTest
	static void limitTest(){
		ApexLogger logger = new ApexLogger();

		Test.startTest();
		logger.limits();
		logger.limits('Standard debug logs limits:');
		logger.limits('Message {0} {1}', new Object[] { 'with', 'arguments' });
        Test.stopTest();

		List<Apex_Log__c> logs = getAllLogs();
		System.assertEquals('LIMITS', logs[0].Severity__c);
        System.assertEquals('limitTest', logs[0].Method__c);
	}
	
	//测试log
	@IsTest
	static void logTest() {
		ApexLogger logger = new ApexLogger(true);

		String severity='DEBUG';
		String className='className';
		String methodName='methodName';
		String message='message';
		ApexLoggerUtil.BlankException thrownException=new ApexLoggerUtil.BlankException(message);
		String formatMessage='field name:{0},error type:{1}';
		Object[] arguments=new Object[]{'Price__c','String'};

		Test.startTest();
		logger.log(severity, className, methodName, formatMessage, arguments);
		logger.log(severity, className, methodName, formatMessage, arguments, thrownException);
		logger.log(severity, className, methodName, message);
		logger.log(severity, className, methodName, message, thrownException);
		logger.log(severity, className, methodName, thrownException);
		logger.log(severity, formatMessage, arguments);
		logger.log(severity, formatMessage, arguments, thrownException);
		logger.log(severity, message);
		logger.log(severity, message, thrownException);
		logger.log(severity, thrownException);
		logger.flush();
		Test.stopTest();

		List<Apex_Log__c> logs = getAllLogs();
		System.assertEquals(10, logs.size());
		System.assertEquals('field name:Price__c,error type:String', logs[0].Message__c);
	}

	//测试ApexLoggerExceptionHandler
	@isTest
	static void apexLoggerExceptionHandlerTest()
	{
		ApexLoggerUtil.BlankException thrownException=new ApexLoggerUtil.BlankException('message');
		
		Test.startTest();
		ApexLoggerExceptionHandler handlerObj=new ApexLoggerExceptionHandler(thrownException);
		handlerObj=new ApexLoggerExceptionHandler('message');
		handlerObj=new ApexLoggerExceptionHandler(thrownException,'message');
		handlerObj.getSimpleMessage(thrownException);
		handlerObj.getComplexMessage(thrownException);
		handlerObj.getFriendlyMessage(thrownException.getTypeName());
		handlerObj.getUIExceptionMessage();
		Test.stopTest();

		// List<Apex_Log__c> logs = getAllLogs();
		// System.assert(logs.size()>=1);
	}

}
