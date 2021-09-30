module DataTypeValidator
  require 'json'
  require 'uri'

  PHONE_REGEXP  = /\A[0-9]{10}(#[0-9]+)?\Z/
  EMAIL_REGEXP  = /\A([^\s\@]+@[A-Za-z0-9.-]+)(,[ ]?[^\s\@]+@[A-Za-z0-9.-]+)*\Z/
  URL_REGEXP    = /\A((ftp|http|https):\/\/)?[\w\-]+(((\.[a-zA-Z0-9]+)+(:\d+)?)|(:\d+))(\/[\w\-]+)*((\.[a-zA-Z]+)|(\/))?(\?([\w\-]+=.+(&[\w\-]+=.+)*)+)?\Z/
  PATH_REGEXP   = /\A(\/|(\/\w+)+\/?)(\?(\w+=\w+(&\w+=\w+)*)+)?\Z/

  def is_boolean?(value)
    %w(true false).include?(value)
  end

  def is_json?(value)
    begin
      JSON.parse(value)
      true
    rescue
      false
    end
  end

  def is_email?(value)
    value.match?(EMAIL_REGEXP)
  end

  def is_url?(value)
    value.match?(URL_REGEXP)
  end

  def is_path?(value)
    value.match?(PATH_REGEXP)
  end

  def get_type(value)
    if is_boolean?(value)
      'boolean'
    elsif is_json?(value)
      'json'
    elsif is_email?(value)
      'email'
    elsif is_url?(value)
      'url'
    elsif is_path?(value)
      'path'
    else
      'string'
    end
  end
end
