//
//  NFDUserManager.h
//  UserSettings
//
//  Created by Ryan Smith on 3/8/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const NFD_USER_MANAGER_USER_INFO_DID_CHANGE_NOTIFICATION;

extern NSString * const NFDAccountSettingsUsername;
extern NSString * const NFDUserSettingsName;
extern NSString * const NFDUserSettingsTitle;
extern NSString * const NFDUserSettingsEmail;
extern NSString * const NFDUserSettingsPhoneWork;
extern NSString * const NFDUserSettingsPhoneMobile;

extern NSString * const NFDUserPreferenceProfileShowMoney;
extern NSString * const NFDUserPreferenceProposalShowHourly;
extern NSString * const NFDUserPreferenceProposalShowTailNumber;

typedef NS_ENUM(NSInteger, NFDCompanySetting) {
    NFDCompanySettingNJA = 0,
    NFDCompanySettingNJE
};

typedef enum
{
    kNFDUserSettingsName = 0,
    kNFDUserSettingsTitle,
    kNFDUserSettingsEmail,
    kNFDUserSettingsPhoneWork,
    kNFDUserSettingsPhoneMobile,
    kNFDAccountSettingsUsername,
    kNFDUserPreferenceProfileShowMoney,
    kNFDUserPreferenceProposalShowHourly,
    kNFDUserPreferenceProposalShowTailNumber,
    kNFDuserPreferenceCompany
} kNFDUserSettingsUserInfo;

@interface NFDUserManager : NSObject

@property (nonatomic, strong) NSMutableSet *remoteDataSyncProgress;
@property BOOL syncInProgress;
@property (nonatomic, strong) NSMutableDictionary *userInfo;
@property (nonatomic, strong) NSArray *keys;

+ (NFDUserManager *)sharedManager;
- (void)setInfo:(id)info forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;
- (void)clearInfo;

// convenience methods
- (NSString *)username;
- (NSString *)name;
- (NSString *)nameAndTitle; // "Name, Title"
- (NSString *)email;
- (NSString *)phoneWork;
- (NSString *)phoneMobile;

- (NFDCompanySetting) companySetting;
- (void) setCompanySetting:(NFDCompanySetting) companySetting;

- (BOOL)profileShowMoney;
- (void)setProfileShowMoney:(BOOL) showMoney;
- (void)toggleProfileShowMoney;

- (BOOL)proposalShowHourly;
- (void)setProposalShowHourly:(BOOL) showHourly;
- (void)toggleProposalShowHourly;

- (BOOL)proposalShowTailNumber;
- (void)toggleProposalShowTailNumber;

+ (NSString *) stringForCompanySetting:(NFDCompanySetting) companySetting;
+ (NFDCompanySetting) companySettingForString:(NSString *) companyString;

@end
