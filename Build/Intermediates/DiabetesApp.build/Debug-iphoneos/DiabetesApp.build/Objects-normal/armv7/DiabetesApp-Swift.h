// Generated by Apple Swift version 3.0.2 (swiftlang-800.0.63 clang-800.0.42.1)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if defined(__has_attribute) && __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if defined(__has_feature) && __has_feature(modules)
@import ObjectiveC;
@import UIKit;
@import Foundation;
@import CoreGraphics;
@import QMChatViewController;
@import QMServices;
#endif

#import "/Users/IPHONE/Deepak/baljeet/diabetesapp_ios/DiabetesApp/DiabetesApp-Bridging-Header.h"

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class UIAlertView;

SWIFT_CLASS("_TtC11DiabetesApp9AlertView")
@interface AlertView : NSObject <UIAlertViewDelegate>
@property (nonatomic, strong) UIAlertView * _Nonnull alert;
/**
  \param cancelButtonTitle cancelButtonTitle has index 0

*/
- (nonnull instancetype)initWithTitle:(NSString * _Nullable)title message:(NSString * _Nullable)message cancelButtonTitle:(NSString * _Nullable)cancelButtonTitle otherButtonTitle:(NSArray<NSString *> * _Nonnull)otherButtonTitle didClick:(void (^ _Nonnull)(NSInteger))closure OBJC_DESIGNATED_INITIALIZER;
- (void)alertView:(UIAlertView * _Nonnull)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class UITextField;
@class UIViewController;

SWIFT_CLASS("_TtC11DiabetesApp22AlertViewWithTextField")
@interface AlertViewWithTextField : NSObject <UIAlertViewDelegate>
@property (nonatomic, strong) id _Nullable alert;
@property (nonatomic, strong) UITextField * _Nullable alertViewControllerTextField;
/**
  @note: cancelButtonTitle cancelButtonTitle has index 0
*/
- (nonnull instancetype)initWithTitle:(NSString * _Nullable)title message:(NSString * _Nullable)message showOver:(UIViewController * _Null_unspecified)showOver didClickOk:(void (^ _Nonnull)(NSString * _Nullable))closureOk didClickCancel:(void (^ _Nonnull)(void))closureCancel OBJC_DESIGNATED_INITIALIZER;
- (void)alertView:(UIAlertView * _Nonnull)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class UIWindow;
@class QBUUser;
@class QBRTCSession;
@class UIApplication;
@class NSPersistentContainer;
@class QBChatDialog;

SWIFT_CLASS("_TtC11DiabetesApp11AppDelegate")
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow * _Nullable window;
@property (nonatomic, strong) QBUUser * _Nullable currentUser;
@property (nonatomic, strong) QBRTCSession * _Nullable session;
- (BOOL)application:(UIApplication * _Nonnull)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> * _Nullable)launchOptions;
- (void)application:(UIApplication * _Nonnull)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData * _Nonnull)deviceToken;
- (void)application:(UIApplication * _Nonnull)application didFailToRegisterForRemoteNotificationsWithError:(NSError * _Nonnull)error;
- (void)application:(UIApplication * _Nonnull)application didReceiveRemoteNotification:(NSDictionary * _Nonnull)userInfo;
- (void)applicationDidEnterBackground:(UIApplication * _Nonnull)application;
- (void)applicationWillEnterForeground:(UIApplication * _Nonnull)application;
- (void)applicationWillResignActive:(UIApplication * _Nonnull)application;
- (void)applicationDidBecomeActive:(UIApplication * _Nonnull)application;
- (void)applicationWillTerminate:(UIApplication * _Nonnull)application;
@property (nonatomic, strong) NSPersistentContainer * _Nonnull persistentContainer;
- (void)saveContext;
- (void)notificationServiceDidStartLoadingDialogFromServer;
- (void)notificationServiceDidFinishLoadingDialogFromServer;
- (void)notificationServiceDidSucceedFetchingDialogWithChatDialog:(QBChatDialog * _Null_unspecified)chatDialog;
- (void)notificationServiceDidFailFetchingDialog;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class UITableView;
@class UITableViewCell;
@class UISegmentedControl;
@class NSBundle;
@class NSCoder;

