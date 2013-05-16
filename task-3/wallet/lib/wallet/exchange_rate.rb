class ExchangeRate
  attr_reader :from_currency, :to_currency, :rate

  def initialize(from_currency, to_currency, rate)
    @from_currency = from_currency
    @to_currency = to_currency
    @rate = rate
  end
  
end