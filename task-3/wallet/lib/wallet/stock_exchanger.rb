class StockExchanger

  def initialize(stock, share)
    @stock = stock
    @share = share
  end

  def buy(amount)
    #tutaj i w sprzedaży kwestia znalezienia odpowiedniego
    #konta walutowego w portfelu (i sprawdzenie czy takie
    #w ogóle istnieje, podliczenia ceny, sprawdzenia balansu
    #konta i odjęcie lub dodanie tej kwoty na konto...
    check(amount)
    @share.buy(amount)
  end
  
  def sell(amount)
  
    check(amount)
    @share.sell(amount)
  end

  private
  def check(amount)
    if amount == nil || amount < 0
      raise IllegalArgument
    end
  end

end