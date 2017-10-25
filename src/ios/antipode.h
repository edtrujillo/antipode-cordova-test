//
//  antipode.h
//  CurrentLocation
//
//  Created by Edmund Trujillo on 10/25/17.
//  Copyright © 2017 Edmund Trujillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Cordova/CDV.h>

@interface antipode : CDVPlugin

- (void)fetchAntiPode:(CDVInvokedUrlCommand *)command;

@end
