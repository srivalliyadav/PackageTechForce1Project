@RestResource(urlMapping='/createAcc')
global with sharing class CreateAccount {
    @HttpPost
    global static String createAccount(String name, String phone) {
        Account newAccount = new Account(
            Name = name,
            Phone = phone
        );
        insert newAccount;
        return 'Account Created: ' + newAccount.Id;
    }
}