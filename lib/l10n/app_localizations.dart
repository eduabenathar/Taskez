import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Taskez'**
  String get appTitle;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get commonSeeAll;

  /// No description provided for @commonToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get commonToday;

  /// No description provided for @commonYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get commonYesterday;

  /// No description provided for @commonTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get commonTomorrow;

  /// No description provided for @commonNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get commonNever;

  /// No description provided for @commonRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get commonRepeat;

  /// No description provided for @commonShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get commonShare;

  /// No description provided for @commonCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get commonCreate;

  /// No description provided for @commonUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get commonUpdate;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @commonSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get commonSettings;

  /// No description provided for @commonLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get commonLanguage;

  /// No description provided for @commonSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get commonSystemDefault;

  /// No description provided for @commonEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get commonEnglish;

  /// No description provided for @commonPortugueseBR.
  ///
  /// In en, this message translates to:
  /// **'Portuguese (Brazil)'**
  String get commonPortugueseBR;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @loginUsingPrefix.
  ///
  /// In en, this message translates to:
  /// **'Using  '**
  String get loginUsingPrefix;

  /// No description provided for @loginUsingSuffix.
  ///
  /// In en, this message translates to:
  /// **'  to login.'**
  String get loginUsingSuffix;

  /// No description provided for @loginSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginSignInButton;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signupTitle;

  /// No description provided for @signupButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signupButton;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Email'**
  String get authEmailLabel;

  /// No description provided for @authEmailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailPlaceholder;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Password'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordPlaceholder;

  /// No description provided for @authNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get authNameLabel;

  /// No description provided for @authNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get authNamePlaceholder;

  /// No description provided for @authContinueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'   Continue with Email'**
  String get authContinueWithEmail;

  /// No description provided for @emailAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your\nemail\naddress?'**
  String get emailAddressTitle;

  /// No description provided for @onboardingStartTagline.
  ///
  /// In en, this message translates to:
  /// **'Task Management '**
  String get onboardingStartTagline;

  /// No description provided for @onboardingStartHeadline.
  ///
  /// In en, this message translates to:
  /// **'Lets create\na space\nfor your workflows.'**
  String get onboardingStartHeadline;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingSlide1.
  ///
  /// In en, this message translates to:
  /// **'Task,\nCalendar,\nChat'**
  String get onboardingSlide1;

  /// No description provided for @onboardingSlide2.
  ///
  /// In en, this message translates to:
  /// **'Work\nAnywhere\nEasily'**
  String get onboardingSlide2;

  /// No description provided for @onboardingSlide3.
  ///
  /// In en, this message translates to:
  /// **'Manage\nEverything\nOn Phone'**
  String get onboardingSlide3;

  /// No description provided for @onboardingTermsNotice.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree Taskez\'s Terms of Services & Privacy Policy.'**
  String get onboardingTermsNotice;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello,\n{name} 👋'**
  String dashboardGreeting(String name);

  /// No description provided for @dashboardOverviewTab.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get dashboardOverviewTab;

  /// No description provided for @dashboardProductivityTab.
  ///
  /// In en, this message translates to:
  /// **'Productivity'**
  String get dashboardProductivityTab;

  /// No description provided for @overviewTotalTask.
  ///
  /// In en, this message translates to:
  /// **'Total Task'**
  String get overviewTotalTask;

  /// No description provided for @overviewCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get overviewCompleted;

  /// No description provided for @overviewTotalProjects.
  ///
  /// In en, this message translates to:
  /// **'Total Projects'**
  String get overviewTotalProjects;

  /// No description provided for @overviewDailyTask.
  ///
  /// In en, this message translates to:
  /// **'Daily Task'**
  String get overviewDailyTask;

  /// No description provided for @overviewInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get overviewInProgress;

  /// No description provided for @overviewUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get overviewUpcoming;

  /// No description provided for @overviewTasksLabel.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get overviewTasksLabel;

  /// No description provided for @currentlyProjectTitle.
  ///
  /// In en, this message translates to:
  /// **'Currently Project'**
  String get currentlyProjectTitle;

  /// No description provided for @allTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'All Tasks'**
  String get allTasksTitle;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @taskFilterToDo.
  ///
  /// In en, this message translates to:
  /// **'To Do'**
  String get taskFilterToDo;

  /// No description provided for @taskFilterInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get taskFilterInProgress;

  /// No description provided for @taskFilterInReview.
  ///
  /// In en, this message translates to:
  /// **'In Review'**
  String get taskFilterInReview;

  /// No description provided for @taskFilterComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get taskFilterComplete;

  /// No description provided for @priorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get priorityMedium;

  /// No description provided for @progressLabel.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressLabel;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High priority'**
  String get priorityHigh;

  /// No description provided for @projectStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get projectStatusInProgress;

  /// No description provided for @projectTasksProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} tasks'**
  String projectTasksProgress(int done, int total);

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notificationsTitle;

  /// No description provided for @projectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projectsTitle;

  /// No description provided for @projectsFavoritesTab.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get projectsFavoritesTab;

  /// No description provided for @projectsRecentTab.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get projectsRecentTab;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search Dashboard'**
  String get searchPlaceholder;

  /// No description provided for @searchTaskTab.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get searchTaskTab;

  /// No description provided for @searchMentionTab.
  ///
  /// In en, this message translates to:
  /// **'Mention'**
  String get searchMentionTab;

  /// No description provided for @searchFilesTab.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get searchFilesTab;

  /// No description provided for @profileViewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get profileViewProfile;

  /// No description provided for @profileWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get profileWorkspace;

  /// No description provided for @profileInvite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get profileInvite;

  /// No description provided for @profileNotification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get profileNotification;

  /// No description provided for @profileDoNotDisturb.
  ///
  /// In en, this message translates to:
  /// **'Do not disturb'**
  String get profileDoNotDisturb;

  /// No description provided for @profileOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get profileOff;

  /// No description provided for @profileManage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get profileManage;

  /// No description provided for @profileTeam.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get profileTeam;

  /// No description provided for @profileLabels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get profileLabels;

  /// No description provided for @profileLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileLogOut;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get profileEdit;

  /// No description provided for @profileShowMeAsAway.
  ///
  /// In en, this message translates to:
  /// **'Show me as away'**
  String get profileShowMeAsAway;

  /// No description provided for @profileMyProjects.
  ///
  /// In en, this message translates to:
  /// **'My Projects'**
  String get profileMyProjects;

  /// No description provided for @profileJoinATeam.
  ///
  /// In en, this message translates to:
  /// **'Join A Team'**
  String get profileJoinATeam;

  /// No description provided for @profileShareProfile.
  ///
  /// In en, this message translates to:
  /// **'Share Profile'**
  String get profileShareProfile;

  /// No description provided for @profileAllMyTask.
  ///
  /// In en, this message translates to:
  /// **'All My Task'**
  String get profileAllMyTask;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @editProfileRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get editProfileRole;

  /// No description provided for @editProfileAboutMe.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get editProfileAboutMe;

  /// No description provided for @teamHeader.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get teamHeader;

  /// No description provided for @teamMembersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Members'**
  String teamMembersCount(String count);

  /// No description provided for @teamCalendarTab.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get teamCalendarTab;

  /// No description provided for @teamSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'re a growing family of 371,521 designers and \nmakers from around the world.'**
  String get teamSubtitle;

  /// No description provided for @teamSuffix.
  ///
  /// In en, this message translates to:
  /// **'{title} Team'**
  String teamSuffix(String title);

  /// No description provided for @notifSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifSettingsTitle;

  /// No description provided for @notifSettings30min.
  ///
  /// In en, this message translates to:
  /// **'30 minutes'**
  String get notifSettings30min;

  /// No description provided for @notifSettings1hour.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get notifSettings1hour;

  /// No description provided for @notifSettingsUntilTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Until Tomorrow'**
  String get notifSettingsUntilTomorrow;

  /// No description provided for @notifSettingsUntilNext2Days.
  ///
  /// In en, this message translates to:
  /// **'Until next 2 days'**
  String get notifSettingsUntilNext2Days;

  /// No description provided for @notifSettingsCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get notifSettingsCustom;

  /// No description provided for @notifSettingsNotifyMeAbout.
  ///
  /// In en, this message translates to:
  /// **'NOTIFY MY ABOUT'**
  String get notifSettingsNotifyMeAbout;

  /// No description provided for @notifSettingsTaskAssigned.
  ///
  /// In en, this message translates to:
  /// **'Task assigned to me'**
  String get notifSettingsTaskAssigned;

  /// No description provided for @notifSettingsTaskCompleted.
  ///
  /// In en, this message translates to:
  /// **'Task completed'**
  String get notifSettingsTaskCompleted;

  /// No description provided for @notifSettingsMentionedMe.
  ///
  /// In en, this message translates to:
  /// **'Mentioned Me'**
  String get notifSettingsMentionedMe;

  /// No description provided for @notifSettingsDirectMessage.
  ///
  /// In en, this message translates to:
  /// **'Direct Message'**
  String get notifSettingsDirectMessage;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @createProjectAssignedTo.
  ///
  /// In en, this message translates to:
  /// **'Assigned to'**
  String get createProjectAssignedTo;

  /// No description provided for @createProjectDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get createProjectDescription;

  /// No description provided for @createProjectCommentPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Post your comments...'**
  String get createProjectCommentPlaceholder;

  /// No description provided for @taskDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get taskDueDate;

  /// No description provided for @taskDueTime.
  ///
  /// In en, this message translates to:
  /// **'Due Time'**
  String get taskDueTime;

  /// No description provided for @projectDetailAllTasks.
  ///
  /// In en, this message translates to:
  /// **'All Tasks'**
  String get projectDetailAllTasks;

  /// No description provided for @projectDetailStarred.
  ///
  /// In en, this message translates to:
  /// **'Starred'**
  String get projectDetailStarred;

  /// No description provided for @projectDetailLayoutList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get projectDetailLayoutList;

  /// No description provided for @projectDetailLayoutBoard.
  ///
  /// In en, this message translates to:
  /// **'Board'**
  String get projectDetailLayoutBoard;

  /// No description provided for @setAssigneesTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Assignees'**
  String get setAssigneesTitle;

  /// No description provided for @setMembersAddMember.
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get setMembersAddMember;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chatTitle;

  /// No description provided for @chatGroupSection.
  ///
  /// In en, this message translates to:
  /// **'GROUP'**
  String get chatGroupSection;

  /// No description provided for @chatDirectMessagesSection.
  ///
  /// In en, this message translates to:
  /// **'DIRECT MESSAGES'**
  String get chatDirectMessagesSection;

  /// No description provided for @chatWriteMessagePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Write a message'**
  String get chatWriteMessagePlaceholder;

  /// No description provided for @newGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'New Group'**
  String get newGroupTitle;

  /// No description provided for @newMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'New Message'**
  String get newMessageTitle;

  /// No description provided for @newMessageSearchMembers.
  ///
  /// In en, this message translates to:
  /// **'Search Members'**
  String get newMessageSearchMembers;

  /// No description provided for @newMessageSuggested.
  ///
  /// In en, this message translates to:
  /// **'SUGGESTED'**
  String get newMessageSuggested;

  /// No description provided for @dashboardSettingsClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get dashboardSettingsClearAll;

  /// No description provided for @dashboardSettingsSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get dashboardSettingsSaveChanges;

  /// No description provided for @dashboardSettingsTotalTask.
  ///
  /// In en, this message translates to:
  /// **'Total Task'**
  String get dashboardSettingsTotalTask;

  /// No description provided for @dashboardSettingsTaskDueSoon.
  ///
  /// In en, this message translates to:
  /// **'Task Due Soon'**
  String get dashboardSettingsTaskDueSoon;

  /// No description provided for @dashboardSettingsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get dashboardSettingsCompleted;

  /// No description provided for @dashboardSettingsWorkingOn.
  ///
  /// In en, this message translates to:
  /// **'Working On'**
  String get dashboardSettingsWorkingOn;

  /// No description provided for @projectSettingsHeader.
  ///
  /// In en, this message translates to:
  /// **'PROJECT SETTINGS'**
  String get projectSettingsHeader;

  /// No description provided for @projectSettingsShare.
  ///
  /// In en, this message translates to:
  /// **'Share Project'**
  String get projectSettingsShare;

  /// No description provided for @projectSettingsMarkAllCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark all completed'**
  String get projectSettingsMarkAllCompleted;

  /// No description provided for @projectSettingsCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get projectSettingsCopy;

  /// No description provided for @projectSettingsDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate Project'**
  String get projectSettingsDuplicate;

  /// No description provided for @projectSettingsSetColor.
  ///
  /// In en, this message translates to:
  /// **'Set Color'**
  String get projectSettingsSetColor;

  /// No description provided for @projectSettingsArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive Project'**
  String get projectSettingsArchive;

  /// No description provided for @projectSettingsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Project'**
  String get projectSettingsDelete;

  /// No description provided for @meetingPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Design Meeting'**
  String get meetingPlaceholder;

  /// No description provided for @meetingEndLabel.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get meetingEndLabel;

  /// No description provided for @meetingInvitesSection.
  ///
  /// In en, this message translates to:
  /// **'INVITES'**
  String get meetingInvitesSection;

  /// No description provided for @meetingDetailsUploadLogo.
  ///
  /// In en, this message translates to:
  /// **'Tap the logo to upload new file'**
  String get meetingDetailsUploadLogo;

  /// No description provided for @meetingDetailsTeamName.
  ///
  /// In en, this message translates to:
  /// **'TEAM NAME'**
  String get meetingDetailsTeamName;

  /// No description provided for @meetingDetailsMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get meetingDetailsMember;

  /// No description provided for @meetingDetailsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get meetingDetailsPrivacy;

  /// No description provided for @meetingDetailsCreateNewTeam.
  ///
  /// In en, this message translates to:
  /// **'Create New Team'**
  String get meetingDetailsCreateNewTeam;

  /// No description provided for @meetingDetailsSelectMembers.
  ///
  /// In en, this message translates to:
  /// **'Select Members'**
  String get meetingDetailsSelectMembers;

  /// No description provided for @meetingDetailsPublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get meetingDetailsPublic;

  /// No description provided for @dashboardAddCreateTask.
  ///
  /// In en, this message translates to:
  /// **'Create Task'**
  String get dashboardAddCreateTask;

  /// No description provided for @dashboardAddCreateProject.
  ///
  /// In en, this message translates to:
  /// **'Create Project'**
  String get dashboardAddCreateProject;

  /// No description provided for @dashboardAddCreateTeam.
  ///
  /// In en, this message translates to:
  /// **'Create team'**
  String get dashboardAddCreateTeam;

  /// No description provided for @dashboardAddCreateEvent.
  ///
  /// In en, this message translates to:
  /// **'Create Event'**
  String get dashboardAddCreateEvent;

  /// No description provided for @createTaskTaskNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Task Name ....'**
  String get createTaskTaskNamePlaceholder;

  /// No description provided for @createProjectProjectNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Project Name ....'**
  String get createProjectProjectNamePlaceholder;

  /// No description provided for @createProjectSelectLayout.
  ///
  /// In en, this message translates to:
  /// **'SELECT LAYOUT'**
  String get createProjectSelectLayout;

  /// No description provided for @createProjectPrivacy.
  ///
  /// In en, this message translates to:
  /// **'PRIVACY'**
  String get createProjectPrivacy;

  /// No description provided for @createProjectPublicToDesignTeam.
  ///
  /// In en, this message translates to:
  /// **'Public to Design Team  '**
  String get createProjectPublicToDesignTeam;

  /// No description provided for @barChartLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Completed in the last 7 Days'**
  String get barChartLast7Days;

  /// No description provided for @moreTeamWorkSpace.
  ///
  /// In en, this message translates to:
  /// **'WorkSpace'**
  String get moreTeamWorkSpace;

  /// No description provided for @moreTeamMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get moreTeamMembers;

  /// No description provided for @dailyGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyGoalTitle;

  /// No description provided for @dailyGoalTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get dailyGoalTasks;

  /// No description provided for @dailyGoalProgress.
  ///
  /// In en, this message translates to:
  /// **'You marked 3/5 tasks\nare done 🎉'**
  String get dailyGoalProgress;

  /// No description provided for @dailyGoalAllTask.
  ///
  /// In en, this message translates to:
  /// **'All Task'**
  String get dailyGoalAllTask;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
