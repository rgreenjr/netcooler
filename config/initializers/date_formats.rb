ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :rfc3393    => '%Y-%m-%dT%H:%M:%SZ',
  :full_date  => '%I:%M %p PST on %b %e, %Y',
  :short_date => '%B %e, %Y'
)
