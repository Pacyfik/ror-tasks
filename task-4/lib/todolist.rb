require 'active_record'

class Todolist < ActiveRecord::Base
  belongs_to :user
  has_many :todoitems

  validates :title, :presence => true
  validates :user_id, :presence => true

  def self.find_by_prefix(prefix)
    where("title like ?", "#{prefix}%").first
  end

  def self.user_lists(id)
    where("user_id = ?", id).all
  end

  def self.find_by_id_eager(id)
    where("id = ?", id).includes(:todoitems).first
  end

end
