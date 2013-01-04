class Date
  def self.next(day)
     next_day_from_date(day,Date.today)
  end
  def self.next_day_from_date(day,date)
    until date.send("#{day}?")
      date = date.next_day
    end
    date
  end
  
  def british_format
    strftime("%A the #{day.ordinalize} of %B")
  end
end

class DateTime
  def self.midnight_on_next(day)
    midnight_on_next_day_from_date(day,Date.today)
  end
  def self.midnight_on_next_day_from_date(day,date)
    date = Date.next(day)
    return DateTime.new(date.year, date.month, date.day, 00, 00)
  end
end

