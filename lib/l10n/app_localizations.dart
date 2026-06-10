import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_uk.dart';

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
    Locale('en'),
    Locale('uk'),
  ];

  /// No description provided for @app_title.
  ///
  /// In uk, this message translates to:
  /// **'Popytka UA'**
  String get app_title;

  /// No description provided for @hello_world.
  ///
  /// In uk, this message translates to:
  /// **'Привіт Світ'**
  String get hello_world;

  /// No description provided for @search_btn.
  ///
  /// In uk, this message translates to:
  /// **'Знайти поїздки'**
  String get search_btn;

  /// No description provided for @from_label.
  ///
  /// In uk, this message translates to:
  /// **'Звідки'**
  String get from_label;

  /// No description provided for @to_label.
  ///
  /// In uk, this message translates to:
  /// **'Куди'**
  String get to_label;

  /// No description provided for @today_label.
  ///
  /// In uk, this message translates to:
  /// **'Сьогодні'**
  String get today_label;

  /// No description provided for @recent_searches.
  ///
  /// In uk, this message translates to:
  /// **'Нещодавні пошуки'**
  String get recent_searches;

  /// No description provided for @publish_title.
  ///
  /// In uk, this message translates to:
  /// **'Опублікувати Поїздку'**
  String get publish_title;

  /// No description provided for @date_label.
  ///
  /// In uk, this message translates to:
  /// **'Дата'**
  String get date_label;

  /// No description provided for @time_label.
  ///
  /// In uk, this message translates to:
  /// **'Час'**
  String get time_label;

  /// No description provided for @seats_label.
  ///
  /// In uk, this message translates to:
  /// **'Кількість місць'**
  String get seats_label;

  /// No description provided for @price_label.
  ///
  /// In uk, this message translates to:
  /// **'Ціна за місце'**
  String get price_label;

  /// No description provided for @publish_action.
  ///
  /// In uk, this message translates to:
  /// **'Опублікувати поїздку'**
  String get publish_action;

  /// No description provided for @profile_title.
  ///
  /// In uk, this message translates to:
  /// **'Профіль Користувача'**
  String get profile_title;

  /// No description provided for @driver_profile_subtitle.
  ///
  /// In uk, this message translates to:
  /// **'Водійський профіль'**
  String get driver_profile_subtitle;

  /// No description provided for @edit_profile.
  ///
  /// In uk, this message translates to:
  /// **'Редагувати профіль'**
  String get edit_profile;

  /// No description provided for @mode_label.
  ///
  /// In uk, this message translates to:
  /// **'Режим'**
  String get mode_label;

  /// No description provided for @passenger_label.
  ///
  /// In uk, this message translates to:
  /// **'Пасажир'**
  String get passenger_label;

  /// No description provided for @driver_label.
  ///
  /// In uk, this message translates to:
  /// **'Водій'**
  String get driver_label;

  /// No description provided for @car_details.
  ///
  /// In uk, this message translates to:
  /// **'Дані автомобіля'**
  String get car_details;

  /// No description provided for @car_brand.
  ///
  /// In uk, this message translates to:
  /// **'Марка'**
  String get car_brand;

  /// No description provided for @car_model.
  ///
  /// In uk, this message translates to:
  /// **'Модель'**
  String get car_model;

  /// No description provided for @car_year.
  ///
  /// In uk, this message translates to:
  /// **'Рік випуску'**
  String get car_year;

  /// No description provided for @car_plate.
  ///
  /// In uk, this message translates to:
  /// **'Номерний знак'**
  String get car_plate;

  /// No description provided for @car_color.
  ///
  /// In uk, this message translates to:
  /// **'Колір'**
  String get car_color;

  /// No description provided for @car_photos.
  ///
  /// In uk, this message translates to:
  /// **'Фото автомобіля'**
  String get car_photos;

  /// No description provided for @add_photo.
  ///
  /// In uk, this message translates to:
  /// **'Додати фото'**
  String get add_photo;

  /// No description provided for @my_rides.
  ///
  /// In uk, this message translates to:
  /// **'Мої поїздки'**
  String get my_rides;

  /// No description provided for @nav_search.
  ///
  /// In uk, this message translates to:
  /// **'Знайти'**
  String get nav_search;

  /// No description provided for @nav_publish.
  ///
  /// In uk, this message translates to:
  /// **'Створити'**
  String get nav_publish;

  /// No description provided for @nav_messages.
  ///
  /// In uk, this message translates to:
  /// **'Повідомлення'**
  String get nav_messages;

  /// No description provided for @nav_profile.
  ///
  /// In uk, this message translates to:
  /// **'Профіль'**
  String get nav_profile;

  /// No description provided for @loading.
  ///
  /// In uk, this message translates to:
  /// **'Завантаження...'**
  String get loading;

  /// No description provided for @admin_users_title.
  ///
  /// In uk, this message translates to:
  /// **'Керування користувачами'**
  String get admin_users_title;

  /// No description provided for @admin_rides_title.
  ///
  /// In uk, this message translates to:
  /// **'Керування поїздками'**
  String get admin_rides_title;

  /// No description provided for @admin_reports_title.
  ///
  /// In uk, this message translates to:
  /// **'Перегляд звітів'**
  String get admin_reports_title;

  /// No description provided for @admin_notifications_title.
  ///
  /// In uk, this message translates to:
  /// **'Сповіщення системи'**
  String get admin_notifications_title;

  /// No description provided for @admin_settings_title.
  ///
  /// In uk, this message translates to:
  /// **'Налаштування системи'**
  String get admin_settings_title;

  /// No description provided for @btn_manage.
  ///
  /// In uk, this message translates to:
  /// **'Керувати'**
  String get btn_manage;

  /// No description provided for @btn_view.
  ///
  /// In uk, this message translates to:
  /// **'Переглянути'**
  String get btn_view;

  /// No description provided for @btn_open.
  ///
  /// In uk, this message translates to:
  /// **'Відкрити'**
  String get btn_open;

  /// No description provided for @btn_go.
  ///
  /// In uk, this message translates to:
  /// **'Перейти'**
  String get btn_go;

  /// No description provided for @btn_configure.
  ///
  /// In uk, this message translates to:
  /// **'Налаштувати'**
  String get btn_configure;

  /// No description provided for @stat_active_users.
  ///
  /// In uk, this message translates to:
  /// **'активних'**
  String get stat_active_users;

  /// No description provided for @stat_new_users.
  ///
  /// In uk, this message translates to:
  /// **'нових'**
  String get stat_new_users;

  /// No description provided for @stat_current_rides.
  ///
  /// In uk, this message translates to:
  /// **'поточні поїздки'**
  String get stat_current_rides;

  /// No description provided for @stat_completed_rides.
  ///
  /// In uk, this message translates to:
  /// **'завершено'**
  String get stat_completed_rides;

  /// No description provided for @stat_report_avail.
  ///
  /// In uk, this message translates to:
  /// **'Новий звіт доступний'**
  String get stat_report_avail;

  /// No description provided for @stat_unreviewed.
  ///
  /// In uk, this message translates to:
  /// **'нерозглянутих'**
  String get stat_unreviewed;

  /// No description provided for @version.
  ///
  /// In uk, this message translates to:
  /// **'Версия'**
  String get version;

  /// No description provided for @search_placeholder.
  ///
  /// In uk, this message translates to:
  /// **'Пошук за ім\'ям або email'**
  String get search_placeholder;

  /// No description provided for @role_label.
  ///
  /// In uk, this message translates to:
  /// **'Роль'**
  String get role_label;

  /// No description provided for @status_label.
  ///
  /// In uk, this message translates to:
  /// **'Статус'**
  String get status_label;

  /// No description provided for @status_active.
  ///
  /// In uk, this message translates to:
  /// **'Активний'**
  String get status_active;

  /// No description provided for @status_blocked.
  ///
  /// In uk, this message translates to:
  /// **'Заблокований'**
  String get status_blocked;

  /// No description provided for @btn_edit.
  ///
  /// In uk, this message translates to:
  /// **'Редагувати'**
  String get btn_edit;

  /// No description provided for @btn_block.
  ///
  /// In uk, this message translates to:
  /// **'Блокувати'**
  String get btn_block;

  /// No description provided for @btn_unblock.
  ///
  /// In uk, this message translates to:
  /// **'Розблокувати'**
  String get btn_unblock;

  /// No description provided for @btn_access.
  ///
  /// In uk, this message translates to:
  /// **'Керувати доступом'**
  String get btn_access;

  /// No description provided for @tab_active.
  ///
  /// In uk, this message translates to:
  /// **'Активні'**
  String get tab_active;

  /// No description provided for @tab_planned.
  ///
  /// In uk, this message translates to:
  /// **'Заплановані'**
  String get tab_planned;

  /// No description provided for @tab_completed.
  ///
  /// In uk, this message translates to:
  /// **'Завершені'**
  String get tab_completed;

  /// No description provided for @status_in_transit.
  ///
  /// In uk, this message translates to:
  /// **'В дорозі'**
  String get status_in_transit;

  /// No description provided for @status_planned.
  ///
  /// In uk, this message translates to:
  /// **'Заплановано'**
  String get status_planned;

  /// No description provided for @status_completed.
  ///
  /// In uk, this message translates to:
  /// **'Завершено'**
  String get status_completed;

  /// No description provided for @label_driver.
  ///
  /// In uk, this message translates to:
  /// **'Водій'**
  String get label_driver;

  /// No description provided for @label_passenger.
  ///
  /// In uk, this message translates to:
  /// **'Пасажир'**
  String get label_passenger;

  /// No description provided for @label_route.
  ///
  /// In uk, this message translates to:
  /// **'Маршрут'**
  String get label_route;

  /// No description provided for @label_duration.
  ///
  /// In uk, this message translates to:
  /// **'Тривалість'**
  String get label_duration;

  /// No description provided for @label_rating.
  ///
  /// In uk, this message translates to:
  /// **'Рейтинг'**
  String get label_rating;

  /// No description provided for @btn_details.
  ///
  /// In uk, this message translates to:
  /// **'Деталі'**
  String get btn_details;

  /// No description provided for @btn_issue.
  ///
  /// In uk, this message translates to:
  /// **'Проблема'**
  String get btn_issue;

  /// No description provided for @btn_change.
  ///
  /// In uk, this message translates to:
  /// **'Змінити'**
  String get btn_change;

  /// No description provided for @btn_archive.
  ///
  /// In uk, this message translates to:
  /// **'Архів'**
  String get btn_archive;

  /// No description provided for @login_title.
  ///
  /// In uk, this message translates to:
  /// **'Вхід'**
  String get login_title;

  /// No description provided for @login_subtitle.
  ///
  /// In uk, this message translates to:
  /// **'Увійдіть через Google для продовження'**
  String get login_subtitle;

  /// No description provided for @phone_label.
  ///
  /// In uk, this message translates to:
  /// **'Номер телефону'**
  String get phone_label;

  /// No description provided for @phone_hint.
  ///
  /// In uk, this message translates to:
  /// **'+380...'**
  String get phone_hint;

  /// No description provided for @otp_label.
  ///
  /// In uk, this message translates to:
  /// **'Код з SMS'**
  String get otp_label;

  /// No description provided for @otp_hint.
  ///
  /// In uk, this message translates to:
  /// **'123456'**
  String get otp_hint;

  /// No description provided for @btn_send_code.
  ///
  /// In uk, this message translates to:
  /// **'Надіслати код'**
  String get btn_send_code;

  /// No description provided for @btn_verify.
  ///
  /// In uk, this message translates to:
  /// **'Увійти'**
  String get btn_verify;

  /// No description provided for @error_invalid_phone.
  ///
  /// In uk, this message translates to:
  /// **'Невірний формат номеру'**
  String get error_invalid_phone;

  /// No description provided for @error_generic.
  ///
  /// In uk, this message translates to:
  /// **'Сталася помилка. Спробуйте ще раз.'**
  String get error_generic;

  /// No description provided for @results_title.
  ///
  /// In uk, this message translates to:
  /// **'Результати пошуку'**
  String get results_title;

  /// No description provided for @no_results.
  ///
  /// In uk, this message translates to:
  /// **'Поїздок не знайдено'**
  String get no_results;

  /// No description provided for @book_btn.
  ///
  /// In uk, this message translates to:
  /// **'Забронювати'**
  String get book_btn;

  /// No description provided for @booking_success.
  ///
  /// In uk, this message translates to:
  /// **'Бронювання успішне!'**
  String get booking_success;

  /// No description provided for @driver_info.
  ///
  /// In uk, this message translates to:
  /// **'Інформація про водія'**
  String get driver_info;

  /// No description provided for @seats_available.
  ///
  /// In uk, this message translates to:
  /// **'Вільних місць'**
  String get seats_available;

  /// No description provided for @ride_details_title.
  ///
  /// In uk, this message translates to:
  /// **'Деталі поїздки'**
  String get ride_details_title;

  /// No description provided for @total_price.
  ///
  /// In uk, this message translates to:
  /// **'Загальна вартість'**
  String get total_price;

  /// No description provided for @chat_title.
  ///
  /// In uk, this message translates to:
  /// **'Повідомлення'**
  String get chat_title;

  /// No description provided for @no_chats.
  ///
  /// In uk, this message translates to:
  /// **'У вас ще немає повідомлень'**
  String get no_chats;

  /// No description provided for @type_message.
  ///
  /// In uk, this message translates to:
  /// **'Напишіть повідомлення...'**
  String get type_message;

  /// No description provided for @send_btn.
  ///
  /// In uk, this message translates to:
  /// **'Надіслати'**
  String get send_btn;

  /// No description provided for @contact_driver.
  ///
  /// In uk, this message translates to:
  /// **'Написати водію'**
  String get contact_driver;

  /// No description provided for @btn_sign_in_google.
  ///
  /// In uk, this message translates to:
  /// **'Увійти через Google'**
  String get btn_sign_in_google;

  /// No description provided for @wallet_balance.
  ///
  /// In uk, this message translates to:
  /// **'Баланс гаманця'**
  String get wallet_balance;

  /// No description provided for @view_wallet.
  ///
  /// In uk, this message translates to:
  /// **'Перейти до гаманця'**
  String get view_wallet;

  /// No description provided for @rating_label.
  ///
  /// In uk, this message translates to:
  /// **'Рейтинг'**
  String get rating_label;

  /// No description provided for @save_changes.
  ///
  /// In uk, this message translates to:
  /// **'Зберегти зміни'**
  String get save_changes;

  /// No description provided for @cancel.
  ///
  /// In uk, this message translates to:
  /// **'Скасувати'**
  String get cancel;

  /// No description provided for @edit_profile_title.
  ///
  /// In uk, this message translates to:
  /// **'Редагувати профіль'**
  String get edit_profile_title;

  /// No description provided for @name_label.
  ///
  /// In uk, this message translates to:
  /// **'Ім\'я'**
  String get name_label;

  /// No description provided for @phone_number.
  ///
  /// In uk, this message translates to:
  /// **'Номер телефону'**
  String get phone_number;

  /// No description provided for @switch_to_driver.
  ///
  /// In uk, this message translates to:
  /// **'Стати водієм'**
  String get switch_to_driver;

  /// No description provided for @switch_to_passenger.
  ///
  /// In uk, this message translates to:
  /// **'Стати пасажиром'**
  String get switch_to_passenger;

  /// No description provided for @car_info_required.
  ///
  /// In uk, this message translates to:
  /// **'Заповніть інформацію про автомобіль'**
  String get car_info_required;

  /// No description provided for @upload_car_photo.
  ///
  /// In uk, this message translates to:
  /// **'Завантажити фото авто'**
  String get upload_car_photo;

  /// No description provided for @remove_photo.
  ///
  /// In uk, this message translates to:
  /// **'Видалити фото'**
  String get remove_photo;

  /// No description provided for @profile_updated.
  ///
  /// In uk, this message translates to:
  /// **'Профіль оновлено'**
  String get profile_updated;

  /// No description provided for @error_updating_profile.
  ///
  /// In uk, this message translates to:
  /// **'Помилка оновлення профілю'**
  String get error_updating_profile;

  /// No description provided for @departure_date.
  ///
  /// In uk, this message translates to:
  /// **'Дата відправлення'**
  String get departure_date;

  /// No description provided for @departure_time.
  ///
  /// In uk, this message translates to:
  /// **'Час відправлення'**
  String get departure_time;

  /// No description provided for @select_date.
  ///
  /// In uk, this message translates to:
  /// **'Оберіть дату'**
  String get select_date;

  /// No description provided for @select_time.
  ///
  /// In uk, this message translates to:
  /// **'Оберіть час'**
  String get select_time;

  /// No description provided for @invalid_date.
  ///
  /// In uk, this message translates to:
  /// **'Оберіть дату в майбутньому'**
  String get invalid_date;

  /// No description provided for @date_time_required.
  ///
  /// In uk, this message translates to:
  /// **'Оберіть дату та час відправлення'**
  String get date_time_required;

  /// No description provided for @settings_title.
  ///
  /// In uk, this message translates to:
  /// **'Налаштування'**
  String get settings_title;

  /// No description provided for @settings_general.
  ///
  /// In uk, this message translates to:
  /// **'Загальні'**
  String get settings_general;

  /// No description provided for @settings_language.
  ///
  /// In uk, this message translates to:
  /// **'Мова'**
  String get settings_language;

  /// No description provided for @settings_theme.
  ///
  /// In uk, this message translates to:
  /// **'Тема'**
  String get settings_theme;

  /// No description provided for @settings_dark_mode.
  ///
  /// In uk, this message translates to:
  /// **'Темна'**
  String get settings_dark_mode;

  /// No description provided for @settings_notifications.
  ///
  /// In uk, this message translates to:
  /// **'Сповіщення'**
  String get settings_notifications;

  /// No description provided for @settings_ride_updates.
  ///
  /// In uk, this message translates to:
  /// **'Оновлення поїздки'**
  String get settings_ride_updates;

  /// No description provided for @settings_new_messages.
  ///
  /// In uk, this message translates to:
  /// **'Нові повідомлення'**
  String get settings_new_messages;

  /// No description provided for @settings_promotions.
  ///
  /// In uk, this message translates to:
  /// **'Акції та знижки'**
  String get settings_promotions;

  /// No description provided for @settings_privacy.
  ///
  /// In uk, this message translates to:
  /// **'Приватність'**
  String get settings_privacy;

  /// No description provided for @settings_data_sharing.
  ///
  /// In uk, this message translates to:
  /// **'Поширення даних'**
  String get settings_data_sharing;

  /// No description provided for @settings_profile_visibility.
  ///
  /// In uk, this message translates to:
  /// **'Видимість профілю'**
  String get settings_profile_visibility;

  /// No description provided for @settings_visibility_public.
  ///
  /// In uk, this message translates to:
  /// **'Публічний'**
  String get settings_visibility_public;

  /// No description provided for @settings_security.
  ///
  /// In uk, this message translates to:
  /// **'Безпека'**
  String get settings_security;

  /// No description provided for @settings_change_password.
  ///
  /// In uk, this message translates to:
  /// **'Змінити пароль'**
  String get settings_change_password;

  /// No description provided for @settings_two_factor.
  ///
  /// In uk, this message translates to:
  /// **'Двофакторна автентифікація'**
  String get settings_two_factor;

  /// No description provided for @settings_support.
  ///
  /// In uk, this message translates to:
  /// **'Допомога та підтримка'**
  String get settings_support;

  /// No description provided for @settings_help_center.
  ///
  /// In uk, this message translates to:
  /// **'Центр допомоги'**
  String get settings_help_center;

  /// No description provided for @settings_contact_us.
  ///
  /// In uk, this message translates to:
  /// **'Зв\'язатися з нами'**
  String get settings_contact_us;

  /// No description provided for @settings_about.
  ///
  /// In uk, this message translates to:
  /// **'Про додаток'**
  String get settings_about;

  /// No description provided for @cancel_ride_title.
  ///
  /// In uk, this message translates to:
  /// **'Скасувати поїздку'**
  String get cancel_ride_title;

  /// No description provided for @cancel_ride_confirm.
  ///
  /// In uk, this message translates to:
  /// **'Ви впевнені, что хочете скасувати цю поїздку?'**
  String get cancel_ride_confirm;

  /// No description provided for @cancel_ride_warning.
  ///
  /// In uk, this message translates to:
  /// **'Ви впевнені, що хочете скасувати цю поїздку? Цю дію неможливо буде відмінити.'**
  String get cancel_ride_warning;

  /// No description provided for @yes.
  ///
  /// In uk, this message translates to:
  /// **'Так'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In uk, this message translates to:
  /// **'Ні'**
  String get no;

  /// No description provided for @yes_cancel.
  ///
  /// In uk, this message translates to:
  /// **'Так, скасувати'**
  String get yes_cancel;

  /// No description provided for @ride_cancelled.
  ///
  /// In uk, this message translates to:
  /// **'Поїздку скасовано'**
  String get ride_cancelled;

  /// No description provided for @ride_cancelled_success.
  ///
  /// In uk, this message translates to:
  /// **'Поїздку успішно скасовано'**
  String get ride_cancelled_success;

  /// No description provided for @error_prefix.
  ///
  /// In uk, this message translates to:
  /// **'Помилка: '**
  String get error_prefix;

  /// No description provided for @no_seats.
  ///
  /// In uk, this message translates to:
  /// **'Місць немає'**
  String get no_seats;

  /// No description provided for @you_label.
  ///
  /// In uk, this message translates to:
  /// **'Це ви'**
  String get you_label;

  /// No description provided for @driver_placeholder.
  ///
  /// In uk, this message translates to:
  /// **'Водій'**
  String get driver_placeholder;

  /// No description provided for @please_login.
  ///
  /// In uk, this message translates to:
  /// **'Будь ласка, увійдіть у систему'**
  String get please_login;

  /// No description provided for @no_active_rides.
  ///
  /// In uk, this message translates to:
  /// **'Немає активних поїздок'**
  String get no_active_rides;

  /// No description provided for @no_planned_rides.
  ///
  /// In uk, this message translates to:
  /// **'Немає запланованих поїздок'**
  String get no_planned_rides;

  /// No description provided for @no_completed_rides.
  ///
  /// In uk, this message translates to:
  /// **'Немає завершених поїздок'**
  String get no_completed_rides;

  /// No description provided for @no_rides_found.
  ///
  /// In uk, this message translates to:
  /// **'Поїздок не знайдено'**
  String get no_rides_found;

  /// No description provided for @create_first_ride.
  ///
  /// In uk, this message translates to:
  /// **'Створіть свою першу поїздку!'**
  String get create_first_ride;

  /// No description provided for @rides_appear_here.
  ///
  /// In uk, this message translates to:
  /// **'Ваші поїздки з\'являться тут'**
  String get rides_appear_here;

  /// No description provided for @status_cancelled.
  ///
  /// In uk, this message translates to:
  /// **'Скасовано'**
  String get status_cancelled;

  /// No description provided for @rate_your_trip.
  ///
  /// In uk, this message translates to:
  /// **'Оцініть вашу поїздку'**
  String get rate_your_trip;

  /// No description provided for @submit_rating.
  ///
  /// In uk, this message translates to:
  /// **'Надіслати оцінку'**
  String get submit_rating;

  /// No description provided for @rating.
  ///
  /// In uk, this message translates to:
  /// **'Оцінка'**
  String get rating;

  /// No description provided for @comment.
  ///
  /// In uk, this message translates to:
  /// **'Коментар'**
  String get comment;

  /// No description provided for @how_was_your_trip.
  ///
  /// In uk, this message translates to:
  /// **'Як пройшла ваша поїздка?'**
  String get how_was_your_trip;

  /// No description provided for @leave_a_comment.
  ///
  /// In uk, this message translates to:
  /// **'Залиште коментар (необов\'язково)'**
  String get leave_a_comment;

  /// No description provided for @user_ratings.
  ///
  /// In uk, this message translates to:
  /// **'Оцінки користувача'**
  String get user_ratings;

  /// No description provided for @no_ratings_yet.
  ///
  /// In uk, this message translates to:
  /// **'Ще немає оцінок'**
  String get no_ratings_yet;

  /// No description provided for @ratings_and_reviews.
  ///
  /// In uk, this message translates to:
  /// **'Оцінки та відгуки'**
  String get ratings_and_reviews;

  /// No description provided for @rate_trip.
  ///
  /// In uk, this message translates to:
  /// **'Оцінити поїздку'**
  String get rate_trip;

  /// No description provided for @statistics_title.
  ///
  /// In uk, this message translates to:
  /// **'Статистика'**
  String get statistics_title;

  /// No description provided for @stat_total_rides.
  ///
  /// In uk, this message translates to:
  /// **'Всього поїздок'**
  String get stat_total_rides;

  /// No description provided for @stat_total_spent.
  ///
  /// In uk, this message translates to:
  /// **'Витрачено'**
  String get stat_total_spent;

  /// No description provided for @stat_total_earned.
  ///
  /// In uk, this message translates to:
  /// **'Зароблено'**
  String get stat_total_earned;

  /// No description provided for @stat_passengers.
  ///
  /// In uk, this message translates to:
  /// **'Перевезено пасажирів'**
  String get stat_passengers;

  /// No description provided for @stat_driver.
  ///
  /// In uk, this message translates to:
  /// **'Статистика водія'**
  String get stat_driver;

  /// No description provided for @stat_passenger.
  ///
  /// In uk, this message translates to:
  /// **'Статистика пасажира'**
  String get stat_passenger;

  /// No description provided for @wallet_title.
  ///
  /// In uk, this message translates to:
  /// **'Мій гаманець'**
  String get wallet_title;

  /// No description provided for @wallet_history.
  ///
  /// In uk, this message translates to:
  /// **'Історія транзакцій'**
  String get wallet_history;

  /// No description provided for @wallet_top_up.
  ///
  /// In uk, this message translates to:
  /// **'Поповнити'**
  String get wallet_top_up;

  /// No description provided for @wallet_withdraw.
  ///
  /// In uk, this message translates to:
  /// **'Вивести'**
  String get wallet_withdraw;

  /// No description provided for @transaction_type_ride.
  ///
  /// In uk, this message translates to:
  /// **'Оплата поїздки'**
  String get transaction_type_ride;

  /// No description provided for @transaction_type_topup.
  ///
  /// In uk, this message translates to:
  /// **'Поповнення'**
  String get transaction_type_topup;

  /// No description provided for @transaction_type_withdrawal.
  ///
  /// In uk, this message translates to:
  /// **'Виведення коштів'**
  String get transaction_type_withdrawal;

  /// No description provided for @no_transactions.
  ///
  /// In uk, this message translates to:
  /// **'Транзакцій ще немає'**
  String get no_transactions;

  /// No description provided for @transaction_amount.
  ///
  /// In uk, this message translates to:
  /// **'Сума'**
  String get transaction_amount;

  /// No description provided for @transaction_date.
  ///
  /// In uk, this message translates to:
  /// **'Дата'**
  String get transaction_date;

  /// No description provided for @transaction_status.
  ///
  /// In uk, this message translates to:
  /// **'Статус'**
  String get transaction_status;

  /// No description provided for @error_past_time.
  ///
  /// In uk, this message translates to:
  /// **'Не можна обрати час, що вже минув'**
  String get error_past_time;
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
      <String>['en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
