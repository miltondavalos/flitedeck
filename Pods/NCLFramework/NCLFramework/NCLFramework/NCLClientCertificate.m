//
//  NCLClientCertificateKeychain.m
//  NCLFramework
//
//  Created by Chad Long on 9/14/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NCLClientCertificate.h"
#import "NCLKeychainStorage.h"

@implementation NCLClientCertificate
{
    SecIdentityRef _identity;
}

- (id)initWithIdentity:(SecIdentityRef)identity host:(NSString*)host
{
    self = [super init];
    
    if (self)
    {
        if (identity == nil ||
            host == nil ||
            host.length == 0)
        {
            NSException *exception = [NSException exceptionWithName:@"Initialization Exception"
                                                             reason:@"An identity & host are required to create a certificate"
                                                           userInfo:nil];
            @throw exception;
        }
        else
        {
            _host = host;
            _identity = identity;
        }
    }
    
    return self;
}

- (NSURLCredential*)credential
{
    NSURLCredential *credential = nil;

    SecCertificateRef certificate;
    SecIdentityCopyCertificate(_identity, &certificate);
    const void *certs[] = { certificate };
    CFArrayRef certsArray = CFArrayCreate(NULL, certs, 1, NULL);
    
    credential = [NSURLCredential credentialWithIdentity:_identity
                                            certificates:(__bridge_transfer NSArray*)certsArray
                                             persistence:NSURLCredentialPersistenceForSession];

    return credential;
}

- (NSString*)subjectSummary
{
    NSString *subjectSummary = @"";
    
    SecCertificateRef certificate;
    SecIdentityCopyCertificate(_identity, &certificate);
    subjectSummary = (__bridge_transfer NSString *)SecCertificateCopySubjectSummary(certificate);
    
    return subjectSummary;
}

@end
