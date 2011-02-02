class Plan < ActiveRecord::Base
  has_many :users
  validates_presence_of :name, :description, :price, :period_months

  # Returns the list of all features with the overriden values (for show)
  def all_features
    connection().select_all("select f.title title, coalesce(pf.value, default_value) value, pf.value is not null overriden from plans p, features f left join plans_features pf on p.id=pf.plan_id and f.id=pf.feature_id where p.id = #{id}")
  end

  # Returns the list of all features with only overriden values (for edit)
  def overriden_features
    connection().select_all("select f.id id, f.title title, pf.value as plan_value, f.format_description format_description from plans p, features f left join plans_features pf on p.id=pf.plan_id and f.id=pf.feature_id where p.id = #{id}")
  end

  # Removes all features from current plan
  def clear_features
    connection().execute("delete from plans_features where plan_id = #{id}");
  end

  # Adds a plan feature to the plan
  def add_feature(feature_id, value)
    connection().execute("insert into plans_features (plan_id, feature_id, value) values (#{id}, #{feature_id}, '#{value}')")
  end
end
