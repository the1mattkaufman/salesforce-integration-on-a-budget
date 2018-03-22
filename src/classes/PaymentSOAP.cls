/**
* @author Matt Kaufman
* @name PaymentSOAP
* @description
**/
global class PaymentSOAP {
	global static final String ENDPOINT = 'https://playbyplay-developer-edition.na78.force.com/services/Soap/class/PaymentSOAP';
	/**
	*	@name fixNull
	*	@description Changes null Strings to empty Strings
	*	@param String i
	**/
	webservice static PaymentResource postMethod(PaymentResource payment){

		Payment__c record = payment.toSobject();
		database.upsert( record, Payment__c.External_Id__c );

		Log__c l = new Log__c();
		//l.Headers__c = JSON.serializePretty(.headers);
        l.Request_Body__c = JSON.serializePretty(payment,true);
		l.Response_Body__c = JSON.serializePretty(payment,true);
        l.Method__c = 'POST';
        l.Endpoint__c = ENDPOINT;
        insert l;

		return payment;
	}

}