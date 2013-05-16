class Converter

  def initialize(from_currency, to_currency, rate)
    @source_account = from_currency
    @target_account = to_currency
    @rate = rate
  end
  
  def exchange(amount)
    check(amount)
    target_amount = amount * @rate
    @source_account.withdraw_money(amount)
    @target_account.deposit_money(target_amount)  
  end
  
  private
  def check(amount)
    if amount == nil || amount < 0
      raise IllegalArgument
    end
  end
  
end