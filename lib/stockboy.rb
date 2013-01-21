require 'log4r'

require 'stockboy/version'
require 'stockboy/exceptions'
require 'stockboy/dsl'
require 'stockboy/job'

# Registries
require 'stockboy/translations'
require 'stockboy/providers'
require 'stockboy/readers'
require 'stockboy/filters'

# Translations
require 'stockboy/translations/default_empty_string'
require 'stockboy/translations/default_zero'
require 'stockboy/translations/default_nil'
require 'stockboy/translations/integer'
require 'stockboy/translations/decimal'
require 'stockboy/translations/time'
require 'stockboy/translations/date'
require 'stockboy/translations/us_date'
require 'stockboy/translations/uk_date'

# Filters
require 'stockboy/filters/missing_email'

# Providers
require 'stockboy/providers/ftp'
require 'stockboy/providers/imap'
require 'stockboy/providers/soap'
require 'stockboy/providers/file'

# Readers
require 'stockboy/readers/csv'
require 'stockboy/readers/xml'

module Stockboy

  module Filters
    register :missing_email, MissingEmail
  end

  module Providers
    register :file, File
    register :ftp,  FTP
    register :soap, SOAP
    register :imap, IMAP
  end

  module Readers
    register :csv, CSV
    register :xml, XML
  end

  # Register default included translators
  module Translations
    register :or_nil,   DefaultNil
    register :or_empty, DefaultEmptyString
    register :or_zero,  DefaultZero
    register :integer,  Integer
    register :decimal,  Decimal
    register :time,     Time
    register :date,     Date
    register :us_date,  USDate
    register :uk_date,  UKDate
  end

end

require 'stockboy/railtie' if defined? Rails
