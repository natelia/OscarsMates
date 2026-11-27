require 'rails_helper'

RSpec.describe FeedbackMailer do
  def with_env(vars)
    previous = vars.to_h { |key, _| [key, ENV.fetch(key, nil)] }
    vars.each { |key, value| value.nil? ? ENV.delete(key) : ENV[key] = value }
    yield
  ensure
    previous&.each { |key, value| value.nil? ? ENV.delete(key) : ENV[key] = value }
  end

  describe '.recipient' do
    it 'reads FEEDBACK_EMAIL from the environment' do
      with_env('FEEDBACK_EMAIL' => 'natalia@example.com') do
        expect(described_class.recipient).to eq('natalia@example.com')
      end
    end

    it 'falls back to a placeholder address when it is not set' do
      with_env('FEEDBACK_EMAIL' => nil) do
        expect(described_class.recipient).to eq('feedback@example.com')
      end
    end
  end

  describe '#send_feedback' do
    it 'delivers to the configured recipient and replies to the person who wrote' do
      with_env('FEEDBACK_EMAIL' => 'natalia@example.com', 'SMTP_FROM' => 'OscarsMates <noreply@kalinka.cat>') do
        mail = described_class.send_feedback(
          email: 'mate@example.com', message: 'Love this app', subject: 'Feature Request', user_name: 'Mate'
        )

        expect(mail.to).to eq(['natalia@example.com'])
        expect(mail.from).to eq(['noreply@kalinka.cat'])
        expect(mail.reply_to).to eq(['mate@example.com'])
        expect(mail.subject).to eq('[OscarsMates] Feature Request')
      end
    end
  end
end
