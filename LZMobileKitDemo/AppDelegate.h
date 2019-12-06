//
//  AppDelegate.h
//  LZMobileKitDemo
//
//  Created by 何伟东 on 2019/12/6.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

