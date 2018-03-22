/**
* @author Matt Kaufman
* @name Util
* @description Helper methods to convert XML Strings to/from Maps
**/
public class Util {

	public static void saveLog(
		String method,
		String endpoint,
		Map<String,String> headers,
		String requestBody,
		String responseBody
	){
		Log__c l = new Log__c();
		l.Headers__c = JSON.serializePretty(headers);
		l.Request_Body__c = requestBody;
		l.Response_Body__c = responseBody;
		l.Method__c = method;
		l.Endpoint__c = endpoint;
		insert l;
	}

}