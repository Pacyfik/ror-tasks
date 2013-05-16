class Share
  attr_reader :company_name, :amount
  
  def initialize(company_name, amount)
    @company_name = company_name
    @amount = amount
  end
  
  def buy(amount)
    @amounut += amount
  end
  
  def sell(amount)
    check_oversell(amount)
    @amount -= amount
  end
  
  private
  def check_oversell(amount)
    if amount > @amount
      raise IllegalArgument #zamienić na inny błąd
    end
  end

end