/// Format utility untuk angka, mata uang Rupiah, dan tanggal tanpa dependensi eksternal
class Formatters {
  Formatters._();

  /// Format angka ke Rupiah: contoh 1500000 -> "Rp 1.500.000"
  static String formatRupiah(num amount) {
    final int val = amount.round();
    final String str = val.abs().toString();
    final StringBuffer buffer = StringBuffer();
    int count = 0;

    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i > 0) {
        buffer.write('.');
      }
    }

    final String reversed = buffer.toString().split('').reversed.join('');
    final String sign = val < 0 ? '-Rp ' : 'Rp ';
    return '$sign$reversed';
  }

  /// Format tanggal singkat Indonesia: contoh DateTime(2026, 11, 6) -> "06 Nov 2026"
  static String formatDate(DateTime dt) {
    const List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    final String day = dt.day.toString().padLeft(2, '0');
    final String month = months[dt.month - 1];
    return '$day $month ${dt.year}';
  }

  /// Format relatif waktu (contoh: "Baru saja", "10 mnt lalu", "2 jam lalu", "Kemarin")
  static String timeAgo(DateTime dt) {
    final Duration diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) {
      return 'Baru saja';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} mnt lalu';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} jam lalu';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} hari lalu';
    } else {
      return formatDate(dt);
    }
  }
}

