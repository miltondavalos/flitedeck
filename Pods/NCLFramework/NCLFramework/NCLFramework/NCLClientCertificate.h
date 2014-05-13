//
//  NCLClientCertificateKeychain.h
//  NCLFramework
//
//  Created by Chad Long on 9/14/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCLClientCertificate : NSObject

@property (nonatomic, readonly, strong) NSString *host;

- (id)initWithIdentity:(SecIdentityRef)identity host:(NSString*)host;

- (NSURLCredential*)credential;
- (NSString*)subjectSummary;

@end
