trigger OpportunityTrigger on Opportunity (before update, after update, before delete) {

    
    if (Trigger.isUpdate && Trigger.isBefore){
        for(Opportunity o : Trigger.new){
            if(o.Amount < 5000){
                o.addError('Opportunity amount must be greater than 5000');
            }
        }
    }


    if (Trigger.isDelete){
        Map<Id, Account> accounts = new Map<Id, Account>([SELECT Id, Industry FROM Account WHERE Id IN (SELECT AccountId FROM Opportunity WHERE Id IN :Trigger.old)]);
        for(Opportunity o : Trigger.old){
            if(o.StageName == 'Closed Won'){
                if(accounts.get(o.AccountId).Industry == 'Banking'){
                    o.addError('Cannot delete closed opportunity for a banking account that is won');
                }
            }
        }
    }

    if (Trigger.isUpdate && Trigger.isBefore){
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity o : Trigger.new){
            accountIds.add(o.AccountId);
        }
        
        Map<Id, Contact> contacts = new Map<Id, Contact>([SELECT Id, FirstName, AccountId FROM Contact WHERE AccountId IN :accountIds AND Title = 'CEO' ORDER BY FirstName ASC]);
        Map<Id, Contact> accountIdToContact = new Map<Id, Contact>();

        for (Contact c : contacts.values()) {
            if (!accountIdToContact.containsKey(c.AccountId)) {
                accountIdToContact.put(c.AccountId, c);
            }
        }

        for(Opportunity o : Trigger.new){
            if(o.Primary_Contact__c == null){
                if (accountIdToContact.containsKey(o.AccountId)){
                    o.Primary_Contact__c = accountIdToContact.get(o.AccountId).Id;
                }
            }
        }
    }    
}