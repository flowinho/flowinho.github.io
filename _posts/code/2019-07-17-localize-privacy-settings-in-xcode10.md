---
layout: post
title: "iOS - The surprisingly difficult way of localizing Info.plist strings"
tags: code
---

In a current project the app has ask the user for his permission to access the iOS location services API. In cases like this Apple specifies the requirement to display a descriptive text to user that will be issued in a popup. Many of you should be familiar with these popups, that typically hold text's like:

```
"Can App XY access your location?"     
"When In Use"     
"Always"     
```

The popup itself is localized by the iOS system dialogs, however the string that is displayed inside is not. Apple changed how to localize these strings multiple times in the recent years.

As it turns out, you have to create a separarte, localized `InfoPlist.strings` file that does the work. 
While doing for this for a project with several target configurations, mainly to distinguish DEV and PROD environments, i've encountered some weird issues regarding how Xcode handles these files, so i decided to document this process here.

## The creation of your localization file

First off, check the names of all your Bundle-Configuration property-list. In my case i had:

- AppInfo.plist
- AppInfoDev.plist
- AppUnitTests.plist
- AppUITests.plist

Create a new .strings file using File -> New ... and select "Strings" in the upcoming dialogue. Make sure that the file is added to the targets you want to localize.

In a next step, rename the files to match the naming scheme of your propertylists. In my case i ended up with these files:

- AppInfoPlist.strings
- AppInfoDevPlist.strings

The naming of these files is **case sensitive**. As the unit-tests and UI tests in most cases do not require localization, you can leave these out.

## Localize these files

Right click your newly created files and add their respective localization by clickling "Localize" in the Identity and Type Inspector in the right pane of Xcode.

![](https://i.imgur.com/jYd6cox.png)

If successfull, it will display the currently available localized languages. Now use the project navigator to fill these string files with their respective content.

![](https://i.imgur.com/Ghy62Om.png)

Example contents:

InfoPlist.strings (English)
```swift
"NSLocationAlwaysAndWhenInUseUsageDescription" = "Send your position to our servers.";
"NSLocationWhenInUseUsageDescription" = "Send your position to our servers.";
````

InfoPlist.strings (German)
```swift
"NSLocationAlwaysAndWhenInUseUsageDescription" = "Um Ihre Position zu unseren Systemen zu übertragen.";
"NSLocationWhenInUseUsageDescription" = "Um Ihre Position zu unseren Systemen zu übertragen.";
```

That's it.