trigger AccountTrigger on Account (before insert, after insert) {

    if (Trigger.isBefore && Trigger.isInsert) {
        for (Account a : Trigger.new) {
            if (a.Type == null) {
                a.Type = 'Prospect';
            }
        }
    }

    if (Trigger.isBefore && Trigger.isInsert) {
        for (Account a : Trigger.new) {
            if (a.ShippingStreet != null) {
                a.BillingStreet = a.ShippingStreet;
            }

            if (a.ShippingCity != null) {
                a.BillingCity = a.ShippingCity;
            }

            if (a.ShippingState != null) {
                a.BillingState = a.ShippingState;
            }

            if (a.ShippingPostalCode != null) {
                a.BillingPostalCode = a.ShippingPostalCode;
            }

            if (a.ShippingCountry != null) {
                a.BillingCountry = a.ShippingCountry;
            }
        }        
    }

    if (Trigger.isBefore && Trigger.isInsert) {
        for (Account a : Trigger.new) {
            if (a.Phone != null && a.Website != null && a.Fax != null) {
                a.Rating = 'Hot';
            }
        }
    }
     
    if(Trigger.isAfter && Trigger.isInsert){     
        List<Contact> contacts = new List<Contact>();   
        for(Account a : Trigger.new){
            Contact c = new Contact();
            c.LastName = 'DefaultContact';
            c.Email = 'default@email.com';
            c.AccountId = a.Id;
            contacts.add(c);
        }
        insert contacts; 
    }
}