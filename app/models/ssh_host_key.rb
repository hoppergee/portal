class SshHostKey < ActiveRecord::Base
  belongs_to :virtual_machine

  validates :key, presence: true

  before_save :generate_fingerprints

  protected

  def generate_fingerprints
    return if key.blank?

    key_file = Tempfile.new
    key_file.write(key)
    key_file.close

    %w[md5 sha256].each do |fingerprint_hash|
      argv = %W[/usr/bin/ssh-keygen -E #{fingerprint_hash} -l -f #{key_file.path}]
      stdout, stderr, status = Open3.capture3(argv.shelljoin)

      if status.exitstatus > 0
        logger.error "Received non-zero exit status when executing: #{argv.join(' ')}"
        logger.error 'stdout: ' + stdout.strip
        logger.error 'stderr: ' + stderr.strip
        logger.error 'status: ' + status.to_s
      else
        send('fingerprint_' + fingerprint_hash + '=', stdout)
      end
    end

    key_file.unlink
  end
end
