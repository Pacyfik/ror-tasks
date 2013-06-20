require_relative 'spec_helper'
require_relative '../../lib/wallet'

describe WalletAccount do
  subject(:account_pl)      { WalletAccount.new(currency_pl, balance_pl) }
  subject(:account_usd)     { WalletAccount.new(currency_usd, balance_usd) }
  let(:currency_pl)         { :pln }
  let(:currency_usd)        { :usd }
  let(:balance_pl)          { 100 }
  let(:balance_usd)         { 50 }

  it "should not allow nil as currency parameter" do
    expect{ WalletAccount.new(nil) }.to raise_error(IllegalArgument)
  end

  it "should not allow nil as balance amount parameter" do
    expect{ WalletAccount.new(currency_pl, nil) }.to raise_error(IllegalArgument)
  end
  
  it "should show it's currency" do
    account_pl.currency.should == :pln
  end
  
  it "should show it's balance" do
    account_pl.balance.should == 100
  end
  
  it "should allow to deposit amounts of money no smaller than 0" do
    account_pl.deposit_money(10)
    account_pl.balance.should == 110
  end
  
  it "should allow to withdraw amounts of money no smaller than 0" do
    account_pl.withdraw_money(10)
    account_pl.balance.should == 90
  end
  
  it "should not allow to deposit amounts of money smaller than 0" do
    expect { account_pl.deposit_money(-10)}.to raise_error(IllegalArgument)
  end
  
  it "should not allow to withdraw amounts of money smaller than 0" do
    expect { account_pl.withdraw_money(-10)}.to raise_error(IllegalArgument)
  end
  
  it "should not allow to withdraw amounts of money greater than the balance of the account" do
    expect { account_pl.withdraw_money(150)}.to raise_error(IllegalArgument)
  end
  
  it "should not accept a nil value when depositing money" do
    expect { account_pl.deposit_money(nil)}.to raise_error(IllegalArgument)
  end
  
  it "should not accept a nil value when withdrawing money" do
    expect { account_pl.withdraw_money(nil)}.to raise_error(IllegalArgument)
  end
  
  # ten niżej jest trochę naciągany
  it "should show proper balance values after exchanging money in different currencies" do
    converter = Converter.new(account_usd, account_pl, 3)
    converter.exchange(50)
    account_usd.balance.should == 0
    account_pl.balance.should == 250 # 100+(3*50)=250
  end
  
  context "when created without the balance parameter" do
    subject(:account)      { WalletAccount.new(:pl) }
  
    it "should be empty (i.e. have a 0 balance) when being created without supplying the balance parameter" do
      account.balance.should == 0
    end
    
  end

end