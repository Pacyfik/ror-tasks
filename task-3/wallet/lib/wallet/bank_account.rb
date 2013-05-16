class BankAccount
  attr_reader :balance
  
  def initialize(amount=0)
    @balance = amount    
  end
  
  def deposit_money(amount)
    @balance += amount
  end
  
  def withdraw_money(amount)
    @balance -= amount
  end
  
end