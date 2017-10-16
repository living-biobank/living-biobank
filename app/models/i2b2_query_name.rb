class I2b2QueryName < ApplicationRecord
  include I2b2Shard
  self.table_name = "MUSC_I2B2DATA.QT_QUERY_MASTER"
end

