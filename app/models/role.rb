class Role < ApplicationRecord
  RailsAdmin.config do |config|
    config.model 'Role' do
      visible false
    end
  end
end
