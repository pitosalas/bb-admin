class ClientError < ActiveRecord::Base
  set_table_name  "ClientErrors"
  
  # Returns summary of errors
  def ClientError.summary
    sum = connection().select_all("SELECT version, COUNT(*) cnt FROM ClientErrors GROUP BY version ORDER BY version desc")
    rows = []
    sum.each do |s|
      row = { :version => s['version'], :cnt => s['cnt'].to_i }
      rows << row
    end
    
    return rows
  end
  
  # Returns groupped errors
  def self.groups(offset, max, cond)
    cnd = cond != '' ? "WHERE #{cond}" : ''
    grps = connection().select_all("SELECT id, version, COUNT(*) cnt, message FROM ClientErrors #{cnd} GROUP BY version, message, details ORDER BY cnt desc LIMIT #{offset}, #{max}")
    rows = []
    grps.each do |g|
      row = { :id => g['id'], :version => g['version'], :cnt => g['cnt'].to_i, :message => g['message'] }
      rows << row
    end
    
    return rows
  end

  # Deletes similar errors
  def self.delete_similar(id)
    connection().delete("DELETE t2 FROM ClientErrors t1, ClientErrors t2 WHERE t1.version = t2.version AND t1.message = t2.message AND t1.details = t2.details AND t1.id = #{id}")
  end
  
  # Deletes records for a given version
  def self.delete_version(version)
    connection().delete("DELETE FROM ClientErrors WHERE version = '#{version}'")
  end
end
