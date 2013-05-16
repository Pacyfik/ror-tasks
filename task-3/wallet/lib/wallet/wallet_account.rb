class WalletAccount
  attr_reader :balance, :currency

  def initialize(currency, amount=0)
    raise IllegalArgument if currency == nil || amount == nil
    @currency = currency
    @balance = amount
  end
  
  def deposit_money(amount)
    check(amount)
    @balance += amount
  end
  
  def withdraw_money(amount)
    check(amount)
    check_overwithdrawal(amount)
    @balance -= amount
  end
  
  private
  def check(amount)
    if amount == nil || amount < 0
      raise IllegalArgument
    end
  end
  
  def check_overwithdrawal(amount)
    if amount > @balance
      raise IllegalArgument #zamienić na inny błąd
    end
  end
  
end