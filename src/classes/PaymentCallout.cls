/**
* @author Matt Kaufman
* @name PaymentCallout
* @description
**/
public class PaymentCallout {

	/**
    * @name callout
    * @param {String} method
    * @param {String} endpoint
    * @param {String} body
    * @param {Map<String,String>} headers
    * @return HttpResponse
    **/
    public static HttpResponse callout(
        String method,
        String endpoint,
        Map<String,String> headers,
        String body
    ){
        if ( headers == null ){
            headers = new Map<String,String>();
        }
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setEndpoint(endpoint);
        if ( String.isNotBlank(body) ){
            headers.put('Content-Length',body.length()+'');
            req.setBody(body);
        }
        for ( String h : headers.keySet() ){
            req.setHeader(h, headers.get(h) );
        }
        system.debug( method +' : '+endpoint+' : '+body);
        HttpResponse res = new Http().send(req);
        system.debug( res.toString() );
        system.debug( res.getBody() );

        util.saveLog(method, endpoint, headers, req.getBody(), res.getBody() );

        return res;
    }

    /**
    * @name getPaymentsViaREST
    * @description Calls out to REST Web Service and then upserts the response as a record
    **/
	public static void getPaymentsViaREST(){
		HttpResponse res = callout('GET', PaymentREST.ENDPOINT, null, null);
        PaymentResource payment = (PaymentResource)JSON.deserialize(res.getBody(),PaymentResource.class);
        Payment__c record = payment.toSobject();
        database.upsert( record, Payment__c.External_Id__c );
	}

}