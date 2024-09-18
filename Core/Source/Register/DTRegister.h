//
//  DTRegister.h
//  LiveIn_Home
//
//  Created by Walg on 2024/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTRegister : NSObject

/**
 Registers your own class for use when encountering a specific tag Name. If you register a class for a previously registered class (or one of the predefined ones (img, iframe, object, video) then this replaces this with the newer registration.
 
 These registrations are permanent during the run time of your app. Custom attachment classes must implement the initWithElement:options: initializer and can implement the DTTextAttachmentDrawing and/or DTTextAttachmentHTMLPersistence protocols.
 @param theClass The class to instantiate in textAttachmentWithElement:options: when encountering a tag with this name
 @param tagName The tag name to use this class for
 */
+ (void)registerAttachmentClass:(Class)theClass forTagName:(NSString *)tagName;

/**
 The class to use for a tag name
 @param tagName The tag name
 @returns The class to use for attachments with with tag name, or `nil` if this should not be an attachment
 */
+ (Class)registeredAttachmentClassForTagName:(NSString *)tagName;

/**
 The class to use for a tag name
 @param tagName The tag name
 @returns The class to use for element with with tag name, or `nil` if this should not be an attachment
 */
+ (void)registerElementClass:(Class)theClass forTagName:(NSString *)tagName;

/**
 The class to use for a tag name
 @param tagName The tag name
 @returns The class to use for attachments with with tag name, or `nil` if this should not be an attachment
 */
+ (Class)registeredElementClassForTagName:(NSString *)tagName;

@end

NS_ASSUME_NONNULL_END
