@isTest
private class ContactManagerTest {
    
    @TestSetup
    static void makeData(){
        Contact ctc = new Contact(LastName = 'Test', Email = 'test@test.com');
        insert ctc;
    }

    @isTest
    static void createContactTest() {

        Test.startTest();
        ContactManager.createContact('testing', 'TEST', 'testing@my-test.com', '0698653271');
        Test.stopTest();

        Contact testCtct = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Email = 'testing@my-test.com' LIMIT 1];

        System.assertEquals('testing@my-test.com', testCtct.Email);
        System.assertEquals('testing', testCtct.FirstName);
    }

    @isTest
    static void createContactWithExistingEmailTest() {
        Contact testContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Email = 'test@test.com' LIMIT 1];

        Test.startTest();
        ContactManager.createContact('testing', 'TEST', 'test@test.com', '0698653271');
        Test.stopTest();

        List<Contact> ctctList = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Email = 'test@test.com'];

        System.assertEquals('test@test.com', ctctList[0].Email);
        System.assertEquals(1, ctctList.size());
    }

    @isTest
    static void updateContactTest() {
        Contact testContact = [SELECT Id FROM Contact WHERE Email = 'test@test.com' LIMIT 1];

        // Simule une requête PATCH pour la méthode d'update
        RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/services/apexrest/Contacts/' + testContact.Id;
        RestContext.request.httpMethod = 'PATCH';
        RestContext.request.requestBody = Blob.valueOf('{"FirstName": "Updated", "Email": "updatedTest@test.com"}');
        RestContext.response = new RestResponse();

        Test.startTest();
        ContactManager.updateContact();
        Test.stopTest();

        Contact updatedCtct = [SELECT Id, FirstName, Email FROM Contact WHERE Id = :testContact.Id];

        System.assertEquals('Updated', updatedCtct.FirstName);
        System.assertEquals(testContact.Id, updatedCtct.Id);
    }

    @isTest
    static void deleteContactTest() {
        Contact testContact = [SELECT Id, IsActive__c FROM Contact WHERE Email = 'test@test.com' LIMIT 1];
        System.assertEquals(true, testContact.IsActive__c);

        // Simule une requête DELETE pour la méthode de désactivation
        RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/services/apexrest/Contacts/' + testContact.Id;
        RestContext.request.httpMethod = 'DELETE';
        RestContext.response = new RestResponse();

        Test.startTest();
        ContactManager.deleteContact();
        Test.stopTest();

        testContact = [SELECT Id, IsActive__c FROM Contact WHERE Id = :testContact.Id];
        System.assertEquals(false, testContact.IsActive__c);
    }

}