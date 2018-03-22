/**
* @author Matt Kaufman
* @name PaymentResource
* @description Represents a Payment object in an external system
**/
global class PaymentResource {

	/**
	* @description These attributes are defined by our external system
	**/
	webservice String CustomerRef;
	webservice String DepositToAccountRef;
	webservice String Id;
	webservice Decimal TotalAmt;
	webservice Date TxnDate;
	webservice String PrivateNote;


	/**
	* @description Default Constructor
	**/
	global PaymentResource(){

	}


	/**
	* @name toSobject
	* @description This method transforms an external Payment to a Salesforce Payment record
	* @return Payment__c
	**/
	global Payment__c toSObject(){
		Payment__c p = new Payment__c();
		p.Customer__c = CustomerRef;
		p.Deposit_To__c = DepositToAccountRef;
		p.External_Id__c = Id;
		p.Private_Note__c = PrivateNote;
		p.Total__c = TotalAmt;
		p.Date__c = TxnDate;
		return p;
	}

	/**
	* @name toSobject
	* @description This method transforms an external Payment to a Salesforce Payment record
	* @return Payment__c
	**/
	global PaymentResource fromSObject(Payment__c record){
		CustomerRef = record.Customer__c;
		DepositToAccountRef = record.Deposit_To__c;
		Id = record.External_Id__c;
		PrivateNote = record.Private_Note__c;
		TotalAmt = record.Total__c;
		TxnDate = record.Date__c;
		return this;
	}

}