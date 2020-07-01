class VirtualMachinesInterface < ApplicationRecord
  belongs_to :virtual_machine

  validates_uniqueness_of :mac_address
end
