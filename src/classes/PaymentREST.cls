/**
* @author Matt Kaufman
* @name PaymentREST
* @description Webservice class to receive incoming data.
*/
@RestResource(urlMapping='/PaymentREST/*')
global class PaymentREST {
	global static final String ENDPOINT = 'https://playbyplay-developer-edition.na78.force.com/services/apexrest/PaymentREST/';

	/**
	* @name getMethod
	* @description Handles the GET operation
	**/
	@HttpGet
	global static PaymentResource getMethod(){
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;

		PaymentResource payment = new PaymentResource();
		for ( Payment__c p : [
			SELECT Customer__c, Deposit_To__c, External_Id__c, Total__c, Date__c, Private_Note__c
			FROM Payment__c
			LIMIT 1
		]){
			payment.fromSobject(p);
		}

		util.saveLog( 'GET', ENDPOINT, req.headers, null, JSON.serializePretty(payment,true) );

		return payment;
	}


	/**
	* @name postMethod
	* @description Handles the POST operation
	* @param {PaymentResource} payment
	* @return String
	**/
	@HttpPost
	global static String postMethod(PaymentResource payment){
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;

		Payment__c record = payment.toSobject();
		database.upsert( record, Payment__c.External_Id__c );

		util.saveLog('POST',ENDPOINT,req.headers,JSON.serializePretty(payment,true),JSON.serializePretty(payment,true));

		return JSON.serialize(payment);
	}
}