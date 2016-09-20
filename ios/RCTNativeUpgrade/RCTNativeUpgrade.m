//
//  RCTNativeUpgrade.m
//  RCTNativeUpgrade
//
//  Created by paozi on 16/9/18.
//  Copyright © 2016年 paozi. All rights reserved.
//

#import "RCTNativeUpgrade.h"
#import "UIKit/UIKit.h"

@implementation RCTNativeUpgrade

@synthesize bridge = _bridge;


RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(checkForUpdate:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=998255344"];//1092837141
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    if (jsonData){
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error){
            NSLog(@"HSLUpdateChecker: Error parsing JSON from iTunes API: %@", error);
            reject(@"10001", @"Error parsing JSON from iTunes API!", [NSError errorWithDomain:@"Error parsing JSON from iTunes API" code:10001 userInfo:nil]);
        }else{
            NSArray *results = dict[@"results"];
            if (results.count > 0){
                NSDictionary *result = results[0];
                NSString *appStoreVersion = result[@"version"];
                NSString *localVersion =[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
                if(!localVersion){
                    localVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
                }
                //版本差异
                if(![localVersion isEqualToString: appStoreVersion]){
                    NSString *updateUrl = result[@"trackViewUrl"];//更新url
                    NSString *releaseNotes =result[@"releaseNotes"];//更新内容
                    NSArray *arr;
                    if(releaseNotes){
                         arr = @[updateUrl,releaseNotes];
                    }else{
                        arr = @[updateUrl,@""];
                    }
                    resolve(arr);//更新url
                }else{
                    resolve(nil);//不更新
                }
            }
        }
    }
}

RCT_EXPORT_METHOD(gotoAppStore:(NSString *)updateUrl
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    NSURL *url = [NSURL URLWithString:updateUrl];
    [[UIApplication sharedApplication] openURL:url];
    
}

@end