SWIFT_CLASS("_TtC11DiabetesApp22CarePlanViewController")
@interface CarePlanViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UISegmentedControl * _Null_unspecified segmentControl;
@property (nonatomic, weak) IBOutlet UITableView * _Null_unspecified tblView;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (IBAction)SegmentControl_ValueChanged:(id _Nonnull)sender;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (CGFloat)tableView:(UITableView * _Nonnull)tableView heightForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class NSTimer;
@class UIImagePickerController;
@class QBChatMessage;
@class UIStoryboardSegue;
@class UIImage;
@class UIButton;
@class QMPlaceHolderTextView;
@class NSAttributedString;
@class QMChatCollectionView;
@class UICollectionViewCell;
@class UICollectionView;
@class QMChatCell;
@class NSTextCheckingResult;
@class QMDeferredQueueManager;
@class QMChatService;
@class UITextView;
@class QMChatAttachmentService;
@class QBChatAttachment;

SWIFT_CLASS("_TtC11DiabetesApp18ChatViewController")
@interface ChatViewController : QMChatViewController <QMChatConnectionDelegate, QMChatCellDelegate, QMDeferredQueueManagerDelegate, QMPlaceHolderTextViewPasteDelegate, QMChatServiceDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, QMChatAttachmentServiceDelegate>
@property (nonatomic, readonly) NSInteger maxCharactersNumber;
@property (nonatomic, readonly, strong) AppDelegate * _Nonnull appDelegate;
@property (nonatomic, strong) QBChatDialog * _Null_unspecified dialog;
@property (nonatomic, strong) id _Nullable willResignActiveBlock;
@property (nonatomic, strong) NSMapTable<id, id> * _Null_unspecified attachmentCellsMap;
@property (nonatomic, copy) NSSet<NSString *> * _Nonnull detailedCells;
@property (nonatomic, strong) NSTimer * _Nullable typingTimer;
@property (nonatomic) NSInteger occupantID;
@property (nonatomic, strong) QBUUser * _Nonnull occupantUser;
@property (nonatomic, strong) UIImagePickerController * _Nonnull imagePickerViewController;
@property (nonatomic, copy) NSArray<QBChatMessage *> * _Nullable unreadMessages;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (void)updateTitle;
- (NSArray<QBChatMessage *> * _Nullable)storedMessages;
- (void)loadMessages;
- (void)sendReadStatusForMessageWithMessage:(QBChatMessage * _Nonnull)message;
- (BOOL)messageShouldBeReadWithMessage:(QBChatMessage * _Nonnull)message;
- (void)readMessagesWithMessages:(NSArray<QBChatMessage *> * _Nonnull)messages;
- (void)optionsClick;
- (void)videoAudioClick;
- (void)callWithConferenceTypeWithConferenceType:(QBRTCConferenceType)conferenceType;
- (void)didPickAttachmentImage:(UIImage * _Null_unspecified)image;
- (void)didPressSendButton:(UIButton * _Null_unspecified)button withMessageText:(NSString * _Null_unspecified)text senderId:(NSUInteger)senderId senderDisplayName:(NSString * _Null_unspecified)senderDisplayName date:(NSDate * _Null_unspecified)date;
- (void)didPressSendButton:(UIButton * _Null_unspecified)button withTextAttachments:(NSArray * _Null_unspecified)textAttachments senderId:(NSUInteger)senderId senderDisplayName:(NSString * _Null_unspecified)senderDisplayName date:(NSDate * _Null_unspecified)date;
- (void)sendMessageWithMessage:(QBChatMessage * _Nonnull)message;
- (BOOL)canMakeACall;
- (BOOL)placeHolderTextView:(QMPlaceHolderTextView * _Nonnull)textView shouldPasteWithSender:(id _Nonnull)sender;
- (void)showCharactersNumberError;
/**
  Builds a string
  Read: login1, login2, login3
  Delivered: login1, login3, @12345
  If user does not exist in usersMemoryStorage, then ID will be used instead of login
  \param message QBChatMessage instance


  returns:
  status string
*/
- (NSString * _Nonnull)statusStringFromMessageWithMessage:(QBChatMessage * _Nonnull)message;
- (Class _Nullable)viewClassForItem:(QBChatMessage * _Nonnull)item;
- (NSAttributedString * _Nullable)attributedStringForItem:(QBChatMessage * _Null_unspecified)messageItem;
/**
  Creates top label attributed string from QBChatMessage
  \param messageItem QBCHatMessage instance


  returns:
  login string, example: @SwiftTestDevUser1
*/
- (NSAttributedString * _Nullable)topLabelAttributedStringForItem:(QBChatMessage * _Null_unspecified)messageItem;
/**
  Creates bottom label attributed string from QBChatMessage using self.statusStringFromMessage
  \param messageItem QBChatMessage instance


  returns:
  bottom label status string
*/
- (NSAttributedString * _Null_unspecified)bottomLabelAttributedStringForItem:(QBChatMessage * _Null_unspecified)messageItem;
- (CGSize)collectionView:(QMChatCollectionView * _Null_unspecified)collectionView dynamicSizeAtIndexPath:(NSIndexPath * _Null_unspecified)indexPath maxWidth:(CGFloat)maxWidth;
- (CGFloat)collectionView:(QMChatCollectionView * _Null_unspecified)collectionView minWidthAtIndexPath:(NSIndexPath * _Null_unspecified)indexPath;
- (QMChatCellLayoutModel)collectionView:(QMChatCollectionView * _Null_unspecified)collectionView layoutModelAtIndexPath:(NSIndexPath * _Null_unspecified)indexPath;
- (void)collectionView:(QMChatCollectionView * _Null_unspecified)collectionView configureCell:(UICollectionViewCell * _Null_unspecified)cell forIndexPath:(NSIndexPath * _Null_unspecified)indexPath;
/**
  Allows to copy text from QMChatIncomingCell and QMChatOutgoingCell
*/
- (BOOL)collectionView:(UICollectionView * _Nonnull)collectionView canPerformAction:(SEL _Nonnull)action forItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath withSender:(id _Nullable)sender;
- (void)collectionView:(UICollectionView * _Nonnull)collectionView performAction:(SEL _Nonnull)action forItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath withSender:(id _Nullable)sender;
- (UICollectionViewCell * _Nonnull)collectionView:(UICollectionView * _Nonnull)collectionView cellForItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
/**
  Removes size from cache for item to allow cell expand and show read/delivered IDS or unexpand cell
*/
- (void)chatCellDidTapContainer:(QMChatCell * _Null_unspecified)cell;
- (void)chatCell:(QMChatCell * _Null_unspecified)cell didTapAtPosition:(CGPoint)position;
- (void)chatCell:(QMChatCell * _Null_unspecified)cell didPerformAction:(SEL _Null_unspecified)action withSender:(id _Null_unspecified)sender;
- (void)chatCell:(QMChatCell * _Null_unspecified)cell didTapOnTextCheckingResult:(NSTextCheckingResult * _Nonnull)result;
- (void)chatCellDidTapAvatar:(QMChatCell * _Null_unspecified)cell;
- (void)deferredQueueManager:(QMDeferredQueueManager * _Nonnull)queueManager didAddMessageLocally:(QBChatMessage * _Nonnull)addedMessage;
- (void)deferredQueueManager:(QMDeferredQueueManager * _Nonnull)queueManager didUpdateMessageLocally:(QBChatMessage * _Nonnull)addedMessage;
- (void)chatService:(QMChatService * _Nonnull)chatService didLoadMessagesFromCache:(NSArray<QBChatMessage *> * _Nonnull)messages forDialogID:(NSString * _Nonnull)dialogID;
- (void)chatService:(QMChatService * _Nonnull)chatService didAddMessageToMemoryStorage:(QBChatMessage * _Nonnull)message forDialogID:(NSString * _Nonnull)dialogID;
- (void)chatService:(QMChatService * _Nonnull)chatService didUpdateChatDialogInMemoryStorage:(QBChatDialog * _Nonnull)chatDialog;
- (void)chatService:(QMChatService * _Nonnull)chatService didUpdateMessage:(QBChatMessage * _Nonnull)message forDialogID:(NSString * _Nonnull)dialogID;
- (void)chatService:(QMChatService * _Nonnull)chatService didUpdateMessages:(NSArray<QBChatMessage *> * _Nonnull)messages forDialogID:(NSString * _Nonnull)dialogID;
- (void)textViewDidChange:(UITextView * _Nonnull)textView;
- (BOOL)textView:(UITextView * _Nonnull)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString * _Nonnull)text;
- (void)textViewDidEndEditing:(UITextView * _Nonnull)textView;
- (void)fireSendStopTypingIfNecessary;
- (void)sendBeginTyping;
- (void)sendStopTyping;
- (void)chatAttachmentService:(QMChatAttachmentService * _Nonnull)chatAttachmentService didChangeAttachmentStatus:(QMMessageAttachmentStatus)status forMessage:(QBChatMessage * _Nonnull)message;
- (void)chatAttachmentService:(QMChatAttachmentService * _Nonnull)chatAttachmentService didChangeLoadingProgress:(CGFloat)progress forChatAttachment:(QBChatAttachment * _Nonnull)attachment;
- (void)chatAttachmentService:(QMChatAttachmentService * _Nonnull)chatAttachmentService didChangeUploadingProgress:(CGFloat)progress forMessage:(QBChatMessage * _Nonnull)message;
- (void)refreshAndReadMessages;
- (void)chatServiceChatDidConnect:(QMChatService * _Nonnull)chatService;
- (void)chatServiceChatDidReconnect:(QMChatService * _Nonnull)chatService;
- (QMDeferredQueueManager * _Nonnull)queueManager;
- (void)handleNotSentMessage:(QBChatMessage * _Nonnull)message forCell:(QMChatCell * _Null_unspecified)cell;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class NSMutableArray;
@class QBResponse;

