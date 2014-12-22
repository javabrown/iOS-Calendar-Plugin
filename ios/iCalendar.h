#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import "EventKit/EventKit.h"

@interface iCalendar : CDVPlugin
    @property (nonatomic, retain) EKEventStore *eventStore;

    - (void) initEventStoreWithCalendarCapabilities;

    - (void)createEventWithCalendar:(CDVInvokedUrlCommand*)command;
@end;
