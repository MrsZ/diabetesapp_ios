//
//  IncomingCallViewController.h
//  QBRTCChatSemple
//
//  Created by Andrey Ivanov on 16.12.14.
//  Copyright (c) 2014 QuickBlox Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickbloxWebRTC/QuickbloxWebRTC.h>
#import <Quickblox/Quickblox.h>

@class UsersDataSource;
@protocol IncomingCallViewControllerDelegate;

@interface IncomingCallViewController : UIViewController

@property (weak, nonatomic) id <IncomingCallViewControllerDelegate> delegate;

@property (strong, nonatomic) QBRTCSession *session;
//@property (weak, nonatomic) UsersDataSource *usersDatasource;
@property (strong, nonatomic) NSMutableArray *qbUsersArray;
@property (weak, nonatomic) QBUUser *currentUser;

@end

@protocol IncomingCallViewControllerDelegate <NSObject>

- (void)incomingCallViewControllerAccept:(IncomingCallViewController *)vc didAcceptSession:(QBRTCSession *)session;
- (void)incomingCallViewControllerReject:(IncomingCallViewController *)vc didRejectSession:(QBRTCSession *)session;

@end