SWIFT_CLASS("_TtC11DiabetesApp25ContactListViewController")
@interface ContactListViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView * _Null_unspecified tableView;
@property (nonatomic, strong) NSMutableArray * _Nonnull patientList;
@property (nonatomic, strong) NSMutableArray * _Nonnull doctorList;
@property (nonatomic, strong) NSMutableArray * _Nonnull educatorsList;
@property (nonatomic) BOOL isGroupMode;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (void)naviagteToChatScreenWithDialog:(QBChatDialog * _Nonnull)dialog;
- (void)getContactsList;
- (IBAction)Back_Click:(id _Nonnull)sender;
- (IBAction)Done_Click:(id _Nonnull)sender;
- (void)createChatWithName:(NSString * _Nullable)name usersArray:(NSArray<NSString *> * _Nonnull)usersArray completion:(void (^ _Nonnull)(QBResponse * _Nullable, QBChatDialog * _Nullable))completion;
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (NSString * _Nullable)tableView:(UITableView * _Nonnull)tableView titleForHeaderInSection:(NSInteger)section;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (void)getPatientDoctors;
- (void)getPatientEducators;
- (void)getDoctorPatients;
- (void)getDoctorEducators;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC11DiabetesApp10ContactObj")
@interface ContactObj : NSObject
@property (nonatomic, copy) NSString * _Nonnull patient_id;
@property (nonatomic, copy) NSString * _Nonnull chatid;
@property (nonatomic, copy) NSString * _Nonnull full_name;
@property (nonatomic, copy) NSString * _Nonnull username;
@property (nonatomic, copy) NSString * _Nonnull isSelected;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class UILabel;
@class UIImageView;
@class UIView;

