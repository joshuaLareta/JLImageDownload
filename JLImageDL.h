//
//  JLImageDL.h
//  JLImageDownload
//
//  Created by Joshua on 26/7/13.
//  Copyright (c) 2013 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JLImageDLDelegate <NSObject>

-(void)downloadFinished:(UIImage *)JLImage withParams:(NSMutableDictionary *)param;

@end

@interface JLImageDL : NSObject
@property(nonatomic,assign)id<JLImageDLDelegate>delegate;

#pragma mark - instance method
// instance method that will need imageLink as a param and an optional/additional parameter that will be sent back in the delegate
// imagelink is mandatory but param can be nil
-(void)downloadImageLink:(NSString *)imageLink forView:(UIView *)view optionalParam:(NSMutableDictionary *)param;

#pragma mark - Class method
//class method that will need imagelink and the completion block to handle the ui update
+(void)downloadImageLinkBlock:(NSString *)imageLink forView:(UIView *)view completion:(void(^)(UIImage *image))completion;


@end
