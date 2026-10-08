# Este archivo se carga antes de cada corrida de tests (ver .rspec).
# Carga el código del TP para que esté disponible en todos los specs.
require_relative '../lib/prototype'

RSpec.configure do |config|
  # Si hay tests marcados con `focus: true`, corre solo esos.
  config.filter_run_when_matching :focus
end
