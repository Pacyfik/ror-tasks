#$:.unshift(File.join(File.dirname(__FILE__),"lib"))
#require 'wallet'
#include Wallet

module WalletTestHelper

  def set_wallet_balance(currency, amount)
    @accounts ||= []
    @accounts << WalletAccount.new(currency, amount)
  end
  
  def set_bank_balance(amount)
    @bank_account = BankAccount.new(amount)
  end
  
  def set_exchange_rate(from_currency, to_currency, rate)
    @exchange_rates ||= []
    @exchange_rates << ExchangeRate.new(from_currency, to_currency, rate)  
  end
  
  def set_stock_price(company_name, price, currency)
    @stocks ||= []
    @stocks << Stock.new(company_name, price, currency)
  end
  
  def set_share(company_name, amount)
    @wallet_stocks ||= []
    @wallet_stocks << Share.new(company_name, amount)
  end
  
  def get_wallet_balance(currency)
    "%.2f" % find_account(currency).balance
  end
  
  def get_bank_balance
    "%.2f" % find_account(bank).balance
  end
  
  def add_money(currency, amount)
    find_account(currency).add_money(amount)
  end
  
  def convert_money(from_currency, to_currency, amount)
    converter = Converter.new(find_account(from_currency), find_account(to_currency), find_rate(from_currency, to_currency).value)
    converter.exchange(amount)
  end
  
  def transfer_money(currency, amount)
    find_account(currency).transfer_money(amount)
  end
  
  def show_stock(company_name)
    find_wallet_stock(company_name).amount
  end
  
  def buy_stock(company_name, amount)
    stock = find_stock(company_name)
    stock_exchanger = StockExchanger.new(stock)
    stock_exchanger.buy(amount)
  end
  
  def sell_stock(company_name, amount)
    stock = find_wallet_stock(company_name)
    stock_exchanger = StockExchanger.new(stock)
    stock_exchanger.sell(amount)
  end

  private
  
  def find_account(account)
    @accounts.find{|a| a.currency == account }
  end
  
  def find_rate(from_currency, to_currency)
    @exchange_rates.find{|r| r.from_currency == from_currency && r.to_currency == to_currency }
  end
  
  def find_stock(company_name)
    @stocks.find{|s| s.company_name == company_name }
  end
  
  def find_wallet_stock(company_name)
    @wallet_stocks.find{|s| s.company_name == company_name }
  end
  
end