@RestResource(urlMapping='/Contacts/*')
global with sharing class ContactManager {

    @HttpPost
    global static Id createContact(String firstName, String lastName, String email, String phone) {
        List<Contact> ctct = [SELECT Id FROM Contact WHERE Email = :email];
        // S'il un contact est retrouvé => renvoit directement l'Id
        if(ctct.size() != 0) {
            return ctct[0].Id;
        } else {
            Contact newCtct = new Contact(
                FirstName = firstName,
                LastName = lastName,
                Email = email,
                Phone = phone
            );
            insert newCtct;
            return newCtct.Id;
        }
    }

    @HttpPatch
    global static Id updateContact() {
        RestRequest req = RestContext.request;
        String ctctId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        Contact ctct = [SELECT Id FROM Contact WHERE ID = :ctctId];
        // On crée une map<fieldName : value>
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());
        for (String field : data.keySet()) {
            ctct.put(field, data.get(field));
        }
        update ctct;
        return ctct.Id;
    }

    @HttpDelete
    global static Id deleteContact() {
        RestRequest req = RestContext.request;
        String ctctId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        Contact ctct = [SELECT Id FROM Contact WHERE ID = :ctctId];
        ctct.isActive__c = false;
        update ctct;
        return (Id)ctctId;
    }

}