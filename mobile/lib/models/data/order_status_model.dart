class OrderStatus {
  // Status di database tetap bahasa Inggris
  static const String pending = 'pending';
  static const String confirmed = 'confirmed';
  static const String shipped = 'shipped';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';

  // Helper untuk mendapatkan tampilan bahasa Indonesia
  static String getIndonesian(String status) {
    switch (status) {
      case pending:
        return 'Menunggu';
      case confirmed:
        return 'Dikonfirmasi';
      case shipped:
        return 'Dikirim';
      case completed:
        return 'Selesai';
      case cancelled:
        return 'Ditolak';
      default:
        return 'Status tidak diketahui';
    }
  }

  // Helper untuk pesan yang lebih deskriptif
  static String getMessage(String status) {
    switch (status) {
      case pending:
        return 'Menunggu konfirmasi penjual';
      case confirmed:
        return 'Pesanan dikonfirmasi';
      case shipped:
        return 'Pesanan sedang dikirim';
      case completed:
        return 'Pesanan selesai';
      case cancelled:
        return 'Pesanan ditolak';
      default:
        return 'Status tidak diketahui';
    }
  }
} 