/**
* @author Matt Kaufman
* @name PaymentEmailService
* @description
**/
global class PaymentEmailService implements Messaging.InboundEmailHandler {

	global Messaging.InboundEmailResult handleInboundEmail(
		Messaging.InboundEmail email,
		Messaging.InboundEnvelope envelope
	){
		Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

		String plainTextBody = email.plainTextBody;

		PaymentResource payment = new PaymentResource();
		payment.CustomerRef = plainTextBody.subStringBetween('<CustomerRef>','</CustomerRef>');
		payment.Id = plainTextBody.subStringBetween('<Id>','</Id>');
		payment.PrivateNote = plainTextBody.subStringBetween('<PrivateNote>','</PrivateNote>');
		String totalString = plainTextBody.subStringBetween('<TotalAmt>','</TotalAmt>');
		if ( String.isNotBlank(totalString) ){
			payment.TotalAmt = Decimal.valueOf(totalString);
		}
		String dateString = plainTextBody.subStringBetween('<TxnDate>','</TxnDate>');
		if ( String.isNotBlank(dateString) ){
			payment.TxnDate = Date.valueOf(dateString);
		}
		payment.DepositToAccountRef = plainTextBody.subStringBetween('<DepositToAccountRef>','</DepositToAccountRef>');
		Payment__c record = payment.toSobject();
		database.upsert( record, Payment__c.External_Id__c );

		util.saveLog( 'EMAIL', 'PaymentEmailService', null, plainTextBody, null );

		return result;
	}

}