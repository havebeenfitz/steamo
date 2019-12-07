# STEAMO  ![](https://github.com/havebeenfitz/steamo/blob/develop/Steamo/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29%401x.png)
### Steam WEB API iOS App

# Архитектурное решение
**MVVM + Routers**
Такая архитектура кажется мне наиболее простой и удобной в использовании. Из недостатков можно отметить только разбухающую вьюмодель при недостаточной разбивке на модули/секции.
Роутеры позволяют выделить навигацию в отдельную сущность и вынести ее из контроллера.

# Используемые зависимости

1. **Alamofire**
Для работы с REST API наиболее удобная для меня обертка над URLSession, стабильно поддерживается, удобно использовать, в итоге получается чуть меньше кода по сравнению с URLSession. Логика работы с данной зависимостью скрыта в `NetworkAdapter`, в случае чего можно подменить реализацию, не задевая остальные части приложения
2. **SnapKit**
Для работы с автолейаутом. Опять же достаточно удобная обертка над стандартными `NSLayoutConstraints`, в итоге получается меньше кода, отлично читается.
3. **Kingfisher**
Для работы с подгрузкой изображений. Очень удобно подгружать изображения в `imageView` ячеек, библиотека разруливает кэширование изображений, в итоге получается меньше кода. Библиотека стабильно поддерживается, ее часто используют
4. **Realm**
Для хранения данных по играм. Лично мне Realm кажется гораздо более дружелюбным, чем CoreData, проще миграции базы, проще использовать. Кроме того, по всем замерам производительности Realm [впереди](http://ios-fathers.blogspot.com/2018/08/core-data-vs-realm.html) CoreData, но на такой маленькой базе данных это вряд ли будет иметь значение
5. **SVProgressHUD**
Для показа прогресса долгих операций. Просто относительно красивая и удобная крутилка
6. **Charts**
Для графиков. Кажется, самая популярная библиотека для быстрой реализации графиков. Разобраться в CoreGraphics за такой короткий срок не успел бы, хотя и интересно. Возможно, стоит избавиться от этой либы в пользу своего решения в дальнейшем.

# Используемые методы Steam API

 - **GET /ISteamUser/GetPlayerSummaries/v0002/**
Профиль пользователя. Принимает параметром массив `steamId`, что позволяет забирать информацию по друзьям одним запросом
 - **GET /ISteamUser/GetFriendList/v0001**
Друзья пользователя, если пользователь разрешил их смотреть. Отсюда берем массив `steamId`, который далее передаем в метод выше
- **GET /IPlayerService/GetOwnedGames/v0001**
Купленные игры пользователя. В параметре передается `steamId`
- **GET /IPlayerService/GetRecentlyPlayedGames/v1/**
Последние сессии пользователя не старше 2 недель
- **GET /ISteamUserStats/GetSchemaForGame/v2/**
Информация по игре, т.е. названия ачивок, урлы их картинок для выполненного/невыполененного состояния, в лучшем случае красивые названия статов, но они приходят очень редко. Для **Civilization V** и некоторых других красивые названия статов заполнены, для других игр используется техническое название статы.
- **GET /ISteamUserStats/GetUserStatsForGame/v0002/**
Статистика и ачивки пользователя без подробной информации. Для того, чтобы отобразить красивые названия и картинки сопоставляем статы и ачивки по полю `name`
- **GET /IDOTA2Match_570/GetMatchHistory/v001/**
История матчей по доте, отдает максимум 100 матчей за раз, при этом пэйджинг работает от последнего матча, включая его, поэтому приходится хитрить, чтобы не было дубликатов
- **GET /IDOTA2Match_570/GetMatchDetails/v001/**
Детализация матча по доте. Принимает только один match_id, поэтому на эндпоинт наибольшая нагрузка при первом заходе на экран. После того, как основная масса матчей сохранена, мы дергаем эндпоинт выше, сопоставляем с тем, чего у нас нет в базе и далее подтягиваем только те матчи, которых у нас нет

# Что можно улучшить

 - [ ] Работу с диспатч группами и семафорами, возможно, стоит вынести в отдельный сервис или попробовать использовать `Operation`
 - [ ] Подумать над структурой базы данных, сейчас сущности в бд строго не связаны, но мы можем фильтровать по `steamId` и `gameId`
 - [ ] Сделать обработку ошибок более детализированной + типизировать ошибки для реалм сервиса. Разбить ошибки по слоям приложения 
 - [ ] Привести к общему виду протоколы секций (`ProfileSectionViewModelRepresentable` и другие). В данный момент они отличаются только типом секций. Хотелось бы, чтобы был один протокол `SectionViewModelRepresentable`
 - [ ] Возможно затащить `R.Swift` для типизированных ассетов и последующей локализации
 - [ ] Покрыть код тестами, совсем не успел

# Выполенные задания
1. Экран профиля с играми и списком друзей
2. Статус онлайн для себя и друзей
3. История статистики в виде графиков + ачивки по любой игре, которая отдает такие данные
4. Детальная история по Доте2. Визуализированный винрейт + выигранные матчи по дням/часам (при зуме)
5. Хранение статистики в локальной базе данных
6. Переход на профиль друга и просмотр его статистики. Статистика друга также хранится в базе
7. Тема по умолчанию - темная. Для iOS 13 реализована поддержка светлой темы на системном уровне. Т.е. если у юзера светлая системная тема - приложение будет белое

Минимальная версия iOS – 10.
Проект собирается под XCode 11.2.1


![profile](https://github.com/havebeenfitz/steamo/blob/develop/screenshots/01_profile.png)![game_stats](https://github.com/havebeenfitz/steamo/blob/develop/screenshots/02_game_stats.png)![dota_stats](https://github.com/havebeenfitz/steamo/blob/develop/screenshots/03_dota2_stats.png)![sessions](https://github.com/havebeenfitz/steamo/blob/develop/screenshots/04_my_sessions.png)
