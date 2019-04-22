module SPARC
  class Setting < SPARC::Base
    def self.preload_values
      # Cache settings for the current request thread for the current request
      RequestStore.store[:settings_map] ||= Setting.all.map{ |s| [s.key, { value: s.read_attribute(:value), data_type: s.data_type }] }.to_h
    end

    def self.get_value(key)
      if RequestStore.store[:settings_map] && RequestStore.store[:settings_map][key]
        converted_value(RequestStore.store[:settings_map][key][:value], RequestStore.store[:settings_map][key][:data_type])
      else
        Setting.find_by_key(key).value rescue nil
      end
    end

    def value
      Setting.converted_value(read_attribute(:value), self.data_type)
    end

    private

    def self.converted_value(val, data_type)
      case data_type
      when 'boolean'
        val == 'true'
      when 'json'
        begin
          JSON.parse(val.gsub("=>", ": "))
        rescue
          nil
        end
      else
        val
      end
    end
  end
end
