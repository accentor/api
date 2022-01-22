# frozen_string_literal: true

module Accentor
  class Application
    module Version
      MAJOR = 0
      MINOR = 17
      PATCH = 0

      STRING = [MAJOR, MINOR, PATCH].compact.join('.')
    end
    VERSION = Version::STRING

    # Set version header for every request
    config.action_dispatch.default_headers.merge!('X-API-Version' => VERSION)
  end
end
