require_relative 'wallet_test_helper'

describe "wallet" do
  include WalletTestHelper
 
  it "accepts arbitrary amount of money from the user in PLN" do
    set_wallet_balance(:pln, 0)
    set_bank_balance(150)

    add_money(:pln, 50)

    get_wallet_balance(:pln).should == 50
    get_bank_balance.should == 100
  end

  it "converts available money from one currency to another according to a currency exchange table" do
    set_wallet_balance(:pln, 0)
    set_wallet_balance(:usd, 10)
    set_exchange_rate(:usd, :pln, 3)
    
    convert_money(:usd, :pln, 10)
    
    get_wallet_balance(:pln).should == 30 # 10*3 = 30
    get_wallet_balance(:usd).should == 0
  end
  
  it "allows the user to buy stocks according to stock exchange rates" do
    set_wallet_balance(:pln, 500)
    set_stock_price(:pekao, 150, :pln)
    
    buy_stock(:pekao, 3)
    
    get_wallet_balance(:pln).should == 50
    show_stock(:pekao).should == 3
  end
  
  it "allows the user to sell stocks according to stock exchange rates" do
    set_wallet_balance(:pln, 0)
    set_stock_price(:pekao, 150, :pln)
    set_share(:pekao, 3)

    sell_stock(:pekao, 3)

    get_wallet_balance(:pln).should == 450
    show_stock(:pekao).should == 0
  end

  it "allows the user to transfer money back to their bank account" do
    set_wallet_balance(:pln, 50)
    set_bank_balance(70)

    transfer_money(:pln, 50)

    get_wallet_balance(:pln).should == 0
    get_bank_balance.should == 120
  end

end