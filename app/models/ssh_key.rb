class SshKey < ActiveRecord::Base
  include ActiveModel::Serializers::JSON

  belongs_to :account

  validates :name, presence: true
  validates :key, presence: true
  validates :username, presence: true

  before_validation :ensure_username

  def attributes
    {
      id: '',
      name: '',
      key: '',
      username: ''
    }
  end

  # keys = [ { id: 1, opts = {} },
  #            id: 2, opts = {} } ]
  #
  # We'll lookup opts but you can also pass any override
  def self.to_config_disk_json(keys)
    return '{}' if keys.empty?

    h = []
    keys.each do |key|
      key = SshKey.find key[:id]

      next unless key

      h << {
        name: key.username,
        ssh_authorized_keys: [
          key.key
        ]
      }
    end

    h.to_json
  end

  protected

  def ensure_username
    self.username = account.login if username.blank?
  end
end
