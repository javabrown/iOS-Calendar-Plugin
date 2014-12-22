var jBrownJS = {

    createEventWithCalendar: function (title, location, notes, startDate,
                                       endDate, options, successCallback, errorCallback) {
        if (!(startDate instanceof Date && endDate instanceof Date)) {
            errorCallback("startDate and endDate must be JavaScript Date Objects");
            return;
        }

        var mergedOptions = {calendarName:"jBrownCalendar"};
        
        for (var val in options) {
            if (options.hasOwnProperty(val)) {
                mergedOptions[val] = options[val];
            }
        }
        
        if (options.recurrenceEndDate != null) {
            mergedOptions.recurrenceEndTime = options.recurrenceEndDate.getTime();
        }
        
        cordova.exec(successCallback, errorCallback,
                     "JBrownCalendar", "createEventWithCalendar",
                     [{
                      "title": title,
                      "location": location,
                      "notes": notes,
                      "startTime": startDate instanceof Date ? startDate.getTime() : null,
                      "endTime": endDate instanceof Date ? endDate.getTime() : null,
                      "options": mergedOptions
                      }]
                    );
        
        alert('**createEventWithCalendar plugin call done **');
    },
    
};
