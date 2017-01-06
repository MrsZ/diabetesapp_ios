//
//  ChatViewController.swift
//  sample-chat-swift
//
//  Created by Anton Sokolchenko on 4/1/15.
//  Copyright (c) 2015 quickblox. All rights reserved.
//

import CoreTelephony
import SafariServices
import QMChatViewController
import QMServices
import SVProgressHUD

var messageTimeDateFormatter: DateFormatter {
    struct Static {
        static let instance : DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
        }()
    }
    
    return Static.instance
}

extension String {
    var length: Int {
        return (self as NSString).length
    }
}

class ChatViewController: QMChatViewController, QMChatServiceDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, QMChatAttachmentServiceDelegate, QMChatConnectionDelegate, QMChatCellDelegate, QMDeferredQueueManagerDelegate, QMPlaceHolderTextViewPasteDelegate  {
    
    let maxCharactersNumber = 1024 // 0 - unlimited
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let selectedUserType: Int = Int(UserDefaults.standard.integer(forKey: userDefaults.loggedInUserType))
    
    var dialog: QBChatDialog!
    var willResignActiveBlock: AnyObject?
    var attachmentCellsMap: NSMapTable<AnyObject, AnyObject>!
    var detailedCells: Set<String> = []
    
    var typingTimer: Timer?
    var occupantID = Int()
    var occupantUser = QBUUser()
    var groupMembersArray = NSMutableArray()
    
    var topBackView:UIView = UIView()
    
    
    
    
    lazy var imagePickerViewController : UIImagePickerController = {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        
        return imagePickerViewController
    }()
    
    var unreadMessages: [QBChatMessage]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for occupantsID in self.dialog.occupantIDs! {
            print("occupantsID \(occupantsID) userID \(self.dialog.userID)")
            
            if Int(occupantsID) != Int(appDelegate.currentUser!.id) {
                occupantID = Int(occupantsID)
                
                QBRequest.user(withID: UInt(occupantsID), successBlock: { (response, user) in
                    
                    if user != nil {
                        self.occupantUser = user!
                        let dict: NSMutableDictionary = NSMutableDictionary()
                        dict.setValue(user!.id, forKey: "id")
                        dict.setValue(user!.fullName, forKey: "login")
                        self.groupMembersArray.add(dict)
                        
                    }
                    
                }, errorBlock: { (error) in
                    
                })
                break
            }
        }
        
        
       // QBRTCClient.instance().add(self)
        
        
        // top layout inset for collectionView
        self.topContentAdditionalInset = self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.size.height+60.0;
        
        if let currentUser = ServicesManager.instance().currentUser() {
            self.senderID = currentUser.id
            self.senderDisplayName = currentUser.login
            
            self.heightForSectionHeader = 40.0
            
            self.updateTitle()
            
            
            self.collectionView?.backgroundColor = UIColor.white
            self.inputToolbar?.contentView?.backgroundColor = UIColor.white
            self.inputToolbar?.contentView?.textView?.placeHolder = "SA_STR_MESSAGE_PLACEHOLDER".localized
            
            self.attachmentCellsMap = NSMapTable(keyOptions: NSPointerFunctions.Options.strongMemory, valueOptions: NSPointerFunctions.Options.weakMemory)
            
            if self.dialog.type == QBChatDialogType.private {
                
                self.dialog.onUserIsTyping = {
                    [weak self] (userID)-> Void in
                    
                    if ServicesManager.instance().currentUser()?.id == userID {
                        return
                    }
                    
                    self?.title = "SA_STR_TYPING".localized
                }
                
                self.dialog.onUserStoppedTyping = {
                    [weak self] (userID)-> Void in
                    
                    if ServicesManager.instance().currentUser()?.id == userID {
                        return
                    }
                    
                    self?.updateTitle()
                }
            }
            
            // Retrieving messages
            if (self.storedMessages()?.count ?? 0 > 0 && self.chatDataSource.messagesCount() == 0) {
                
                self.chatDataSource.add(self.storedMessages()!)
            }
            
            self.loadMessages()
            
            self.enableTextCheckingTypes = NSTextCheckingAllTypes
        }
        
       
        // HeaderView
        let screenSize: CGRect = UIScreen.main.bounds
        let headerLbl: UILabel = UILabel(frame:  CGRect(x: 0, y: 64, width: screenSize.width, height: 30.0))
        headerLbl.backgroundColor = Colors.chatHeaderColor
        headerLbl.text = "Health Card Number = HC12345678"
        headerLbl.font = Fonts.healthCardFont
        headerLbl.textColor = UIColor.gray
        headerLbl.textAlignment = .center
        self.view.addSubview(headerLbl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        // set Navigation Bar
        
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.hidesBackButton = true
        
        let optionsBtnBar: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "options"), style: UIBarButtonItemStyle.plain , target: self, action: #selector(optionsClick))
        
        if self.dialog.type == .private {
            
            let callBtnBar: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Call"), style: UIBarButtonItemStyle.plain , target: self, action: #selector(videoAudioClick))
            
            if selectedUserType != userType.patient {
                
                self.navigationItem.rightBarButtonItems = [optionsBtnBar,callBtnBar]
                self.tabBarController?.navigationItem.rightBarButtonItems = [optionsBtnBar,callBtnBar]
                
            }
        }
        
        else if self.dialog.type == .group && selectedUserType != userType.patient {
            
            self.navigationItem.rightBarButtonItems = [optionsBtnBar]
        }
        
        //let backBtn: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action:  #selector(BackBtn_Click))
        
        //self.navigationItem.leftBarButtonItem = backBtn
        //self.tabBarController?.navigationItem.leftBarButtonItem = backBtn
        
        createCustomTopView()
        
        self.title = self.dialog.name
        self.tabBarController?.navigationItem.title = self.dialog.name
        
        ServicesManager.instance().chatService.addDelegate(self)
        ServicesManager.instance().chatService.chatAttachmentService.delegate = self
        
        self.queueManager().add(self)
        
