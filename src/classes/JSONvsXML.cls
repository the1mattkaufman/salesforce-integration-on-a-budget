/**
* @author Matt Kaufman
* @name JSONvsXML
* @description Demonstrates working with JSON and XML representations of objects
**/
public class JSONvsXML {

	public static PaymentResource getSample(){
		PaymentResource p = new PaymentResource();
		p.CustomerRef = 'Acme';
		p.DepositToAccountRef = 'Checking';
		return p;
	}

	/**
	*	@name demonstrateJSON
	*	@description Demonstrates using the built in JSON classes
	**/
	public static void demonstrateJSON(){
		PaymentResource p = getSample();
		system.debug( '/**** Initial PaymentResource ****/' );
		system.debug( p );

		//Create a one line JSON string of the PaymentResource including null values
		String jsonString = JSON.serialize(p);
		system.debug( '/**** Serialized JSON String ****/' );
		system.debug( jsonString );

		//Create a one line JSON string of the PaymentResource excluding null values
		String jsonStringWithoutNulls = JSON.serialize(p, true);
		system.debug( '/**** Serialized JSON String with Nulls removed ****/' );
		system.debug( jsonStringWithoutNulls );

		//Create an easy to read JSON string of the PaymentResource including null values
		String prettyJsonString = JSON.serializePretty(p);
		system.debug( '/**** Serialized Pretty JSON String ****/' );
		system.debug( prettyJsonString );

		//Create an easy to read JSON string of the PaymentResource including null values
		String prettyJsonStringWithoutNulls = JSON.serializePretty(p,true);
		system.debug( '/**** Serialized Pretty JSON String with Nulls removed ****/' );
		system.debug( prettyJsonStringWithoutNulls );

		//Create a PaymentResource from the JSON string
		PaymentResource reconstructedPayment = (PaymentResource)JSON.deserialize(
			jsonString, PaymentResource.class
		);
		system.debug( '/**** Reconstructed PaymentResource ****/' );
		system.debug( reconstructedPayment );

		//Create a Map from the JSON string
		Map<String,Object> attributeMap = (Map<String,Object>)JSON.deserializeUntyped(jsonString);
		system.debug( '/**** Map of PaymentResource ****/' );
		system.debug( attributeMap );
	}

	/**
	*	@name demonstrateXMLStreams
	*	@description Demonstrates using the built in XMLStream classes
	**/
	public static void demonstrateXMLStreams(){
		PaymentResource p = getSample();
		system.debug( '/**** Initial PaymentResource ****/' );
		system.debug( p );

		//Create a one line XML string of the PaymentResource
		XmlStreamWriter w = new XmlStreamWriter();
		w.writeStartDocument(null, '1.0');
		w.writeStartElement('', 'Payment', '');
		w.writeStartElement('', 'DepositToAccountRef', '');
		w.writeCharacters(p.CustomerRef);
		w.writeEndElement();
		w.writeStartElement('', 'DepositToAccountRef', '');
		w.writeCharacters(p.DepositToAccountRef);
		w.writeEndElement();
		w.writeEndElement();
		w.writeEndDocument();
		String xmlString = w.getXmlString();
		w.close();
		system.debug( '/**** XML String ****/' );
		system.debug( xmlString );

		//Recreate the PaymentResource from the XML string
		PaymentResource reconstrutedPayment = new PaymentResource();
		XmlStreamReader reader = new XmlStreamReader(xmlString);
    	Boolean isSafeToGetNextXmlElement = true;
        while( reader.hasNext() ) {
			if ( reader.getEventType() == XmlTag.START_ELEMENT ){
				if ( reader.getLocalName() == 'CustomerRef' ){
					reader.next();
					reconstrutedPayment.CustomerRef = reader.getText();
					reader.next();
				}
				else if ( reader.getLocalName() == 'DepositToAccountRef' ){
					reader.next();
					reconstrutedPayment.DepositToAccountRef = reader.getText();
					reader.next();
				}
			}
            if (!reader.hasNext()) {
				break;
            }
			reader.next();
        }
		system.debug( '/**** Reconstructed PaymentResource ****/' );
		system.debug( reconstrutedPayment );
	}

	/**
	*	@name demonstrateXMLStreams
	*	@description Demonstrates using the built in XML Document classes
	**/
	public static void demonstrateXMLDocument(){
		PaymentResource p = getSample();

		Dom.Document doc = new Dom.Document();
        String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
        String xsi = 'http://www.w3.org/2001/XMLSchema-instance';
        String serviceNS = 'http://www.myservice.com/services/MyService/';
		Dom.XmlNode envelope = doc.createRootElement('Envelope', soapNS, 'soapenv');
        envelope.setNamespace('xsi', xsi);
    	envelope.setAttributeNS('schemaLocation', soapNS, xsi, null);
        Dom.XmlNode body = envelope.addChildElement('Body', soapNS, null);
		body.addChildElement('CustomerRef', serviceNS, '').
			addTextNode(p.CustomerRef);
		body.addChildElement('DepositToAccountRef', serviceNS, '').
			addTextNode(p.DepositToAccountRef);
		String xmlString = doc.toXmlString();
		system.debug( '/**** XML String ****/' );
		system.debug( xmlString );

		//Recreate the PaymentResource from the XML string
		PaymentResource reconstrutedPayment = new PaymentResource();
		Dom.Document doc2 = new Dom.Document();
		doc2.load(xmlString);
        Dom.XMLNode root = doc2.getRootElement();
        reconstrutedPayment.CustomerRef = root.getChildElement('CustomerRef', null).getText();
        reconstrutedPayment.DepositToAccountRef = root.getChildElement('DepositToAccountRef', null).getText();
		system.debug( '/**** Reconstructed PaymentResource ****/' );
		system.debug( reconstrutedPayment );

	}

}