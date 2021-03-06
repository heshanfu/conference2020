import 'package:conferenceapp/model/notification.dart';
import 'package:conferenceapp/notifications/repository/notifications_repository.dart';
import 'package:conferenceapp/notifications/repository/notifications_unread_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notificationsRepository =
        RepositoryProvider.of<FirestoreNotificationsRepository>(context);
    final notificationUnreadRepository =
        RepositoryProvider.of<AppNotificationsUnreadStatusRepository>(context);
    final lastRead = notificationUnreadRepository.latestNotificationReadTime();

    return StreamBuilder<List<AppNotification>>(
        stream: notificationsRepository.notifications(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            final list = snapshot.data;
            return ListView.builder(
              physics: AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final notif = list[index];
                return ListTile(
                  title: Text(
                    notif.title ?? '',
                    style: TextStyle(
                      fontWeight:
                          notif.important ? FontWeight.bold : FontWeight.w400,
                    ),
                  ),
                  subtitle: Text(notif.content ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(timeago.format(notif.dateTime)),
                      if (lastRead != null && lastRead.isBefore(notif.dateTime))
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).accentColor),
                            height: 8,
                            width: 8,
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Container(
              child: Center(
                child: NotificationsEmptyState(),
              ),
            );
          }
        });
  }
}

class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/notifications.png',
            height: 200,
            width: 200,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Here you will see your notifications and messages from organizers',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
