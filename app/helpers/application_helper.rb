module ApplicationHelper
  CURRENCY_RATES = {
    "USD" => 1.0,
    "EUR" => 1.1,
    "GBP" => 1.3,
    "INR" => 0.012,
    "JPY" => 0.007
  }

  CURRENCY_EMOJIS = {
    "USD" => "💵",
    "EUR" => "💶",
    "GBP" => "💷",
    "INR" => "💰",
    "JPY" => "💴"
  }

  def convert_to_trip_currency(expense)
    return 0 unless expense.amount && expense.currency.present? && expense.trip&.currency.present?

    from_rate = CURRENCY_RATES[expense.currency]
    to_rate = CURRENCY_RATES[expense.trip.currency]
    return 0 unless from_rate && to_rate

    (expense.amount / from_rate) * to_rate
  end

  def currency_symbol(code)
    {
      "USD" => "$",
      "EUR" => "€",
      "GBP" => "£",
      "INR" => "₹",
      "JPY" => "¥"
    }[code] || code
  end

  def currency_emoji(code)
    CURRENCY_EMOJIS[code] || ""
  end
end

