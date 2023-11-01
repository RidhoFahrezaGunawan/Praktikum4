class Sahamku {
  final int? tickerid;
  final String ticker;
  final int? open;
  final int? high;
  final int? last;
  final String? change;

  Sahamku({
    this.tickerid,
    required this.ticker,
    this.open,
    this.high,
    this.last,
    this.change,
  });

  Sahamku.fromMap(Map<String, dynamic> res)
      : tickerid = res["tickerid"],
        ticker   = res["ticker"],
        open     = res["open"],
        high     = res["high"],
        last     = res["last"],
        change   = res["change"];

  Map<String, Object?> toMap() {
    return {
      'tickerid': tickerid,
      'ticker': ticker,
      'open': open,
      'high': high,
      'last': last,
      'change': change
    };
  }
}