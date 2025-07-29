import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';

class DashboardPromotersMockData {
  static List<CustomUser> getMockPromoters() {
    final now = DateTime.now();
    final promoters = <CustomUser>[];
    
    // Vorheriger Monat (31. Mai - 29. Juni): 10 Promoter 
    // Das sind etwa 31-60 Tage her
    for (int i = 0; i < 10; i++) {
      final daysAgo = 60 - (i * 3); // 60, 57, 54... Tage her
      promoters.add(CustomUser(
        id: UniqueID.fromUniqueString('mock-promoter-prevmonth-$i'),
        firstName: 'Max${i + 1}',
        lastName: 'Mustermann${i + 1}',
        email: 'max${i + 1}@example.com',
        role: Role.promoter,
        createdAt: now.subtract(Duration(days: daysAgo)),
      ));
    }

    // Aktueller Monat (30. Juni - 29. Juli): 7 Promoter total
    // Davon: 2 aktuelle Woche, 3 vorherige Woche, 2 sonstige
    
    // Sonstige im aktuellen Monat (vor 16. Juli): 2 Promoter
    // 16. Juli ist etwa 13 Tage her, also 13-25 Tage her
    promoters.add(CustomUser(
      id: UniqueID.fromUniqueString('mock-promoter-monthother-1'),
      firstName: 'Anna1',
      lastName: 'Beispiel1',
      email: 'anna1@example.com',
      role: Role.promoter,
      createdAt: DateTime(2025, 7, 10), // 19 Tage her
    ));
    
    promoters.add(CustomUser(
      id: UniqueID.fromUniqueString('mock-promoter-monthother-2'),
      firstName: 'Anna2',
      lastName: 'Beispiel2',
      email: 'anna2@example.com',
      role: Role.promoter,
      createdAt: DateTime(2025, 7, 5), // 24 Tage her
    ));

    // Vorherige Woche (16. Juli - 22. Juli): 3 Promoter
    promoters.add(CustomUser(
      id: UniqueID.fromUniqueString('mock-promoter-prevweek-1'),
      firstName: 'Peter1',
      lastName: 'Schmidt1',
      email: 'peter1@example.com',
      role: Role.promoter,
      createdAt: DateTime(2025, 7, 17), // In vorheriger Woche
    ));
    
    promoters.add(CustomUser(
      id: UniqueID.fromUniqueString('mock-promoter-prevweek-2'),
      firstName: 'Peter2',
      lastName: 'Schmidt2',
      email: 'peter2@example.com',
      role: Role.promoter,
      createdAt: DateTime(2025, 7, 19), // In vorheriger Woche
    ));
    
    promoters.add(CustomUser(
      id: UniqueID.fromUniqueString('mock-promoter-prevweek-3'),
      firstName: 'Peter3',
      lastName: 'Schmidt3',
      email: 'peter3@example.com',
      role: Role.promoter,
      createdAt: DateTime(2025, 7, 21), // In vorheriger Woche
    ));

    // Aktuelle Woche (23. Juli - 29. Juli): 2 Promoter
    promoters.add(CustomUser(
      id: UniqueID.fromUniqueString('mock-promoter-currentweek-1'),
      firstName: 'Lisa1',
      lastName: 'Müller1',
      email: 'lisa1@example.com',
      role: Role.promoter,
      createdAt: DateTime(2025, 7, 25), // In aktueller Woche
    ));
    
    promoters.add(CustomUser(
      id: UniqueID.fromUniqueString('mock-promoter-currentweek-2'),
      firstName: 'Lisa2',
      lastName: 'Müller2',
      email: 'lisa2@example.com',
      role: Role.promoter,
      createdAt: DateTime(2025, 7, 27), // In aktueller Woche
    ));

    return promoters;
  }

  /// Überblick der Mockdaten:
  /// - Vorheriger Monat (31-60 Tage her): 10 Promoter
  /// - Aktueller Monat (1-30 Tage her): 7 Promoter
  ///   - Aktuelle Woche (1-7 Tage her): 2 Promoter  
  ///   - Vorherige Woche (8-14 Tage her): 3 Promoter
  ///   - Sonstige (15-30 Tage her): 2 Promoter
  /// 
  /// Erwartete Trends:
  /// - Woche: 2 (aktuelle) vs 3 (vorherige) = -33.3% → fallend
  /// - Monat: 7 (aktueller) vs 10 (vorheriger) = -30% → fallend
  /// - Jahr: 17 (dieses) vs 0 (letztes) = +100% → steigend
}