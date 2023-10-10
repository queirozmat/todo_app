class Util {
  static String formatarData(String dataOriginal, {bool dataHora = true}) {
    try {
      DateTime data = DateTime.parse(dataOriginal);

      if (!dataHora) {
        return "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}";
      }

      String dataFormatada =
          "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}";
      return dataFormatada;
    } catch (e) {
      return dataOriginal;
    }
  }

  static DateTime convertStringToDate(String dateString) {
    List<String> dateParts = dateString.split('/');
    if (dateParts.length == 3) {
      int day = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);

      if (day >= 1 && day <= 31 && month >= 1 && month <= 12 && year >= 0) {
        return DateTime(year, month, day);
      }
    }
    return DateTime.now();
  }
}