SWIFT_CLASS("_TtC11DiabetesApp19DialogTableViewCell")
@interface DialogTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified dialogLastMessage;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified dialogName;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified dialogTypeImage;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified unreadMessageCounterLabel;
@property (nonatomic, weak) IBOutlet UIView * _Null_unspecified unreadMessageCounterHolder;
@property (nonatomic, copy) NSString * _Nonnull dialogID;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC11DiabetesApp24DialogTableViewCellModel")
@interface DialogTableViewCellModel : NSObject
@property (nonatomic, copy) NSString * _Nonnull detailTextLabelText;
@property (nonatomic, copy) NSString * _Nonnull textLabelText;
@property (nonatomic, copy) NSString * _Nullable unreadMessagesCounterLabelText;
@property (nonatomic) BOOL unreadMessagesCounterHiden;
@property (nonatomic, strong) UIImage * _Nullable dialogIcon;
- (nonnull instancetype)initWithDialog:(QBChatDialog * _Nonnull)dialog OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class IncomingCallViewController;
@class UIBarButtonItem;

SWIFT_CLASS("_TtC11DiabetesApp21DialogsViewController")
@interface DialogsViewController : UITableViewController <QMChatConnectionDelegate, QMAuthServiceDelegate, QMChatServiceDelegate, IncomingCallViewControllerDelegate, QBRTCClientDelegate, QBCoreDelegate>
@property (nonatomic, readonly, strong) AppDelegate * _Nonnull appDelegate;
- (void)awakeFromNib;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (void)didReceiveNewSession:(QBRTCSession * _Null_unspecified)session userInfo:(NSDictionary * _Null_unspecified)userInfo;
- (void)sessionDidClose:(QBRTCSession * _Null_unspecified)session;
- (void)incomingCallViewControllerReject:(IncomingCallViewController * _Null_unspecified)vc didRejectSession:(QBRTCSession * _Null_unspecified)session;
- (void)incomingCallViewControllerAccept:(IncomingCallViewController * _Null_unspecified)vc didAcceptSession:(QBRTCSession * _Null_unspecified)session;
- (void)didEnterBackgroundNotification;
- (UIBarButtonItem * _Nonnull)createLogoutButton;
- (IBAction)GroupAction:(UIBarButtonItem * _Nonnull)sender;
- (IBAction)logoutAction;
- (void)getDialogs;
- (NSArray<QBChatDialog *> * _Nullable)dialogs;
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView * _Nonnull)tableView heightForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (BOOL)tableView:(UITableView * _Nonnull)tableView canEditRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)tableView:(UITableView * _Nonnull)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (NSString * _Nullable)tableView:(UITableView * _Nonnull)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)chatService:(QMChatService * _Nonnull)chatService didUpdateChatDialogInMemoryStorage:(QBChatDialog * _Nonnull)chatDialog;
- (void)chatService:(QMChatService * _Nonnull)chatService didUpdateChatDialogsInMemoryStorage:(NSArray<QBChatDialog *> * _Nonnull)dialogs;
- (void)chatService:(QMChatService * _Nonnull)chatService didAddChatDialogsToMemoryStorage:(NSArray<QBChatDialog *> * _Nonnull)chatDialogs;
- (void)chatService:(QMChatService * _Nonnull)chatService didAddChatDialogToMemoryStorage:(QBChatDialog * _Nonnull)chatDialog;
- (void)chatService:(QMChatService * _Nonnull)chatService didDeleteChatDialogWithIDFromMemoryStorage:(NSString * _Nonnull)chatDialogID;
- (void)chatService:(QMChatService * _Nonnull)chatService didAddMessagesToMemoryStorage:(NSArray<QBChatMessage *> * _Nonnull)messages forDialogID:(NSString * _Nonnull)dialogID;
- (void)chatService:(QMChatService * _Nonnull)chatService didAddMessageToMemoryStorage:(QBChatMessage * _Nonnull)message forDialogID:(NSString * _Nonnull)dialogID;
- (void)chatServiceChatDidFailWithStreamError:(NSError * _Nonnull)error;
- (void)chatServiceChatDidAccidentallyDisconnect:(QMChatService * _Nonnull)chatService;
- (void)chatServiceChatDidConnect:(QMChatService * _Nonnull)chatService;
- (void)chatService:(QMChatService * _Nonnull)chatService chatDidNotConnectWithError:(NSError * _Nonnull)error;
- (void)chatServiceChatDidReconnect:(QMChatService * _Nonnull)chatService;
- (void)reloadTableViewIfNeeded;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC11DiabetesApp21HistoryViewController")
@interface HistoryViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView * _Null_unspecified tblView;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (CGFloat)tableView:(UITableView * _Nonnull)tableView heightForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView;
- (UIView * _Nullable)tableView:(UITableView * _Nonnull)tableView viewForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView * _Nonnull)tableView heightForHeaderInSection:(NSInteger)section;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC11DiabetesApp20HomeTabBarController")
@interface HomeTabBarController : UITabBarController
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC11DiabetesApp19LoginViewController")
@interface LoginViewController : UIViewController <QBCoreDelegate>
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified usernameTxtFld;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified passwordTxtFld;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified doctorBtn;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified patientBtn;
@property (nonatomic, weak) IBOutlet UISegmentedControl * _Null_unspecified segmentUserType;
@property (nonatomic) NSInteger selectedUserType;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)didReceiveMemoryWarning;
- (void)checkLoginStatus;
- (void)navigateToNextScreen;
- (IBAction)SelectUserTypBtns_Click:(id _Nonnull)sender;
- (IBAction)LoginBtn_Click:(id _Nonnull)sender;
- (void)loginToQuickBloxWithLogin:(NSString * _Nonnull)login username:(NSString * _Nonnull)username userID:(NSString * _Nonnull)userID;
- (BOOL)textFieldShouldReturn:(UITextField * _Nonnull)textField;
- (void)registerForRemoteNotification;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC11DiabetesApp22MessagesViewController")
@interface MessagesViewController : UIViewController
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIColor;
@class NSDate;
@class NSError;

