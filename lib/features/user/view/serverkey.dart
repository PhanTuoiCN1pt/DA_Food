import 'package:googleapis_auth/auth_io.dart';

class get_server_key {
  Future<String> server_token() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "foodai-96b3a",
        "private_key_id": "c87986253a33fca023562151ec6b1fb359eb3ae8",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDPXdgA7hh9pjzH\nY31KhS7akTxVwfJUvLTkRH/4oyI2BpIrRG6TOtedosN4iGscdjp9TI3a3Qq2QUXZ\n0gqPnPKIeTjIMrknJPwBVeNoAUTPJ6ohFv/ChW4NmAioPgFbgO9w17jZ1qk7RBa0\n2wYTVQ6/wTBhFucaIomZiSfRWxIO28vVvhAAWyWpKngYH1wctQvEPHInmv8jFrmp\nvc6gXhQRsRWYEbw5+f3SD7mZZciweAgxVXHIRvOHVFrVWZGtKVVPMnWpIOCQcc7r\ncMZAR9l3Dfh0b0/2/dXQiJlTIVc7aRxQ+FKlavWk7uvrdyYsV8buDa/K38hzdcl+\nK3yPwJSTAgMBAAECggEAAtKxoxzN41menQEWVPjIZE9ZdYcFAb3qVIU3z/tTw7Qf\nmOX+/2AfGVVJUsKNer8dTFSWrDKzXgg4QQV8AVKCQ46RUe0zpuKSnIE+OrQLUZEM\neHpz4IKo6eR2kbVhlvMdaPlDpsUmW3LLQFd1Y+piuTeSRtZ+yCGz1kEPJ4MVSHOt\nSbvkKGqRU4Zu8ZbD7okh2GcWMSxpMY2Qfe8vJgoFr4h7+eyWFug4S8gjw+qTmC7e\n6mlC98cDv1Ehfuseo8lLOz2O7EfXsGUO5KcBLaGac3nUYG0t2zg1nsyNl25Xebjp\n3hWUZuBBt6v2soUIvrdLeIrb/XVi8kxmPX8X/HzXOQKBgQD0atpOvcsekEgt96ST\ntm9DXUm4S4JctsVAo1qiLnm6Cdt88RbtYqngBZoglVKiW8ereyLZ0BA3wg8HQuwq\n+UHC2ALdK+4iTzQ/z22oz9driMw9OpNpHi+Ks8yRaz61iCchqgoCA5IT3q1hFl7c\n8UCqHs/gORJrtwbnG+uY2N+ChwKBgQDZMYJmydfkS2U5po9ZjsTXZgyqhTZtaJmm\n2SUsNWpQDubH4PNYBlaZoz7sfy9aGtMq0c6TT2N1ffmD/ehG8BB7wmwXW93grQbm\n75/iqljgn3/sRnBzcYyTISkupWTPed/osNheY5D6lfiOTx4e85NbhaKLBDywqvIk\n7KByYcSElQKBgGl0QMSAdsa1Ea9jjYp9x/uUoF33lkNSSEDfOheHXdW6swxxKKc7\nTnftctZkFsceOkPuWNcJQjYMcFd9tE/GQ21BrdqnPZNoAO8XHAUdx6AJ4bT5NOjB\nsVlywexsDR5dpCSOLMs5pykThlLBSCSjonbD3IStmxkGWuAT186Wo7i5AoGBANDT\nTXHO+AjEhRsdDg8puhDwSZVaZ65iN/m4JomPAhzfdv0PSGmGDpXB46o3zytvR0GQ\nYHI6joJVESbbZg1unCqiEJOU/IwdUNmR48RnzPSL5s8iGtSkhGiiJZp346mooKR2\nBFMcoDSPJWCOqYNQ5onEvzeyZzfl5NOjv9C6N9zRAoGAFAmrt/wTY9uFF3Z4wQld\n5HPuGIbBpRfxxNw+EB5tQzxSNeiWUzdh8cGAUrg4unI7dA2vIrAJZ/84+eoM9X8E\niNhuTtcEA6Xq5wVvfChHTjFiHgW0XyMBJSvb7aTtJ30xY0VteK+Kky/icDZxqdAK\n2lai4qYCs9IW2l8SoMoSrts=\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-fbsvc@foodai-96b3a.iam.gserviceaccount.com",
        "client_id": "115685247203885542792",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40foodai-96b3a.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com",
      }),
      scopes,
    );
    final accessserverkey = client.credentials.accessToken.data;
    return accessserverkey;
  }
}