        self.willResignActiveBlock = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillResignActive, object: nil, queue: nil) { [weak self] (notification) in
            
            self?.fireSendStopTypingIfNecessary()
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Saving current dialog ID.
        ServicesManager.instance().currentDialogID = self.dialog.id!
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        topBackView.removeFromSuperview()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
        if let willResignActive = self.willResignActiveBlock {
            NotificationCenter.default.removeObserver(willResignActive)
        }
        
        // Resetting current dialog ID.
        ServicesManager.instance().currentDialogID = ""
        
        // clearing typing status blocks
        self.dialog.clearTypingStatusBlocks()
        ServicesManager.instance().chatService.removeDelegate(self)
        ServicesManager.instance().chatService.chatAttachmentService.delegate = nil
      
        self.queueManager().remove(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if let chatInfoViewController = segue.destination as? ChatUsersInfoTableViewController {
//            chatInfoViewController.dialog = self.dialog
//        }
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Get groupmember Name
    func getGroupMemberName(occupant_id: Int)->String {
       
        for dict in groupMembersArray {
            let obj: NSMutableDictionary = dict as! NSMutableDictionary
            let id: String = "\(obj.value(forKey: "id")!)"
            if id == String(occupant_id) {
                return String(describing: obj.value(forKey: "login")!)
            }
        }
        return ""
    }
    
    // MARK: - Custom Top View
    func createCustomTopView() {
        
        topBackView = UIView(frame: CGRect(x: 0, y: 0, width: 74, height: 40))
        topBackView.backgroundColor = UIColor(patternImage: UIImage(named: "topBackBtn")!)
        let userImgView: UIImageView = UIImageView(frame: CGRect(x: 35, y: 3, width: 34, height: 34))
        userImgView.image = UIImage(named: "user.png")
        topBackView.addSubview(userImgView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(BackBtn_Click))
        topBackView.addGestureRecognizer(tapGesture)
        topBackView.isUserInteractionEnabled = true
        
        self.navigationController?.navigationBar.addSubview(topBackView)
        self.tabBarController?.navigationController?.navigationBar.addSubview(topBackView)
    }
    
    func BackBtn_Click(){
        self.navigationController?.popViewController(animated: true)
    }

    
    // MARK: Update
    func updateTitle() {
        
        if self.dialog.type != QBChatDialogType.private {
            
            self.title = self.dialog.name
        }
        else {
            
            if let recipient = ServicesManager.instance().usersService.usersMemoryStorage.user(withID: UInt(self.dialog!.recipientID)) {
                
                self.title = recipient.login
            }
        }
    }
    
    func storedMessages() -> [QBChatMessage]? {
        return ServicesManager.instance().chatService.messagesMemoryStorage.messages(withDialogID: self.dialog.id!)
    }
    
    func loadMessages() {
        // Retrieving messages for chat dialog ID.
        guard let currentDialogID = self.dialog.id else {
            print ("Current chat dialog is nil")
            return
        }
        
        ServicesManager.instance().chatService.messages(withChatDialogID: currentDialogID, completion: {
            [weak self] (response, messages) -> Void in
            
            guard let strongSelf = self else { return }
            
            guard response.error == nil else {
                SVProgressHUD.showError(withStatus: response.error?.error?.localizedDescription)
                return
            }
            
            if messages?.count ?? 0 > 0 {
                strongSelf.chatDataSource.add(messages)
            }
            
            SVProgressHUD.dismiss()
            })
    }
    
    func sendReadStatusForMessage(message: QBChatMessage) {
        
        guard QBSession.current().currentUser != nil else {
            return
        }
        guard message.senderID != QBSession.current().currentUser?.id else {
            return
        }
        
        if self.messageShouldBeRead(message: message) {
            ServicesManager.instance().chatService.read(message, completion: { (error) -> Void in
                
                guard error == nil else {
                    print("Problems while marking message as read! Error: %@", error!)
                    return
                }
                
                if UIApplication.shared.applicationIconBadgeNumber > 0 {
                    let badgeNumber = UIApplication.shared.applicationIconBadgeNumber
                    UIApplication.shared.applicationIconBadgeNumber = badgeNumber - 1
                }
            })
        }
    }
    
    func messageShouldBeRead(message: QBChatMessage) -> Bool {
        
        let currentUserID = NSNumber(value: QBSession.current().currentUser!.id as UInt)
        
        return !message.isDateDividerMessage
            && message.senderID != self.senderID
            && !(message.readIDs?.contains(currentUserID))!
    }
    
    func readMessages(messages: [QBChatMessage]) {
        
        if QBChat.instance().isConnected {
            
            ServicesManager.instance().chatService.read(messages, forDialogID: self.dialog.id!, completion: nil)
        }
        else {
            
            self.unreadMessages = messages
        }
        
        var messageIDs = [String]()
        
        for message in messages {
            messageIDs.append(message.id!)
        }
    }
    
    // MARK: - Right Buttons Actions
    func optionsClick() {
        
        let actionSheet = UIAlertController(title: "", message: "Select Option", preferredStyle: .actionSheet)
        let patientInfoBtn: UIAlertAction = UIAlertAction(title: ChatInfo.patientInfo, style: .default, handler: { (UIAlertAction)in
            
        })
        
        let readingHistoryBtn: UIAlertAction = UIAlertAction(title: ChatInfo.readingHistory, style: .default, handler: { (UIAlertAction)in
            
            let historyViewController: HistoryMainViewController = self.storyboard?.instantiateViewController(withIdentifier: ViewIdentifiers.historyMainViewController) as! HistoryMainViewController
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
            self.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(historyViewController, animated: true)
            
        })
        
        let carePlanBtn: UIAlertAction = UIAlertAction(title: ChatInfo.carePlan, style: .default, handler: { (UIAlertAction)in
            
            let carePlanViewController: CarePlanMainViewController = self.storyboard?.instantiateViewController(withIdentifier: ViewIdentifiers.carePlanViewController) as! CarePlanMainViewController
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
            self.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(carePlanViewController, animated: true)
        })
        
        let cancelBtn: UIAlertAction = UIAlertAction(title: GeneralLabels.cancel, style: .cancel, handler: { (UIAlertAction)in
        })
        
        
//        let attributedString = NSAttributedString(string: "Title", attributes: [
//            NSFontAttributeName : Fonts.SFTextRegularFont ,
//            NSForegroundColorAttributeName : UIColor.white
//            ])
        
        // Set Images
        patientInfoBtn.setValue((UIImage(named: "option_patientInfo")?.withRenderingMode(.alwaysOriginal)) , forKey: "image")
        readingHistoryBtn.setValue((UIImage(named: "option_history")?.withRenderingMode(.alwaysOriginal)) , forKey: "image")
        carePlanBtn.setValue((UIImage(named: "option_careplan")?.withRenderingMode(.alwaysOriginal)) , forKey: "image")
        
        actionSheet.addAction(patientInfoBtn)
        actionSheet.addAction(readingHistoryBtn)
        actionSheet.addAction(carePlanBtn)
        actionSheet.addAction(cancelBtn)
        
        actionSheet.view.tintColor = UIColor.black
        
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = NSTextAlignment.left
//        
//        let messageText = NSMutableAttributedString(
//            string: ChatInfo.patientInfo,
//            attributes: [
//                NSParagraphStyleAttributeName: paragraphStyle,
//                NSFontAttributeName : UIFont.preferredFont(forTextStyle: UIFontTextStyle.body),
//                NSForegroundColorAttributeName : UIColor.gray
//            ]
//        )
        
//        patientInfoBtn.setValue(messageText, forKey: "attributedMessage")
//        readingHistoryBtn.setValue(messageText, forKey: "attributedMessage")
//        carePlanBtn.setValue(messageText, forKey: "attributedMessage")
//        cancelBtn.setValue(messageText, forKey: "attributedMessage")
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func videoAudioClick() {
        
        let actionSheet = UIAlertController(title: "", message: "Select Option", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: VideoAudioCall.audioCall , style: .default , handler:{ (UIAlertAction)in
            
            self.callWithConferenceType(conferenceType: .audio)
        }))
        
        actionSheet.addAction(UIAlertAction(title: VideoAudioCall.videoCall, style: .default , handler:{ (UIAlertAction)in
            self.callWithConferenceType(conferenceType: .video)
        }))
        
        actionSheet.addAction(UIAlertAction(title: GeneralLabels.cancel, style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
            
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    //MARK: - Webrtc
    
    
    func callWithConferenceType(conferenceType: QBRTCConferenceType) {
        if (appDelegate.session != nil) {
            return
        }
        
        
        QBAVCallPermissions.check(with: conferenceType) { (granted) in
            
            if granted {
                
                let session = QBRTCClient.instance().createNewSession(withOpponents: [UInt(self.occupantID)], with: conferenceType)
                
                if session != nil {
                    
                    QBRequest.user(withID: UInt(self.occupantID), successBlock: { (response, user) in
                        
                        self.appDelegate.session = session;
                        let callViewController: CallViewController = self.storyboard?.instantiateViewController(withIdentifier: "CallViewController") as! CallViewController
                        
                        callViewController.currentUser = self.appDelegate.currentUser
                        callViewController.session = self.appDelegate.session
                        callViewController.qbUsersArray = NSMutableArray(object: user! as QBUUser)
                        self.navigationController?.pushViewController(callViewController, animated: true)
                        
                    }, errorBlock: { (error) in
                        
                    })
                    
                }
                else {
                    
                }
                
            }
        }
    }
    
//    //MARK: - QBRTCClientDelegate Delegate
//    func didReceiveNewSession(_ session: QBRTCSession!, userInfo: [AnyHashable : Any]! = [:]) {
//        
//        if (self.session != nil) {
//            session.rejectCall(["reject":"busy"])
//            return
//        }
//        
//        self.session = session
//        QBRTCSoundRouter.instance().initialize()
//        
//        
//        QBRequest.user(withID:session.initiatorID as UInt , successBlock: { (response, user) in
//            
//            let incomingViewController: IncomingCallViewController = self.storyboard?.instantiateViewController(withIdentifier: "IncomingCallViewController") as! IncomingCallViewController
//            incomingViewController.delegate = self
//            incomingViewController.session = self.session
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            incomingViewController.currentUser = appDelegate.currentUser
//            incomingViewController.qbUsersArray = NSMutableArray(object: user)
//            //self.present(incomingViewController, animated: true, completion: nil)
//            self.navigationController?.pushViewController(incomingViewController, animated: true)
//            
//        }) { (eroor) in
//            
//        }
//        
//    }
//    
//    func sessionDidClose(_ session: QBRTCSession!) {
//        
//        if session == self.session {
//            self.navigationController?.popToViewController(self, animated: true)
//            //self.navigationController?.popViewController(animated: true)
//            //self.dismiss(animated: true, completion: nil)
//            self.session = nil
//            
//        }
//
//    }
//    
//    
//    //MARK: - IncomingCall Delegate
//    func incomingCallViewControllerReject(_ vc: IncomingCallViewController!, didReject session: QBRTCSession!) {
//        
//        session.rejectCall(nil)
//        //self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    func incomingCallViewControllerAccept(_ vc: IncomingCallViewController!, didAccept session: QBRTCSession!) {
//        
//        QBRequest.user(withID:session.initiatorID as UInt , successBlock: { (response, user) in
//            
//            let callViewController: CallViewController = self.storyboard?.instantiateViewController(withIdentifier: "CallViewController") as! CallViewController
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            callViewController.currentUser = appDelegate.currentUser
//            callViewController.session = self.session
//            callViewController.qbUsersArray = NSMutableArray(object: user)
//           // self.present(callViewController, animated: true, completion: nil)
//            self.navigationController?.pushViewController(callViewController, animated: true)
//            
//        }) { (eroor) in
//            
//        }
//    }
    
    
    // MARK: Actions
    override func didPickAttachmentImage(_ image: UIImage!) {
        
        let message = QBChatMessage()
        message.senderID = self.senderID
        message.dialogID = self.dialog.id
        message.dateSent = Date()
        
        DispatchQueue.global().async { [weak self] () -> Void in
            
            guard let strongSelf = self else { return }
            
            var newImage : UIImage! = image
            if strongSelf.imagePickerViewController.sourceType == UIImagePickerControllerSourceType.camera {
                //newImage = newImage.fixOrientation()
            }
            
            let largestSide = newImage.size.width > newImage.size.height ? newImage.size.width : newImage.size.height
            let scaleCoeficient = largestSide/560.0
            let newSize = CGSize(width: newImage.size.width/scaleCoeficient, height: newImage.size.height/scaleCoeficient)
            
            // create smaller image
            
            UIGraphicsBeginImageContext(newSize)
            
            newImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            // Sending attachment.
            DispatchQueue.main.async(execute: {
                self?.chatDataSource.add(message)
                // sendAttachmentMessage method always firstly adds message to memory storage
                ServicesManager.instance().chatService.sendAttachmentMessage(message, to: self!.dialog, withAttachmentImage: resizedImage!, completion: {
                    [weak self] (error) -> Void in
                    
                    self?.attachmentCellsMap.removeObject(forKey: message.id as AnyObject?)
                    
                    guard error != nil else { return }
                    
                    self?.chatDataSource.delete(message)
                    })
            })
        }
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: UInt, senderDisplayName: String!, date: Date!) {

        if !self.queueManager().shouldSendMessagesInDialog(withID: self.dialog.id!) {
            return
        }
        self.fireSendStopTypingIfNecessary()
        
        let message = QBChatMessage()
        message.text = text
        message.senderID = self.senderID
        message.deliveredIDs = [(NSNumber(value: self.senderID))]
        message.readIDs = [(NSNumber(value: self.senderID))]
        message.markable = true
        message.dateSent = date
        
        self.sendMessage(message: message)
    }
    
    override func didPressSend(_ button: UIButton!, withTextAttachments textAttachments: [Any]!, senderId: UInt, senderDisplayName: String!, date: Date!) {
        
        if let attachment = textAttachments.first as? NSTextAttachment {
            
            if (attachment.image != nil) {
                let message = QBChatMessage()
                message.senderID = self.senderID
                message.dialogID = self.dialog.id
                message.dateSent = Date()
                ServicesManager.instance().chatService.sendAttachmentMessage(message, to: self.dialog, withAttachmentImage: attachment.image!, completion: {
                    [weak self] (error: Error?) -> Void in
                    
                    self?.attachmentCellsMap.removeObject(forKey: message.id as AnyObject?)
                    
                    guard error != nil else { return }
                    
                    // perform local attachment message deleting if error
                    ServicesManager.instance().chatService.deleteMessageLocally(message)
                    
                    self?.chatDataSource.delete(message)
                    
                    })
                
                self.finishSendingMessage(animated: true)
            }
        }
    }
    
    
    func sendMessage(message: QBChatMessage) {
        
        // Sending message.
        ServicesManager.instance().chatService.send(message, toDialogID: self.dialog.id!, saveToHistory: true, saveToStorage: true) { (error) ->
            Void in
            
            if error != nil {
                
                QMMessageNotificationManager.showNotification(withTitle: "SA_STR_ERROR".localized, subtitle: error?.localizedDescription, type: QMMessageNotificationType.warning)
            }
           let pushMessage =  QBMPushMessage()
            pushMessage.alertBody = self.dialog.name! + " : " + message.text!
            //pushMessage.badge = 1
            
            QBRequest .sendPush(pushMessage, toUsers: String(self.dialog.userID), successBlock: { (response, event) in
                
            }, errorBlock: { (error) in
                
            })
//            QBRequest.sendPush(withText: message.text!, toUsers: String(self.dialog.userID) , successBlock: { (response, event) in
//                print(response)
//                
//            }) { (error) in
//                print(error!)
//            }
        }
        
        self.finishSendingMessage(animated: true)
    }
    
    // MARK: Helper
    func canMakeACall() -> Bool {
        
        var canMakeACall = false
        
        if (UIApplication.shared.canOpenURL(URL.init(string: "tel://")!)) {
            
            // Check if iOS Device supports phone calls
            let networkInfo = CTTelephonyNetworkInfo()
            let carrier = networkInfo.subscriberCellularProvider
            if carrier == nil {
                return false
            }
            let mnc = carrier?.mobileNetworkCode
            if mnc?.length == 0 {
                // Device cannot place a call at this time.  SIM might be removed.
            }
            else {
                // iOS Device is capable for making calls
                canMakeACall = true
            }
        }
        else {
            // iOS Device is not capable for making calls
        }
        
        return canMakeACall
    }
    
    func placeHolderTextView(_ textView: QMPlaceHolderTextView, shouldPasteWithSender sender: Any) -> Bool {
        
        if UIPasteboard.general.image != nil {
            
            let textAttachment = NSTextAttachment()
            textAttachment.image = UIPasteboard.general.image!
            textAttachment.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
            
            let attrStringWithImage = NSAttributedString.init(attachment: textAttachment)
            self.inputToolbar.contentView.textView.attributedText = attrStringWithImage
            self.textViewDidChange(self.inputToolbar.contentView.textView)
            
            return false
        }
        
        return true
    }
    
    func showCharactersNumberError() {
        let title  = "SA_STR_ERROR".localized;
        let subtitle = String(format: "The character limit is %lu.", maxCharactersNumber)
        QMMessageNotificationManager.showNotification(withTitle: title, subtitle: subtitle, type: .error)
    }
    
    /**
     Builds a string
     Read: login1, login2, login3
     Delivered: login1, login3, @12345
     
     If user does not exist in usersMemoryStorage, then ID will be used instead of login
     
     - parameter message: QBChatMessage instance
     
     - returns: status string
     */
    func statusStringFromMessage(message: QBChatMessage) -> String {
        
        var statusString = ""
        
        let currentUserID = NSNumber(value:self.senderID)
        
        var readLogins: [String] = []
        
        if message.readIDs != nil {
            
            let messageReadIDs = message.readIDs!.filter { (element) -> Bool in
                
                return !element.isEqual(to: currentUserID)
            }
            
            if !messageReadIDs.isEmpty {
                for readID in messageReadIDs {
                    let user = ServicesManager.instance().usersService.usersMemoryStorage.user(withID: UInt(readID))
                    
                    guard let unwrappedUser = user else {
                        
                        let name: String = getGroupMemberName(occupant_id: Int(readID))
                        if name != "" {
                             readLogins.append(name)
                        }
                        else {
                            let unknownUserLogin = "@\(readID)"
                            readLogins.append(unknownUserLogin)
                        }
                        
                        continue
                    }
                    
                    readLogins.append(unwrappedUser.fullName!)
                }
                
                statusString += message.isMediaMessage() ? "SA_STR_SEEN_STATUS".localized : "SA_STR_READ_STATUS".localized;
                statusString += ": " + readLogins.joined(separator: ", ")
            }
        }
        
        if message.deliveredIDs != nil {
            var deliveredLogins: [String] = []
            
            let messageDeliveredIDs = message.deliveredIDs!.filter { (element) -> Bool in
                return !element.isEqual(to: currentUserID)
            }
            
            if !messageDeliveredIDs.isEmpty {
                for deliveredID in messageDeliveredIDs {
                    let user = ServicesManager.instance().usersService.usersMemoryStorage.user(withID: UInt(deliveredID))
                    
                    guard let unwrappedUser = user else {
                        
                        let name: String = getGroupMemberName(occupant_id: Int(deliveredID))
                        if name != "" {
                            deliveredLogins.append(name)
                        }
                        else {
                            let unknownUserLogin = "@\(deliveredID)"
                            deliveredLogins.append(unknownUserLogin)
                        }
                        
                        continue
                    }
                    
                    if readLogins.contains(unwrappedUser.fullName!) {
                        continue
                    }
                    
                    deliveredLogins.append(unwrappedUser.fullName!)
                    
                }
                
                if readLogins.count > 0 && deliveredLogins.count > 0 {
                    statusString += "\n"
                }
                
                if deliveredLogins.count > 0 {
                    statusString += "SA_STR_DELIVERED_STATUS".localized + ": " + deliveredLogins.joined(separator: ", ")
                }
            }
        }
        
        if statusString.isEmpty {
            
            let messageStatus: QMMessageStatus = self.queueManager().status(for: message)
            
            switch messageStatus {
            case .sent:
                statusString = "SA_STR_SENT_STATUS".localized
            case .sending:
                statusString = "SA_STR_SENDING_STATUS".localized
            case .notSent:
                statusString = "SA_STR_NOT_SENT_STATUS".localized
            }
            
        }
        
        return statusString
    }
    
    // MARK: Override
    
    override func viewClass(forItem item: QBChatMessage) -> AnyClass? {
        // TODO: check and add QMMessageType.AcceptContactRequest, QMMessageType.RejectContactRequest, QMMessageType.ContactRequest
        
        if item.isNotificatonMessage() || item.isDateDividerMessage {
            return QMChatNotificationCell.self
        }
        
        if (item.senderID != self.senderID) {
            
            if (item.isMediaMessage() && item.attachmentStatus != QMMessageAttachmentStatus.error) {
                
                return QMChatAttachmentIncomingCell.self
                
            }
            else {
                
                return QMChatIncomingCell.self
            }
            
        }
        else {
            
            if (item.isMediaMessage() && item.attachmentStatus != QMMessageAttachmentStatus.error) {
                
                return QMChatAttachmentOutgoingCell.self
                
            }
            else {
                
                return QMChatOutgoingCell.self
            }
        }
    }
    
    // MARK: Strings builder
    
    override func attributedString(forItem messageItem: QBChatMessage!) -> NSAttributedString? {
        
        guard messageItem.text != nil else {
            return nil
        }
        
        var textColor = messageItem.senderID == self.senderID ? UIColor.white : UIColor.gray
        if messageItem.isNotificatonMessage() || messageItem.isDateDividerMessage {
            textColor = UIColor.gray
        }
        
        var attributes = Dictionary<String, AnyObject>()
        attributes[NSForegroundColorAttributeName] = textColor
        attributes[NSFontAttributeName] = Fonts.SFTextMediumFont
        
        let attributedString = NSAttributedString(string: messageItem.text!, attributes: attributes)
        
        return attributedString
    }
    
    
    /**
     Creates top label attributed string from QBChatMessage
     
     - parameter messageItem: QBCHatMessage instance
     
     - returns: login string, example: @SwiftTestDevUser1
     */
    override func topLabelAttributedString(forItem messageItem: QBChatMessage!) -> NSAttributedString? {
        
        guard messageItem.senderID != self.senderID else {
            return nil
        }
        
        guard self.dialog.type != QBChatDialogType.private else {
            return nil
        }
        
        let paragrpahStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragrpahStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        var attributes = Dictionary<String, AnyObject>()
        attributes[NSForegroundColorAttributeName] = UIColor(red: 11.0/255.0, green: 96.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        attributes[NSFontAttributeName] = Fonts.healthCardFont
        attributes[NSParagraphStyleAttributeName] = paragrpahStyle
        
        var topLabelAttributedString : NSAttributedString?
        
        if let topLabelText = ServicesManager.instance().usersService.usersMemoryStorage.user(withID: messageItem.senderID)?.fullName {
            topLabelAttributedString = NSAttributedString(string: topLabelText, attributes: attributes)
        } else { // no user in memory storage
            
             topLabelAttributedString = NSAttributedString(string: getGroupMemberName(occupant_id: Int(messageItem.senderID)), attributes: attributes)
             //topLabelAttributedString = NSAttributedString(string: "@\(messageItem.senderID)", attributes: attributes)
        }
        
        return topLabelAttributedString
    }
    
    /**
     Creates bottom label attributed string from QBChatMessage using self.statusStringFromMessage
     
     - parameter messageItem: QBChatMessage instance
     
     - returns: bottom label status string
     */
    override func bottomLabelAttributedString(forItem messageItem: QBChatMessage!) -> NSAttributedString! {
        
        let textColor = messageItem.senderID == self.senderID ? UIColor.white : UIColor.black
        
        let paragrpahStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragrpahStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        var attributes = Dictionary<String, AnyObject>()
        attributes[NSForegroundColorAttributeName] = textColor
        attributes[NSFontAttributeName] = Fonts.healthCardFont
        attributes[NSParagraphStyleAttributeName] = paragrpahStyle
        
        var text = messageItem.dateSent != nil ? messageTimeDateFormatter.string(from: messageItem.dateSent!) : ""
        
        if messageItem.senderID == self.senderID {
            text = text + "\n" + self.statusStringFromMessage(message: messageItem)
        }
        
        let bottomLabelAttributedString = NSAttributedString(string: text, attributes: attributes)
        
        return bottomLabelAttributedString
    }
    
    
    // MARK: Collection View Datasource
//    override func collectionView(_ collectionView: QMChatCollectionView!, sectionHeaderAt indexPath: IndexPath!) -> UICollectionReusableView! {
//        
//        let headerView: QMHeaderCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: QMHeaderCollectionReusableView.cellReuseIdentifier(), for: indexPath) as! QMHeaderCollectionReusableView
//        headerView.headerLabel.text = "test"
//        return headerView
//        
//    }
    
    override func collectionView(_ collectionView: QMChatCollectionView!, dynamicSizeAt indexPath: IndexPath!, maxWidth: CGFloat) -> CGSize {
        
        var size = CGSize.zero
        
        guard let message = self.chatDataSource.message(for: indexPath) else {
            return size
        }
        
        let messageCellClass: AnyClass! = self.viewClass(forItem: message)
        
        
        if messageCellClass === QMChatAttachmentIncomingCell.self {
            
            size = CGSize(width: min(200, maxWidth), height: 200)
        }
        else if messageCellClass === QMChatAttachmentOutgoingCell.self {
            
            let attributedString = self.bottomLabelAttributedString(forItem: message)
            
            let bottomLabelSize = TTTAttributedLabel.sizeThatFitsAttributedString(attributedString, withConstraints: CGSize(width: min(200, maxWidth), height: CGFloat.greatestFiniteMagnitude), limitedToNumberOfLines: 0)
            size = CGSize(width: min(200, maxWidth), height: 200 + ceil(bottomLabelSize.height))
        }
        else if messageCellClass === QMChatNotificationCell.self {
            
            let attributedString = self.attributedString(forItem: message)
            size = TTTAttributedLabel.sizeThatFitsAttributedString(attributedString, withConstraints: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), limitedToNumberOfLines: 0)
        }
        else {
            
            let attributedString = self.attributedString(forItem: message)
            
            size = TTTAttributedLabel.sizeThatFitsAttributedString(attributedString, withConstraints: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), limitedToNumberOfLines: 0)
        }
        
        return size
    }
    
    override func collectionView(_ collectionView: QMChatCollectionView!, minWidthAt indexPath: IndexPath!) -> CGFloat {
        
        var size = CGSize.zero
        
        guard let item = self.chatDataSource.message(for: indexPath) else {
            return 0
        }
        
        if self.detailedCells.contains(item.id!) {
            
            let str = self.bottomLabelAttributedString(forItem: item)
            let frameWidth = collectionView.frame.width
            let maxHeight = CGFloat.greatestFiniteMagnitude
            
            size = TTTAttributedLabel.sizeThatFitsAttributedString(str, withConstraints: CGSize(width:frameWidth - kMessageContainerWidthPadding, height: maxHeight), limitedToNumberOfLines:0)
        }
        
        if self.dialog.type != QBChatDialogType.private {
            
            let topLabelSize = TTTAttributedLabel.sizeThatFitsAttributedString(self.topLabelAttributedString(forItem: item), withConstraints: CGSize(width: collectionView.frame.width - kMessageContainerWidthPadding, height: CGFloat.greatestFiniteMagnitude), limitedToNumberOfLines:0)
            
            if topLabelSize.width > size.width {
                size = topLabelSize
            }
        }
        
        return size.width
    }
    
    override func collectionView(_ collectionView: QMChatCollectionView!, layoutModelAt indexPath: IndexPath!) -> QMChatCellLayoutModel {
        
        var layoutModel: QMChatCellLayoutModel = super.collectionView(collectionView, layoutModelAt: indexPath)
        
        layoutModel.avatarSize = CGSize(width: 0, height: 0)
        layoutModel.topLabelHeight = 0.0
        layoutModel.spaceBetweenTextViewAndBottomLabel = 5
        layoutModel.maxWidthMarginSpace = 20.0
        
        guard let item = self.chatDataSource.message(for: indexPath) else {
            return layoutModel
        }
        
        let viewClass: AnyClass = self.viewClass(forItem: item)! as AnyClass
        
        if viewClass === QMChatIncomingCell.self || viewClass === QMChatAttachmentIncomingCell.self {
            
            if self.dialog.type != QBChatDialogType.private {
                let topAttributedString = self.topLabelAttributedString(forItem: item)
                let size = TTTAttributedLabel.sizeThatFitsAttributedString(topAttributedString, withConstraints: CGSize(width: collectionView.frame.width - kMessageContainerWidthPadding, height: CGFloat.greatestFiniteMagnitude), limitedToNumberOfLines:1)
                layoutModel.topLabelHeight = size.height
            }
            
            layoutModel.spaceBetweenTopLabelAndTextView = 5
        }
        
        var size = CGSize.zero
        
        if self.detailedCells.contains(item.id!) {
            
            let bottomAttributedString = self.bottomLabelAttributedString(forItem: item)
            size = TTTAttributedLabel.sizeThatFitsAttributedString(bottomAttributedString, withConstraints: CGSize(width: collectionView.frame.width - kMessageContainerWidthPadding, height: CGFloat.greatestFiniteMagnitude), limitedToNumberOfLines:0)
        }
        
        layoutModel.bottomLabelHeight = floor(size.height)
        
        
        return layoutModel
    }
    
    override func collectionView(_ collectionView: QMChatCollectionView!, configureCell cell: UICollectionViewCell!, for indexPath: IndexPath!) {
        
        super.collectionView(collectionView, configureCell: cell, for: indexPath)
        
        // subscribing to cell delegate
        let chatCell = cell as! QMChatCell
        
        chatCell.delegate = self
        
        let message = self.chatDataSource.message(for: indexPath)
        
        if let attachmentCell = cell as? QMChatAttachmentCell {
            
            if attachmentCell is QMChatAttachmentIncomingCell {
                 chatCell.containerView?.bgColor = Colors.incomingMSgColor
                //chatCell.containerView?.bgColor = UIColor(red: 226.0/255.0, green: 226.0/255.0, blue: 226.0/255.0, alpha: 1.0)
            }
            else if attachmentCell is QMChatAttachmentOutgoingCell {
                chatCell.containerView?.bgColor = Colors.outgoingMsgColor
                //chatCell.containerView?.bgColor = UIColor(red: 10.0/255.0, green: 95.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            }
            
            if let attachment = message?.attachments?.first {
                
                var keysToRemove: [String] = []
                
                let enumerator = self.attachmentCellsMap.keyEnumerator()
                
                while let existingAttachmentID = enumerator.nextObject() as? String {
                    let cachedCell = self.attachmentCellsMap.object(forKey: existingAttachmentID as AnyObject?)
                    if cachedCell === cell {
                        keysToRemove.append(existingAttachmentID)
                    }
                }
                
                for key in keysToRemove {
                    self.attachmentCellsMap.removeObject(forKey: key as AnyObject?)
                }
                
                self.attachmentCellsMap.setObject(attachmentCell, forKey: attachment.id as AnyObject?)
                
                attachmentCell.attachmentID = attachment.id
                
                // Getting image from chat attachment cache.
                
                ServicesManager.instance().chatService.chatAttachmentService.image(forAttachmentMessage: message!, completion: { [weak self] (error, image) in
                    
                    guard attachmentCell.attachmentID == attachment.id else {
                        return
                    }
                    
                    self?.attachmentCellsMap.removeObject(forKey: attachment.id as AnyObject?)
                    
                    guard error == nil else {
                        SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        print("Error downloading image from server: \(error).localizedDescription")
                        return
                    }
                    
                    if image == nil {
                        print("Image is nil")
                    }
                    
                    attachmentCell.setAttachmentImage(image)
                    cell.updateConstraints()
                    })
            }
            
        }
        else if cell is QMChatIncomingCell || cell is QMChatAttachmentIncomingCell {
            chatCell.containerView?.bgColor = Colors.incomingMSgColor
            
           // chatCell.containerView?.bgColor = UIColor(red: 226.0/255.0, green: 226.0/255.0, blue: 226.0/255.0, alpha: 1.0)
        }
        else if cell is QMChatOutgoingCell {
            
            let status: QMMessageStatus = self.queueManager().status(for: message!)
            
            switch status {
            case .sent:
                 chatCell.containerView?.bgColor = Colors.outgoingMsgColor
                //chatCell.containerView?.bgColor = UIColor(red: 10.0/255.0, green: 95.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            case .sending:
                chatCell.containerView?.bgColor = UIColor(red: 166.3/255.0, green: 171.5/255.0, blue: 171.8/255.0, alpha: 1.0)
            case .notSent:
                chatCell.containerView?.bgColor = UIColor(red: 254.6/255.0, green: 30.3/255.0, blue: 12.5/255.0, alpha: 1.0)
            }
            
        }
        else if cell is QMChatAttachmentOutgoingCell {
            chatCell.containerView?.bgColor = Colors.outgoingMsgColor
           // chatCell.containerView?.bgColor = UIColor(red: 10.0/255.0, green: 95.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
        else if cell is QMChatNotificationCell {
            cell.isUserInteractionEnabled = false
            chatCell.containerView?.bgColor = self.collectionView?.backgroundColor
        }
    }
    
    /**
     Allows to copy text from QMChatIncomingCell and QMChatOutgoingCell
     */
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        
        guard let item = self.chatDataSource.message(for: indexPath) else {
            return false
        }
        
        let viewClass: AnyClass = self.viewClass(forItem: item)! as AnyClass
        
        if  viewClass === QMChatNotificationCell.self ||
            viewClass === QMChatContactRequestCell.self {
            return false
        }
        
        return super.collectionView(collectionView, canPerformAction: action, forItemAt: indexPath, withSender: sender)
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
        let item = self.chatDataSource.message(for: indexPath)
        
        if (item?.isMediaMessage())! {
            ServicesManager.instance().chatService.chatAttachmentService.localImage(forAttachmentMessage: item!, completion: { (error: Error?,image: UIImage?) in
                
                guard error == nil else {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    return
                }
                
                if image != nil {
                    guard let imageData = UIImageJPEGRepresentation(image!, 1) else { return }
                    
                    let pasteboard = UIPasteboard.general
                    
                    //pasteboard.setValue(imageData, forPasteboardType:kUTTypeJPEG as String)
                }
            })
        }
        else {
            UIPasteboard.general.string = item?.text
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let lastSection = self.collectionView!.numberOfSections - 1
        
        if (indexPath.section == lastSection && indexPath.item == (self.collectionView?.numberOfItems(inSection: lastSection))! - 1) {
            // the very first message
            // load more if exists
            // Getting earlier messages for chat dialog identifier.
            
            guard let dialogID = self.dialog.id else {
                print("DialogID is nil")
                return super.collectionView(collectionView, cellForItemAt: indexPath)
            }
            
            ServicesManager.instance().chatService.loadEarlierMessages(withChatDialogID: dialogID).continue({ [weak self] (task) -> Any? in
                
                guard let strongSelf = self else { return nil }
                
                if (task.result?.count ?? 0 > 0) {
                    
                    strongSelf.chatDataSource.add(task.result as! [QBChatMessage]!)
                }
                
                return nil
                })
        }
        
        // marking message as read if needed
        if let message = self.chatDataSource.message(for: indexPath) {
            self.sendReadStatusForMessage(message: message)
        }
        
        return super.collectionView(collectionView, cellForItemAt
            : indexPath)
    }
    
    
    // MARK: QMChatCellDelegate
    
    /**
     Removes size from cache for item to allow cell expand and show read/delivered IDS or unexpand cell
     */
    func chatCellDidTapContainer(_ cell: QMChatCell!) {
        let indexPath = self.collectionView?.indexPath(for: cell)
        
        guard let currentMessage = self.chatDataSource.message(for: indexPath) else {
            return
        }
        
        let messageStatus: QMMessageStatus = self.queueManager().status(for: currentMessage)
        
        if messageStatus == .notSent {
            self.handleNotSentMessage(currentMessage, forCell:cell)
            return
        }
        
        if self.detailedCells.contains(currentMessage.id!) {
            self.detailedCells.remove(currentMessage.id!)
        } else {
            self.detailedCells.insert(currentMessage.id!)
        }
        
        self.collectionView?.collectionViewLayout.removeSizeFromCache(forItemID: currentMessage.id)
        self.collectionView?.performBatchUpdates(nil, completion: nil)
        
    }
    
    func chatCell(_ cell: QMChatCell!, didTapAtPosition position: CGPoint) {}
    
    func chatCell(_ cell: QMChatCell!, didPerformAction action: Selector!, withSender sender: Any!) {}
    
    func chatCell(_ cell: QMChatCell!, didTapOn result: NSTextCheckingResult) {
        
        switch result.resultType {
            
        case NSTextCheckingResult.CheckingType.link:
            
            let strUrl : String = (result.url?.absoluteString)!
            
            let hasPrefix = strUrl.lowercased().hasPrefix("https://") || strUrl.lowercased().hasPrefix("http://")
            
            if #available(iOS 9.0, *) {
                if hasPrefix {
                    
                    let controller = SFSafariViewController(url: URL(string: strUrl)!)
                    self.present(controller, animated: true, completion: nil)
                    
                    break
                }
                
            }
            // Fallback on earlier versions
            
            if UIApplication.shared.canOpenURL(URL(string: strUrl)!) {
                
                UIApplication.shared.openURL(URL(string: strUrl)!)
            }
            
            break
            
        case NSTextCheckingResult.CheckingType.phoneNumber:
            
            if !self.canMakeACall() {
                
                SVProgressHUD.showInfo(withStatus: "Your Device can't make a phone call".localized, maskType: .none)
                break
            }
            
            let urlString = String(format: "tel:%@",result.phoneNumber!)
            let url = URL(string: urlString)
            
            self.view.endEditing(true)
            
            let alertController = UIAlertController(title: "",
                                                    message: result.phoneNumber,
                                                    preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "SA_STR_CANCEL".localized, style: .cancel) { (action) in
                
            }
            
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "SA_STR_CALL".localized, style: .destructive) { (action) in
                UIApplication.shared.openURL(url!)
            }
            alertController.addAction(openAction)
            
            self.present(alertController, animated: true) {
            }
            
            break
            
        default:
            break
        }
    }
    
    func chatCellDidTapAvatar(_ cell: QMChatCell!) {
    }
    
    // MARK: QMDeferredQueueManager

    func deferredQueueManager(_ queueManager: QMDeferredQueueManager, didAddMessageLocally addedMessage: QBChatMessage) {
        
        if addedMessage.dialogID == self.dialog.id {
            self.chatDataSource.add(addedMessage)
        }
    }
    
    func deferredQueueManager(_ queueManager: QMDeferredQueueManager, didUpdateMessageLocally addedMessage: QBChatMessage) {
        
        if addedMessage.dialogID == self.dialog.id {
            self.chatDataSource.update(addedMessage)
        }
    }
    
    // MARK: QMChatServiceDelegate
    
    func chatService(_ chatService: QMChatService, didLoadMessagesFromCache messages: [QBChatMessage], forDialogID dialogID: String) {
        
        if self.dialog.id == dialogID {
            
            self.chatDataSource.add(messages)
        }
    }
    
    func chatService(_ chatService: QMChatService, didAddMessageToMemoryStorage message: QBChatMessage, forDialogID dialogID: String) {
        
        if self.dialog.id == dialogID {
            // Insert message received from XMPP or self sent
            if self.chatDataSource.messageExists(message) {
                
                self.chatDataSource.update(message)
            }
            else {
                
                self.chatDataSource.add(message)
            }
        }
    }
    
    func chatService(_ chatService: QMChatService, didUpdateChatDialogInMemoryStorage chatDialog: QBChatDialog) {
        
        if self.dialog.type != QBChatDialogType.private && self.dialog.id == chatDialog.id {
            self.dialog = chatDialog
            self.title = self.dialog.name
        }
    }
    
    func chatService(_ chatService: QMChatService, didUpdate message: QBChatMessage, forDialogID dialogID: String) {
        
        if self.dialog.id == dialogID {
            self.chatDataSource.update(message)
        }
    }
    
    func chatService(_ chatService: QMChatService, didUpdate messages: [QBChatMessage], forDialogID dialogID: String) {
        
        if self.dialog.id == dialogID {
            self.chatDataSource.update(messages)
        }
    }
    
    // MARK: UITextViewDelegate
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
    }
    
    override func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Prevent crashing undo bug
        let currentCharacterCount = textView.text?.length ?? 0
        
        if (range.length + range.location > currentCharacterCount) {
            return false
        }
        
        if !QBChat.instance().isConnected { return true }
        
        if let timer = self.typingTimer {
            timer.invalidate()
            self.typingTimer = nil
            
        } else {
            
            self.sendBeginTyping()
        }
        
        self.typingTimer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(ChatViewController.fireSendStopTypingIfNecessary), userInfo: nil, repeats: false)
        
        if maxCharactersNumber > 0 {
            
            if currentCharacterCount >= maxCharactersNumber && text.length > 0 {
                
                self.showCharactersNumberError()
                return false
            }
            
            let newLength = currentCharacterCount + text.length - range.length
            
            if  newLength <= maxCharactersNumber || text.length == 0 {
                return true
            }
            
            let oldString = textView.text ?? ""
            
            let numberOfSymbolsToCut = maxCharactersNumber - oldString.length
            
            var stringRange = NSMakeRange(0, min(text.length, numberOfSymbolsToCut))
            
            
            // adjust the range to include dependent chars
            stringRange = (text as NSString).rangeOfComposedCharacterSequences(for: stringRange)
            
            // Now you can create the short string
            let shortString = (text as NSString).substring(with: stringRange)
            
            let newText = NSMutableString()
            newText.append(oldString)
            newText.insert(shortString, at: range.location)
            textView.text = newText as String
            
            self.showCharactersNumberError()
            
            self.textViewDidChange(textView)
            
            return false
        }
        
        return true
    }
    
    override func textViewDidEndEditing(_ textView: UITextView) {
        
        super.textViewDidEndEditing(textView)
        
        self.fireSendStopTypingIfNecessary()
    }
    
    func fireSendStopTypingIfNecessary() -> Void {
        
        if let timer = self.typingTimer {
            
            timer.invalidate()
        }
        
        self.typingTimer = nil
        self.sendStopTyping()
    }
    
    func sendBeginTyping() -> Void {
        self.dialog.sendUserIsTyping()
    }
    
    func sendStopTyping() -> Void {
        
        self.dialog.sendUserStoppedTyping()
    }
    
    // MARK: QMChatAttachmentServiceDelegate
    
    func chatAttachmentService(_ chatAttachmentService: QMChatAttachmentService, didChange status: QMMessageAttachmentStatus, for message: QBChatMessage) {
        
        if status != QMMessageAttachmentStatus.notLoaded {
            
            if message.dialogID == self.dialog.id {
                self.chatDataSource.update(message)
            }
        }
    }
    
    func chatAttachmentService(_ chatAttachmentService: QMChatAttachmentService, didChangeLoadingProgress progress: CGFloat, for attachment: QBChatAttachment) {
        
        if let attachmentCell = self.attachmentCellsMap.object(forKey: attachment.id! as AnyObject?) {
            attachmentCell.updateLoadingProgress(progress)
        }
    }
    
    func chatAttachmentService(_ chatAttachmentService: QMChatAttachmentService, didChangeUploadingProgress progress: CGFloat, for message: QBChatMessage) {
        
        guard message.dialogID == self.dialog.id else {
            return
        }
        var cell = self.attachmentCellsMap.object(forKey: message.id as AnyObject?)
        
        if cell == nil && progress < 1.0 {
            
            if let indexPath = self.chatDataSource.indexPath(for: message) {
                cell = self.collectionView?.cellForItem(at: indexPath) as? QMChatAttachmentCell
                self.attachmentCellsMap.setObject(cell, forKey: message.id as AnyObject?)
            }
        }
        
        cell?.updateLoadingProgress(progress)
    }
    
    // MARK : QMChatConnectionDelegate
    
    func refreshAndReadMessages() {
        
        SVProgressHUD.show(withStatus: "SA_STR_LOADING_MESSAGES".localized, maskType: SVProgressHUDMaskType.clear)
        self.loadMessages()
        
        if let messagesToRead = self.unreadMessages {
            self.readMessages(messages: messagesToRead)
        }
        
        self.unreadMessages = nil
    }
    
    func chatServiceChatDidConnect(_ chatService: QMChatService) {
        
        self.refreshAndReadMessages()
    }
    
    func chatServiceChatDidReconnect(_ chatService: QMChatService) {
        
        self.refreshAndReadMessages()
    }
    
    func queueManager() -> QMDeferredQueueManager {
        return ServicesManager.instance().chatService.deferredQueueManager
    }
    
    func handleNotSentMessage(_ message: QBChatMessage,
                              forCell cell: QMChatCell!) {
        
        let alertController = UIAlertController(title: "", message: "SA_STR_MESSAGE_FAILED_TO_SEND".localized, preferredStyle:.actionSheet)
        
        let resend = UIAlertAction(title: "SA_STR_TRY_AGAIN_MESSAGE".localized, style: .default) { (action) in
            self.queueManager().perfromDefferedAction(for: message, withCompletion: nil)
        }
        alertController.addAction(resend)
        
        let delete = UIAlertAction(title: "SA_STR_DELETE_MESSAGE".localized, style: .destructive) { (action) in
            self.queueManager().remove(message)
            self.chatDataSource.delete(message)
        }
        alertController.addAction(delete)
        
        let cancelAction = UIAlertAction(title: "SA_STR_CANCEL".localized, style: .cancel) { (action) in
            
        }
        
        alertController.addAction(cancelAction)
        
        if alertController.popoverPresentationController != nil {
            self.view.endEditing(true)
            alertController.popoverPresentationController!.sourceView = cell.containerView
            alertController.popoverPresentationController!.sourceRect = cell.containerView.bounds
        }
        
        self.present(alertController, animated: true) {
        }
    }
    
    
    
    
}
