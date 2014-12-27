iOS Calendar Plugins
====================
PhoneGap Calendar plugin
for iOS, by Raja Khan

For a quick demo app and easy code samples, check out the plugin page: http://www.javabrown.com/blog/objective-c/

Description
Installation
Automatically (CLI / Plugman)
Manually
PhoneGap Build
Usage

1. Description

This plugin allows you to add events to the Calendar of the mobile device.

Works with PhoneGap >= 3.0.
For PhoneGap 2.x, see the pre-3.0 branch.
Compatible with Cordova Plugman.
Officially supported by PhoneGap Build.
iOS specifics

Supported methods: find, create, modify, delete, ..
All methods work without showing the native calendar. Your app never looses control.
Tested on iOS 6, 7 and 8.

2. Installation

Automatically (CLI / Plugman)

Calendar is compatible with Cordova Plugman and ready for the PhoneGap 3.0 CLI, here's how it works with the CLI:

    $ phonegap local plugin add https://github.com/javabrown/iOSPlugins.git
or

    $ cordova plugin add https://github.com/javabrown/iOSPlugins.git
and run this command afterwards:

    $ cordova build
Manually

iOS

1. Add the following xml to your config.xml:

<!-- for iOS -->
    <feature name="Calendar">
        <param name="ios-package" value="jBrownCalendar" />
    </feature>
2. Grab a copy of Calendar.js, add it to your project and reference it in index.html:

    <script type="text/javascript" src="js/jBrownCalendar.js"></script>
3. Download the source files for iOS and copy them to your project.

Copy jBrownCalendar.h and jBrownCalendar.m to platforms/ios/<ProjectName>/Plugins

4. Click your project in XCode, Build Phases, Link Binary With Libraries, search for and add EventKit.framework and EventKitUI.framework.

5. Usage

Basic operations, you'll want to copy-paste this for testing purposes:


    var startDate = new Date(2015,11,25,18,10,0,0,0); // beware: month 0 = january, 11 = december
    var endDate = new Date(2015,11,25,19,40,0,0,0);
    var title = "Trip from White Plains to Chicago";
  
    var location = "Grand Central";
    var notes = "Your COACH:c10A, Seat: 15A. Please carry your ID card";

    var success = function(message) { alert("Success: " + JSON.stringify(message)); };
    var error = function(message) { alert("Error: " + message); };
  
    var calOptions = {}; // grab the defaults
    calOptions.firstReminderMinutes = 60; // default is 60, pass in null for no reminder
    calOptions.secondReminderMinutes = 30;
    calOptions.thirdReminderMinutes = 15;
                
    jBrownJS.createEventWithCalendar(title,location,notes,
        startDate,endDate,calOptions, success,error);
                
