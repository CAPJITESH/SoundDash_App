class htmlFormatter {
  static String removeHtmlTags(String htmlString) {
    String temp = htmlString
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll("&#039;", "'")
        .replaceAll(" &#039; ", "'");
    return temp;
  }
}
