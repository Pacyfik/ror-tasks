class Stock
  attr_reader :company_name, :price, :currency
  
  def initialize(company_name, price, currency)
    @company_name = company_name
    @price = price
    @currency = currency
  end

end