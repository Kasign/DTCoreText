//
//  DTRegister.m
//  LiveIn_Home
//
//  Created by Walg on 2024/7/2.
//

#import "DTRegister.h"

#import "DTHTMLElement.h"
#import "DTAnchorHTMLElement.h"
#import "DTBreakHTMLElement.h"
#import "DTListItemHTMLElement.h"
#import "DTHorizontalRuleHTMLElement.h"
#import "DTStylesheetHTMLElement.h"
#import "DTTextAttachmentHTMLElement.h"
#import "DTTextHTMLElement.h"

#import "DTTableHTMLElement.h"
#import "DTTHeadHTMLElement.h"
#import "DTTBodyHTMLElement.h"
#import "DTTrHTMLElement.h"
#import "DTThHTMLElement.h"
#import "DTTdHTMLElement.h"
#import "DTSpanElement.h"


#import "DTIframeTextAttachment.h"
#import "DTImageTextAttachment.h"
#import "DTObjectTextAttachment.h"
#import "DTVideoTextAttachment.h"
#import "DTTableTextAttachment.h"
#import "DTLoadingTextAttachment.h"


@interface DTRegister ()

@property (nonatomic, strong) NSMutableDictionary *elementClassDic;
@property (nonatomic, strong) NSMutableDictionary *attachmentClassDic;

@end


@implementation DTRegister

+ (void)initialize {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        /// Attachment
        [DTRegister registerAttachmentClass:[DTImageTextAttachment class] forTagName:@"img"];
        [DTRegister registerAttachmentClass:[DTVideoTextAttachment class] forTagName:@"video"];
        [DTRegister registerAttachmentClass:[DTIframeTextAttachment class] forTagName:@"iframe"];
        [DTRegister registerAttachmentClass:[DTObjectTextAttachment class] forTagName:@"object"];
        
        [DTRegister registerAttachmentClass:[DTObjectTextAttachment class] forTagName:@"oliver"];
        [DTRegister registerAttachmentClass:[DTLoadingTextAttachment class] forTagName:@"input"];
        
        /// Element
        [DTRegister registerElementClass:[DTAnchorHTMLElement class] forTagName:@"a"];
        [DTRegister registerElementClass:[DTBreakHTMLElement class] forTagName:@"br"];
        [DTRegister registerElementClass:[DTHorizontalRuleHTMLElement class] forTagName:@"hr"];
        [DTRegister registerElementClass:[DTListItemHTMLElement class] forTagName:@"li"];
        [DTRegister registerElementClass:[DTStylesheetHTMLElement class] forTagName:@"style"];
        [DTRegister registerElementClass:[DTTextAttachmentHTMLElement class] forTagName:@"img"];
        [DTRegister registerElementClass:[DTTextAttachmentHTMLElement class] forTagName:@"object"];
        [DTRegister registerElementClass:[DTTextAttachmentHTMLElement class] forTagName:@"video"];
        [DTRegister registerElementClass:[DTTextAttachmentHTMLElement class] forTagName:@"iframe"];
        
        [DTRegister registerElementClass:[DTTableHTMLElement class] forTagName:@"table"];
        [DTRegister registerElementClass:[DTTHeadHTMLElement class] forTagName:@"thead"];
        [DTRegister registerElementClass:[DTTBodyHTMLElement class] forTagName:@"tbody"];
        [DTRegister registerElementClass:[DTThHTMLElement class] forTagName:@"th"];
        [DTRegister registerElementClass:[DTTdHTMLElement class] forTagName:@"td"];
        [DTRegister registerElementClass:[DTTrHTMLElement class] forTagName:@"tr"];
        [DTRegister registerElementClass:[DTSpanElement class] forTagName:@"span"];
    });
}

+ (void)registerAttachmentClass:(Class)class forTagName:(NSString *)tagName {
    
    [[self sharedInstance].attachmentClassDic setValue:class forKey:tagName];
}

+ (Class)registeredAttachmentClassForTagName:(NSString *)tagName {
    
    return [[self sharedInstance].attachmentClassDic valueForKey:tagName];
}

+ (void)registerElementClass:(Class)theClass forTagName:(NSString *)tagName {
    
    if (theClass && tagName) {
        [[self sharedInstance].elementClassDic setValue:theClass forKey:tagName];
    }
}

+ (Class)registeredElementClassForTagName:(NSString *)tagName {
    
    return [[self sharedInstance].elementClassDic valueForKey:tagName];
}

+ (instancetype)sharedInstance {
    
    static DTRegister *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [DTRegister new];
    });
    return instance;
}

- (NSMutableDictionary *)elementClassDic {
    
    if (!_elementClassDic) {
        _elementClassDic = [NSMutableDictionary dictionary];
    }
    return _elementClassDic;
}

- (NSMutableDictionary *)attachmentClassDic {
    
    if (!_attachmentClassDic) {
        _attachmentClassDic = [NSMutableDictionary dictionary];
    }
    return _attachmentClassDic;
}
@end
