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
        "private_key_id": "d31d92969383a011d25bf37d82142a6375d35578",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDwEzgj9opS99GO\nZalTmKGlx43pxspohsEI3gnAcK7j8Y45lBMO8QJND+YFRj3z7BpFT+Jceu3CjdqO\ncLeF7Ye4RRy7NmgHD5rR8amdFxaL3R27GtLTr9+alak78NVFlbXfWGGPBzqjpBtR\nAX3CU/k2cJ+RqZEuB75IoB6CB3doknrpqoaEfb9VeC2LTTAa07LjAdtLMXW27HVS\nlvPgxtn8xMt7A2BREm9RzcbFKthyYsV0qScySo0sEr1s0JAYFpAuYDxAhs/cU8kt\n8XOswQmu4aldal9Wytey8ICEqLjtcNDKceDmeT6/HJkCZa2WTNIBUNFXp0axf7yW\npd5RpDd1AgMBAAECggEAHPgwvtQ18leRq7V0RpBlNyg6pXJVw+G44u1KL3TZgcuI\n/kUyPIwUG0D3IH1OpgPAUstWNRMnZCHydNxApRJZ3YBHfIbO7EUziTB4Z2qdD6EN\nwKF2vdEb8h8rpf5EegpcATi8wwHcD1mS60Y7CutPqARUmQLlcDDCgyiBLe8hN1az\n0owVg7mmGcn87Vc9eCCgYqGe4BdNdx58IBYoL1CT5eiADdGuqsHgfRRjjhf+6e13\n2ekBRrpg9tvKakQlcEIPMq/TJovhdJVKkbu+5PwujN6fzt3Oj1zUxXPqd7p5lX04\nHxjdEqVWCOau7/HeFIBFDHsi5p4u96MsEyToBK63cQKBgQD9UWoty2L0h0pFzU97\nf+46NWnCivwgARgYaSU5PvUeSALQJHHKp+uRiWGurN+SWCZXF8eWJZ44rIuyjccx\nMN800PIsGTPsLRyRrigwPOexrTLjZe4Dh5fQ0YcVtYgLoPH0s3IizjocBiqWAsqr\nZ9qcpF83XlgOgcOyYqo93bZhcQKBgQDynelINjjtaYrT+hlbUDBBtiHBV3DrnbLJ\nOUuFrHPsKpODmkxDE1YSZUwdc/GKXBlleQZFAo1YNH+1qP+3qxQfSLYq0MUm2yCd\n4WyEAIOAjMa/HtqFWjaPIUpX6F75McNk6bQ5Fsjm4GH3ADHLBFgVTrHE5/a87CnB\nX6kTJkE0RQKBgC2qDX/v2AjIkqT+m8NhjmpD0qrVLxn92IAeBC3LoZgx1v/6ceDc\nYGS95TP9ydexuEee68WvRlRlFlG7qRq++p2kxOMaL/f1Md85C9mWQRYQaMoBR+Su\n/rkP7FAHh1zBSJyZ9Is9rc/7dJXSLwKzF/+AygFLKoiC7+oqSxIX85ahAoGAH8B8\n5F98Sc3zRlTH9sRi3Ga6ujP4ak2kNWOTN7ZfIXxc++84pdqk/BlXwc8HwITXKgmR\nwXxZBT8xq5Oni+EO7B03Ahl6g+BPv3neGtR6YVuLMz4VeThaRZckxKZ7r39MxCs1\n0/bgah7Zk1rqKVizMm6vI0b8arM5r74WQZRTGkUCgYEAlDNyPVzBwH4t6takUDkx\n95uAkNoiQToOuW7rKEWfNYFyBGrI6Y8eyjpahFyodB//IaLh70dzx5jF5kSKn+d1\nCidf89Xn8gRTZd3LlFGI3ZgxuesbpxlqaXSgNHsZAercg0rZJTiABwF3XupNNb2Z\naEkhe8zHc1CGSLpqdk2Qgio=\n-----END PRIVATE KEY-----\n",
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
