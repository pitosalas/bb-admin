require 'rss/maker'

class RssController < ApplicationController
  @@limit = 50

  def index
  end
  
  # All events in a stream
  def all
    gen_feed Event.find(:all, :limit => @@limit, :order => 'id DESC'), 'All Events';
  end
  
  # --- PayPal

  def subscriptions
    gen_feed select_events_by_type(1), 'Subscription Creations'
  end
  
  def payments
    gen_feed select_events_by_type(2), 'Subscription Payments'
  end
  
  def cancellations
    gen_feed select_events_by_type(3), 'Subscription Cancellations'
  end
  
  def suspicious
    gen_feed select_events_by_type(4), 'Suspicious Subscriptions'
  end

  # --- Account
  
  def activations
    gen_feed select_events_by_type(5), 'Account Activations'
  end
  
  # --- Basic

  def select_events_by_type(type)
    Event.find(:all, :conditions => "event_type = #{type}", :limit => @@limit, :order => 'id DESC');
  end
  
  # Generates feeds
  def gen_feed(events, title)
    feed = RSS::Maker::make("2.0") do |f|
      f.channel.title = title
      f.channel.link = ''
      f.channel.description = title
      f.items.do_sort = true
      
      events.each do |e|
        i = f.items.new_item
        i.title = event_to_title(e)
        i.description = event_to_description(e)
        i.date = event_to_date(e)
      end
    end
    
    headers['Content-Type'] = 'application/rss+xml';
    render :text => feed.to_s, :layout => false
  end
  
  def event_to_title(e)
    case e.event_type
      when 1
        "User #{e.user.fullName} (#{e.user.email}) subscribed to '#{e.user.plan.name}' plan"
      when 2
        "User #{e.user.fullName} (#{e.user.email}) paid for the subscription"
      when 3
        "User #{e.user.fullName} (#{e.user.email}) cancelled the subscription"
      when 4
        "User #{e.user.fullName} (#{e.user.email}) requested a suspicious plan"
      when 5
        "User #{e.user.fullName} (#{e.user.email}) activated the account"
      else
        "Unknown event type: #{e.event_type}"
    end
  end
  
  def event_to_description(e)
    e.description
  end
  
  def event_to_date(e)
    e.created_at
  end
end
