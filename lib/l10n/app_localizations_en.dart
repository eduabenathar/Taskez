// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Taskez';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDone => 'Done';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonNext => 'Next';

  @override
  String get commonBack => 'Back';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonOk => 'OK';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonClose => 'Close';

  @override
  String get commonAll => 'All';

  @override
  String get commonSeeAll => 'See All';

  @override
  String get commonToday => 'Today';

  @override
  String get commonYesterday => 'Yesterday';

  @override
  String get commonTomorrow => 'Tomorrow';

  @override
  String get commonNever => 'Never';

  @override
  String get commonRepeat => 'Repeat';

  @override
  String get commonShare => 'Share';

  @override
  String get commonCreate => 'Create';

  @override
  String get commonUpdate => 'Update';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonSettings => 'Settings';

  @override
  String get commonLanguage => 'Language';

  @override
  String get commonSystemDefault => 'System default';

  @override
  String get commonEnglish => 'English';

  @override
  String get commonPortugueseBR => 'Portuguese (Brazil)';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginUsingPrefix => 'Using  ';

  @override
  String get loginUsingSuffix => '  to login.';

  @override
  String get loginSignInButton => 'Sign In';

  @override
  String get signupTitle => 'Sign Up';

  @override
  String get signupButton => 'Sign Up';

  @override
  String get authEmailLabel => 'Your Email';

  @override
  String get authEmailPlaceholder => 'Email';

  @override
  String get authPasswordLabel => 'Your Password';

  @override
  String get authPasswordPlaceholder => 'Password';

  @override
  String get authNameLabel => 'Your Name';

  @override
  String get authNamePlaceholder => 'Name';

  @override
  String get authContinueWithEmail => '   Continue with Email';

  @override
  String get emailAddressTitle => 'What\'s your\nemail\naddress?';

  @override
  String get onboardingStartTagline => 'Task Management ';

  @override
  String get onboardingStartHeadline =>
      'Lets create\na space\nfor your workflows.';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingSlide1 => 'Task,\nCalendar,\nChat';

  @override
  String get onboardingSlide2 => 'Work\nAnywhere\nEasily';

  @override
  String get onboardingSlide3 => 'Manage\nEverything\nOn Phone';

  @override
  String get onboardingTermsNotice =>
      'By continuing you agree Taskez\'s Terms of Services & Privacy Policy.';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String dashboardGreeting(String name) {
    return 'Hello,\n$name 👋';
  }

  @override
  String get dashboardOverviewTab => 'Overview';

  @override
  String get dashboardProductivityTab => 'Productivity';

  @override
  String get overviewTotalTask => 'Total Task';

  @override
  String get overviewCompleted => 'Completed';

  @override
  String get overviewTotalProjects => 'Total Projects';

  @override
  String get overviewDailyTask => 'Daily Task';

  @override
  String get overviewInProgress => 'In Progress';

  @override
  String get overviewUpcoming => 'Upcoming';

  @override
  String get overviewTasksLabel => 'Tasks';

  @override
  String get currentlyProjectTitle => 'Currently Project';

  @override
  String get allTasksTitle => 'All Tasks';

  @override
  String get seeAll => 'See all';

  @override
  String get taskFilterToDo => 'To Do';

  @override
  String get taskFilterInProgress => 'In Progress';

  @override
  String get taskFilterInReview => 'In Review';

  @override
  String get taskFilterComplete => 'Complete';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get progressLabel => 'Progress';

  @override
  String get priorityHigh => 'High priority';

  @override
  String get projectStatusInProgress => 'In progress';

  @override
  String projectTasksProgress(int done, int total) {
    return '$done of $total tasks';
  }

  @override
  String get notificationsTitle => 'Notification';

  @override
  String get projectsTitle => 'Projects';

  @override
  String get projectsFavoritesTab => 'Favorites';

  @override
  String get projectsRecentTab => 'Recent';

  @override
  String get searchPlaceholder => 'Search Dashboard';

  @override
  String get searchTaskTab => 'Task';

  @override
  String get searchMentionTab => 'Mention';

  @override
  String get searchFilesTab => 'Files';

  @override
  String get profileViewProfile => 'View Profile';

  @override
  String get profileWorkspace => 'Workspace';

  @override
  String get profileInvite => 'Invite';

  @override
  String get profileNotification => 'Notification';

  @override
  String get profileDoNotDisturb => 'Do not disturb';

  @override
  String get profileOff => 'Off';

  @override
  String get profileManage => 'Manage';

  @override
  String get profileTeam => 'Team';

  @override
  String get profileLabels => 'Labels';

  @override
  String get profileLogOut => 'Log Out';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEdit => 'Edit';

  @override
  String get profileShowMeAsAway => 'Show me as away';

  @override
  String get profileMyProjects => 'My Projects';

  @override
  String get profileJoinATeam => 'Join A Team';

  @override
  String get profileShareProfile => 'Share Profile';

  @override
  String get profileAllMyTask => 'All My Task';

  @override
  String get profileLanguage => 'Language';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get editProfileRole => 'Role';

  @override
  String get editProfileAboutMe => 'About Me';

  @override
  String get teamHeader => 'Team';

  @override
  String teamMembersCount(String count) {
    return '$count Members';
  }

  @override
  String get teamCalendarTab => 'Calendar';

  @override
  String get teamSubtitle =>
      'We\'re a growing family of 371,521 designers and \nmakers from around the world.';

  @override
  String teamSuffix(String title) {
    return '$title Team';
  }

  @override
  String get notifSettingsTitle => 'Notifications';

  @override
  String get notifSettings30min => '30 minutes';

  @override
  String get notifSettings1hour => '1 hour';

  @override
  String get notifSettingsUntilTomorrow => 'Until Tomorrow';

  @override
  String get notifSettingsUntilNext2Days => 'Until next 2 days';

  @override
  String get notifSettingsCustom => 'Custom';

  @override
  String get notifSettingsNotifyMeAbout => 'NOTIFY MY ABOUT';

  @override
  String get notifSettingsTaskAssigned => 'Task assigned to me';

  @override
  String get notifSettingsTaskCompleted => 'Task completed';

  @override
  String get notifSettingsMentionedMe => 'Mentioned Me';

  @override
  String get notifSettingsDirectMessage => 'Direct Message';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get createProjectAssignedTo => 'Assigned to';

  @override
  String get createProjectDescription => 'Description';

  @override
  String get createProjectCommentPlaceholder => 'Post your comments...';

  @override
  String get taskDueDate => 'Due Date';

  @override
  String get taskDueTime => 'Due Time';

  @override
  String get projectDetailAllTasks => 'All Tasks';

  @override
  String get projectDetailStarred => 'Starred';

  @override
  String get projectDetailLayoutList => 'List';

  @override
  String get projectDetailLayoutBoard => 'Board';

  @override
  String get setAssigneesTitle => 'Set Assignees';

  @override
  String get setMembersAddMember => 'Add Member';

  @override
  String get chatTitle => 'Chat';

  @override
  String get chatGroupSection => 'GROUP';

  @override
  String get chatDirectMessagesSection => 'DIRECT MESSAGES';

  @override
  String get chatWriteMessagePlaceholder => 'Write a message';

  @override
  String get newGroupTitle => 'New Group';

  @override
  String get newMessageTitle => 'New Message';

  @override
  String get newMessageSearchMembers => 'Search Members';

  @override
  String get newMessageSuggested => 'SUGGESTED';

  @override
  String get dashboardSettingsClearAll => 'Clear All';

  @override
  String get dashboardSettingsSaveChanges => 'Save Changes';

  @override
  String get dashboardSettingsTotalTask => 'Total Task';

  @override
  String get dashboardSettingsTaskDueSoon => 'Task Due Soon';

  @override
  String get dashboardSettingsCompleted => 'Completed';

  @override
  String get dashboardSettingsWorkingOn => 'Working On';

  @override
  String get projectSettingsHeader => 'PROJECT SETTINGS';

  @override
  String get projectSettingsShare => 'Share Project';

  @override
  String get projectSettingsMarkAllCompleted => 'Mark all completed';

  @override
  String get projectSettingsCopy => 'Copy';

  @override
  String get projectSettingsDuplicate => 'Duplicate Project';

  @override
  String get projectSettingsSetColor => 'Set Color';

  @override
  String get projectSettingsArchive => 'Archive Project';

  @override
  String get projectSettingsDelete => 'Delete Project';

  @override
  String get meetingPlaceholder => 'Design Meeting';

  @override
  String get meetingEndLabel => 'End';

  @override
  String get meetingInvitesSection => 'INVITES';

  @override
  String get meetingDetailsUploadLogo => 'Tap the logo to upload new file';

  @override
  String get meetingDetailsTeamName => 'TEAM NAME';

  @override
  String get meetingDetailsMember => 'Member';

  @override
  String get meetingDetailsPrivacy => 'Privacy';

  @override
  String get meetingDetailsCreateNewTeam => 'Create New Team';

  @override
  String get meetingDetailsSelectMembers => 'Select Members';

  @override
  String get meetingDetailsPublic => 'Public';

  @override
  String get dashboardAddCreateTask => 'Create Task';

  @override
  String get dashboardAddCreateProject => 'Create Project';

  @override
  String get dashboardAddCreateTeam => 'Create team';

  @override
  String get dashboardAddCreateEvent => 'Create Event';

  @override
  String get createTaskTaskNamePlaceholder => 'Task Name ....';

  @override
  String get createProjectProjectNamePlaceholder => 'Project Name ....';

  @override
  String get createProjectSelectLayout => 'SELECT LAYOUT';

  @override
  String get createProjectPrivacy => 'PRIVACY';

  @override
  String get createProjectPublicToDesignTeam => 'Public to Design Team  ';

  @override
  String get barChartLast7Days => 'Completed in the last 7 Days';

  @override
  String get moreTeamWorkSpace => 'WorkSpace';

  @override
  String get moreTeamMembers => 'Members';

  @override
  String get dailyGoalTitle => 'Daily Goal';

  @override
  String get dailyGoalTasks => 'Tasks';

  @override
  String get dailyGoalProgress => 'You marked 3/5 tasks\nare done 🎉';

  @override
  String get dailyGoalAllTask => 'All Task';

  @override
  String get calendarNewEvent => 'New event';

  @override
  String get calendarEditEvent => 'Edit event';

  @override
  String get calendarFieldTitle => 'Title';

  @override
  String get calendarFieldLocation => 'Location';

  @override
  String get calendarFieldDate => 'Date';

  @override
  String get calendarFieldStart => 'Start';

  @override
  String get calendarFieldDuration => 'Duration';

  @override
  String get calendarFieldColor => 'Color';

  @override
  String get calendarTitleRequired => 'Required';

  @override
  String calendarDurationMinutes(int minutes) {
    return '${minutes}m';
  }

  @override
  String get calendarViewDots => 'Timeline';

  @override
  String get calendarViewHours => 'Date';

  @override
  String get calendarNoMoreTasks => 'No more tasks today';

  @override
  String get taskDetailStartDate => 'Start date';

  @override
  String get taskDetailDueDate => 'Due date';

  @override
  String get taskDetailDescription => 'Description';

  @override
  String get taskDetailTeamMember => 'Team Member';

  @override
  String get taskDetailAttachments => 'Attachments';

  @override
  String get taskDetailTaskDetail => 'Task Detail';

  @override
  String get taskDetailPriorityHigh => 'High priority';

  @override
  String get taskDetailPriorityMedium => 'Medium priority';

  @override
  String get taskDetailPriorityLow => 'Low priority';

  @override
  String get taskDetailAddTask => 'Add task';

  @override
  String get taskDetailAddSubtask => 'Add subtask';

  @override
  String get taskDetailAddMember => 'Add member';

  @override
  String get taskDetailPreview => 'Preview';

  @override
  String get taskDetailNewGroupHint => 'New section title';

  @override
  String get taskDetailNewSubtaskHint => 'New subtask';

  @override
  String get taskDetailEditDescription => 'Edit description';

  @override
  String get taskDetailDescriptionHint => 'Describe the task...';

  @override
  String get taskDetailAddAttachment => 'Add attachment';

  @override
  String get taskDetailAttachmentNameHint => 'File name';

  @override
  String get taskDetailAttachmentImage => 'Image';

  @override
  String get taskDetailAttachmentDocument => 'Document';

  @override
  String get taskDetailChooseIcon => 'Choose an icon';

  @override
  String get taskDetailCommentAuthorYou => 'You';

  @override
  String get taskDetailEditTitle => 'Edit title';

  @override
  String get taskDetailEventNameHint => 'Event name';

  @override
  String get taskDetailEditLocation => 'Edit location';

  @override
  String get taskDetailLocationHint => 'Location, room or link';

  @override
  String taskDetailDurationMinutesLabel(int count) {
    return '$count min';
  }

  @override
  String get taskDetailAttachImageError => 'Could not attach image.';

  @override
  String get taskDetailAddLocation => 'Add location';

  @override
  String get taskDetailColorLabel => 'Color';

  @override
  String get taskDetailComments => 'Comments';

  @override
  String get taskDetailNoComments => 'No comments yet.';

  @override
  String taskDetailOldCommentsHidden(int count) {
    return '$count old comments have no saved content.';
  }

  @override
  String get taskDetailCommentHint => 'Write a comment';

  @override
  String get taskDetailRemoveMemberTitle => 'Remove team member?';

  @override
  String get taskDetailAddImage => 'Add image';

  @override
  String get taskDetailChooseFromGallery => 'Choose from gallery';

  @override
  String get taskDetailGallerySubtitle => 'Attach an existing image';

  @override
  String get taskDetailOpenCamera => 'Open camera';

  @override
  String get taskDetailCameraSubtitle => 'Photo or video to attach to event';

  @override
  String get taskDetailAddMedia => 'Add media';

  @override
  String get taskDetailAttachVideoError => 'Could not attach the video.';

  @override
  String get taskDetailAttachmentVideo => 'Video';

  @override
  String get taskDetailAttachmentPreviewUnavailable =>
      'Preview unavailable for this file type.';

  @override
  String get taskDetailAttachmentShareError => 'Could not share this file.';

  @override
  String get taskDetailRemoveAttachmentTitle => 'Delete attachment?';

  @override
  String get taskDetailPickFile => 'Pick a file';

  @override
  String get taskDetailPickFileSubtitle => 'Attach a file from your device';

  @override
  String get cameraModePhoto => 'Photo';

  @override
  String get cameraModeVideo => 'Video';

  @override
  String get cameraRatio4to3 => '4:3';

  @override
  String get cameraRatio16to9 => '16:9';

  @override
  String get cameraRatio1to1 => '1:1';

  @override
  String get cameraRatioFull => 'Full';

  @override
  String get cameraFlashOff => 'Flash off';

  @override
  String get cameraFlashAuto => 'Flash auto';

  @override
  String get cameraFlashOn => 'Flash on';

  @override
  String get cameraTimerOff => 'Timer off';

  @override
  String get cameraTimer3s => 'Timer 3s';

  @override
  String get cameraTimer10s => 'Timer 10s';

  @override
  String get cameraGridOn => 'Grid on';

  @override
  String get cameraGridOff => 'Grid off';

  @override
  String get cameraGallery => 'Gallery';

  @override
  String get cameraSwitchCamera => 'Switch camera';

  @override
  String get cameraPermissionDenied =>
      'Camera permission denied. Enable it in Settings.';

  @override
  String get cameraInitError => 'Could not start the camera.';

  @override
  String get cameraNoCameraAvailable => 'No camera available on this device.';

  @override
  String get cameraClose => 'Close';

  @override
  String get cameraShutter => 'Capture';

  @override
  String get cameraStartRecord => 'Start recording';

  @override
  String get cameraStopRecord => 'Stop recording';

  @override
  String get cameraDone => 'Done';

  @override
  String get cameraRetake => 'Retake';

  @override
  String get cameraUse => 'Use';

  @override
  String get videoPlayerPlay => 'Play';

  @override
  String get videoPlayerPause => 'Pause';

  @override
  String get commentAttachVideo => 'Choose a video';

  @override
  String get commentAttachVideoSubtitle => 'Pick an existing video';

  @override
  String get commentAttachFile => 'Choose a file';

  @override
  String get commentAttachFileSubtitle => 'Any document or attachment';

  @override
  String get taskDetailPriorityLabel => 'Priority';

  @override
  String get taskDetailEventColorLabel => 'Event color';

  @override
  String get taskDetailCommentNow => 'now';

  @override
  String taskDetailCommentMinutesAgo(int count) {
    return '$count min';
  }

  @override
  String taskDetailCommentHoursAgo(int count) {
    return '${count}h';
  }

  @override
  String notificationMentionedIn(String user, String mention) {
    return '$user mentioned you in $mention';
  }

  @override
  String get notificationHello => 'Hello ';

  @override
  String chatMembersCount(String count) {
    return '$count members';
  }

  @override
  String taskProgressIsCompleted(String rating) {
    return '$rating is completed';
  }
}
