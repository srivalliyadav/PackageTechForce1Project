global with sharing class AccountPlan {
    public static void syncAccount(String accountId) {
        try {
            Account sourceAccount = fetchAccountFromSourceOrg(accountId);
            if (sourceAccount != null) {
                upsertAccountInTargetOrg(sourceAccount);
            } else {
                System.debug('No account found in Source Org with ID: ' + accountId);
            }
        } catch (Exception e) {
            System.debug('Error during account synchronization: ' + e.getMessage());
        }
    }

    private static Account fetchAccountFromSourceOrg(String accountId) {
        String endpoint = 'https://varmitech-1f-dev-ed.develop.my.salesforce.com/services/data/v61.0/sobjects/Account'+ accountId; 

        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');  req.setHeader('Authorization', 'Bearer ' + '00DIT000002JWaV!AQYAQNBQQJPw4JH1Tds.BP5_3VyKmFIBkHHSw4tyqvM5Q.bvuzabfjNSUH.ndEVYax0ZLFpZS_LY.1F4iUzw4zc7jgT3cM2X'); 
       
        req.setHeader('Content-Type', 'application/json');
       
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
            Map<String, Object> accountData = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            Account acc = new Account();
            acc.Name = (String) accountData.get('Name');
            acc.Industry = (String) accountData.get('Industry');
            acc.Phone = (String) accountData.get('Phone');
            return acc;
        } else {
            System.debug('Failed to fetch account. Status Code: ' + res.getStatusCode() + ', Response: ' + res.getBody());
            return null;
        }
    }

    private static void upsertAccountInTargetOrg(Account sourceAccount) {
        String targetOrgNamedCredential = 'SourceOrgIntegration';
         HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:' + targetOrgNamedCredential + '/services/data/v61.0/sobjects/Account/');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');

            String jsonBody = '{"Name": "' + sourceAccount.Name + '", "Industry": "' + sourceAccount.Industry + '", "Phone": "' + sourceAccount.Phone + '"}';
            req.setBody(jsonBody);

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 201) {
                System.debug('New account created successfully in Target Org: ' + res.getBody());
            } else {
                System.debug('Failed to upsert account. Status Code: ' + res.getStatusCode() + ', Response: ' + res.getBody());
            }
        } 
}