/**
  Implements user’s memory/cache storing, error handling, show top bar notifications.
*/
SWIFT_CLASS("_TtC11DiabetesApp15ServicesManager")
@interface ServicesManager : QMServicesManager
@property (nonatomic, copy) NSString * _Nonnull currentDialogID;
@property (nonatomic, copy) NSArray<UIColor *> * _Nonnull colors;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (void)handleNewMessageWithMessage:(QBChatMessage * _Nonnull)message dialogID:(NSString * _Nonnull)dialogID;
@property (nonatomic, strong) NSDate * _Nullable lastActivityDate;
- (void)handleErrorResponse:(QBResponse * _Nonnull)response;
/**
  Download users accordingly to Constants.QB_USERS_ENVIROMENT
  \param successBlock successBlock with sorted [QBUUser] if success

  \param errorBlock errorBlock with error if request is failed

*/
- (void)downloadCurrentEnvironmentUsersWithSuccessBlock:(void (^ _Nullable)(NSArray<QBUUser *> * _Nullable))successBlock errorBlock:(void (^ _Nullable)(NSError * _Nonnull))errorBlock;
- (UIColor * _Nonnull)colorForUser:(QBUUser * _Nonnull)user;
/**
  Sorted users

  returns:
  sorted [QBUUser] from usersService.usersMemoryStorage.unsortedUsers()
*/
- (NSArray<QBUUser *> * _Nullable)sortedUsers;
/**
  Sorted users without current user

  returns:
  [QBUUser]
*/
- (NSArray<QBUUser *> * _Nullable)sortedUsersWithoutCurrentUser;
- (void)chatService:(QMChatService * _Nonnull)chatService didAddMessageToMemoryStorage:(QBChatMessage * _Nonnull)message forDialogID:(NSString * _Nonnull)dialogID;
- (void)logoutUserWithCompletionWithCompletion:(void (^ _Nonnull)(BOOL))completion;
@end

@class UIAlertController;

SWIFT_CLASS("_TtC11DiabetesApp12UtilityClass")
@interface UtilityClass : NSObject
+ (UIAlertController * _Nonnull)displayAlertMessageWithMessage:(NSString * _Nonnull)message title:(NSString * _Nonnull)title viewController:(UIViewController * _Nonnull)viewController;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

#pragma clang diagnostic pop
