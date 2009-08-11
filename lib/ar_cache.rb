# AR_Cache o ActiveRecord Cache Performe ActiveRecord 
# cache in File System for heavy and repetitive query.
#
# Author::    Gianni Mazza  (mailto:redvex@me.com)
# Copyright:: Copyright (c) Redvex
# License::   Distributes under the same terms as Ruby

module ArCache
  def self.included(base)
    base.extend ClassMethods
  end
  
  def ensure_unique(name)
    begin
      self[name] = yield
    end while self.class.exists?(name => self[name])
  end
  
  module ClassMethods
    # Perform a query on dabatase and store result in FileSystem.
    #
    # To uniquify the file name the library calculate MD5 hash for classname, id and params,
    # if result for query exist and isn't expired it return the cached result otherwise DB
    # is queried and the results is stored in FileSystem.
    # TODO: Support for Eeager-loading
    def cache_find(id, params=nil)
      class_name = self.class.name
      
      if (params.nil?)
        params = Array.new
      end
      
      filename   = calculate_file_name(id, params)
      if cache_reset?(filename)
        cache_reset(id, params)
      end
      
      if File.exist?(filename)
        content = File.read(filename)
        toReturn = JSON.parse(content)
      else
        toReturn = self.find(id, params)
        File.open(filename, 'w') do |f|
          f.write toReturn.to_json
          f.close
        end
        toReturn = JSON.parse(toReturn.to_json)
      end
      if toReturn.count > 1
        out = Array.new
        toReturn.each do |obj|
          out << hash_to_obj(obj.values.first)
        end
      else
        toReturn = toReturn.first
        out = hash_to_obj(toReturn.values.first)
      end
      return out
    end
    
    def cache_find_first(params=nil)
      return cache_find(:first, params)
    end
    
    def cache_find_last(params=nil)
      return cache_find(:last, params)
    end
    
    def cache_find_all(params=nil)
      return cache_find(:all, params)
    end
    
    def cache_reset_first(params=nil)
      return cache_reset(:first, params)
    end
    
    def cache_reset_last(params=nil)
      return cache_reset(:last, params)
    end
    
    def cache_reset_all(params=nil)
      return cache_reset(:all, params)
    end
    
    def cache_reset(id, params=nil)
      filename   = calculate_file_name(id, params)
      File.delete(filename)
    end
    
  private
    def hash_to_obj(hash)
      tmp = self.new
      hash.each do |k,v|
        unless v.nil? or v.is_a?(Numeric)
          v = v.gsub('"',"'")
        end
        eval(sprintf('tmp.%s = "%s"',k,v))
      end
      return tmp
    end
    
    def cache_reset?(file)
      filename   = File.join(RAILS_ROOT, "config", "database.yml")
      dbconf = YAML.load_file(filename)[RAILS_ENV]
      if dbconf["cache_expire"].nil?
        return false
      else
        return File.open(file).ctime + dbconf["cache_expire"] > Time.now
      end
    end
    
    def calculate_file_name(id, params)
      File.join(RAILS_ROOT, "tmp", "cache", 
                            Digest::MD5.hexdigest(class_name + "--" + id.to_s + "--"+ params.values.join("--"))+".query")
    end
  end
end

class ActiveRecord::Base
  include ArCache
end