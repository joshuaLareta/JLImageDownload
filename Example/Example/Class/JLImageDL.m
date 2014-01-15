//
//  JLImageDL.m
//  JLImageDownload
//
//  Created by Joshua on 26/7/13.
//  Copyright (c) 2013 Joshua. All rights reserved.
//

#import "JLImageDL.h"
#import <QuartzCore/QuartzCore.h>

#define ActivityIndicatorTag 9101
#define ActivityIndicatorTagSingle 9103
#define ActivityIndicatorBGTag 9100
#define ActivityIndicatorBGTagSingle 9104

#define ParameterViewNameConv @"v!ew456@%)"
#define ParameterImageConv @"im@ge456@%)"
#define ParameterImageLinkConv @"im@geL!nk456@%)"

@interface JLImageDL(){
    NSOperationQueue *queue;
    UIView *activityIndicatorBG;
    UIActivityIndicatorView *activityView;
}

@end


@implementation JLImageDL
@synthesize delegate = _delegate;


-(void)doneLoadingImage:(NSMutableDictionary *)param{
    
    UIImage *image = [param valueForKey:ParameterImageConv];
    UIView *view = [param valueForKey:ParameterViewNameConv];
    
    [param removeObjectForKey:ParameterViewNameConv];
    [param removeObjectForKey:ParameterImageConv];
    [param removeObjectForKey:ParameterImageLinkConv];
    [JLImageDL hideActivityView:view isForMultiple:NO];
    [_delegate downloadFinished:image withParams:param];
     

}

-(void)downloadImageProcess:(NSMutableDictionary *)params{
    
    NSString *imageLink = [params valueForKey:ParameterImageLinkConv];
    NSURL *dataURL = [NSURL URLWithString:imageLink];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:dataURL]];
    
    if([_delegate respondsToSelector:@selector(downloadFinished:withParams:)]){
        NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:image,ParameterImageConv, nil];
        
        if(params != nil){
            if([params respondsToSelector:@selector(count)]){
                if([params count]>0){
                    [parameter addEntriesFromDictionary:params];
                }
            }
        }
        [self performSelectorOnMainThread:@selector(doneLoadingImage:) withObject:parameter waitUntilDone:YES];
       
    }

}

-(void)downloadImageLink:(NSString *)imageLink forView:(UIView *)view optionalParam:(NSMutableDictionary *)param{

    if(imageLink!=nil){
        
        if(queue == nil){
            queue = [[NSOperationQueue alloc]init];
        }
        [JLImageDL showActivityView:view isForMultiple:NO];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:imageLink,ParameterImageLinkConv, nil];
      
        if(view != nil){
            [params setObject:view forKey:ParameterViewNameConv];
        }
        
        if(param != nil){
            if([param respondsToSelector:@selector(count)]){
                if([param count]>0){
                    [params addEntriesFromDictionary:param];
                   
                }
            }
        }

        
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(downloadImageProcess:) object:params];
        [queue addOperation:operation];
    }
}

+(void)downloadImageLinkBlock:(NSString *)imageLink forView:(UIView *)view completion:(void(^)(UIImage *image))completion{
    
    if(imageLink != nil){
       
        if([NSThread isMainThread])
            [JLImageDL showActivityView:view isForMultiple:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
            NSURL *url = [NSURL URLWithString:imageLink];
//            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            NSData * imageData = [NSData dataWithContentsOfURL:url];
            

           
            if (imageData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *image = [UIImage imageWithData:imageData];
                  
                    completion(image);
                    if([NSThread isMainThread])
                        [JLImageDL hideActivityView:view isForMultiple:YES];
                    
                });
                
            }
        });

        
    }
}


#pragma mark -ACTIVITY VIEW
+(void)showActivityView:(UIView *)view isForMultiple:(BOOL)isMultiple{
    
    if(view != nil){
        
        UIView *aView = (UIView *)[view viewWithTag:(isMultiple)?ActivityIndicatorBGTag:ActivityIndicatorBGTagSingle];
        if(aView == nil){
            aView = [[UIView alloc]initWithFrame:CGRectMake((view.frame.size.width/2)-20, (view.frame.size.height/2)-20, 40, 40)];
            aView.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:.5];
            aView.layer.cornerRadius = 5.0;
            aView.tag = (isMultiple)?ActivityIndicatorBGTag:ActivityIndicatorBGTagSingle;
             [view addSubview:aView];
           
        }
        
        UIActivityIndicatorView *activeView = (UIActivityIndicatorView *)[aView viewWithTag:(isMultiple)?ActivityIndicatorTag:ActivityIndicatorTagSingle];
        if(activeView == nil){
            activeView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
            [aView addSubview:activeView];
        }
        activeView.tag = (isMultiple)?ActivityIndicatorTag:ActivityIndicatorTagSingle;
        [activeView startAnimating];
       
        
       
    }
}

+(void)hideActivityView:(UIView *)view isForMultiple:(BOOL)isMultiple{
    if(view != nil){
        UIView *aView = (UIView *)[view viewWithTag:(isMultiple)?ActivityIndicatorBGTag:ActivityIndicatorBGTagSingle];
        if(aView != nil){
            UIActivityIndicatorView *activeView = (UIActivityIndicatorView *)[aView viewWithTag:(isMultiple)?ActivityIndicatorTag:ActivityIndicatorTagSingle];
            if(activeView != nil){
                activeView.tag = (isMultiple)?ActivityIndicatorTag:ActivityIndicatorTagSingle;
                [activeView stopAnimating];
                [activeView removeFromSuperview];
            }
        
        }
     [aView removeFromSuperview];
     
    }
}


#pragma mark - DEALLOC
-(void)dealloc{
    queue = nil;
    activityView = nil;
}



@end
