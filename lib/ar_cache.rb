# AR_Cache o ActiveRecord Cache esegue query e ne memorizza
# il risultato sul FS per evitare l'overloading del Database
# tramite query ricorrenti e molto pesanti.
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
    # Esegue una query sul dabatase del tipo find(:all) e ne memorizza il risultato sul FileSystem.
    #
    # Per rendere univoco il nome del file viene calcolato l'MD5 di nome classe e di tutti i parametri della query,
    # se la cache della query esiste nel FS viene restituita senza interrogare il DB.
    # TODO: Supportare l'eager-loading
    def cache_find(id, params)
      class_name = self.class.name
              
      filename   = File.join(RAILS_ROOT, "tmp", "cache", 
                            Digest::MD5.hexdigest(class_name + "--" + id.to_s + "--"+ params.values.join("--"))+".query")
      if File.exist?(filename)
        content = File.read(filename)
        toReturn = JSON.parse(content)
      else
        #altrimenti eseguo la query e memorizzo il risultato su file
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
    
  end
end

class ActiveRecord::Base
  include ArCache
end