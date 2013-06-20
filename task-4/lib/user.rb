require 'active_record'

class User < ActiveRecord::Base
  has_many :todolists
  has_many :todoitems, :through => :todolists

  attr_accessor :terms_of_service

  validates :name, :presence => true, :length => { :maximum => 20 }
  validates :surname, :presence => true, :length => { :maximum => 30 }
  validates :email, :format => { :with => /\A[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ }
  validates :terms_of_service, :acceptance => true
  validates :password, :presence => true, :length => { :minimum => 10 }, :confirmation => true
  validates :failed_login_count, :presence => true, :numericality => { :only_integer => true }

  def self.find_by_surname(surname)
    where("surname = ?", surname).first
  end

  def self.find_by_email(email)
    where("email = ?", email).first
  end

  def self.find_by_prefix(prefix)
    where("surname like ?", "#{prefix}%").first
  end

  def authenticate(email, password)
    if user = User.find_by_email(email)
      if user.password == password
        true
      else
        user.failed_login_count += 1
        false
      end
    else
      false
    end
  end

  def self.find_suspicious_users
    where("failed_login_count > 2").all
  end

  def self.group_by_failed_login_count
    order("failed_login_count DESC").all
  end

end
