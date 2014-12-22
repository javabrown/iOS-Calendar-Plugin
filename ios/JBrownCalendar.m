#import <Foundation/Foundation.h>
#import "JBrownCalendar.h"
#import "JBrownHelper.h"

@implementation JBrownCalendar
@synthesize eventStore;

-(CDVPlugin*) initWithWebView:(UIWebView *)theWebView {
    self = (JBrownCalendar*) [super initWithWebView: theWebView];
    
    if(self){
        [self initEventStoreWithCalendarCapabilities];
    }
    
    return self;
}

-(void) initEventStoreWithCalendarCapabilities{
    __block BOOL accessGranted = NO;
    eventStore = [[EKEventStore alloc] init];
    
    if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]){
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else{ // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted) {
        self.eventStore = eventStore;
    }
}


- (void)createEventWithCalendar:(CDVInvokedUrlCommand*)command {
    NSDictionary* options = [command.arguments objectAtIndex:0];
    
    NSString* title      = [options objectForKey:@"title"];
    NSString* location   = [options objectForKey:@"location"];
    NSString* notes      = [options objectForKey:@"notes"];
    NSNumber* startTime  = [options objectForKey:@"startTime"];
    NSNumber* endTime    = [options objectForKey:@"endTime"];
    
    NSDictionary* calOptions = [options objectForKey:@"options"];
    NSNumber* firstReminderMinutes = [calOptions objectForKey:@"firstReminderMinutes"];
    NSNumber* secondReminderMinutes = [calOptions objectForKey:@"secondReminderMinutes"];
    NSNumber* thirdReminderMinutes = [calOptions objectForKey:@"thirdReminderMinutes"];
    NSString* calendarName = [calOptions objectForKey:@"calendarName"];
    
    //NSString* recurrence = [calOptions objectForKey:@"recurrence"];
    //NSString* recurrenceEndTime = [calOptions objectForKey:@"recurrenceEndTime"];
    
    
    NSTimeInterval _startInterval = [startTime doubleValue] / 1000; // strip millis
    NSDate* myStartDate = [NSDate dateWithTimeIntervalSince1970:_startInterval];
    
    NSTimeInterval _endInterval = [endTime doubleValue] / 1000; // strip millis
    
    if(calendarName == nil){
        calendarName = @"jBrownCalendar";
    }
    
    EKCalendar* brownCalendar = 
       [JBrownHelper createNewCalendar:self.eventStore calendarName:calendarName 
          calendarTitle:calendarName calendarColor:@"#3366CC"];
    
    EKEvent *myEvent = [EKEvent eventWithEventStore: self.eventStore];
    myEvent.title = title;
    myEvent.location = location;
    myEvent.notes = notes;
    myEvent.startDate = myStartDate;
    myEvent.calendar = brownCalendar;
    
    int duration = _endInterval - _startInterval;
    int moduloDay = duration % (60*60*24);
    
    if (moduloDay == 0) {
        //myEvent.allDay = YES;
        NSDate *myEndDate = [NSDate dateWithTimeIntervalSince1970:_endInterval-1];
        myEvent.endDate = myEndDate;//[NSDate dateWithTimeIntervalSince1970:_endInterval-1];
    } else {
        NSDate *myEndDate = [NSDate dateWithTimeIntervalSince1970:_endInterval];
        myEvent.endDate = myEndDate;//[NSDate dateWithTimeIntervalSince1970:_endInterval];
    }
    
    if (firstReminderMinutes != (id)[NSNull null]) {
        EKAlarm *reminder = [EKAlarm alarmWithRelativeOffset:-1*firstReminderMinutes.intValue*60];
        [myEvent addAlarm:reminder];
    }
    
    if (secondReminderMinutes != (id)[NSNull null]) {
        EKAlarm *reminder = [EKAlarm alarmWithRelativeOffset:-1*secondReminderMinutes.intValue*60];
        [myEvent addAlarm:reminder];
    }
    
    if (thirdReminderMinutes != (id)[NSNull null]) {
        EKAlarm *reminder = [EKAlarm alarmWithRelativeOffset:-1*thirdReminderMinutes.intValue*60];
        [myEvent addAlarm:reminder];
    }
    
    NSError *error = nil;
    [self.eventStore saveEvent:myEvent span:EKSpanThisEvent error:&error];
    
    if (error) {
        CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.userInfo.description];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } else {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    
    NSLog(@"Calendar-Event created successfully!!");
}

@end
