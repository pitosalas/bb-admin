class ReportsController < ApplicationController
  # Shows the index
  def index
    @today_w, @today_wo = users_without_accounts(0.days.ago)
    @week_w, @week_wo = users_without_accounts(7.days.ago)
    @month_w, @month_wo = users_without_accounts(30.days.ago)
  end
  
  private
  
  def users_without_accounts(since = 1.day.ago)
    # Fetch stats
    con = Event.connection()
    res = con.select_all(<<-END
      SELECT userid is not null as flag, COUNT(DISTINCT i.id) cnt
      FROM runs r, installations i
      WHERE r.installationid=i.id AND
        rundate >= 30*24*3600 AND
        installationdate >= '#{since.beginning_of_day.to_date.to_s}'
      GROUP BY flag
      END
    )
    
    with, without = 0, 0
    res.each do |r|
      cnt = r['cnt']
      if r['flag'].to_s == '1'
        with = cnt
      else
        without = cnt
      end
    end
    
    return with, without
  end
end
