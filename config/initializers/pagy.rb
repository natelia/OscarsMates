# frozen_string_literal: true

# Pagy configuration
# See https://ddnexus.github.io/pagy/docs/api/pagy#variables

require 'pagy/extras/bootstrap'
require 'pagy/extras/overflow'
require 'pagy/extras/array'

# Instance variables
Pagy::DEFAULT[:limit] = 20 # items per page
Pagy::DEFAULT[:size] = 7   # nav bar links

# Overflow handling - return last page when page is out of range
Pagy::DEFAULT[:overflow] = :last_page
