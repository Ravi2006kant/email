import 'package:postgres/postgres.dart';

class DatabaseService {
  late final Connection connection;

  Future<void> connect() async {
    connection = await Connection.open(
      Endpoint(
        host: "ep-winter-rice-atppcaxk-pooler.c-9.us-east-1.aws.neon.tech",
        database: "neondb",
        username: "neondb_owner",
        password: "npg_NMc36vdypDow",
      ),
      settings: const ConnectionSettings(sslMode: SslMode.require),
    );

    print("Connected to Neon");
  }

  Future<void> insertEmail({
    required String sender,
    required String receiver,
    required String subject,
    required String body,
  }) async {
    await connection.execute(
      Sql.named('''
        INSERT INTO emails
        (sender, receiver, subject, body, sent_time, status)
        VALUES
        (@sender, @receiver, @subject, @body, @time, @status)
      '''),
      parameters: {
        "sender": sender,
        "receiver": receiver,
        "subject": subject,
        "body": body,
        "time": DateTime.now(),
        "status": "Sent",
      },
    );

    print("Inserted Successfully");
  }
}
