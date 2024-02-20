@RestResource(urlMapping='/Contracts/*')
global with sharing class ContractManager {

    @HttpPost
    global static Id createContract(Id accountId, Date startDate, Integer contractTerm, String status) {
        Contract newCtrct = new Contract(
            AccountId = accountId,
            StartDate = startDate,
            ContractTerm = contractTerm,
            Status = status
        );
        insert newCtrct;
        return newCtrct.Id;
    }

    @HttpPatch
    global static ID updateContract() {
        RestRequest request = RestContext.request;
        String contractId = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);
        Contract thisContract = [SELECT Id FROM Contract WHERE Id = :contractId];
        Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        for(String field : data.keySet()) {
            if(field == 'startDate') {
                thisContract.put(field, Date.valueOf((String)data.get(field)));
            } else if(field == 'contractTerm') {
                thisContract.put(field, Integer.valueOf((String)data.get(field)));
            } else {
                thisContract.put(field, data.get(field));
            }            
        }
        update thisContract;
        return thisContract.Id;
    }    
}