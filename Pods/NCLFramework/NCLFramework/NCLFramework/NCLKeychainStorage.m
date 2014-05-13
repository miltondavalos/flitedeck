//
//  NCLKeychainStorage.m
//  NCLFramework
//
//  Created by Chad Long on 10/17/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NCLKeychainStorage.h"
#import "NCLFramework.h"
#import "NCLClientCertificate.h"
#import "NCLUserPassword.h"
#import "NCLNetworking_Private.h"
#import "NSError+Utility.h"

@implementation NCLKeychainStorage
{
    NSMutableDictionary *_certificateCache;
}

#pragma mark - user/password management

+ (NCLKeychainStorage*)sharedInstance
{
	static dispatch_once_t pred;
	static NCLKeychainStorage *sharedInstance = nil;
    
	dispatch_once(&pred, ^
    {
        sharedInstance = [[self alloc] init];
    });
	
    return sharedInstance;
}

+ (NSMutableDictionary*)keychainQueryForHost:(NSString*)host
{
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
	[query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[query setObject:[NCLNetworking secondLevelDomainForHost:host] forKey:(__bridge id)kSecAttrService];
    [query setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
    
    return query;
}

+ (NSDictionary*)keychainValuesForHost:(NSString*)host
{
    // setup the keychain query to return data
    NSMutableDictionary *query = [self keychainQueryForHost:host];
	[query setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
	[query setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    // convert the keychain query to core foundation classes, and retrieve the keychain values
    CFDictionaryRef cfQuery = (__bridge_retained CFDictionaryRef)query;
	CFDictionaryRef cfResult = NULL;
    OSStatus status = SecItemCopyMatching(cfQuery, (CFTypeRef*)&cfResult);
    CFRelease(cfQuery);
    
    NSDictionary *result = nil;
    
	if (status == errSecSuccess)
    {
        result = (__bridge_transfer NSDictionary*)cfResult;
    }
    
    return result;
}

+ (BOOL)saveUserPassword:(NCLUserPassword*)userPass error:(NSError**)error
{
    // if nothing is provided, ignore the call
    if (userPass == nil ||
        userPass.username == nil ||
        userPass.username.length == 0 ||
        userPass.host == nil ||
        userPass.host.length == 0)
    {
        INFOLog(@"nothing to save to keychain... continuing");
        
        return YES;
    }
    
    // clean up the parameter data
    userPass.username = [userPass.username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (userPass.password == nil)
    {
        userPass.password = @"";
    }
    
    // clear existing storage
    OSStatus status = errSecSuccess;
    NSMutableDictionary *query = [self keychainQueryForHost:userPass.host];
    NSString *keychainUsername = [query objectForKey:(__bridge id)kSecAttrAccount];
    
    SecItemDelete((__bridge CFDictionaryRef)query);
    
    // save the credentials to the keychain
    [query setObject:(id)userPass.username forKey:(__bridge id)kSecAttrAccount];
    [query setObject:(id)[userPass.password dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
    
    status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    
    if (status != errSecSuccess)
    {
        NSError *saveError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:[[NSString stringWithFormat:@"%ld", status] integerValue]
                                          description:@"Error Saving User/Password"
                                        failureReason:[NSString stringWithFormat:@"%ld", status]];
        
        if (error != 0)
        {
            *error = saveError;
        }
        
        INFOLog(@"error adding user/password to keychain: %ld", status);
        [NCLAnalytics addEvent:[NCLAnalyticsEvent eventForComponent:@"keychain" action:@"save" value:userPass.username error:saveError]];
        
        return NO;
    }
    
    INFOLog(@"saved user/password to keychain for user: %@", userPass.username);
    
    if (![keychainUsername isEqualToString:userPass.username])
        [NCLAnalytics addEvent:[NCLAnalyticsEvent eventForComponent:@"keychain" action:@"save" value:userPass.username]];
    
    return YES;
}

+ (NCLUserPassword*)userPasswordForUser:(NSString*)username host:(NSString*)host
{
    if (username != nil &&
        username.length > 0)
    {
        NSDictionary *keychainValues = [self keychainValuesForHost:host];
        
        if (keychainValues != nil)
        {
            NSString *keychainUsername = [keychainValues objectForKey:(__bridge id)kSecAttrAccount];
            NSString *keychainPassword = [[NSString alloc] initWithData:[keychainValues objectForKey:(__bridge id)kSecValueData] encoding:NSUTF8StringEncoding];
            
            username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if ([username isEqualToString:keychainUsername])
            {
                NSString *secondLevelDomainName = [NCLNetworking secondLevelDomainForHost:host];
                
                return [[NCLUserPassword alloc] initWithUsername:keychainUsername password:keychainPassword host:secondLevelDomainName];
            }
        }
    }
    
    INFOLog(@"user %@ not in keychain for host %@", username, [NCLNetworking secondLevelDomainForHost:host]);
    
    return nil;
}

#pragma mark - client certificate management

- (NCLClientCertificate*)certificateForHost:(NSString*)host
{
    if (host == nil)
        return nil;
    
    NCLClientCertificate *cert = nil;
    host = [NCLNetworking secondLevelDomainForHost:host];
    
    // first priority is to use the cert from memory
    @synchronized(self)
    {
        if (_certificateCache)
        {
            cert = [_certificateCache objectForKey:host];
        }
    }
    
    // if no cert is in memory, get it from the keychain & cache it in memory
    if (cert == nil)
    {
        NSString *identityKey = [NCLKeychainStorage identityKeyForHost:host];
        CFDataRef identityRef = (__bridge CFDataRef)[[NSUserDefaults standardUserDefaults] dataForKey:identityKey];
        
        if (identityRef != nil)
        {
            CFTypeRef identity_ref = NULL;
            const void *keys[] =   { kSecReturnRef,  kSecValuePersistentRef };
            const void *values[] = { kCFBooleanTrue, identityRef };
            CFDictionaryRef dict = CFDictionaryCreate(NULL, keys, values, 2, NULL, NULL);
            SecItemCopyMatching(dict, &identity_ref);
            
            if (dict)
                CFRelease(dict);

            cert = [[NCLClientCertificate alloc] initWithIdentity:(SecIdentityRef)identity_ref host:host];
            
            INFOLog(@"successfully retrieved client certificate from keychain");
            
            [self cacheCertificateForIdentity:(SecIdentityRef)identity_ref host:host];
        }
    }

    return cert;
}

- (void)cacheCertificateForIdentity:(SecIdentityRef)identity host:(NSString*)host
{
    @synchronized(self)
    {
        // caches a certificate in memory for the identity/host
        // this provides a smoother user experience in the case that a client certificate is not yet stored in the keychain
        if (_certificateCache == nil)
        {
            _certificateCache = [[NSMutableDictionary alloc] init];
        }
        
        host = [NCLNetworking secondLevelDomainForHost:host];
        NCLClientCertificate *cert = [[NCLClientCertificate alloc] initWithIdentity:identity host:host];
        [_certificateCache setObject:cert forKey:host];
    }
    
    INFOLog(@"successfully stored client certificate in memory");
}

+ (NSString*)identityKeyForHost:(NSString*)host
{
    return [NSString stringWithFormat:@"ClientCertIdentityRef-%@", [NCLNetworking secondLevelDomainForHost:host]];
}

+ (BOOL)saveIdentity:(SecIdentityRef)identity forHost:(NSString*)host error:(NSError**)error
{
    if (identity == nil ||
        host == nil)
    {
        return NO;
    }
    
    // cache the identity in memory
    [[NCLKeychainStorage sharedInstance] cacheCertificateForIdentity:identity host:host];

    // get a standardized key to store the identity reference to the keychain in UserDefaults
    NSString *identityKey = [NCLKeychainStorage identityKeyForHost:host];
    
    // if an identity already exists, remove it (will be re-added below ... effectively replacing it)
    CFDataRef identityRef = (__bridge CFDataRef)[[NSUserDefaults standardUserDefaults] dataForKey:identityKey];
    
    if (identityRef != nil)
    {
        NSDictionary *delAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                       (__bridge id)identityRef, kSecMatchItemList,
                                       nil];
        OSStatus delStatus = SecItemDelete((__bridge CFDictionaryRef)delAttributes);
        
        if (delStatus == errSecSuccess)
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:identityKey];
            INFOLog(@"removed existing identity from keychain for key: %@", identityKey);
        }
        else
        {
            NSError *removeError = [NSError errorWithDomain:NSOSStatusErrorDomain
                                                       code:[[NSString stringWithFormat:@"%ld", delStatus] integerValue]
                                                description:@"error removing identity from keychain"
                                              failureReason:nil];
            
            if (error != 0)
            {
                *error = removeError;
            }
            
            INFOLog(@"error removing identity from keychain: %ld", delStatus);
            [NCLAnalytics addEvent:[NCLAnalyticsEvent eventForComponent:@"keychain" action:@"remove" value:@"certificate" error:removeError]];
        }
    }
    
    // add the client certificate identity (includes the certificate and private key) to the keychain
    CFDataRef persistentRef = nil;
    NSDictionary *addAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                   (__bridge id)identity, kSecValueRef,
                                   (id)kCFBooleanTrue, kSecReturnPersistentRef,
                                   nil];
    OSStatus addStatus = SecItemAdd((__bridge CFDictionaryRef)addAttributes, (CFTypeRef *)&persistentRef);
    
    // if we get a 'duplicate error', clear all certificates from this apps' keychain and try again
    if (addStatus == errSecDuplicateItem)
    {
        SecItemDelete((__bridge CFDictionaryRef) [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)kSecClassIdentity, kSecClass, nil]);
        SecItemDelete((__bridge CFDictionaryRef) [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)kSecClassCertificate, kSecClass, nil]);
        SecItemDelete((__bridge CFDictionaryRef) [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)kSecClassKey, kSecClass, nil]);
        
        addStatus = SecItemAdd((__bridge CFDictionaryRef)addAttributes, (CFTypeRef *)&persistentRef);
    }
    
    if (addStatus != errSecSuccess)
    {
        NSError *addError = [NSError errorWithDomain:NSOSStatusErrorDomain
                                                code:[[NSString stringWithFormat:@"%ld", addStatus] integerValue]
                                         description:@"error saving identity to keychain"
                                       failureReason:nil];
        
        if (error != 0)
        {
            *error = addError;
        }
        
        INFOLog(@"error adding identity to keychain: %ld", addStatus);
        [NCLAnalytics addEvent:[NCLAnalyticsEvent eventForComponent:@"keychain" action:@"save" value:@"certificate" error:addError]];
        
        return NO;
    }
    
    // if no errors, store a reference to the keychain for the identity in user defaults
    [[NSUserDefaults standardUserDefaults] setObject:(__bridge_transfer NSData*)persistentRef forKey:identityKey];
    
    INFOLog(@"saved identity to keychain for key: %@", identityKey);
    [NCLAnalytics addEvent:[NCLAnalyticsEvent eventForComponent:@"keychain" action:@"save" value:@"certificate"]];
    
    return YES;
}

@end