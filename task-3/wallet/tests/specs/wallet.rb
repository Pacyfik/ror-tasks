require_relative 'spec_helper'
require_relative '../../lib/wallet'
require_relative '../../lib/exceptions'

describe Wallet do
  subject(:wallet)          { Wallet.new() }
  let(:database)            { stub }
  let(:item)                { Struct.new(:title,:description).new(title,description) }
  let(:title)               { "Shopping" }
  let(:description)         { "Go to the shop and buy toilet paper and toothbrush" }

  it " " do
  
  end
  
end

describe do


end
