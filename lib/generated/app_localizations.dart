import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @modes.
  ///
  /// In en, this message translates to:
  /// **'Modes'**
  String get modes;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @advanced_modes.
  ///
  /// In en, this message translates to:
  /// **'Advanced modes'**
  String get advanced_modes;

  /// No description provided for @automatic_mode_activated.
  ///
  /// In en, this message translates to:
  /// **'Automatic mode activated!'**
  String get automatic_mode_activated;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @user_profile.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get user_profile;

  /// No description provided for @bluetooth_connection.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth connection'**
  String get bluetooth_connection;

  /// No description provided for @themes.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get themes;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @get_started.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get get_started;

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// No description provided for @for_grabbing.
  ///
  /// In en, this message translates to:
  /// **'For grabbing'**
  String get for_grabbing;

  /// No description provided for @think_of_your_right_hand.
  ///
  /// In en, this message translates to:
  /// **'think of your right hand'**
  String get think_of_your_right_hand;

  /// No description provided for @for_elbow_up.
  ///
  /// In en, this message translates to:
  /// **'For Elbow up'**
  String get for_elbow_up;

  /// No description provided for @no_bonded_devices_found.
  ///
  /// In en, this message translates to:
  /// **'No bonded devices found.'**
  String get no_bonded_devices_found;

  /// No description provided for @think_of_your_left_hand.
  ///
  /// In en, this message translates to:
  /// **'think of your left hand'**
  String get think_of_your_left_hand;

  /// No description provided for @for_elbow_down.
  ///
  /// In en, this message translates to:
  /// **'For Elbow down'**
  String get for_elbow_down;

  /// No description provided for @think_neutrally.
  ///
  /// In en, this message translates to:
  /// **'think neutrally'**
  String get think_neutrally;

  /// No description provided for @automatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get automatic;

  /// No description provided for @manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @manual_modes.
  ///
  /// In en, this message translates to:
  /// **'Manual Modes'**
  String get manual_modes;

  /// No description provided for @permission_required.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permission_required;

  /// No description provided for @bluetooth_and_location_permissions_are_required.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth and location permissions are required.'**
  String get bluetooth_and_location_permissions_are_required;

  /// No description provided for @unknown_device.
  ///
  /// In en, this message translates to:
  /// **'Unknown Device'**
  String get unknown_device;

  /// No description provided for @no_file_selected.
  ///
  /// In en, this message translates to:
  /// **'No file selected.'**
  String get no_file_selected;

  /// No description provided for @expected_a_json_array.
  ///
  /// In en, this message translates to:
  /// **'Expected a JSON array.'**
  String get expected_a_json_array;

  /// No description provided for @invalid_eeg_shape.
  ///
  /// In en, this message translates to:
  /// **'Invalid EEG shape. Expected [19, 200]'**
  String get invalid_eeg_shape;

  /// No description provided for @classification.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get classification;

  /// No description provided for @bluetooth_send_failed.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth send failed:'**
  String get bluetooth_send_failed;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong:'**
  String get something_went_wrong;

  /// No description provided for @pick_a_xml_file.
  ///
  /// In en, this message translates to:
  /// **'Pick a XML file'**
  String get pick_a_xml_file;

  /// No description provided for @loading_model.
  ///
  /// In en, this message translates to:
  /// **'Loading Model...'**
  String get loading_model;

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting...'**
  String get waiting;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @go_to_bluetooth_page.
  ///
  /// In en, this message translates to:
  /// **'Go to Bluetooth Page'**
  String get go_to_bluetooth_page;

  /// No description provided for @bluetooth_not_connected.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Not Connected'**
  String get bluetooth_not_connected;

  /// No description provided for @please_connect_to_a_Bluetooth_device_before_sending_data.
  ///
  /// In en, this message translates to:
  /// **'Please connect to a Bluetooth device before sending data.'**
  String get please_connect_to_a_Bluetooth_device_before_sending_data;

  /// No description provided for @send_failed.
  ///
  /// In en, this message translates to:
  /// **'Send Failed'**
  String get send_failed;

  /// No description provided for @error_sending_data.
  ///
  /// In en, this message translates to:
  /// **'❌ Error sending data:'**
  String get error_sending_data;

  /// No description provided for @select_device.
  ///
  /// In en, this message translates to:
  /// **'Select Device'**
  String get select_device;

  /// No description provided for @still_not_connected_to_a_device.
  ///
  /// In en, this message translates to:
  /// **'⚠️Still not connected to a device'**
  String get still_not_connected_to_a_device;

  /// No description provided for @failed_to_connect_to_a_device.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to a device'**
  String get failed_to_connect_to_a_device;

  /// No description provided for @user_didnt_connect_or_connection_failed.
  ///
  /// In en, this message translates to:
  /// **'❌User didn\'t connect or connection failed'**
  String get user_didnt_connect_or_connection_failed;

  /// No description provided for @eating.
  ///
  /// In en, this message translates to:
  /// **'Eating'**
  String get eating;

  /// No description provided for @reading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get reading;

  /// No description provided for @rehabilation.
  ///
  /// In en, this message translates to:
  /// **'Rehabilation'**
  String get rehabilation;

  /// No description provided for @turn_off.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get turn_off;

  /// No description provided for @note_To_switch_to_another_mode_turn_off_eating_mode.
  ///
  /// In en, this message translates to:
  /// **'Note:\nTo switch to another mode, turn off Eating mode.'**
  String get note_To_switch_to_another_mode_turn_off_eating_mode;

  /// No description provided for @note_To_switch_to_another_mode_turn_off_reading_mode.
  ///
  /// In en, this message translates to:
  /// **'Note:\nTo switch to another mode, turn off Reading mode.'**
  String get note_To_switch_to_another_mode_turn_off_reading_mode;

  /// No description provided for @note_To_switch_to_another_mode_turn_off_rehabilation_mode.
  ///
  /// In en, this message translates to:
  /// **'Note:\nTo switch to another mode, turn off Rehabilation mode.'**
  String get note_To_switch_to_another_mode_turn_off_rehabilation_mode;

  /// No description provided for @note_To_switch_to_another_mode_turn_off_automatic_mode.
  ///
  /// In en, this message translates to:
  /// **'Note:\nTo switch to another mode, turn off Automatic mode.'**
  String get note_To_switch_to_another_mode_turn_off_automatic_mode;

  /// No description provided for @position.
  ///
  /// In en, this message translates to:
  /// **'position'**
  String get position;

  /// No description provided for @reading_position.
  ///
  /// In en, this message translates to:
  /// **'Reading position'**
  String get reading_position;

  /// No description provided for @elbow_max.
  ///
  /// In en, this message translates to:
  /// **'Elbow max. position'**
  String get elbow_max;

  /// No description provided for @elbow_min.
  ///
  /// In en, this message translates to:
  /// **'Elbow min. position'**
  String get elbow_min;

  /// No description provided for @eating_drinking.
  ///
  /// In en, this message translates to:
  /// **'Eating/ Drinking position'**
  String get eating_drinking;

  /// No description provided for @preview_themes.
  ///
  /// In en, this message translates to:
  /// **'Preview Themes'**
  String get preview_themes;

  /// No description provided for @choose_theme.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme'**
  String get choose_theme;

  /// No description provided for @low_contrast.
  ///
  /// In en, this message translates to:
  /// **'Low Contrast'**
  String get low_contrast;

  /// No description provided for @high_contrast.
  ///
  /// In en, this message translates to:
  /// **'High contrast'**
  String get high_contrast;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'loading'**
  String get loading;

  /// No description provided for @choose_language.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get choose_language;

  /// No description provided for @empower_movement_with_the_power_of_your_mind.
  ///
  /// In en, this message translates to:
  /// **'Empower movement with the power of your mind'**
  String get empower_movement_with_the_power_of_your_mind;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
