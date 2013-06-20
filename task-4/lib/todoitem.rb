require 'active_record'

class Todoitem < ActiveRecord::Base
  belongs_to :todolist

  DATE_FORMAT = "%d/%m/%Y"

  validates :title, :presence => true, :length => { :in => 5..30 }
  validates :todolist_id, :presence => true
  validates :description, :length => { :maximum => 255 }
  validates :date_due, :format => { :with => /\A[0-3][0-9]\/[0-1][0-9]\/[0-9]{4}\z/ }

  def self.find_by_word(word)
    where("description like ?", "%#{word}%").first
  end

  def self.find_by_long_desc
    where("length(description) > 100").all
  end

  def self.paginate(page)
    order("title").offset(5*(page-1)).limit(5)
  end

  def self.find_user_items(user)
    joins(:todolist).where("todolists.user_id = ?", user)
  end

  def self.find_user_items_due_by_date(user, day)
    find_user_items(user).find_items_due_by_day(day)
  end

  def self.find_items_due_by_day(day)
    day = Time.parse(day)
    where("date_due = ?", day).all
  end

  def self.find_items_due_by_week(week)
    week_begin = Time.parse(Date.commercial(2013, week, 1).to_s)
    week_end = Time.parse(Date.commercial(2013, week, 7).to_s)
    where("date_due between ? and ?", week_begin, week_end)
  end

  def self.find_items_due_by_month(month)
    start = Time.new(Time.now.year, month)
    finish = Time.new(Time.now.year, month).end_of_month
    where("date_due between ? and ?", start, finish)
  end

  def self.find_items_overdue
    where("date_due < ?", Time.now.beginning_of_day)
  end

  def self.find_items_due_in_n_hours(hours)
    date = Time.now + hours.hours
    where("date_due between ? and ?", Time.now.beginning_of_day, date)
  end

end
